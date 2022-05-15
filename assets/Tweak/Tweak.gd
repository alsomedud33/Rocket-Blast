# Here is all the code used for player movement.
# It's not yet complete (no going up steps and probably more features missing), and may be a bit messy
# See it in action here : https://www.youtube.com/watch?v=ALRW8pSbosE

extends KinematicBody


var blue_pallete = load("res://Online/Characters/Blue_Pallete Gradient.png")
var red_pallete = load("res://Online/Characters/Red_Pallete Gradient.png")
var hud = load("res://Online/HUD/Hud (Online).tscn")

remote var username = ''
var max_health = 125
var health = 125
var wep_spread = 6
var dealth_location = global_transform.origin
onready var killer = name
var merc = "Tweak"
var team:int


var rng = RandomNumberGenerator.new()
var mouse_sensitivity = Globals.mouse_sense


export var max_speed: float = 8.5 # Meters per second
export var max_air_speed: float = 0.2#4
export var accel: float = max_speed * 10 # or max_speed * 10 : Reach max speed in 1 / 10th of a second

# For now, the friction variable is not used, as the calculations are  not the same as quake's
# export var friction: float = 2 # Higher friction = less slippery. In quake-based games, usually between 1 and 5

export var gravity: float = 15
export var jump_impulse: float = 7
var rocket_impulse: float = 0
var terminal_velocity: float = gravity * -5 # When this is reached, we stop increasing falling speed

var snap: Vector3 # Needed for move_and_slide_wit_snap(), which enables to go down slopes without falling

onready var head: Spatial = $Pivot
onready var camera: Camera = $Pivot/Camera
onready var gun_camera = $CanvasLayer/ViewportContainer/Viewport/Camera
onready var raycast = $Pivot/Camera/RayCast
onready var anim = $AnimationPlayer
onready var anim_tree = $AnimationTree
onready var timer = $"Primary_Cooldown"
onready var spread_cooldown = $"Spread_Cooldown"
onready var ground_check = $GroundCheck
onready var main = get_tree().current_scene
#onready var get_rocket_launcher = $"Pivot/Camera/Rocket Launcher"
onready var guns = $"Pivot/Camera/Projectile/Position3D"#"Pivot/Camera/Rocket Launcher/Gun0"
onready var health_label = $Health
onready var damage_label = $damage
onready var team_label = $Team
onready var arm_ik_left =$"Pivot/Camera/Arms/SkeletonIK2"
onready var arm_ik_right =$"Pivot/Camera/Arms/SkeletonIK"
onready var fp_arms = $"Pivot/Camera/Arms/Arms"
onready var user_tag = $"Username"
#onready var usr_tag = $Username

onready var armature = $"Armature"

export var cooldown = 0.8
var velocity: Vector3 = Vector3.ZERO # The current velocity vector
var wishdir: Vector3 = Vector3.ZERO # Desired travel direction of the player

var vertical_velocity: float = 0 # Vertical component of our velocity. 
# We separate it from 'velocity' to make calculations easier, then join both vectors before moving the player

var rocket_jump: bool = false
var temp_rocket_jump:bool 
var wish_jump: bool = false # If true, player has queued a jump : the jump key can be held down before hitting the ground to jump.
var can_jump: bool = true
var auto_jump: bool = false # Auto bunnyhopping

# The next three variables are used to display corresponding vectors in game world.
# This is probably not the best solution and will be removed in the future.
var debug_horizontal_velocity: Vector3 = Vector3.ZERO
var accelerate_return: Vector3 = Vector3.ZERO
var forward_input: float 
var strafe_input: float
#Networking variables
var puppet_position = Vector3()
var puppet_velocity = Vector3()
var puppet_rotation = Vector3()
var puppet_rocket_transform:Transform 
var puppet_floorcheck
var puppet_rocketjump
var puppet_wish_jump
var puppet_anim:String
var puppet_anim_val
var puppet_rocket_num:int
var puppet_forward_input:float
var puppet_team
var puppet_current_weapon:int = 0 


export var tick_rate:float = 0.015
var rocket_num:int = 0

	#when a packet is sent via the network_timer, puppet versions of soldier are updated 
func _on_network_timer_timeout():
	if self.is_network_master():# and name == str(get_tree().get_network_unique_id()):
		rpc_unreliable("update_transform", global_transform.origin, velocity, Vector2(head.rotation.x, self.rotation.y),camera.global_transform)
		rpc_unreliable("update_state", state,old_state,rocket_num,forward_input,current_weapon)
