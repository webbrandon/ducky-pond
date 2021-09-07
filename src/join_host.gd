extends LineEdit

signal connect_host(host)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_ENTER:
			var host = get_text()
			emit_signal("connect_host", host)
