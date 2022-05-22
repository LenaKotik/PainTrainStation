extends Enemy

export var attack_period : int;
export var attacks : PoolStringArray;

var attack : String;

func _process(_delta):
	move()
	if randi() % attack_period * 60:
		attack = attacks[randi()%attacks.size()];
		call(attack);