#	rpc("update_anim",is_on_floor(),rocket_jump,wish_jump)
func anim_timeout():
	if is_network_master() and name == str(get_tree().get_network_unique_id()):
		rpc("update_anim",is_on_floor(),temp_rocket_jump,wish_jump)
		pass

	#only executed on puppet soldiers. Their rotation, position and velocity are adjusted to match where they roughly are
puppet func update_transform(p_pos, p_vel, p_rot, rocket_trans):
	puppet_position = p_pos
	puppet_velocity = p_vel
	puppet_rotation = p_rot
	puppet_rocket_transform = rocket_trans
	
	$Tween.interpolate_property(self,"global_transform", global_transform, Transform(global_transform.basis,p_pos),tick_rate)
	$Tween.interpolate_property(gun_camera,"global_transform", global_transform, rocket_trans,tick_rate)
	$Tween.start()
puppet func update_anim(floor_check,r_jump,w_jump):
	puppet_floorcheck = floor_check
	puppet_rocketjump = r_jump
	puppet_wish_jump = w_jump

puppet func update_state(fake_state,fake_old_state,fake_rocket_num,forward_inp,cur_wep):
	puppet_state = fake_state
	puppet_old_state = fake_old_state
	puppet_rocket_num = fake_rocket_num
	puppet_forward_input = forward_inp
	puppet_current_weapon = cur_wep
puppet func shoot_anim():
	anim_tree.set("parameters/Is_Shooting/active",1)
	if current_weapon == 3:
		animtree_change("parameters/Attack_Anim/current",1)
		anim.play("Shoot_Melee")
#		anim.play("Shoot_Shovel")
#		armature.get_node("Skeleton/Rocket Launcher/Shovel").visible = true
#		yield(anim,"animation_finished")
#		armature.get_node("Skeleton/Rocket Launcher/Shovel").visible = false
	if current_weapon == 2:
		animtree_change("parameters/Attack_Anim/current",0)
		anim.play("Shoot_Secondary")
		armature.get_node("Skeleton/Weapons/Secondary").visible = true
		yield(anim,"animation_finished")
		armature.get_node("Skeleton/Weapons/Secondary").visible = false
	if current_weapon == 1:
		animtree_change("parameters/Attack_Anim/current",0)
		anim.play("Shoot_Primary")
		armature.get_node("Skeleton/Weapons/Primary").visible = true
		yield(anim,"animation_finished")
		armature.get_node("Skeleton/Weapons/Primary").visible = false
#Networking end



func animtree_change(parameter : String, val):
	anim_tree.set(parameter, val)
		#rpc_unreliable("update_anim",parameter,val)

func _input(event: InputEvent) -> void:
	if is_network_master():
		# Camera rotation
		if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED and state !=DEAD:
			head.rotate_x(deg2rad(event.relative.y * mouse_sensitivity))
			self.rotate_y(deg2rad((event.relative.x * -mouse_sensitivity)))
			head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))
			#armature.get_node("Skeleton").set_bone_pose(armature.get_node("Skeleton").find_bone("Head"),Transform(camera.global_transform.basis,armature.get_node("Skeleton").get_bone_pose(armature.get_node("Skeleton").find_bone("Head")).origin))
enum {
	GROUND,
	AIR,
	DEAD
}
var state = GROUND
var puppet_state = GROUND
var old_state = GROUND
var puppet_old_state = GROUND

