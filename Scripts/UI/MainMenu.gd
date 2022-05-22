extends Control

export var cloud : PackedScene;
export var starting_clouds : int;

onready var settingsA : AnimationPlayer = $anims/SettingsA;
onready var settings : Control = $Settings;
onready var startA : AnimationPlayer = $anims/StartA;
onready var clouds_tmr : Timer = $CloudTimer;
onready var clouds : Node2D = $clouds;

func load_inputs():
	var f = File.new();
	if !f.file_exists("user://keyconfig.dat"): return;
	f.open("user://keyconfig.dat", File.READ);
	var data = f.get_as_text();
	for pair in data.split(";"):
		var action = pair.split(":")[0];
		InputMap.action_erase_events(action);
		if pair.split(":").size() < 2: continue;
		var events = pair.split(":")[1].split(",") as PoolStringArray; 
		if events.size() > 0:
			InputMap.action_add_event(action, get_event_from_str(events[0]));
		if events.size() > 1:
			InputMap.action_add_event(action, get_event_from_str(events[1]));
	
func save_inputs():
	var data : String = "";
	for a in InputMap.get_actions():
		if a.begins_with("ui_"): continue;
		data += ";" + a + ":"
		for e in InputMap.get_action_list(a):
			data += get_event_readable(e) + ",";
		data.erase(data.length()-1,1);
	data.erase(0,1);
	
	var f = File.new();
	f.open("user://keyconfig.dat", File.WRITE);
	f.store_string(data);
func get_event_from_str(s : String) -> InputEvent:
	if s.begins_with("Mouse"):
		var e = InputEventMouseButton.new();
		e.button_index = int(s[s.length()-1]);
		return e;
	var e = InputEventKey.new();
	e.physical_scancode = OS.find_scancode_from_string(s);
	return e;

func get_event_readable(e : InputEvent) -> String:
	if e is InputEventKey:
		return OS.get_scancode_string(e.physical_scancode);
	elif e is InputEventMouseButton:
		return ("Mouse%s" % e.button_index);
	else: return "";

func _ready():
	load_inputs();
	settings.start();
	clouds_tmr.connect("timeout", self, "make_cloud");
	for _i in range(starting_clouds):
		var C = cloud.instance();
		clouds.add_child(C);
		C.global_position.x = rand_range(0, 700);
		
	$Player.can_move = false;

func make_cloud():
	var C = cloud.instance();
	clouds.add_child(C)

func play_pressed():
	startA.play("def");
	yield(startA, "animation_finished");
	get_tree().change_scene("res://Scenes/Levels/Test2.tscn");

func settings_pressed():
	settingsA.play("to");

func _on_Back_from_settings():
	settingsA.play_backwards("to");
	save_inputs();

func _on_Quit():
	get_tree().quit();
