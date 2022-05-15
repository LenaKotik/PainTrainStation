extends Area2D
class_name Carpet

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
	player_in(body);
func on_body_exited(body:Node) -> void:
	player_out(body);