var current_weapon = 1
var a = InputEventAction.new()
func weapon_switch():
	animtree_change("parameters/Current_Wep/current",current_weapon - 1)
	if is_network_master():
		if Input.is_action_just_released("Wep_scroll+"):
			var temp = current_weapon
			if temp <=2:
				temp += 1
			else:
				temp = 1
			a = InputEventAction.new()
			print(temp)
			print(current_weapon)
			a.action = "wep_slot_" + str(temp)
			a.pressed = true
			Input.action_press("wep_slot_" + str(temp))
		elif Input.is_action_just_released("Wep_scroll-"):
			var temp = current_weapon
			if temp >=2:
				temp -= 1
			else:
				temp = 3
			a = InputEventAction.new()
			print(temp)
			print(current_weapon)
			a.action = "wep_slot_" + str(temp)
			a.pressed = true
			Input.action_press("wep_slot_" + str(temp))
		if Input.is_action_just_pressed("wep_slot_1") and current_weapon != 1:
			$Weapon_Cooldown.start()
			timer.stop()
			wep_spread = 6
			current_weapon = 1
			anim.play("Change_Primary")
			animtree_change("parameters/Attack_Anim/current",0)
		
		elif Input.is_action_just_pressed("wep_slot_2") and current_weapon != 2:
			$Weapon_Cooldown.start()
			timer.stop()
			wep_spread = 0
			current_weapon = 2
			anim.play("Change_Secondary")
			animtree_change("parameters/Attack_Anim/current",0)
		
		elif Input.is_action_just_pressed("wep_slot_3") and current_weapon != 3:
			$Weapon_Cooldown.start()
			timer.stop()
			current_weapon = 3
			anim.play("Change_Melee")
			animtree_change("parameters/Attack_Anim/current",1)
	else:
		current_weapon = puppet_current_weapon
	if current_weapon == 1:
		timer
		head.get_node("Camera/Primary").visible = true
		#anim.play("Sway")
		armature.get_node("Skeleton/Weapons/Primary").visible = true
	else:
		head.get_node("Camera/Primary").visible = false
		armature.get_node("Skeleton/Weapons/Primary").visible = false

	if current_weapon == 2:
		head.get_node("Camera/Secondary").visible = true
		armature.get_node("Skeleton/Weapons/Secondary").visible = true
	else:
		head.get_node("Camera/Secondary").visible = false
		armature.get_node("Skeleton/Weapons/Secondary").visible = false

	if current_weapon == 3:
		head.get_node("Camera/Melee").visible = true
		armature.get_node("Skeleton/Weapons/Melee").visible = true
	else:
		head.get_node("Camera/Melee").visible = false
		armature.get_node("Skeleton/Weapons/Melee").visible = false
remote func set_team():
	match team:
		1:
			set_collision_layer_bit(1,true)
			set_collision_mask_bit(5, true)
			fp_arms.get_active_material(0).set_texture(0,blue_pallete)
			self.armature.get_node("Skeleton/Scout").get_active_material(0).set_texture(0,red_pallete)
		2:
			set_collision_layer_bit(5,true)
			set_collision_mask_bit(1, true)
			fp_arms.get_active_material(0).set_texture(0,red_pallete)
			self.armature.get_node("Skeleton/Scout").get_active_material(0).set_texture(0,blue_pallete)

func set_username():
	if is_network_master():
		var temp = int(self.name)
		username = Players.player_list[temp]["username"]
		rset("username",Players.player_list[temp]["username"])

func _ready():
	camera.current = is_network_master() 
	$"Health_Bar".max_value = max_health
#	$"CanvasLayer/ViewportContainer/HUD (Online)".visible = self.is_network_master()
#	set_team()
	set_username()
	$"Username Sprite".get_node("Viewport").emit_signal("set_the_name",self.is_network_master())
	Network.get_node("Net_Time").connect("timeout",self,'_on_network_timer_timeout')
	$network_timer.wait_time = tick_rate
	Globals.player = 1
	$Armature/Skeleton/Spineik.start()
	arm_ik_left.start()
	arm_ik_right.start()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Health_Bar.visible = is_network_master()
	health_label.visible = is_network_master()
	team_label.visible = is_network_master()
	head.visible = is_network_master()
	#get_rocket_launcher.visible = is_network_master()
	#get_rocket_launcher.get_node("MeshInstance").set_layer_mask_bit(2,is_network_master())
#	hat.get_node("MeshInstance").set_layer_mask_bit(0,!is_network_master())#visible = !is_network_master() 
	$"CanvasLayer/ViewportContainer".visible = is_network_master() 
	fp_arms.visible = is_network_master() 
	Network.connect("hit",self,"_hit")
	armature.get_node("Skeleton/Scout").set_layer_mask_bit(0,!is_network_master())#.visible = !is_network_master()
	for i in armature.get_node("Skeleton/Weapons").get_children():
		for c in i.get_children():
			for h in c.get_children():
				h.set_layer_mask_bit(0,!is_network_master())
#	for i in armature.get_node("Skeleton/Weapons/Remburg 8").get_children():
#		i.set_layer_mask_bit(0,!is_network_master())
#	armature.get_node("Skeleton/Rocket Launcher/Shotgun").set_layer_mask_bit(0,!is_network_master())
#	for i in armature.get_node("Skeleton/Weapons/Shovel").get_children():
#		i.set_layer_mask_bit(0,!is_network_master())
	armature.get_node("Skeleton/Hat/Hair").set_layer_mask_bit(0,!is_network_master())
	anim.playback_active = true
	if self.is_network_master():
		rpc("set_team")
		set_team()
		NetNodes.add_child(hud.instance())#$"CanvasLayer/ViewportContainer".add_child(hud.instance())
		main = get_tree().current_scene
#	else:
#		$"CanvasLayer/ViewportContainer/HUD (Online)".queue_free()
	#yield(get_tree().create_timer(.2), "timeout")
	main = get_tree().current_scene
