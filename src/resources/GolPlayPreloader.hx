package resources;

#if doc

#elseif js

// html5 doesn't support drawTiles
class GolPlayPreloader extends NMEPreloader { }

#else

import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Graphics;
import nme.display.Sprite;
import nme.display.Tilesheet;
import nme.events.Event;
import nme.geom.Point;
import nme.geom.Rectangle;

@:bitmap("assets/graphics/preloader/pantalla-loader.png")
class GolPlayBackground extends BitmapData {}

class GolPlayPreloader extends NMEPreloader
{
	public function new()
	{ 

	}
}

#end