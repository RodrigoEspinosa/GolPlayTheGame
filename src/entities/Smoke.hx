package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Emitter;

class Smoke extends Entity
{
	private var smokeEntity:Entity;
    private var smoke:Emitter;

	public function new(x:Float, y:Float)
	{
		super(x-16, y-16);

		smoke = new Emitter("gfx/smoke.png", 16, 16);
        smoke.newType("exhaust", [0]);
        smoke.setMotion("exhaust", 90, 3, 0.5, 360, 10, 0.5);
        smoke.setAlpha("exhaust");

        // smokeEntity = addGraphic(smoke);
        graphic = smoke;
	}
	public override function update()
	{
		super.update();
		smoke.emit("exhaust", x, y);
		// for (i in 0...10)
  //       {
  //           smoke.emit("exhaust", x, y);
  //       }
	}
}