func _process(delta):
#	Engine.set_target_fps(0)
	camera.fov = Globals.fov
	gun_camera.fov = Globals.viewmodel_fov
	mouse_sensitivity = Globals.mouse_sense * 0.001
	if is_network_master():
		gun_camera.global_transform = camera.global_transform
#		if Input.is_action_just_pressed("ui_cancel"):
#			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		anim_tree.set(puppet_anim,puppet_anim_val)
func _physics_process(delta: float) -> void:
#	usr_tag.rect_global_position =  get_viewport().get_camera().unproject_position(head.global_transform.origin)
	if !is_network_master():
		weapon_switch()
		global_transform.origin = puppet_position
		velocity.x = puppet_velocity.x
		velocity.y = puppet_velocity.y
		#print (puppet_rocketjump)
		velocity.z = puppet_velocity.z
		head.rotation.x = puppet_rotation.x
		rotation.y = puppet_rotation.y
		gun_camera.global_transform = puppet_rocket_transform
		rocket_num = puppet_rocket_num
		forward_input = puppet_forward_input
		if puppet_wish_jump and ground_check.is_colliding():
			if !$Jump.is_playing():
				$Jump.play()
		match puppet_state:
			GROUND:
			#	if puppet_floorcheck:
					puppet_rocketjump = false
					anim_tree.set("parameters/Char_State/current",0)
					anim_tree.set("parameters/Air_Hit/blend_amount",0)
					if (abs(velocity.z) <1  and abs(velocity.x) < 1):#(sqrt(pow(velocity.x,2) + pow(velocity.z,2)) <3) or forward_input in range(-0.2,0.2):
						#anim_tree.set("parameters/Is_Moving/current", 0)
						anim_tree.set("parameters/Is_Moving/current",0)
					else:
						#anim_tree.set("parameters/Is_Moving/current", 1)
						anim_tree.set("parameters/Is_Moving/current",1)
						#anim_tree.set("parameters/Run_Dir/blend_amount", int(velocity.z>0))
						anim_tree.set("parameters/Run_Dir/blend_amount",forward_input >0) #int(velocity.z<=0))#int(velocity.z<=0))
			AIR:
			#	else: #We're in the air. Do not apply friction
					if ground_check.is_colliding():#velocity.y <=0 and ground_check.is_colliding() and !wish_jump== true:
						#anim_tree.set("parameters/Char_State/current", 2)
						anim_tree.set("parameters/Char_State/current",2)
					else:
						#anim_tree.set("parameters/Char_State/current", 1)
						anim_tree.set("parameters/Char_State/current",1)
						if puppet_rocketjump:
							#anim_tree.set("parameters/Air_Hit/blend_amount", 1)
							anim_tree.set("parameters/Air_Hit/blend_amount",1)
						if velocity.y > 0 and !puppet_wish_jump:
							#anim_tree.set("parameters/Air_State/current", 0)
							anim_tree.set("parameters/Air_State/current",0)
						else:
							#anim_tree.set("parameters/Air_State/current", 1)
							anim_tree.set("parameters/Air_State/current",1)
			DEAD:
				$Armature/Skeleton/Spineik.interpolation = 0
				armature.set_as_toplevel(true)
				anim_tree.set("parameters/Ragdoll/current",1)
				get_node("CollisionShape").disabled = true
				get_node("Projectile Hurtbox").monitoring = false
				get_node("Projectile Hurtbox").monitorable = false
				#$Armature/Skeleton/Spineik.stop()
	if is_network_master():
		weapon_switch()
		if Input.is_action_just_pressed("ragdoll"):
			health -= 10
		health_label.text = str(health)
		$"Health_Bar".value = health
		team_label.text = ("Team: "+str(team))
		#print(wish_jump)
		queue_jump()
		forward_input = Input.get_action_strength("move_forward") - Input.get_action_strength("move_back")
		strafe_input= Input.get_action_strength("move_left") - Input.get_action_strength("move_right")
		wishdir = Vector3(strafe_input, 0, forward_input).rotated(Vector3.UP, self.global_transform.basis.get_euler().y).normalized() 
		# wishdir is our normalized horizontal inpur
		if health <= 0 and state != DEAD:
			dealth_location = global_transform.origin
			health = 0
			$Death_Cam.start()
			state = DEAD
		match state:
				GROUND:
					if !is_on_floor():
						change_state(AIR)
					else:
						can_jump = true
					temp_rocket_jump = false
					if wish_jump: # If we're on the ground but wish_jump is still true, this means we've just landed
						snap = Vector3.ZERO #Set snapping to zero so we can get off the ground
						vertical_velocity = jump_impulse # Jump
						$Jump.play()
						change_state(AIR)
						move_air(velocity, delta) # Mimic Quake's way of treating first frame after landing as still in the air
						
						#yield(get_tree().create_timer(.3), "timeout")
						wish_jump = false # We have jumped, the player needs to press jump key again
					#	anim_tree.set("parameters/Char_State/current", 2)
						animtree_change("parameters/Char_State/current",2)
					#	anim_tree.set("parameters/Air_Hit/blend_amount", 0)
						animtree_change("parameters/Air_Hit/blend_amount",0)
					elif rocket_jump: # If we're on the ground but wish_jump is still true, this means we've just landed
						#print("rocket jump: "+name)
						snap = Vector3.ZERO #Set snapping to zero so we can get off the ground
						vertical_velocity = rocket_impulse # Jump
						$Jump.play()
						change_state(AIR)
						move_air(velocity, delta) # Mimic Quake's way of treating first frame after landing as still in the air
						
						#yield(get_tree().create_timer(.3), "timeout")
						rocket_jump = false # We have jumped, the player needs to press jump key again
						rocket_impulse = 0
						temp_rocket_jump = true
					else : # Player is on the ground. Move normally, apply friction
						#anim_tree.set("parameters/Char_State/current", 0)
						if ground_check.is_colliding() == true:
							var normal = ground_check.get_collision_normal()
							#print(normal.dot(Vector3.UP))
							if normal.dot(Vector3.UP) > .92:
								#print ("true")
								vertical_velocity = -1
							else:
								#print (false)
								vertical_velocity = 2
						snap = -get_floor_normal() #Turn snapping on, so we stick to slopes
						move_ground(velocity, delta)
							#print (sqrt(pow(velocity.x,2) + pow(velocity.z,2)))
						#anim_tree.set("parameters/Char_State/current", 0)
						animtree_change("parameters/Char_State/current",0)
						#anim_tree.set("parameters/Air_Hit/blend_amount", 0)
						animtree_change("parameters/Air_Hit/blend_amount",0)
						#print (forward_input)
						if (abs(forward_input) < 0.2  and abs(strafe_input) < 0.2):#(sqrt(pow(velocity.x,2) + pow(velocity.z,2)) <3) or forward_input in range(-0.2,0.2):
							#anim_tree.set("parameters/Is_Moving/current", 0)
							animtree_change("parameters/Is_Moving/current",0)
						else:
							if (sqrt(pow(velocity.x,2) + pow(velocity.z,2))) <1:
								animtree_change("parameters/Is_Moving/current",0)
							else:
								#anim_tree.set("parameters/Is_Moving/current", 1)
								animtree_change("parameters/Is_Moving/current",1)
								#anim_tree.set("parameters/Run_Dir/blend_amount", int(velocity.z>0))
								animtree_change("parameters/Run_Dir/blend_amount",int(velocity.z>0))
								#if velocity.z >
				AIR:
					if Input.is_action_just_pressed("jump") and can_jump == true:
						wish_jump = true
						velocity.x = wishdir.x * jump_impulse *1.5
						velocity.z = wishdir.z * jump_impulse *1.5
						can_jump = false
						change_state(GROUND)
						#vertical_velocity = rocket_impulse
					if is_on_floor():
						change_state(GROUND)
					if ground_check.is_colliding():#velocity.y <=0 and ground_check.is_colliding() and !wish_jump== true:
						#anim_tree.set("parameters/Char_State/current", 2)
						animtree_change("parameters/Char_State/current",2)
						rocket_jump = false
					else:
						#anim_tree.set("parameters/Char_State/current", 1)
						animtree_change("parameters/Char_State/current",1)
					snap = Vector3.DOWN
					vertical_velocity = velocity.y
					
					if vertical_velocity >= terminal_velocity:
						vertical_velocity -= gravity * delta #if vertical_velocity >= terminal_velocity else 0 # Stop adding to vertical velocity once terminal velocity is reached
					else:
						vertical_velocity = terminal_velocity	
					move_air(velocity, delta)
					#print(vertical_velocity)
					if self.is_on_ceiling(): #We've hit a ceiling, usually after a jump. Vertical velocity is reset to cancel any remaining jump momentum
						vertical_velocity = 0
			#		for i in self.get_slide_count():
			#			#print (state.get_contact_collider_object(i).name)
			#			#print(get_slide_collision(i).get_collider().name)
			#			if get_slide_collision(i).get_collider().name == "Explosion_Hitbox":
			#				velocity += get_slide_collision(i).normal *15
				DEAD:
					$Armature/Skeleton/Spineik.interpolation = 0
					head.hide()
					#get_rocket_launcher.hide()
