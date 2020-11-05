package zero.openfl.utilities;

import openfl.display.Sprite;
import zero.utilities.Vec2;

#if echo
import echo.data.Options.BodyOptions;
#end

using zero.utilities.EventBus;

class GameObject extends Sprite {

	#if echo
	public var body(default, set):Null<Body>;
	inline function set_body(v:Null<Body>) {
		if (body != null) {
			body.remove();
			body.game_object = null;
		}
		v.game_object = this;
		Game.i.world.add(v);
		return body = v;
	}
	
	override private function set_x(v:Float){
		if (body != null) body.x = v;
		return super.set_x(v);
	}
	
	override private function set_y(v:Float){
		if (body != null) body.y = v;
		return super.set_y(v);
	}
	
	override private function set_rotation(v:Float){
		if (body != null) body.rotation = v;
		return super.set_rotation(v);
	}

	public function create_body(options:BodyOptions, ?world:World) {
		if (body != null) body.dispose();

		if (options.x == null) options.x = x;
		if (options.y == null) options.y = y;

		x = options.x;
		y = options.y;

		body = new Body(options);

		if (world != null) world.add(body);

		return body;
	}
	#end
	
	public function new() {
		super();
		update.listen('update');
		resize.listen('resize');
	}

	public function update(?dt:Float) {
		#if echo
		if (body == null) return;
		if (body.x != x) x = body.x;
		if (body.y != y) y = body.y;
		if (body.rotation != rotation) rotation = body.rotation;
		#end
	}

	public function resize(?size:{ width:Float, height:Float }) {}
	public function get_position():Vec2 return [x, y];
	public function get_scale():Vec2 return [scaleX, scaleY];
	public function set_scale(x:Float, y:Float) {
		scaleX = x;
		scaleY = y;
	}

}