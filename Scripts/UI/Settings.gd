extends Control

export var action_binding : PackedScene;

onready var input_container : VBoxContainer = $Inputs;

func start():
	for a in InputMap.get_actions():
		if a.begins_with("ui_"): continue;
		var AB = action_binding.instance();
		input_container.add_child(AB);
		AB.set_action(a);
