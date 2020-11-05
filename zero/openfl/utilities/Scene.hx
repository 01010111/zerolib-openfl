package zero.openfl.utilities;

import openfl.display.Sprite;

class Scene extends Sprite {

	public var zoom(get , set):Float;
	function get_zoom() return (scaleX + scaleY)/2;
	function set_zoom(n:Float) return scaleX = scaleY = n;

	public function new() {
		super();
		init();
	}
	
	function init() {
		#if echo
		Game.i.world.clear();
		#end
	}

	public function create() {

	}	

}