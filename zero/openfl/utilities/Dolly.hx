package zero.openfl.utilities;

import zero.utilities.Rect;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import zero.utilities.Vec2;

using Math;
using zero.utilities.EventBus;

class Dolly extends Sprite {

	var target:DisplayObject;
	var position:Vec2 = Vec2.get();
	var offset:Vec2 = Vec2.get();
	var offset_amt:Vec2 = Vec2.get(96, 64);
	var bounds:Rect;
	var zoom(get, never):Float;

	public static var i:Dolly;

	public var pixel_perfect:Bool = true;

	public function new(?parent:Scene) {
		super();
		i = this;
		if (parent != null) parent.addChild(this);
		update.listen('update');
	}

	public function follow(target:DisplayObject, snap:Bool = true) {
		this.target = target;
		if (snap) {
			position.set(-target.x + Game.width / zoom / 2, -target.y + Game.height / zoom / 2);
			x = position.x;
			y = position.y;
			apply_bounds();
		}
	}

	public function update(?dt:Dynamic) {
		if (target == null) return;
		get_target_position(position);
		get_offset();
		lerp_to_position();
		apply_bounds();
		apply_pixel_perfect();
	}

	function get_target_position(?position:Vec2) {
		if (position == null) position = Vec2.get();
		if (target == null) return position;
		position.set(-target.x + Game.width / zoom / 2, -target.y + Game.height / zoom / 2);
		return position;
	}

	function get_offset(?offset:Vec2) {
		if (offset == null) offset = Vec2.get();
		offset.x += (-Controller.get_axis(RIGHT_ANALOG_X) * offset_amt.x - offset.x) * 0.1;
		offset.y += (-Controller.get_axis(RIGHT_ANALOG_Y) * offset_amt.y - offset.y) * 0.1;
		return offset;
	}

	function lerp_to_position() {
		x += (position.x + offset.x - x) * 0.1;
		y += (position.y + offset.y - y) * 0.1;
	}

	function apply_bounds() {
		if (bounds == null) return;
		x = x.min(-bounds.left).max(-bounds.right + Game.width/zoom);
		y = y.min(-bounds.top).max(-bounds.bottom + Game.height/zoom);
	}

	function apply_pixel_perfect() {
		if (!pixel_perfect) return;
		x = x.round();
		y = y.round();
	}

	function get_zoom() {
		var zoom = 1.0;
		var parent = this.parent;
		while (parent != null) {
			zoom *= parent.scaleX;
			parent = parent.parent;
		}
		return zoom;
	}

	public function set_bounds(rect:Rect) bounds = cast rect.copy();

}