extends Carpet

export var friction : float ;
export var speed : float;
export(ParticlesMaterial) var particles : ParticlesMaterial;

var speeds : Dictionary;
var frictions : Dictionary;

func player_in(body : Actor):
	body.particles.process_material = particles;
	body.particles.emitting = true;
	body.can_move = false;
	speeds[body.name] = body.velocity.length();
	body.velocity = body.velocity.normalized() * speed;
	frictions[body.name] = body.friction;
	body.friction = friction;
#	speeds[body.name] = body.speed;
#	body.speed = speed;

func player_out(body: Actor):
	body.particles.process_material = null;
	body.particles.emitting = false;
	body.can_move = true;
	body.velocity = body.velocity.normalized() * speeds[body.name];
	body.friction = frictions[body.name];
#	body.speed = speeds[body.name];