#					fp_arms.hide()
#					camera.get_node("prim").hide()
#					camera.get_node("Shovel").hide()
					armature.set_as_toplevel(true)
					animtree_change("parameters/Ragdoll/current",1)
					velocity = Vector3.ZERO
					self.global_transform.origin = dealth_location
					armature.visible = true
					armature.get_node("Skeleton/Hat/Hair").set_layer_mask_bit(0,true)
					armature.get_node("Skeleton/Scout").set_layer_mask_bit(0,true)#.visible = !is_network_master()
					for i in armature.get_node("Skeleton/Weapons").get_children():
						for c in i.get_children():
							for h in c.get_children():
								h.set_layer_mask_bit(0,true)
#					armature.get_node("Skeleton/Rocket Launcher/Shotgun").set_layer_mask_bit(0,true)
#					armature.get_node("Skeleton/Rocket Launcher/Rocket Launcher").set_layer_mask_bit(0,true)
#					armature.get_node("Skeleton/Hat/Soldier Hat2").set_layer_mask_bit(0,true)
					get_node("CollisionShape").disabled = true
					get_node("Projectile Hurtbox").monitoring = false
					get_node("Projectile Hurtbox").monitorable = false
					var T = camera.global_transform.looking_at(NetNodes.players.get_node(killer).global_transform.origin,Vector3.UP)
					$Tween.interpolate_property(camera,"global_transform",Transform(camera.global_transform.basis,dealth_location),Transform(T.basis,camera.global_transform.origin),0.1)
					$Tween.start()
		if raycast.is_colliding() and raycast.get_collider().is_in_group("Player") and state != DEAD:
			user_tag.show()
			user_tag.text = raycast.get_collider().username
			if raycast.get_collider().team == 1:
				get_node("Username/Usr_name_panel").set_self_modulate(Color(1, 0, 0, 0.5))
			elif raycast.get_collider().team == 2:
				get_node("Username/Usr_name_panel").set_self_modulate(Color(0, 0.764706, 1, 0.5))
		elif state == DEAD:
			user_tag.show()
			user_tag.text = NetNodes.players.get_node(killer).username
			if NetNodes.players.has_node(killer):
				if NetNodes.players.get_node(killer).team == 1:
					get_node("Username/Usr_name_panel").set_self_modulate(Color(1, 0, 0, 0.5))
				elif NetNodes.players.get_node(killer).team == 2:
					get_node("Username/Usr_name_panel").set_self_modulate(Color(0, 0.764706, 1, 0.5))
		else:
			user_tag.hide()
