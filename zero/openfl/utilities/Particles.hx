package zero.openfl.utilities;

class Particles {

	var create:Void -> Particle;
	var pool:Array<Particle> = [];
	
	public function new(create:Void -> Particle) {
		this.create = create;
	}

	public function fire(options:Dynamic) {
		get_particle().fire(options);
	}

	function get_particle():Particle {
		for (particle in pool) if (particle.get_available()) return particle;
		var particle = create();
		pool.push(particle);
		return particle;
	}

}

interface Particle {

	function get_available():Bool;
	function fire(options:Dynamic):Void;

}