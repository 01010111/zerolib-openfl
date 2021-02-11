package zero.openfl.utilities;

import zero.utilities.Tween;
import zero.utilities.Timer;
import openfl.events.Event;

using Math;
using zero.utilities.EventBus;

class UpdateManager {
	static var last = 0.0;
	public static var wait:Bool = false;
	public static var FPS(get, never):Int;
	static function get_FPS() {
		var amt = 0.0;
		for (n in fps_array) amt += n;
		return (amt/fps_array.length).round();
	}
	static var fps_array:Array<Float> = [];
	public static function update(e:Event) {
		if (wait) return;
		var dt = get_dt(get_time());
		Timer.update(dt);
		Tween.update(dt);
		'update'.dispatch(dt);
		'persistent_update'.dispatch(dt);
		fps_array.push(1/dt);
		while (fps_array.length > 10) fps_array.shift();
	}
	static function get_time():Float {
		return Date.now().getTime();
	}
	static function get_dt(time:Float):Float {
		var out = (time - last) / 1000;
		last = time;
		return out;
	}
}