#		if Input.is_action_pressed("shoot1"):
#			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		if Input.is_action_pressed("shoot1") and timer.is_stopped() and $"Weapon_Cooldown".is_stopped() and state != DEAD and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			match current_weapon:
				1:
					timer.start(0.625)
					anim.play("Shoot_Primary")
					animtree_change("parameters/Is_Shooting/active",0)
					animtree_change("parameters/Is_Shooting/active",1)
					rpc("shoot_anim")
					randomize()
					for r in camera.get_node("RayContainer").get_children():
						r.cast_to.x = rand_range(wep_spread, -wep_spread)
						r.cast_to.y = rand_range(wep_spread, -wep_spread)
					Network.emit_signal("player_shot",name,guns.global_transform.origin,"Shotgun",6)
				2:
					timer.start(0.4)
					spread_cooldown.start(1.25)
					wep_spread +=1
					wep_spread = clamp(wep_spread,0,6)
					anim.play("Shoot_Secondary")
					animtree_change("parameters/Is_Shooting/active",0)
					animtree_change("parameters/Is_Shooting/active",1)
					rpc("shoot_anim")
					randomize()
#					for r in camera.get_node("RayContainer").get_children():
#						r.cast_to.x = rand_range(wep_spread, -wep_spread)
#						r.cast_to.y = rand_range(wep_spread, -wep_spread)
					Network.emit_signal("player_shot",name,guns.global_transform.origin,"Hitscan",10)
				3:
					timer.start(0.5)
					anim.play("Shoot_Melee")
					animtree_change("parameters/Is_Shooting/active",0)
					animtree_change("parameters/Is_Shooting/active",1)
					rpc("shoot_anim")

