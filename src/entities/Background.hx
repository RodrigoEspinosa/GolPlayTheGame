package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

class Background extends Entity
{
	private static inline var DEFAULT_X = 0;
	private static inline var DEFAULT_Y = 0;

	public function new(x:Float = DEFAULT_X, y:Float = DEFAULT_Y)
	{
		super(x, y);

		var image:Image = new Image("gfx/background.png");

		graphic = image;
	}
}