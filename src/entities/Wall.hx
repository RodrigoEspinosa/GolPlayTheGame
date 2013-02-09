package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

class Wall extends Entity
{
	private inline static var DEFAULT_WIDTH  = 600;
	private inline static var DEFAULT_HEIGHT = 10;
	private inline static var COLOR = 0x335599;

	public function new(x:Float, y:Float, width:Int = DEFAULT_WIDTH, height = DEFAULT_HEIGHT)
	{
		super(x, y);

		graphic = Image.createRect(width, height, COLOR);
		
		setHitbox(width, height);

		type = "wall";
	}
}