#		if Input.is_action_pressed("shoot1") and timer.is_stopped() and state != DEAD and current_weapon == 1 and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
#			anim.play("Shoot_Rocket")
#			animtree_change("parameters/Is_Shooting/active",1)
#			rpc("shoot_anim")
#			timer.start(cooldown)
#			#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#
#			Network.emit_signal("player_shot",name,guns.global_transform.origin,"Rocket")
#			#anim.play("Shoot_Rocket")
#			$Rocket_Launch.play()
#			$Rocket_Trail.play()
#
#		elif Input.is_action_pressed("shoot1") and timer.is_stopped() and state != DEAD and current_weapon == 2 and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
#			timer.start(cooldown)
#			anim.play("Shoot_Shotty")
#			animtree_change("parameters/Is_Shooting/active",1)
#			rpc("shoot_anim")
#			randomize()
##			for r in camera.get_node("RayContainer").get_children():
##				r.cast_to.x = rand_range(wep_spread, -wep_spread)
##				r.cast_to.y = rand_range(wep_spread, -wep_spread)
#			Network.emit_signal("player_shot",name,guns.global_transform.origin,"Hitscan")
#			pass
#
#		elif Input.is_action_pressed("shoot1") and timer.is_stopped() and state != DEAD and current_weapon == 3 and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
#			timer.start(cooldown)
#			anim.play("Shoot_Shovel")
#			animtree_change("parameters/Is_Shooting/active",1)
#			rpc("shoot_anim")
#			pass

func change_state(new_state):
	old_state = state
	state = new_state

#Calculate the speed to add to velocity
master func accelerate(wish_dir: Vector3, input_velocity: Vector3, accels: float, maxspeed: float, delta: float)-> Vector3:
	# Current speed is calculated by projecting our velocity onto wishdir.
	# We can thus manipulate our wishdir to trick the engine into thinking we're going slower than we actually are, allowing us to accelerate further.
	var current_speed: float = input_velocity.dot(wish_dir)
	
	# Next, we calculate the speed to be added for the next frame.
	# If our current speed is low enough, we will add the max acceleration.
	# If we're going too fast, our acceleration will be reduced (until it evenutually hits 0, where we don't add any more speed).
	var add_speed: float = clamp(maxspeed - current_speed, 0, accels * delta)
	
	# Put the new velocity in a variable, so the vector can be displayed.
	accelerate_return = input_velocity + wish_dir * add_speed
	return accelerate_return

# Scale down horizontal velocity
# For now, we're simply substracting 10% from our current velocity. This is not how it works in engines like idTech or Source !
master func friction(input_velocity: Vector3, delta)-> Vector3:
	#var speed: float = input_velocity.length()
	var scaled_velocity: Vector3

	scaled_velocity = input_velocity * 0.9 # Reduce current velocity by 10%
	
	# If the player is moving too slowly, we stop them completely
	if scaled_velocity.length() < max_speed / 100:
		scaled_velocity = Vector3.ZERO

	return scaled_velocity*60 *delta

# Apply friction, then accelerate
master func move_ground(input_velocity: Vector3, delta: float)-> void:
	# We first work on only on the horizontal components of our current velocity
	var nextVelocity: Vector3 = Vector3.ZERO
	nextVelocity.x = input_velocity.x
	nextVelocity.z = input_velocity.z
	nextVelocity = friction(nextVelocity,delta) #Scale down velocity
	nextVelocity = accelerate(wishdir, nextVelocity, accel, max_speed, delta)
	
	# Then get back our vertical component, and move the player
	nextVelocity.y = vertical_velocity
	#print (vertical_velocity)
	velocity = move_and_slide_with_snap(nextVelocity, snap, Vector3.UP,true,4,deg2rad(60))

# Accelerate without applying friction (with a lower allowed max_speed)
master func move_air(input_velocity: Vector3, delta: float)-> void:
	# We first work on only on the horizontal components of our current velocity
	var nextVelocity: Vector3 = Vector3.ZERO
	nextVelocity.x = input_velocity.x
	nextVelocity.z = input_velocity.z
	nextVelocity = accelerate(wishdir, nextVelocity, accel*5, max_air_speed, delta)
	
	# Then get back our vertical component, and move the player
	nextVelocity.y = vertical_velocity
	if rocket_jump:
		#anim_tree.set("parameters/Air_Hit/blend_amount", 1)
		animtree_change("parameters/Air_Hit/blend_amount",1)
	if nextVelocity.y > 0 and !wish_jump:
		#anim_tree.set("parameters/Air_State/current", 0)
		animtree_change("parameters/Air_State/current",0)
	else:
		#anim_tree.set("parameters/Air_State/current", 1)
		animtree_change("parameters/Air_State/current",1)
