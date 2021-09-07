extends KinematicBody

var speed = 5
var gravity = Vector3.DOWN * 10
var velocity = Vector3.ZERO
var camera_y = 0

var color = ["ffffff", "f6e100", "000000", "ffd100", "ffffff"]
#onready var camera_cords = $Camera.transform.origin

func _ready():
	_update_material_menu()
	rpc_config("update_duck_user", 1)

func _physics_process(delta):
	velocity += gravity * delta
	# check speed control events
	_speed_control()
	
	# check direction control events
	_direction_control(delta)
	
	get_parent().get_parent().get_node("client").send_new_position(transform.origin, rotation)
		
	velocity = move_and_slide(velocity, Vector3.UP)
	#_reset_camera(delta)

# Direction Controls
func _direction_control(delta):
	var vy = velocity.y
	velocity = Vector3.ZERO
	if Input.is_action_pressed("ui_up"):
		velocity += transform.basis.z * speed
		#translate(Vector3(1,0,0) * delta * speed)
		
	if Input.is_action_pressed("ui_down"):
		velocity += -transform.basis.z * speed
		#translate(Vector3(-1,0,0) * delta * speed)
	
	if Input.is_action_pressed("ui_right"):
		rotate_y(-0.9 * delta)
		
	if Input.is_action_pressed("ui_left"):
		rotate_y(0.9 * delta)
	velocity.y = vy

# Speed Controls
func _speed_control():
	if Input.is_action_pressed("minus"):
		if speed > 1:
			speed -= 1
		
	if Input.is_action_pressed("plus"):
		if speed < 100:
			speed += 1
		
	pass

# Color Controls
## Objects
# RoundCube => Duck
#RoundCube001 => Duck Water Reflection
## Layers
# HeadFeathers => Layer 0
# Bill Outer => Layer 1
# Eyes => Layer 2
# Bill Edge => Layer 3
# Under Feathers => Layer 4
## Color
# Color in HEXIDECIMAL
func _update_material_colors():
	_get_material_color_updates()
	
	# Update the upper (duck and lower (reflection) model
	get_node("Roundcube").get_surface_material(0).albedo_color = Color(color[0])
	get_node("Roundcube001").get_surface_material(0).albedo_color = Color(color[0])
	get_node("Roundcube").get_surface_material(1).albedo_color = Color(color[1])
	get_node("Roundcube001").get_surface_material(1).albedo_color = Color(color[1])
	get_node("Roundcube").get_surface_material(2).albedo_color = Color(color[2])
	get_node("Roundcube001").get_surface_material(2).albedo_color = Color(color[2])
	get_node("Roundcube").get_surface_material(3).albedo_color = Color(color[3])
	get_node("Roundcube001").get_surface_material(3).albedo_color = Color(color[3])
	get_node("Roundcube").get_surface_material(4).albedo_color = Color(color[4])
	get_node("Roundcube001").get_surface_material(4).albedo_color = Color(color[4])
	
	# Tell other players to update their view
	get_parent().get_parent().get_node("client").send_new_color(color)

func _get_material_color_updates():
	color[0] = get_parent().get_parent().get_node("UserControls/ColorSelection/DuckColor/VBoxContainer/MaterialHead/MaterialEdit/MaterialLine").text
	color[1] = get_parent().get_parent().get_node("UserControls/ColorSelection/DuckColor/VBoxContainer/MaterialBody/MaterialEdit/MaterialLine").text 
	color[2] = get_parent().get_parent().get_node("UserControls/ColorSelection/DuckColor/VBoxContainer/MaterialBill/MaterialEdit/MaterialLine").text 
	color[3] = get_parent().get_parent().get_node("UserControls/ColorSelection/DuckColor/VBoxContainer/MaterialBillEdge/MaterialEdit/MaterialLine").text 
	color[4] = get_parent().get_parent().get_node("UserControls/ColorSelection/DuckColor/VBoxContainer/MaterialEyes/MaterialEdit/MaterialLine").text 
	
func _update_material_menu():
	get_parent().get_parent().get_node("UserControls/ColorSelection/DuckColor/VBoxContainer/MaterialHead/MaterialEdit/MaterialLine").text = color[0]
	get_parent().get_parent().get_node("UserControls/ColorSelection/DuckColor/VBoxContainer/MaterialBody/MaterialEdit/MaterialLine").text = color[1]
	get_parent().get_parent().get_node("UserControls/ColorSelection/DuckColor/VBoxContainer/MaterialBill/MaterialEdit/MaterialLine").text = color[2]
	get_parent().get_parent().get_node("UserControls/ColorSelection/DuckColor/VBoxContainer/MaterialBillEdge/MaterialEdit/MaterialLine").text = color[3]
	get_parent().get_parent().get_node("UserControls/ColorSelection/DuckColor/VBoxContainer/MaterialEyes/MaterialEdit/MaterialLine").text = color[4]
	
# Signals and Buttons
func _on_JoinHostButton_toggled(button_pressed):
	if get_parent().get_parent().get_node("UserControls/HostSelection/JoinHost").visible:
		get_parent().get_parent().get_node("UserControls/HostSelection/JoinHost").visible = false
	else:
		get_parent().get_parent().get_node("UserControls/HostSelection/JoinHost").visible = true
		
func _on_ColorDuckButton_toggled(button_pressed):
	if get_parent().get_parent().get_node("UserControls/ColorSelection/DuckColor").visible:
		get_parent().get_parent().get_node("UserControls/ColorSelection/DuckColor").visible = false
	else:
		get_parent().get_parent().get_node("UserControls/ColorSelection/DuckColor").visible = true
