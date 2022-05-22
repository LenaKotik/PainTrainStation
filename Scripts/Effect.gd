extends CPUParticles2D

export var effect_lifetime : float;
func _ready():
	var tmr = Timer.new();
	add_child(tmr);
	tmr.connect("timeout", self, "queue_free");
	emitting = true;
	tmr.start(effect_lifetime);
