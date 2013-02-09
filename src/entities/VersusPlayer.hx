package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

class VersusPlayer extends Entity
{
	private static inline var DEFAULT_X:Int = 0;
	private static inline var DEFAULT_Y:Int = 340;
	// TEAM 0 = RED 1 = BLUE
	public var selfPlayer( getSelfPlayer, setSelfPlayer):Bool = false;
	public var team( getTeam, setTeam):Int  = 0;
	public var number( getNumber, setNumber):Int = 1;
	public var Player( getPlayer, setPlayer):Dynamic = null;

	public function new(x:Int = DEFAULT_X, y:Int = DEFAULT_Y)
	{
		super(x, y);
		
		var image:Image = new Image("gfx/player-vs.png");

		graphic = image;

		Player = {};
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
	public function getSelfPlayer():Bool
	{
		return this.selfPlayer;
	}
	public function setSelfPlayer( selfPlayer:Bool ):Bool
	{
		this.selfPlayer = selfPlayer;
		return this.selfPlayer;
	}
	private function checkPlayerPosition()
	{
		// 1° equipo rojo
		// x= 145
		// y= 340
		// 2° equipo rojo
		// x= 70
		// y= 340
		// 1° equipo azul
		// x= 490
		// y= 340
		// 2° equipo azul
		// x= 565
		// y= 340
		if( team == 0 ){
			switch( number )
			{
				case 1:
					this.x = 145;
					this.y = 340;
				case 2:
					this.x = 70;
					this.y = 340;
			}
		}else{
			switch( number )
			{
				case 1:
					this.x = 490;
					this.y = 340;
				case 2:
					this.x = 565;
					this.y = 340;
			}
		}
	}
	public override function update()
	{
		checkPlayerPosition();

		super.update();
	}
}