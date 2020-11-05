package zero.openfl.utilities;

import openfl.events.Event;
import lime.ui.Joystick;

using Math;

class Gamepad {

	public static var analog_threshold:Float = 0.2;

	static var buttons:Map<Int, Bool> = [];
	static var buttons_last:Map<Int, Bool> = [];

	static var axes:Map<Int, Float> = [];
	static var axes_last:Map<Int, Float> = [];

	public static function init() {
		Joystick.onConnect.add(connect);
	}

	static function connect(joystick:Joystick) {
		joystick.onButtonDown.add((id) -> buttons.set(id, true));
		joystick.onButtonUp.add((id) -> buttons.set(id, false));
		joystick.onAxisMove.add((id, value) -> axes.set(id, value));
		Game.root.stage.addEventListener(Event.EXIT_FRAME, (e) -> {
			for (key => value in buttons) buttons_last.set(key, value);
			for (key => value in axes) axes_last.set(key, value);
		});
	}

	public static function pressed(button:Int):Bool {
		if (!buttons.exists(button)) return false;
		return buttons[button];
	}

	public static function just_pressed(button:Int):Bool {
		if (!buttons.exists(button)) return false;
		if (!buttons[button]) return false;
		if (buttons_last[button]) return false;
		buttons_last.set(button, true);
		return true;
	}

	public static function just_released(button:Int):Bool {
		if (!buttons.exists(button)) return false;
		if (buttons[button]) return false;
		if (!buttons_last[button]) return false;
		buttons_last.set(button, false);
		return true;
	}

	public static function axis_pressed(axis:Int):Bool {
		if (!axes.exists(axis)) return false;
		return axes[axis].abs() >= analog_threshold;
	}

	public static function axis_just_pressed(axis:Int):Bool {
		if (!axes.exists(axis)) return false;
		if (axes[axis].abs() < analog_threshold) return false;
		if (axes_last[axis].abs() >= analog_threshold) return false;
		axes_last.set(axis, axes[axis]);
		return true;
	}

	public static function axis_just_released(axis:Int):Bool {
		if (!axes.exists(axis)) return false;
		if (axes[axis].abs() >= analog_threshold) return false;
		if (axes_last[axis].abs() < analog_threshold) return false;
		axes_last.set(axis, axes[axis]);
		return true;
	}

	public static function get_axis(axis:Int):Float {
		if (!axes.exists(axis)) return 0;
		return axes[axis];
	}

	public static function trace_buttons() {
		//for (button => pressed in buttons) if (pressed) trace('button $button pressed');
	}

	public static function trace_axes() {
		for (axis => value in axes) if (value.abs() > analog_threshold) trace('axis $axis value $value');
	}

}