package zero.openfl.utilities;

import zero.utilities.IntPoint;
import openfl.display.Tile;
import openfl.geom.Rectangle;
import openfl.display.Tilemap as OpenFLTilemap;
import openfl.display.Tileset as OpenFLTileset;

using openfl.Assets;
using zero.extensions.ArrayExt;
using Math;
using Std;

class Tilemap extends OpenFLTilemap {

	#if echo
	public var bodies:Array<echo.Body>;
	#end
	var map:Array<Array<Int>>;
	var options:TilemapOptions;
	var tiles:Array<Array<Tile>>;

	public function new(options:TilemapOptions) {
		super(
			options.tileset.frame_width * options.map[0].length,
			options.tileset.frame_height * options.map.length,
			new Tileset(options.tileset),
			options.smoothing
		);
		if (options.auto) options.map = auto(options.map);
		this.options = options;
		map = options.map;
		init_map(options.map, options.tileset.frame_width, options.tileset.frame_height);
	}

	function auto(map:Array<Array<Int>>):Array<Array<Int>> {
		return [for (j in 0...map.length) [for (i in 0...map[j].length) get_auto_tile(map, i, j)]];
	}

	function get_auto_tile(map:Array<Array<Int>>, x:Int, y:Int):Int {
		if (map[y][x] == 0) return -1;
		var out = 0;
		var width = map[0].length;
		var height = map.length;

		if ((y == 0) || (map[y - 1][x] > 0))			out += 1;
		if ((x == width - 1) || (map[y][x + 1] > 0))	out += 2;
		if ((y == height - 1) || (map[y + 1][x] > 0))	out += 4;
		if ((x == 0) || (map[y][x - 1] > 0))			out += 8;

		if (out == 15) {
			if ((x > 0) && (y < height - 1) && (map[y + 1][x - 1] <= 0)) out = 1;
			if ((x > 0) && (y > 0) && (map[y - 1][x - 1] <= 0)) out = 2;
			if ((x < width - 1) && (y > 0) && (map[y - 1][x + 1] <= 0)) out = 4;
			if ((x < width - 1) && (y < height - 1) && (map[y + 1][x + 1] <= 0)) out = 8;
		}
		return out;
	}
	
	function init_map(map:Array<Array<Int>>, w:Int, h:Int) {
		#if echo
		Game.i.world.width = map[0].length * options.tileset.frame_width;
		Game.i.world.height = map.length * options.tileset.frame_height;
		#end
		if (options.solids != null) make_solids(map, options.solids);
		tiles = [];
		for (j in 0...map.length) {
			tiles[j] = [];
			for (i in 0...map[j].length) {
				if (map[j][i] < 0) continue;
				tiles[j][i] = addTile(new Tile(map[j][i], i * w, j * h));
			}
		}
	}

	function make_solids(map:Array<Array<Int>>, solids:Array<Int>) {
		#if echo
		bodies = echo.util.TileMap.generate([for (j in 0...map.length) for (i in 0...map[j].length) solids.contains(map[j][i]) ? 1 : -1], options.tileset.frame_width, options.tileset.frame_height, map[0].length, map.length);
		for (body in bodies) Game.i.world.add(body);
		#end
	}

	public function get_solids_array(?solids:Array<Int>):Array<Array<Int>> {
		if (solids == null && options.solids == null) return [];
		if (solids == null) solids = options.solids;
		return [for (j in 0...map.length) [for (i in 0...map[j].length) solids.contains(map[j][i]) ? 1 : 0]];
	}

	public function get_map(copy:Bool = true):Array<Array<Int>> {
		return copy ? map.copy() : map;
	}

	public function set_tile(x:Int, y:Int, id:Int) {
		get_tile(x, y).id = id;
		map[y][x] = id;
	}

	public function set_tile_at(x:Float, y:Float, id:Int) {
		var p = translate_float_to_map(x, y);
		get_tile(p.x, p.y).id = id;
		map[p.y][p.x] = id;
		p.put();
	}

	public function get_tile_id(x:Int, y:Int):Int {
		return get_tile(x, y).id;
	}

	public function get_tile_id_at(x:Float, y:Float) {
		var p = translate_float_to_map(x, y);
		var out = get_tile(p.x, p.y).id;
		p.put();
		return out;
	}

	public function get_tile(x:Int, y:Int) {
		return tiles[y][x];
	}

	function translate_float_to_map(x:Float, y:Float):IntPoint {
		return [(x/options.tileset.frame_width).floor(), (y/options.tileset.frame_height).floor()];
	}

}

class Tileset extends OpenFLTileset {

	public function new(options:TilesetOptions) {
		super(options.image.getBitmapData());
		var rect = new Rectangle(0, 0, options.frame_width, options.frame_height);
		for (j in 0...(bitmapData.height/options.frame_height).int()) for (i in 0...(bitmapData.width/options.frame_width).int()) {
			rect.x = i * options.frame_width;
			rect.y = j * options.frame_height;
			addRect(rect);
		}
	}

}

typedef TilemapOptions = {
	map:Array<Array<Int>>,
	tileset:TilesetOptions,
	smoothing:Bool,
	?solids:Array<Int>,
	?auto:Bool,
}

typedef TilesetOptions = {
	image:String,
	frame_width:Int,
	frame_height:Int,
}