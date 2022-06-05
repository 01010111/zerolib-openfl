package zero.openfl.utilities;

import openfl.events.Event;
import openfl.events.KeyboardEvent;

class Keys {

	static var keys:Map<KeyCode, Bool> = [];
	static var last:Map<KeyCode, Bool> = [];

	public static function init() {
		Game.root.stage.addEventListener(KeyboardEvent.KEY_DOWN, (e) -> keys.set(cast e.keyCode, true));
		Game.root.stage.addEventListener(KeyboardEvent.KEY_UP, (e) -> keys.set(cast e.keyCode, false));
		Game.root.stage.addEventListener(Event.EXIT_FRAME, (e) -> for (key => value in keys) last.set(key, value));
	}

	public static function pressed(key:KeyCode):Bool {
		if (!keys.exists(key)) return false;
		return keys[key];
	}

	public static function just_pressed(key:KeyCode):Bool {
		if (!keys.exists(key)) return false;
		if (!keys[key]) return false;
		if (last[key]) return false;
		last.set(key, true);
		return true;
	}

	public static function just_released(key:KeyCode):Bool {
		if (!keys.exists(key)) return false;
		if (keys[key]) return false;
		if (!last[key]) return false;
		last.set(key, false);
		return true;
	}

	public static function trace() {
		for (key => value in keys) if (value) trace(key); 
	}

}

enum abstract KeyCode(Int) {
	var UP = 38;
	var DOWN = 40;
	var LEFT = 37;
	var RIGHT = 39;
}