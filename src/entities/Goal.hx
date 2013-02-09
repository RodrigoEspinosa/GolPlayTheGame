package entities;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import flash.geom.Point;
import com.haxepunk.masks.Polygon;
import com.haxepunk.masks.Masklist;

class Goal extends Entity
{
	// CONSTANTES
	private static inline var WIDTH:Int = 67;
	private static inline var HEIGHT:Int= 163;
	private var team:Int;

	public function new(x:Float, y:Float, team:Int = 0)
	{
		super(x,y);
		
		var image:Image = new Image("gfx/goal_01.png");
		
		this.team = team;

		var m1:Polygon;
		var m2:Polygon;
		var m3:Polygon;

		if( team > 0 ){
			image.flipped = true;
			m1 = new Polygon([new Point(7, 9), new Point(7, 7), new Point(55, 19)]);
			m2 = new Polygon([new Point(55, 19), new Point(55, 142), new Point(55, 142), new Point(55, 19)]);
			m3 = new Polygon([new Point(7, 144), new Point(55, 146), new Point(55, 142)]);
		}else{
			m1 = new Polygon([new Point(7, 19), new Point(55, 9), new Point(55, 7)]);
			m2 = new Polygon([new Point(7, 19), new Point(7, 142), new Point(5, 142), new Point(5, 19)]);
			m3 = new Polygon([new Point(7, 142), new Point(55, 150), new Point(55, 144)]);
		}

		graphic = image;

		mask = new Masklist([m1, m2, m3]);

		type = "goalLimit";
	}
	public function setGol()
	{
		var golFor:Int = (team == 0) ? 1 : 0;

		HXP.server.postDataToGroup({
			type: "setGol",
			team: golFor
		});

		trace( golFor );
	}
	public override function update()
	{
		if ( collide("ball", x, y) != null){
			// La pelota entró en la red.
			setGol();
		}
		super.update();
	}
}