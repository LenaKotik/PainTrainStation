extends Area2D
class_name Carpet

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
		player_in(body);
func on_body_exited(body:Node) -> void:
	if body is Actor:
		player_out(body);
