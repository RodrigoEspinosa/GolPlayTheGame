package entities;
 
import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

class Block extends Entity
{
    public function new(x:Int, y:Int)
    {
        super(x, y);
 
        graphic = new Image("gfx/block.png");
    }
    private function handelInput()
    {
    	acceleration = 0;
    	if( Input.check(Key.LEFT) )
    	{
    		acceleration = -1;
    	}
    	if( Input.check(Key.RIGHT) )
    	{
    		acceleration = 1;
    	}
    	if( Input.check(Key.UP) )
    	{
    		moveBy(0, -2);
    	}
    	if( Input.check(Key.DOWN) )
    	{
    		moveBy(0, 2);
    	}
    }
    private function move()
    {
    	velocity += acceleration;
    	if( Math.abs(velocity) > 5 )
    	{
    		velocity = 5 * HXP.sign(velocity);
    	}
    	moveBy(velocity, 0);
    }
    private function setAnimations()
    {
    	if( velocity == 0 )
    	{
    		// IDLE
		}else{
			if( velocity < 0 )
			{
				// Left
			}else
			{
				// Right
			}
		}
    }
    public override function update()
    {   	
    	handelInput();
    	move();
    	// moveBy(velocity, 0);

    	super.update();
    }
    private var velocity:Float;
    private var acceleration:Float;
}