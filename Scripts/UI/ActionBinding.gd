extends HBoxContainer

onready var action_name : Label = $Name;
onready var main_event : Button = $Main;
onready var alt_event : Button = $Alt;
onready var delay : Timer = $Timer;

var waiting_key : int = 0; # 0 - none 1 - main 2 - alt

func _ready():
	main_event.connect("button_down", self, "pressed", [true]);
	alt_event.connect("button_down", self, "pressed", [false]);

func pressed(is_main: bool):
	if waiting_key != 0: return;
	var b = main_event if is_main else alt_event;
	b.text = "[press any button]";
	waiting_key = 2 - int(is_main);
	delay.start();

func _input(event):
	if waiting_key == 0 or !delay.is_stopped(): return;
	var events : Array = InputMap.get_action_list(action_name.text);
	InputMap.action_erase_events(action_name.text);
	if events.size() >= waiting_key:  events.erase(events[waiting_key-1]);
	if !(event is InputEventKey and event.physical_scancode == KEY_ESCAPE):
		events.insert(waiting_key-1, event);
	for e in events:
		InputMap.action_add_event(action_name.text, e);
	var b = main_event if waiting_key == 1 else alt_event;
	b.text =  get_event_readable(event);
	if (event is InputEventKey and event.physical_scancode == KEY_ESCAPE) or b.text == "":
		b.text = "[not set]";
	b.pressed = false;
	waiting_key = 0;

func set_action(a : String):
	action_name.text = a;
	var events = InputMap.get_action_list(a);
	if events.size() > 0:
		main_event.text = get_event_readable(events[0]);
	else:
		main_event.text = "[not set]";
	if events.size() > 1:
		alt_event.text = get_event_readable(events[1]);
	else:
		alt_event.text = "[not set]";

func get_event_readable(e : InputEvent) -> String:
	if e is InputEventKey:
		return OS.get_scancode_string(e.physical_scancode);
	elif e is InputEventMouseButton:
		return ("Mouse%s" % e.button_index);
	else: return "";
