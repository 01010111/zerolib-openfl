package zero.openfl.utilities;

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

class Game {

	public static var i:Game;

	public static var width(get, never):Float;
	static function get_width() return Lib.application.window.width;

	public static var height(get, never):Float;
	static function get_height() return Lib.application.window.height;

	public var scene(default, null):Scene;
	#if echo
	public var world(default, null):echo.World;
	#end

	public static var root:Sprite;
	public static var mouse:Vec2 = [0, 0];

	var last = Date.now().getTime();

	public function new(root:Sprite, scene:Class<Scene>) {
		i = this;
		Game.root = root;

		root.addEventListener(Event.ENTER_FRAME, tick);
		root.addEventListener(Event.EXIT_FRAME, (e) -> 'post_update'.dispatch());
		root.addEventListener(Event.RESIZE, (e) -> 'resize'.dispatch({ width: width, height: height }));

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
		var fps = new FPS(32, Game.height - 80, 0xFFFFFF);
		root.add(fps);
		((?_) -> fps.y = Game.height - 80).listen('resize');
		#end
	}

	function tick(e:Event) {
		var time = Date.now().getTime();
		var dt = (time - last) / 1000;
		last = time
		Timer.update(dt);
		Tween.update(dt);
		'update'.dispatch(dt);
		#if echo
		if (world != null) world.step(dt);
		#end
	}
	
}