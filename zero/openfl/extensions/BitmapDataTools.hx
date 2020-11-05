package zero.openfl.extensions;

import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.display.BitmapData;

class BitmapDataTools {

	public static function combine(bitmaps:Array<BitmapData>) {
		var width = 0;
		var height = 0;
		for (bitmap in bitmaps) {
			if (bitmap.width > width) width = bitmap.width;
			height += bitmap.height;
		}
		var out = new BitmapData(width, height, true, 0x00FFFFFF);
		var p = new Point(0, 0);
		var r = new Rectangle(0, 0, 0, 0);
		for (bitmap in bitmaps) {
			r.width = bitmap.width;
			r.height = bitmap.height;
			out.copyPixels(bitmap, r, p);
			p.y += bitmap.height;
		}
		return out;
	}

}