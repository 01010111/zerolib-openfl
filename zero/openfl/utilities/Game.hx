package zero.openfl.utilities;

import openfl.events.FocusEvent;
import zero.utilities.Tween;
import zero.utilities.Tween.TweenProperty;
import zero.utilities.Timer;
import openfl.events.Event;
import zero.utilities.Vec2;
import openfl.display.Sprite;
import zero.openfl.utilities.Scene;
import zero.openfl.utilities.FPS;
import openfl.Lib;

using zero.openfl.extensions.SpriteTools;
using zero.utilities.EventBus;
using Math;

class Game {

	public static var i:Game;
	public static var width(get, never):Float;
	public static var height(get, never):Float;	
	public static var root:Sprite;
	public static var mouse:Vec2 = [0, 0];

	static function get_width() return Lib.application.window.width;
	static function get_height() return Lib.application.window.height;

	public var scene(default, null):Scene;
	public var time_scale:Float = 1;
	#if echo
	public var world(default, null):echo.World;
	#if debug
	public var debug:echo.util.Debug.OpenFLDebug;
	#end
	#end

	var last = haxe.Timer.stamp();
	var focus_lost:Bool = false;

	public function new(root:Sprite, scene:Class<Scene>, bg_color:Int = 0x000000) {
		i = this;

		Game.root = root;
		root.stage.color = bg_color;
		root.addEventListener(Event.ENTER_FRAME, tick);
		root.addEventListener(Event.EXIT_FRAME, (e) -> 'post_update'.dispatch());
		root.addEventListener(Event.RESIZE, (e) -> 'resize'.dispatch({ width: width, height: height }));
		root.addEventListener(Event.DEACTIVATE, (e) -> focus_lost = true);
		root.addEventListener(FocusEvent.FOCUS_OUT, (e) -> focus_lost = true);

		Keys.init();

		#if echo
		world = new echo.World({
			width: Game.width,
			height: Game.height
		});
		#end

		change_scene(Type.createInstance(scene, []));
	}

	public function change_scene(scene:Scene) {
		if (this.scene != null) this.scene.remove();
		this.scene = scene;
		scene.create();
		root.add(scene);
		#if debug
		#if echo
		debug = new echo.util.Debug.OpenFLDebug();
		debug.canvas.visible = false;
		var debug_update = (?dt) -> {
			if (Keys.just_pressed(192)) debug.canvas.visible = !debug.canvas.visible;
			if (debug.canvas.visible) debug.draw(world);
		}
		debug_update.listen('update');
		if (Dolly.i != null) Dolly.i.add(debug.canvas);
		else {
			root.add(debug.canvas);
			debug.canvas.set_scale(scene.scaleX, scene.scaleY);
		}
		#end
		var fps = new FPS(32, Game.height - 80, 0xFFFFFF);
		root.add(fps);
		((?_) -> fps.y = Game.height - 80).listen('resize');
		#end
	}

	function tick(e:Event) {
		if (focus_lost) {
			last = haxe.Timer.stamp();
			focus_lost = false;
			return;
		}
		var time = haxe.Timer.stamp();
		var dt = time - last;
		dt = dt.min(0.1);
		if (dt > 1) trace(dt);
		last = time;
		#if echo if (world != null) world.step(dt); #end
		'update'.dispatch(dt);
		Tween.update(dt);
		Timer.update(dt);
	}
	
}