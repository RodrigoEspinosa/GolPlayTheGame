package entities;
 
import flash.geom.Point;
import com.haxepunk.HXP;
import com.haxepunk.Entity;
// import com.haxepunk.graphics.Emitter;
import com.haxepunk.graphics.Image;
import com.haxepunk.masks.Circle;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

class Player extends Entity
{
    // CONSTANTES
    private static inline var RADIUS:Int = 20;
    private static inline var COLOR:Int = 0xFF33FF;
    private static inline var SPEED:Int = 3;
    private static inline var MAX_VELOCITY:Int = 6;
    private static inline var DRAG:Float = 0.4;
    // EQUIPO DEL JUGADOR
    public var team:Int;
    public var number:Int;
    // PROPIEDADES FISICAS DEL JUGADOR
    private var velocity:Point;
    private var velocityF:Float;
    private var acceleration:Point;
    private var angle:Float;
    // PROPIEDADES FISICAS DEL GOLPE
    private var kicking:Bool;
    private var forceX:Float;
    private var forceY:Float;
    // 
    private var moving:Bool;
    private var lastX:Float; 
    private var lastY:Float;

    public function new(x:Float, y:Float, team:Int = 0)
    {
        super(x, y);

        this.team = team;

        // graphic = Image.createCircle(RADIUS, COLOR);

        // TEAM 0 = RED
        // TEAM 1 = BLUE
        if( team == 0 )
            graphic = new Image("gfx/player_red_self.png")
        else
            graphic = new Image("gfx/player_blue_self.png");

        mask = new Circle(RADIUS);
        type = "player";

        Input.define("left", [Key.LEFT, Key.A]);
        Input.define("right", [Key.RIGHT, Key.D]);
        Input.define("up", [Key.UP, Key.W]);
        Input.define("down", [Key.DOWN, Key.S]);
        Input.define("kick", [Key.CONTROL, Key.X]);
    
        acceleration = new Point();
        velocity     = new Point();
        velocity.x   = 0;
        velocity.y   = 0;
        angle = 0;
    }
 
    private function handleInput()
    {
        /*
            MANEJO DE CONTROLES
        */
        acceleration.x = 0;
        acceleration.y = 0;
 
        if (Input.check("left"))
        {
            acceleration.x = -1;
        }
        if (Input.check("right"))
        {
            acceleration.x = 1;
        }
        if (Input.check("up"))
        {
            acceleration.y = -1;
        }
        if (Input.check("down"))
        {
            acceleration.y = 1;
        }
        if (Input.check("kick"))
        {
            kicking = true;
            // graphic = Image.createCircle(RADIUS, 0xFFFFFF);
            if( team == 0 )
                graphic = new Image("gfx/player_red_self_h.png")
            else
                graphic = new Image("gfx/player_blue_self_h.png");
        }else{
            kicking = false;
            // graphic = Image.createCircle(RADIUS, COLOR);
            if( team == 0 )
                graphic = new Image("gfx/player_red_self.png")
            else
                graphic = new Image("gfx/player_blue_self.png");
        }
    }
 
