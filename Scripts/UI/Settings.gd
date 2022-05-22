extends Control

export var action_binding : PackedScene;

onready var input_container : VBoxContainer = $Inputs;

func start():
	var actns = InputMap.get_actions();
	actns.sort();
	for a in actns:
		if a.begins_with("ui_"): continue;
		var AB = action_binding.instance();
		input_container.add_child(AB);
		AB.set_action(a);
