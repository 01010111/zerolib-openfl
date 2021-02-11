package zero.openfl.utilities;

class Controller {
	
	static var key_map:Map<Action, Array<Int>> = [
		A				=> [90, 67],
		B				=> [88],
		UP				=> [38],
		DOWN			=> [40],
		LEFT			=> [37],
		RIGHT			=> [39],
		START			=> [13],
		SELECT			=> [9],
		LEFT_BUMPER		=> [65],
		RIGHT_BUMPER	=> [68],
	];
	static var pad_map:Map<Action, Button> = [
		A				=> A,
		B				=> B,
		UP				=> UP,
		DOWN			=> DOWN,
		LEFT			=> LEFT,
		RIGHT			=> RIGHT,
		START			=> START,
		SELECT			=> SELECT,
		LEFT_BUMPER		=> LEFT_BUMPER,
		RIGHT_BUMPER	=> RIGHT_BUMPER,
	];

	public static function set_key(a:Action, k:Int) key_map.set(a, [k]);

	public static function pressed(action:Action) {
		// Keyboard
		var keys = false;
		for (key in key_map[action]) if (Keys.pressed(key)) keys = true;
		// Gamepad
		var gamepad = false;
		if ((cast pad_map[action]) < 0 && Gamepad.axis_pressed((cast pad_map[action]) * -1)) gamepad = true;
		else if (Gamepad.pressed(cast pad_map[action])) gamepad = true;
		return keys || gamepad;
	}

	public static function just_pressed(action:Action) {
		// Keyboard
		var keys = false;
		for (key in key_map[action]) if (Keys.just_pressed(key)) keys = true;
		// Gamepad
		var gamepad = false;
		if ((cast pad_map[action]) < 0 && Gamepad.axis_pressed((cast pad_map[action]) * -1)) gamepad = true;
		else if (Gamepad.just_pressed(cast pad_map[action])) gamepad = true;
		return keys || gamepad;
	}

	public static function just_released(action:Action) {
		// Keyboard
		var keys = false;
		for (key in key_map[action]) if (Keys.just_released(key)) keys = true;
		// Gamepad
		var gamepad = false;
		if ((cast pad_map[action]) < 0 && Gamepad.axis_pressed((cast pad_map[action]) * -1)) gamepad = true;
		else if (Gamepad.just_released(cast pad_map[action])) gamepad = true;
		return keys || gamepad;
	}

	public static function get_axis(id:Axis):Float {
		if (Gamepad.axis_pressed(cast id)) return Gamepad.get_axis(cast id);
		return 0;
	}

}

enum Action {
	A;
	B;
	X;
	Y;
	UP;
	DOWN;
	LEFT;
	RIGHT;
	START;
	SELECT;
	LEFT_BUMPER;
	RIGHT_BUMPER;
}

enum abstract Button(Int) {
	var A = 0;
	var B = 1;
	var X = 2;
	var Y = 3;
	var UP = 12;
	var DOWN = 13;
	var LEFT = 14;
	var RIGHT = 15;
	var START = 9;
	var SELECT = 8;
	var LEFT_BUMPER = 4;
	var RIGHT_BUMPER = 5;
	var LEFT_TRIGGER = -4;
	var RIGHT_TRIGGER = -5;
}

enum abstract Axis(Int) {
	var LEFT_ANALOG_X = 0;
	var LEFT_ANALOG_Y = 1;
	var RIGHT_ANALOG_X = 2;
	var RIGHT_ANALOG_Y = 3;
	var LEFT_TRIGGER = 4;
	var RIGHT_TRIGGER = 5;
}