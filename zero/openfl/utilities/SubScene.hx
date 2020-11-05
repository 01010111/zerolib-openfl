package zero.openfl.utilities;

import openfl.events.Event;
import zero.openfl.utilities.Scene;

using zero.utilities.EventBus;
using zero.openfl.extensions.SpriteTools;

class SubScene extends Scene {

	public function new() {
		super();
		addEventListener(Event.ENTER_FRAME, update);
		addEventListener(Event.ADDED_TO_STAGE, on_added);
		create();
	}
	
	function on_added(e) {
		'update'.set_active(false);
	}

	public function close() {
		'update'.set_active(true);
		removeEventListener(Event.ENTER_FRAME, update);
		this.remove();
	}
	
	override function init() {}
	public function update(e:Event) {}

}