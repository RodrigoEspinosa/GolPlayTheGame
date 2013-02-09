package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

class Field extends Entity
{
	private inline static var DEFAULT_WIDTH  = 640;
	private inline static var DEFAULT_HEIGHT = 430;
	private inline static var COLOR = 0xACD373;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		var image:Image = new Image("gfx/field_01.png");

		// graphic = Image.createRect(DEFAULT_WIDTH, DEFAULT_HEIGHT, COLOR);
		graphic = image;
	}
}