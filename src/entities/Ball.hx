package entities; 

import flash.geom.Point;
import haxe.Timer;
import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.masks.Circle;

class Ball extends Entity
{
	// CONSTANTES
	private static inline var RADIUS:Int = 10;
	private static inline var SPEED:Int = 3;
	private static inline var MAX_VELOCITY = 30;
	private static inline var DRAG:Float = 0.3;
	
	private static inline var INITIAL_X = 372;
	private static inline var INITIAL_Y = 307;
	// PROPIEDADES
	private var velocity:Point;
	public  var moving:Bool;
	private var lastX:Float; 
	private var lastY:Float;

	public function new (x:Float, y:Float)
	{
		super(x, y);

		graphic = new Image("gfx/ball_01.png");

		mask = new Circle(RADIUS);
		type = "ball";

		moving = false;
		lastX  = x;
		lastY  = y;

		velocity = new Point();
		velocity.x = 0;
		velocity.y = 0;
	}
	public function move(velocityX:Float, velocityY:Float)
	{
        velocity.x = velocityX * 1.5;
        velocity.y = velocityY * 1.5;

	}
	public function kick(velocityX:Float, velocityY:Float)
	{

	}
	public function reset()
	{
		velocity.x = 0;
		velocity.y = 0;
		this.x = 372;
		this.y = 307;
	}
	private function movment()
	{
		if ( Math.abs(velocity.x) > MAX_VELOCITY ){
            velocity.x = MAX_VELOCITY * HXP.sign(velocity.x);
        }
        if( velocity.x < 0 ){
            velocity.x = Math.min(velocity.x + DRAG, 0);
        }else if ( velocity.x > 0 ) {
            velocity.x = Math.max(velocity.x - DRAG, 0);
        }
        if ( Math.abs(velocity.y) > MAX_VELOCITY ){
            velocity.y = MAX_VELOCITY * HXP.sign(velocity.y);
        }
        if( velocity.y < 0 ){
            velocity.y = Math.min(velocity.y + DRAG, 0);
        }else if ( velocity.y > 0 ) {
            velocity.y = Math.max(velocity.y - DRAG, 0);
        }

        moveBy(velocity.x, velocity.y, ["player", "goalLimits", "fieldLimit"]);
		
		if( lastX != x || lastY != y){ moving = true; }
		else{ moving = false; }

		lastX = x;
		lastY = y;
	}
	public override function update()
	{
		movment();
		
		var goalCollide:Entity = collide("goalLimit", x, y);
		if( goalCollide != null ){
			velocity.x *= -1;
			velocity.y *= -1;
			
			Timer.delay( function(){
				this.reset();
			}, 400);
		}

		var fieldLimit:Entity = collide("fieldLimit", x, y);
        if( fieldLimit != null ){
    		velocity.y *= -1;
        	velocity.x *= -1;
        }

        super.update();
	}
}