    public function move()
    {
        /*
            MOVIMIENTO PROPIO DEL JUGADOR 
        */
        velocity.x += acceleration.x * SPEED;
        if ( Math.abs(velocity.x) > MAX_VELOCITY ){
            velocity.x = MAX_VELOCITY * HXP.sign(velocity.x);
        }
        if( velocity.x < 0 ){
            velocity.x = Math.min(velocity.x + DRAG, 0);
        }else if ( velocity.x > 0 ) {
            velocity.x = Math.max(velocity.x - DRAG, 0);
        }
        velocity.y += acceleration.y * SPEED;
        if ( Math.abs(velocity.y) > MAX_VELOCITY ){
            velocity.y = MAX_VELOCITY * HXP.sign(velocity.y);
        }
        if( velocity.y < 0 ){
            velocity.y = Math.min(velocity.y + DRAG, 0);
        }else if ( velocity.y > 0 ) {
            velocity.y = Math.max(velocity.y - DRAG, 0);
        }
        angle = Math.atan( velocity.y / velocity.x) / (Math.PI / 180);
        angle+= 90;
        if( velocity.x < 0){
            angle += 180;
        }
        if( velocity.x >= 0 && velocity.y <0 ){
            angle += 360;
        }
        if( angle >= 360 ){
            angle = angle % 360;
        }
        velocityF = Math.sqrt( (velocity.x*velocity.x) + (velocity.y*velocity.y) );
        if( velocityF > MAX_VELOCITY ){
            velocity.x = (velocity.x / 1.4142); // 1.4142 = sqrt(2)
            velocity.y = (velocity.y / 1.4142); // 1.4142 = sqrt(2)
        }
        moveBy(velocity.x, velocity.y, "ball");

        sendMovment();
    }
    public function sendMovment():Void
    {
        if( moving )
        {
            HXP.server.postDataToGroup({
                type: "playerPosition",
                x: this.x,
                y: this.y,
                kicking: this.kicking
            });
        }
    }
    public function sendBallForce(xF:Float, yF:Float)
    {
        HXP.server.postDataToGroup({
            type: "forceToBall",
            x: xF,
            y: yF
        });
    }
    public override function moveCollideX(e:Entity)
    {
        super.moveCollideX(e);
        // var hip:Float = Math.sqrt((velocityX*velocityX) + (velocityY*velocityY));
        
        // trace( Math.sin( angle ) * hip );
        // e.moveBy( Math.sin( angle ) * hip, 0 );
        // trace( e.x + " , " + e.y );
        
        // Vf1 = ((M1 - M2) / (M1 + M2) * Vi1) + ((M2*2)/(M1+M2)) * Vi2
        
        forceX =  ((0.2 - SPEED) / (0.2 + SPEED) * 0) + ((SPEED * 2) / (0.2 + SPEED)) * velocity.x;
        forceY =  ((0.2 - SPEED) / (0.2 + SPEED) * 0) + ((SPEED * 2) / (0.2 + SPEED)) * velocity.y;

        var ball:Ball = cast(e, Ball);
        if( kicking ){
            ball.move(forceX, forceY);
            sendBallForce( forceX, forceY);
        }else{
            ball.move(velocity.x, velocity.y);
            sendBallForce( velocity.x, velocity.y );
        }
    }
    public override function moveCollideY(e:Entity)
    {
        super.moveCollideX(e);

        forceX =  ((0.2 - SPEED) / (0.2 + SPEED) * 0) + ((SPEED * 2) / (0.2 + SPEED)) * velocity.x;
        forceY =  ((0.2 - SPEED) / (0.2 + SPEED) * 0) + ((SPEED * 2) / (0.2 + SPEED)) * velocity.y;

        var ball:Ball = cast(e, Ball);
        if( kicking ){
            ball.move(forceX, forceY);
            sendBallForce( forceX, forceY);
        }else{
            ball.move(velocity.x, velocity.y);
            sendBallForce( velocity.x, velocity.y );
        }
    }
    public function wallCollide()
    {
        if( collide("gameLimit", x, y) != null ){
            velocity.x = 0;
            velocity.y = 0;
        }

        if( collide("goalLimit", x, y) != null ){
            velocity.x *= -1;
            velocity.y *= -1;
        }
    }
    public function resetPosition()
    {
        if( team == 0 )
        {
            switch( number )
            {
                case 1:
                    this.x = 240;
                    this.y = 240;
                case 2:
                    this.x = 240;
                    this.y = 370;
                case 3:
                    this.x = 140;
                    this.y = 270;
                case 4:
                    this.x = 140;
                    this.y = 340;
            }
        }else{
            switch( number )
            {
                case 1:
                    this.x = 620;
                    this.y = 240;
                case 2:
                    this.x = 640;
                    this.y = 340;
                case 3:
                    this.x = 520;
                    this.y = 270;
                case 4:
                    this.x = 520;
                    this.y = 340;
            }
        }
    }
    public override function update()
    {
        handleInput();

        move();
     
        if( lastX != x || lastY != y )
            moving = true
        else
            moving = false;

        lastX = x;
        lastY = y;

        wallCollide();
        
        super.update();
    }
}