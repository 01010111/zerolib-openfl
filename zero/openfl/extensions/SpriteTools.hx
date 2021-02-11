package zero.openfl.extensions;

import openfl.geom.Point;
import openfl.events.MouseEvent;
import openfl.events.Event;
import openfl.display.BitmapData;
import zero.openfl.utilities.Game;
import openfl.display.Bitmap;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.Assets;
import zero.utilities.Color;
import zero.utilities.Vec2;
import zero.utilities.Anchor;

using Math;

class SpriteTools {

	public static inline function add(parent:Sprite, child:DisplayObject) {
		parent.addChild(child);
	}

	public static inline function add_at(parent:Sprite, child:DisplayObject, index:Int) {
		parent.addChildAt(child, index);
	}

	public static inline function remove(sprite:Sprite) {
		if (sprite.parent != null) sprite.parent.removeChild(sprite);
	}

	public static inline function fill_circle(sprite:Sprite, color:Color, x:Float, y:Float, radius:Float):Sprite {
		sprite.graphics.beginFill(color.to_hex_24(), color.alpha);
		sprite.graphics.drawCircle(x, y, radius);
		sprite.graphics.endFill();
		return sprite;
	}

	public static inline function fill_rect(sprite:Sprite, color:Color, x:Float, y:Float, width:Float, height:Float, radius:Float = 0):Sprite {
		sprite.graphics.beginFill(color.to_hex_24(), color.alpha);
		radius == 0 ? sprite.graphics.drawRect(x, y, width, height) : sprite.graphics.drawRoundRect(x, y, width, height, radius);
		sprite.graphics.endFill();
		return sprite;
	}

	public static inline function fill_poly(sprite:Sprite, color:Color, poly:Array<Vec2>) {
		if (poly.length <= 2) return sprite;
		sprite.graphics.beginFill(color.to_hex_24());
		var start = poly.shift();
		sprite.graphics.moveTo(start.x, start.y);
		while (poly.length > 0) {
			var p = poly.shift();
			sprite.graphics.lineTo(p.x, p.y);
			p.put();
		}
		sprite.graphics.moveTo(start.x, start.y);
		start.put();
		sprite.graphics.endFill();
		return sprite;
	}

	public static inline function circle(sprite:Sprite, color:Color, x:Float, y:Float, radius:Float, line_width:Float = 1):Sprite {
		sprite.graphics.lineStyle(line_width, color.to_hex_24(), color.alpha);
		sprite.graphics.drawCircle(x, y, radius);
		sprite.graphics.lineStyle();
		return sprite;
	}

	public static inline function rect(sprite:Sprite, color:Color, x:Float, y:Float, width:Float, height:Float, radius:Float = 0, line_width:Float = 1):Sprite {
		sprite.graphics.lineStyle(line_width, color.to_hex_24(), color.alpha);
		radius == 0 ? sprite.graphics.drawRect(x, y, width, height) : sprite.graphics.drawRoundRect(x, y, width, height, radius);
		sprite.graphics.lineStyle();
		return sprite;
	}

	public static inline function line(sprite:Sprite, color:Color, p0x:Float, p0y:Float, p1x:Float, p1y:Float, thickness:Float = 1):Sprite {
		sprite.graphics.lineStyle(thickness, color.to_hex_24(), color.alpha);
		sprite.graphics.moveTo(p0x, p0y);
		sprite.graphics.lineTo(p1x, p1y);
		sprite.graphics.lineStyle();
		return sprite;
	}

	public static inline function poly(sprite:Sprite, color:Color, poly:Array<Vec2>, thickness:Float = 1) {
		if (poly.length < 2) return sprite;
		if (poly.length == 2) return line(sprite, color, poly[0].x, poly[0].y, poly[1].x, poly[2].y, thickness);
		var start = poly[0];
		var p1 = poly.shift();
		while (poly.length > 0) {
			var p2 = poly.shift();
			line(sprite, color, p1.x, p1.y, p2.x, p2.y, thickness);
			p1 = p2.copy();
			p2.put();
		}
		line (sprite, color, p1.x, p1.y, start.x, start.y, thickness);
		start.put();
		p1.put();
		return sprite;
	}

	public static inline function set_scale(sprite:Sprite, x:Float = 0, ?y:Float) {
		if (y == null) y = x;
		sprite.scaleX = x;
		sprite.scaleY = y;
		return sprite;
	}

	public static inline function children(sprite:Sprite):Array<DisplayObject> {
		return [for (i in 0...sprite.numChildren) sprite.getChildAt(i)];
	}

	public static inline function set_position(sprite:Sprite, x:Float, y:Float) {
		sprite.x = x;
		sprite.y = y;
		return sprite;
	}

	public static inline function distance(sprite1:Sprite, sprite2:Sprite):Float {
		var p1 = Vec2.get(sprite1.x, sprite1.y);
		var p2 = Vec2.get(sprite2.x, sprite2.y);
		var out = p1.distance(p2);
		p1.put();
		p2.put();
		return out;
	}

	public static inline function vector_between(sprite1:Sprite, sprite2:Sprite):Vec2 {
		var p1 = Vec2.get(sprite1.x, sprite1.y);
		var p2 = Vec2.get(sprite2.x, sprite2.y);
		var out = p1 - p2;
		p1.put();
		p2.put();
		return out;
	}

	public static function load_graphic(sprite:Sprite, graphic:String, anchor:Anchor, smoothing:Bool = false) {
		var bitmap = new Bitmap(Assets.getBitmapData(graphic));
		bitmap.smoothing = smoothing;
		bitmap.x = switch anchor {
			case TOP_LEFT | MIDDLE_LEFT | BOTTOM_LEFT: 0;
			case TOP_CENTER | MIDDLE_CENTER | BOTTOM_CENTER: -bitmap.width/2;
			case TOP_RIGHT | MIDDLE_RIGHT | BOTTOM_RIGHT: -bitmap.width;
		}
		bitmap.y = switch anchor {
			case TOP_LEFT | TOP_CENTER | TOP_RIGHT: 0;
			case MIDDLE_LEFT | MIDDLE_CENTER | MIDDLE_RIGHT: -bitmap.height/2;
			case BOTTOM_LEFT | BOTTOM_CENTER | BOTTOM_RIGHT: -bitmap.height;
		}
		sprite.addChild(bitmap);
		return sprite;
	}

	public static function center(sprite:Sprite):Sprite {
		set_position(sprite, Game.width/2, Game.height/2);
		return sprite;
	}

	public static function on<T>(sprite:Sprite, event:openfl.events.EventType<T>, callback:Dynamic -> Sprite -> Void):Sprite {
		sprite.addEventListener(event, (e) -> callback(e, sprite));
		return sprite;
	}

	public static function global_position(sprite:Sprite):Vec2 {
		var pos = new Point(sprite.x, sprite.y);
		var global_pos = sprite.parent.localToGlobal(pos);
		var out = Vec2.get(global_pos.x, global_pos.y);
		return out;
	}

}