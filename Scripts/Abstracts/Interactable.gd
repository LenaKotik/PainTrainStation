extends Area2D
class_name Interactable


# warning-ignore:unused_argument
func interact(_body: Actor) -> void: # virtual
	print("if you are reading this, i messed up ;-;");
func player_in(_body : Actor) -> void: # virtual
	pass
func player_out(_body : Actor) -> void: # virtual
	pass
func _ready():
# warning-ignore:return_value_discarded
	self.connect("body_entered", self, "on_body_entered");
# warning-ignore:return_value_discarded
	self.connect("body_exited", self, "on_body_exited");
func on_body_entered(body:Node) -> void:
	if body is Actor:
		body.inter = self;
		player_in(body);
func on_body_exited(body:Node) -> void:
	if body is Actor:
		body.inter = null;
		player_out(body);
