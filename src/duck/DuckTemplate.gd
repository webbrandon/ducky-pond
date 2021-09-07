extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func move_player(duck_origin, duck_rotation):
	transform.origin = duck_origin
	rotation = duck_rotation
