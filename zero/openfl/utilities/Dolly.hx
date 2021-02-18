package zero.openfl.utilities;

import openfl.display.DisplayObject;
import openfl.display.Sprite;
import zero.utilities.Vec2;

using Math;
using zero.utilities.EventBus;

class Dolly extends Sprite {

	var target:DisplayObject;
	var tilemap:Tilemap;
	var position:Vec2 = [0, 0];
	var offset:Vec2 = [0, 0];
	var offset_amt:Vec2 = [96, 64];

	public static var i:Dolly;

	public var pixel_perfect:Bool = true;

	public function new(?parent:Scene) {
		super();
		i = this;
		if (parent != null) parent.addChild(this);
		update.listen('update');
	}

	public function follow(target:DisplayObject, snap:Bool = true, ?tilemap:Tilemap) {
		this.target = target;
		this.tilemap = tilemap;
		if (snap) {
			position.set(-target.x + Game.width/Game.i.scene.zoom/2, -target.y + Game.height/Game.i.scene.zoom/2);
			x = position.x;
			y = position.y;
		}
	}

	public function update(?dt:Float) {
		if (target == null) return;
		var zoom = 1.0;
		var parent = this.parent;
		while (parent != null) {
			zoom *= parent.scaleX;
			parent = parent.parent;
		}
		position.set(-target.x + Game.width / zoom / 2, -target.y + Game.height / zoom / 2);
		offset.x += (-Controller.get_axis(RIGHT_ANALOG_X) * offset_amt.x - offset.x) * 0.1;
		offset.y += (-Controller.get_axis(RIGHT_ANALOG_Y) * offset_amt.y - offset.y) * 0.1;
		x += (position.x + offset.x - x) * 0.1;
		y += (position.y + offset.y - y) * 0.1;
		if (pixel_perfect) {
			x = x.round();
			y = y.round();
		}
	}

}