extends Spatial

var hostname = null
var port 
var network
var my_id = null 
var username

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _connect_network():
	print("Connecting " + hostname + ":" + str(port))
	
	if get_tree().network_peer == null:
		network = NetworkedMultiplayerENet.new()
		network.create_client(hostname, port)
		get_tree().network_peer = network
		get_tree().connect("network_peer_connected", self, "_host_connected")
		get_tree().connect("network_peer_disconnected", self, "_host_disconnected")
		get_tree().connect("connected_to_server", self, "_connected_ok")
		get_tree().connect("connection_failed", self, "_connected_fail")
		get_tree().connect("server_disconnected", self, "_server_disconnected")

# Extract from valid URL only.
func _extract_host_segments(host):
	var regex = RegEx.new()
	regex.compile("(?:http.*://)?(?P<host>[^:/ ]+).?(?P<port>[0-9]*).*")
	var result = regex.search(host)
	if result:
		# Come back and get proto
		port = int(result.get_string("port"))
		hostname = result.get_string("host")
		
# Check if hostname is valid.
func _check_valid_host(host):
	print("Extract valid segments from " + host)
	
	_extract_host_segments(host)
		
	if hostname == null:
		return false
	else:
		return true

# Handle signal request to join host.
func _on_join_host_line_connect_host(host):
	print("Join host request for " + host)
	
	if _check_valid_host(host) && get_tree().network_peer == null:
		_connect_network()
		$GameScreen/UserControls/JoinHostButton.disabled = true
		$GameScreen/UserControls/HostSelection/JoinHost.visible = false
		$GameScreen/PondNetwork.visible = true
	else: 
		printerr("Unable to connect.")
		$GameScreen/UserControls/HostSelection/JoinHost.visible = false

func _host_connected(id):
	print("host "+ str(id) + " connected")
	
func _host_disconnected(id):
	print("host "+ str(id) + " disconnected")
	$GameScreen/client.delete_duck(id)

func _connected_ok():
	print("connected from " + hostname)
	$GameScreen/UserControls/JoinHostButton.disabled = false
	$GameScreen/PondNetwork.visible = false
	my_id = get_tree().get_network_unique_id()
	var response = {"name": username,"orgin": $GameScreen/PondScene/Duck.transform.origin, "rotation": $GameScreen/PondScene/Duck.rotation}
	rpc_id(1, "set_new_duck_user", response)

func _server_disconnected():
	print("disconnected from " + hostname)
	
	$GameScreen/client.delete_pond()
	
	# TODO Try and reconnect 3 times then send message
	$GameScreen/UserControls/JoinHostButton.disabled = true
	$GameScreen/PondNetwork.visible = true

func _on_Cancel_pressed():
	get_node("GameScreen/UserControls/ColorSelection/DuckColor").visible = false
	$GameScreen/PondScene/Duck._update_material_menu()

func _on_Save_pressed():
	get_node("GameScreen/UserControls/ColorSelection/DuckColor").visible = false
	$GameScreen/PondScene/Duck._update_material_colors()

func _on_BeginGame_pressed():
	get_node("StartScreen").hide() 
	get_node("GameScreen").visible = true
	get_node("GameScreen/PondScene/Duck").visible = true
	username = get_node("StartScreen/UserNameEdit/UserNameLine").text
	$GameScreen/UserControls/UserName.text = username
	
