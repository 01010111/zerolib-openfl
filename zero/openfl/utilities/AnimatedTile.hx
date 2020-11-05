package zero.openfl.utilities;

import openfl.Assets;
import openfl.display.Tile;
import openfl.display.Tileset;
import openfl.geom.Rectangle;

using Std;

class AnimatedTile extends Tile
{
	private var frames:Array<Int>;

	public function new(options:AnimatedTileOptions)
	{
		super();
		var bitmap_data = Assets.getBitmapData(options.source);
		tileset = new Tileset(bitmap_data);
		var rect = new Rectangle(0, 0, options.frame_width, options.frame_height);
		for (j in 0...(bitmap_data.height/options.frame_height).int()) {
			for (i in 0...(bitmap_data.width/options.frame_width).int()) {
				rect.x = i * options.frame_width;
				rect.y = j * options.frame_height;
				tileset.addRect(rect);
			}
		}
	}

}

typedef AnimatedTileOptions = {
	source:String,
	frame_width:Int,
	frame_height:Int,
}