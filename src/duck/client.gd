extends Node

var connected_clients = []

func _ready():
	rpc_config("create_duck", 1)
	rpc_config("update_duck", 1)

remote func create_duck(duck):
	print("Adding duck to your pond view")
	
	if duck.id != get_tree().get_network_unique_id() && !connected_clients.has(str(duck.id)):
		var duck_user = preload("res://duck/DuckTemplate.tscn").instance(PackedScene.GEN_EDIT_STATE_INSTANCE)
		duck_user.set_process(true)
		duck_user.name = str(duck.id)
		duck_user.transform.origin = duck.origin
		duck_user.visible = true
		duck_user.rotation = Vector3(duck.rotation)
		# Track connections
		connected_clients.append(str(duck.id))
		get_parent().add_child(duck_user)
		update_duck_name(duck.id, duck.name)
		
func update_duck_name(id, name):
	if get_parent().get_node(str(id)):
		print("Updating duck " + str(id) + " given name " + name)
		get_parent().get_node(str(id)).get_node("DuckName/DuckNameView/DuckNameLabel").text = name
	
remote func update_duck_color(duck):
	if get_parent().get_node(str(duck.id)):
		print("Updating duck " + str(duck.id) + " color in your pond view with " + str(duck.color))
		get_parent().get_node(str(duck.id)).get_node("Roundcube").get_surface_material(0).albedo_color = Color(duck.color[0])
		get_parent().get_node(str(duck.id)).get_node("Roundcube001").get_surface_material(0).albedo_color = Color(duck.color[0])
		get_parent().get_node(str(duck.id)).get_node("Roundcube").get_surface_material(1).albedo_color = Color(duck.color[1])
		get_parent().get_node(str(duck.id)).get_node("Roundcube001").get_surface_material(1).albedo_color = Color(duck.color[1])
		get_parent().get_node(str(duck.id)).get_node("Roundcube").get_surface_material(2).albedo_color = Color(duck.color[2])
		get_parent().get_node(str(duck.id)).get_node("Roundcube001").get_surface_material(2).albedo_color = Color(duck.color[2])
		get_parent().get_node(str(duck.id)).get_node("Roundcube").get_surface_material(3).albedo_color = Color(duck.color[3])
		get_parent().get_node(str(duck.id)).get_node("Roundcube001").get_surface_material(3).albedo_color = Color(duck.color[3])
		get_parent().get_node(str(duck.id)).get_node("Roundcube").get_surface_material(4).albedo_color = Color(duck.color[4])
		get_parent().get_node(str(duck.id)).get_node("Roundcube001").get_surface_material(4).albedo_color = Color(duck.color[4])
	
remote func update_duck(duck):
	if get_parent().get_node(str(duck.id)):
		#print("Updating duck " + str(duck.id) + " in your pond view at " + str(duck.origin))
		get_parent().get_node(str(duck.id)).transform.origin = duck.origin
		get_parent().get_node(str(duck.id)).rotation = Vector3(duck.rotation)

func delete_duck(duck_id):
	if get_parent().get_node(str(duck_id)):
		print("Deleting duck " + str(duck_id) + " from your pond view")
		get_parent().get_node(str(duck_id)).queue_free()

func delete_pond():
	for duck in connected_clients:
		delete_duck(duck)

func send_new_position(duck_origin, duck_rotation):
	if get_tree().network_peer != null:
		rpc_id(1, "update_duck_user", {"name": get_parent().get_node("client").name,"origin": duck_origin,"rotation": duck_rotation})
		
func send_new_color(color):
	if get_tree().network_peer != null:
		rpc_id(1, "update_duck_user_color", {"name": get_parent().get_node("client").name,"color": color})
