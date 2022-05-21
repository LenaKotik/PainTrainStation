extends Control



func play_pressed():
	get_tree().change_scene("res://Scenes/Levels/Test2.tscn");


func settings_pressed():
	get_tree().change_scene("res://Scenes/UI/Settings.tscn");