#	print(sqrt(pow(nextVelocity.x,2) + pow(nextVelocity.z,2)))
	if sqrt(pow(nextVelocity.x,2) + pow(nextVelocity.z,2)) >10:
		velocity = move_and_slide_with_snap(nextVelocity, snap, Vector3.UP,true,4,deg2rad(20))
	else:
		velocity = move_and_slide_with_snap(nextVelocity, snap, Vector3.UP,true)

# Set wish_jump depending on player input.
master func queue_jump():
	# If auto_jump is true, the player keeps jumping as long as the key is kept down
#	if auto_jump:
#		wish_jump = true if Input.is_action_pressed("jump") else false
#		return
	
	if Input.is_action_pressed("jump") and !wish_jump:
		wish_jump = true
		return true
	if Input.is_action_just_released("jump"):
		wish_jump = false
		return false

master func shoot_event():
	pass 


master func _on_Footstep_timeout():
	var my_random_number = rng.randi_range(1,3)
	if self.is_on_floor() and velocity.length() > 3:
		match my_random_number:
			1:
				$Footstep1.play()
			2:
				$Footstep2.play()
			3:
				$Footstep3.play()
	elif !self.is_network_master() and puppet_state == GROUND and velocity.length() > 3:
		match my_random_number:
			1:
				$Footstep1.play()
			2:
				$Footstep2.play()
			3:
				$Footstep3.play()

func take_damage(dmg,enemy,app_kb:bool = false):
	rpc("take_damage_remote",dmg,enemy,app_kb)
	health -= dmg
	killer = enemy
	if app_kb == true:
		take_knockback(dmg,enemy)
#	print (name + "" + str(health))

remote func take_damage_remote(dmg,enemy,app_kb:bool = false):
	health -= dmg
	killer = enemy
	if app_kb == true:
		take_knockback(dmg,enemy)
#	print (name + "" + str(health))

func take_knockback(dmg,enemy,scaler:float = 6):
	var knockback = min(20,dmg *(scaler*0.01905*2))
	velocity.x += (NetNodes.players.get_node(enemy).global_transform.origin.direction_to(self.camera.global_transform.origin)*knockback).x
	velocity.z += (NetNodes.players.get_node(enemy).global_transform.origin.direction_to(self.camera.global_transform.origin)*knockback).z
	velocity.y += (NetNodes.players.get_node(enemy).global_transform.origin.direction_to(self.camera.global_transform.origin)*knockback).y
	if (self.camera.global_transform.origin.direction_to(NetNodes.players.get_node(enemy).global_transform.origin).y+0.7 <0):
		rocket_jump = true 
		rocket_impulse += (NetNodes.players.get_node(enemy).global_transform.origin.direction_to(self.camera.global_transform.origin)*knockback).y
	print("knockback is "+ str(self.camera.global_transform.origin.direction_to(NetNodes.players.get_node(enemy).global_transform.origin).y+0.7))

func _hit(dmg,location):
	if self.is_network_master():
		print ("I AM DONG: " +str(dmg) +" DAMAGE")
		damage_label.show()
		damage_label.rect_position =  get_viewport().get_camera().unproject_position(location)#camera.unproject_position(location)
		damage_label.get_node("Tween").interpolate_property(damage_label,'rect_position',Vector2(damage_label.rect_position.x,damage_label.rect_position.y),Vector2(damage_label.rect_position.x,damage_label.rect_position.y-500),2)
		damage_label.get_node("Tween").start()
		damage_label.text = "-"+str(dmg)
		damage_label.get_node("Tween").interpolate_property(damage_label,'modulate',Color(1, 0.913725, 0),Color.transparent,2)
		damage_label.get_node("Tween").start()



func get_health(amount,overheal,is_multiplier):
	rpc("get_health_remote",amount,overheal,is_multiplier)
	if is_multiplier:
		health += round(amount * max_health)
	else:
		health += amount
	if (overheal != true) and (health >max_health):
		health = max_health

#remote func get_health_remote(amount,overheal,is_multiplier):
#	if is_multiplier:
#		health += round(amount * max_health)
#	else:
#		health += amount
#	if (overheal != true) and (health >max_health):
#		health = max_health


func _on_Death_Cam_timeout():
	if is_network_master():
		Network.emit_signal("respawn",int(name),merc,team)


func pallete_swap(colour):
	match colour:
		"blue":
			pass

func melee_attack():
	if self.is_network_master():
		Network.emit_signal("player_shot",name,guns.global_transform.origin,"Melee",35)


func _on_Spread_Cooldown_timeout():
	if current_weapon == 2:
		wep_spread = 0
