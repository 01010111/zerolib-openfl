package zero.openfl.extensions;

import zero.utilities.Color;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormatAlign;
import openfl.text.TextField;
import openfl.text.TextFormat;
import zero.utilities.Anchor;

using zero.openfl.extensions.TextTools;
using zero.extensions.Tools;
using Reflect;

class TextTools {

	// Styles

	static var formats:Map<String, TextFormatOptions> = [];
	public static function store_format(name:String, format:TextFormatOptions) formats.set(name, format);

	// Static Extensions

	public static function format(text:TextField, options:TextFormatOptions, cache:String = '') {
		text.defaultTextFormat = get_format_from_options(options);
		if (cache.length > 0) store_format(cache, options);
		text.autoSize = switch options.align {
			case null | JUSTIFY | LEFT | START : LEFT;
			case CENTER: CENTER;
			case END | RIGHT: RIGHT;
		}
		return text;
	}

	public static function from_format(text:TextField, format_name:String, ?override_options:TextFormatOptions) {
		var options:TextFormatOptions = {};
		if (!formats.exists(format_name)) {
			trace('$format_name does not exist in formats!');
			if (override_options == null) return text;
		}
		else {
			for (field in Reflect.fields(formats[format_name])) {
				options.setField(field, formats[format_name].field(field));
			}
		}
		if (override_options != null) {
			for (field in Reflect.fields(override_options)) {
				options.setField(field, override_options.field(field));
			}
		}
		text.format(options);
		return text;
	}

	public static function set_string(text:TextField, string:String) {
		text.text = string;
		return text;
	}

	public static function set_position(text:TextField, x:Float, y:Float, align:Anchor = TOP_LEFT) {
		text.x = switch align {
			case TOP_LEFT | MIDDLE_LEFT | BOTTOM_LEFT : x;
			case TOP_CENTER | MIDDLE_CENTER | BOTTOM_CENTER : x - text.width/2;
			case TOP_RIGHT | MIDDLE_RIGHT | BOTTOM_RIGHT: x - text.width;
		}
		text.y = switch align {
			case TOP_LEFT | TOP_CENTER | TOP_RIGHT : y;
			case MIDDLE_LEFT | MIDDLE_CENTER | MIDDLE_RIGHT: y - text.height/2;
			case BOTTOM_LEFT | BOTTOM_CENTER | BOTTOM_RIGHT: y - text.height;
		}
		return text;
	}

	public static function set_autosize(text:TextField, align:TextFieldAutoSize) {
		text.autoSize = align;
		return text;
	}

	public static function on<T>(text:TextField, event:openfl.events.EventType<T>, callback:Dynamic -> TextField -> Void):TextField {
		text.addEventListener(event, (e) -> callback(e, text));
		return text;
	}

	// Util

	public static function wrap_string(string:String, text:TextField, width:Float):String {
		var text_ref = text.text != null ? text.text : '';
		var split = string.split(' ');
		text.text = split.shift();

		while (split.length > 0) {
			var word = split.shift();
			text.text += ' $word';
			if (text.width < width) continue;
			text.text = text.text.substring(0, text.text.length - word.length - 1) + '\n$word';
		}

		var out = text.text;
		text.text = text_ref;
		return out;
	}

	static function get_format_from_options(options:TextFormatOptions) {
		var color = options.color == null ? 0x000000 : options.color.to_hex_24();
		return new TextFormat(
			options.font,
			options.size,
			color,
			options.bold,
			options.italic,
			options.underline,
			options.url,
			options.target,
			options.align,
			options.left_margin,
			options.right_margin,
			options.indent,
			options.leading
		);
	}

	public static function styles_from_json(json:String) {
		var styles:Array<TextFormatOptions> = json.parse_json();
		for (style in styles) store_format(style.name, style);
	}

}

typedef TextFormatOptions = {
	?name:String,
	?font:String,
	?size:Int,
	?color:Color,
	?bold:Bool,
	?italic:Bool,
	?underline:Bool,
	?url:String,
	?target:String,
	?align:TextFormatAlign,
	?left_margin:Int,
	?right_margin:Int,
	?indent:Int,
	?leading:Int,
}