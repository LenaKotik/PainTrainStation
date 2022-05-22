extends Level

export var start_train : NodePath;
export var ghost : PackedScene;
export var drone : PackedScene;
export var snail : PackedScene;
export var bombs : PackedScene;

onready var trains = [$trains/Train, $trains/Train2, $trains/Train3, $trains/Train4];

func _ready():
	setup();
	get_node(start_train).player_in()


# DEMO CODE:

func _on_shorten():
	if $Timer.wait_time > 0.1:
		$Timer.wait_time -= 0.1
func _on_spawn():
	var E : Enemy;
	if randi() % 3 == 0:
		E = snail.instance();
		add_child(E);
		E.global_position = trains[randi()%trains.size()].global_position;
	var p : Vector2 = Vector2.RIGHT.rotated(rand_range(-PI, PI)) * rand_range(200, 400);
	if randi() % 3 == 0:
		E = drone.instance();
	else:
		E = ghost.instance();
	add_child(E);
	E.global_position = p;

func _on_bomb_timeout():
	var B = bombs.instance();
	add_child(B);
	B.global_position = trains[randi()%trains.size()].global_position;

func _on_shotgun_timeout():
	$pickups/WeaponPickUp2.visible = true;
	$pickups/WeaponPickUp2/CollisionShape2D.disabled = false;


func _on_sword_timeout():
	$pickups/DevilWSword.visible = true;
	$pickups/DevilWSword/WeaponPickUp/CollisionShape2D.disabled = false;




func _on_tutorial_timeout():
	$Player/Label.queue_free()
