extends Area2D
class_name Interactable


# warning-ignore:unused_argument
func interact(_body: Node) -> void: # virtual
	print("if you are reading this, i messed up ;-;");
func player_in(_body : Node) -> void: # virtual
	pass
func player_out(_body : Node) -> void: # virtual
	pass
func _ready():
# warning-ignore:return_value_discarded
	self.connect("body_entered", self, "on_body_entered");
# warning-ignore:return_value_discarded
	self.connect("body_exited", self, "on_body_exited");
func on_body_entered(body:Node) -> void:
	body.inter = self;
	player_in(body);
func on_body_exited(body:Node) -> void:
	body.inter = null;
	player_out(body);
