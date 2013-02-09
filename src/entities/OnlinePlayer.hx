package entities;
 
import flash.geom.Point;
import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.masks.Circle;

class OnlinePlayer extends Entity
{
    // CONSTANTES
    private static inline var RADIUS:Int = 20;
    // EQUIPO DEL JUGADOR
    public var team( getTeam, setTeam):Int;
    public var number( getNumber, setNumber):Int;
    public var Player( getPlayer, setPlayer ):Dynamic = null;
    public var kicking( getKicking, setKicking ):Bool = false;

    public function new(x:Float, y:Float, Player:Dynamic)
    {
        this.Player = {};
        this.Player = Player;
        this.team = Player.team;
        this.number = Player.number;

        super(x, y);
        
        // TEAM 0 = RED
        // TEAM 1 = BLUE
        if( team == 0 )
            graphic = new Image("gfx/player_red.png")
        else
            graphic = new Image("gfx/player_blue.png");

        mask = new Circle(RADIUS);
        type = "player";

        resetPosition();
    }
    public function getTeam():Int
    {
        return this.team;
    }
    public function setTeam( team:Int ):Int
    {
        this.team = team;
        return this.team;
    }
    public function getNumber():Int
    {
        return this.number;
    }
    public function setNumber( number:Int ):Int
    {
        this.number = number;
        return this.number;
    }
    public function getPlayer():Dynamic
    {
        return this.Player;
    }
    public function setPlayer( Player:Dynamic ):Dynamic
    {
        this.Player = Player;
        return this.Player;
    }
    public function getKicking():Bool
    {
        return this.kicking;
    }
    public function setKicking( kicking:Bool ):Bool
    {
        this.kicking = kicking;
        return this.kicking;
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
        super.update();
    }
}