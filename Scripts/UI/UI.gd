extends Control

export var green : Color;
export var yellow : Color;
export var red : Color;
export var weaponDisplay : PackedScene;

onready var HP_bar : ProgressBar = $ProgressBar;
onready var wep_cont : HBoxContainer = $Weapons;
onready var pause_ : Control = $Pause;
onready var pause_resume : Button = $Pause/Panel/VBoxContainer/Resume;
onready var pause_menu : Button = $Pause/Panel/VBoxContainer/Menu;
onready var dead_ : Control = $Death;
onready var dead_restart : Button = $Death/Panel/VBoxContainer/Restart;
onready var dead_menu : Button = $Death/Panel/VBoxContainer/Menu;

var can_pause : bool = true;

func _ready():
	var sb = HP_bar.get_stylebox("fg") as StyleBoxFlat;
	sb.bg_color = green;
	pause_resume.connect("pressed", self, "resume");
	dead_restart.connect("pressed", self, "restart");
	pause_menu.connect("pressed", self, "menu");
	dead_menu.connect("pressed", self, "menu");

func died():
	dead_.visible = true;
	can_pause = false;

func menu():
	get_tree().paused = false;
	get_tree().change_scene("res://Scenes/UI/MainMenu.tscn");

func resume():
	get_tree().paused = false;
	pause_.visible = false;

func restart():
	get_tree().reload_current_scene();

func _input(event):
	if event.is_action_pressed("ui_cancel") and can_pause:
		get_tree().paused = !get_tree().paused;
		pause_.visible = get_tree().paused;

func set_max_hp(v:float):
	HP_bar.max_value = v;
	HP_bar.value = v;

func set_hp(v:float):
	HP_bar.value = v;
	var sb = HP_bar.get_stylebox("fg") as StyleBoxFlat;
	var w = HP_bar.value/HP_bar.max_value;
	if w >= 0.5:
		sb.bg_color = lerp(yellow,green, w*2-1);
	else:
		sb.bg_color = lerp(red,yellow, w*2);

func select_weapon(idx : int):
	for i in range(wep_cont.get_child_count()):
		wep_cont.get_children()[i].select(i == idx);

func add_weapon(texture : Texture):
	var WD = weaponDisplay.instance();
	wep_cont.add_child(WD);
	WD.set_texture(texture);
	select_weapon(wep_cont.get_child_count()-1);
func remove_weapon(idx : int):
	wep_cont.get_children()[idx].queue_free();
