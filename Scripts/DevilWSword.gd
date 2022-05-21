extends Node2D

signal unlocked;

var dialogue : PoolStringArray = [
	"This legendary sword will help you slaughter\nevery one who stands in your way.\nTake it as a gift for bravery.",
	"Good. Now go, and kill as many as you can!"
];
onready var dialogue_label : Label = $Label;
onready var tmr : Timer = $Timer;

var seen : bool = false;
var lock : bool = false;

func _on_screen_entered():
	if seen: return;
	seen = true;
	say(0);
func say(idx : int):
	if lock: 
		yield(self, "unlocked");
	lock = true;
	dialogue_label.text = "";
	for ch in dialogue[idx]:
		dialogue_label.text += ch;
		tmr.start();
		yield(tmr, "timeout");
	lock = false;
	emit_signal("unlocked");
func _on_sword_taken():
	say(1);
