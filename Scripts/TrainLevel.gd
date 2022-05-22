extends Level

export var start_train : NodePath;

func _ready():
	setup();
	get_node(start_train).player_in()
