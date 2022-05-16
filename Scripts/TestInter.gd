extends Interactable
tool

export(NodePath) var spritePath;

var colors : PoolColorArray = [
	Color.yellowgreen,
	Color.crimson,
	Color.navyblue,
	Color.deeppink,
	Color.yellow,
	Color.green
];
func _get_configuration_warning():
	if (spritePath == ""):
		return "sprite path must be set";
	return "";
func interact(_body:Actor):
	var sprite = get_node(spritePath) as CanvasItem;
	sprite.modulate = colors[randi() % colors.size()]
