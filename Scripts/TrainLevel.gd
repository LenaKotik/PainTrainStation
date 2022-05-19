extends Level

export var start_train : NodePath;

func _ready():
	get_node(start_train).player_in()
