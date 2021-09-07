extends TextEdit


var default_name = "Ducky"
var random_id = RandomNumberGenerator.new()

func _ready():
	random_id.randomize()
	var name = default_name + str(random_id.randi_range(0, 999999))
	$UserNameLine.text = name
