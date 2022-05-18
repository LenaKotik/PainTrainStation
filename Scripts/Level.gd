extends Node2D

onready var player = $Player;
onready var nav = $Navigation2D;

func _process(_delta):
	if (Input.is_action_just_pressed("restart") and player == null):
		get_tree().reload_current_scene();
