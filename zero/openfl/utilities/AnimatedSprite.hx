package zero.openfl.utilities;

import zero.utilities.AnimationManager;
import openfl.display.Sprite;
import openfl.display.Tilemap;
import zero.openfl.utilities.AnimatedTile;

class AnimatedSprite extends Sprite {

	public var animation:AnimationManager;
	public var frame_index(get, set):Int;
	var graphic:Tilemap;
	var frame:AnimatedTile;

	public function new(options:AnimatedSpriteOptions) {
		super();
		init_frame(options);
		init_graphic(options);
		init_animations(options);
	}

	function init_frame(options:AnimatedSpriteOptions) {
		frame = new AnimatedTile({
			source: options.source,
			frame_width: options.frame_width,
			frame_height: options.frame_height
		});
	}

	function init_graphic(options:AnimatedSpriteOptions) {
		graphic = new Tilemap(options.frame_width, options.frame_height, null, false);
		graphic.addTile(frame);
		graphic.x -= options.offset_x;
		graphic.y -= options.offset_y;
		addChild(graphic);
	}

	function init_animations(options:AnimatedSpriteOptions) {
		animation = new AnimationManager({ on_frame_change: (i) -> frame.id = i });
		for (data in options.animations) animation.add(data);
	}

	public function get_frame_index() {
		return frame.id;
	}

	public function set_frame_index(i:Int) {
		return frame.id = i;
	}

}

typedef AnimatedSpriteOptions = {
	> AnimatedTileOptions,
	offset_x:Float,
	offset_y:Float,
	animations:Array<AnimationData>
}