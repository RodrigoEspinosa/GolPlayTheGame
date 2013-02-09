package worlds;

import com.haxepunk.World;
import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Text;
import com.haxepunk.graphics.Image;
import com.haxepunk.masks.Hitbox;
import com.haxepunk.masks.Polygon;
import flash.geom.Point;
import com.haxepunk.utils.Input;
import haxe.Timer;
// ENTITIES
import entities.Background;
import entities.Field;
import entities.Player;
import entities.OnlinePlayer;
import entities.Ball;
import entities.Goal;
import entities.Wall;
// TO CHANGE MOUSE CURSOR
import flash.ui.Mouse;

class GameWorld extends World
{
    private var ball:Ball;
    private var players:Array<Dynamic>;
    private var playersInGame:Array<Dynamic>;
    private var onlinePlayers:Array<Dynamic>;
    private var team0Points:Int = 0;
    private var team1Points:Int = 0;
    private var textScore:Entity;

    public function new(roomID:String, players:Array<Dynamic>)
    {
        super();
        Mouse.cursor = "auto";
        this.players = players;
        playersInGame = [];
        onlinePlayers = [];
    }

    public override function begin()
    {
        add(new Background());
        // SET GAME LIMITS
        addMask(new Hitbox(HXP.width, 10),  "gameLimit", 0, -10);        // TOP
        addMask(new Hitbox(10, HXP.height), "gameLimit", HXP.width, 0);  // RIGHT
        addMask(new Hitbox(HXP.width, 10),  "gameLimit", 0, HXP.height); // BOTTOM
        addMask(new Hitbox(10, HXP.height), "gameLimit", -10, 0);        // LEFT

        add(new Field(50, 90));
    	// SET FIELD LIMITS
        addMask(new Hitbox(640, 10), "fieldLimit", 50, 90);  // TOP
        // addMask(new Hitbox(10, 110), "fieldLimit", 690, 90); // RIGHT 1
        // GOAL SPACE
        // addMask(new Hitbox(10, 267), "fieldLimit", 690, 273); // RIGHT 2
        addMask(new Hitbox(640, 10), "fieldLimit", 50, 530); // BOTTOM
        // addMask(new Hitbox(10, 110), "fieldLimit", 50, 90);  // LEFT 1
        // GOAL SPACE
        // addMask(new Hitbox(10, 267), "fieldLimit", 50, 273);  // LEFT 2
        addGraphic(new Image("gfx/score.jpg"), 2, 325, 0);
        // C6C6C6
        addGraphic(new Image("gfx/logo-ingame.png"), 2, 280, 544);
        addGraphic(new Image("gfx/chat-bg.png"), 2, 10, 572);

        // ADD THE BALL TO THE FIELD
        ball = new Ball(372, 307);
        add(ball);
        // ADD PLAYERS
        var newSelfPlayer:Player;
        var newPlayer:OnlinePlayer;
        for( player in players ) 
        {
            // ADD SELF PLAYER
            if( player.selfPlayer){
                newSelfPlayer = new Player(180, 190, player.team);
                add( newSelfPlayer );
                playersInGame.push( newSelfPlayer );
            }else{
                newPlayer = new OnlinePlayer(230, 190, player);
                add( newPlayer );
                playersInGame.push( newPlayer );
                onlinePlayers.push( newPlayer );
            }
        }
        // SET PLAYER POSITIONS
        resetPositions();
        // ADD LEFT GOAL
        add(new Goal(7, 230, 0));   // 0 = Red Team
        // ADD RIGHT GOAL
        add(new Goal(688, 230, 1)); // 1 = Blue Team

        changeScore();

        HXP.server.onNetGroupPostingNotify = function( event:flash.events.NetStatusEvent ){
            if( event.info.message.type == "playerPosition" )
            {
                movePlayer( event.info.message );        
            }
            if( event.info.message.type == "setGol" )
            {
                if( event.info.message.team == 0 ){
                    team0Points++;
                }else{
                    team1Points++;
                }

                changeScore();
            }
            if( event.info.message.type == "forceToBall" )
            {
                ball.move( event.info.message.x, event.info.message.y );
            }
        }
    }
    public function movePlayer( message:Dynamic )
    {
        for( player in onlinePlayers )
        {
            if( player.Player.Player._oCon == message.User._oCon )
            {
                player.x = message.x;
                player.y = message.y;
                player.kicking = message.kicking;
            }
        }
    }
    private function resetPositions()
    {
        for( player in playersInGame )
        {
            player.resetPosition();
        }
    }
    private function changeScore()
    {
        // remove( textScore );

        var fontOptions:TextOptions = { 
            size:   16, 
            color:  0xFFFFFF, 
            font:   "font/arial.ttf"
        };
        var text:Text = new Text(team0Points+" - "+team1Points, 0, 0, 0, 0, fontOptions);
        
        textScore = addGraphic( text, 1, 365, 5 );
    }
    public override function update()
	{

		super.update();

	}

}