package worlds;

import com.haxepunk.HXP;
import com.haxepunk.World;
import com.haxepunk.Entity;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.graphics.Image;
// ENTITY
import entities.VersusPlayer;
// RTMFP CONNECTION
import flash.events.NetStatusEvent;
// MongoDB CONNECTION
import tjson.TJSON;
import haxe.Http;
// TO DISPLAY LISTS
import com.haxepunk.graphics.Text;
import entities.Link;
// TO CHANGE MOUSE CURSOR
import flash.ui.Mouse;

class Versus extends World
{
	// GAME-ROOM IDENTITY
	private var gameID:String;
	private var joinedRoom:Bool = false;
	private var sayHello:Bool = false;
	private var selfPlayer:VersusPlayer;
	private var selfTeam:Int = 0;
	private var selfNumber:Int = 1;
	private var allPlayers:Array<VersusPlayer> = null;
	private var team0NumPlayers:Int = 0;
	private var team1NumPlayers:Int = 0;

	public function new( gameID:String )
	{
		this.gameID = gameID;
		Mouse.cursor = "auto";
		allPlayers = [];

		Input.define("left", [Key.LEFT, Key.A]);
		Input.define("right", [Key.RIGHT, Key.D]);
		Input.define("enter", [Key.ENTER, Key.E]);
		
		super();
	}

	private function createServerRoomConnection():Void
	{
		try{
			HXP.server.joinRoom( gameID, selfTeam, selfNumber );

			HXP.server.onNetGroupSuccess = function(){
				selfPlayer = new VersusPlayer();
				selfPlayer.team = selfTeam;
				selfPlayer.number = selfNumber;
				selfPlayer.Player = HXP.server.User;
				selfPlayer.selfPlayer = true;
				add( selfPlayer );
				allPlayers.push(selfPlayer);

				joinedRoom = true;
			}
			HXP.server.onNetGroupNeighborConnect = function(){
				if( joinedRoom && !sayHello )
				{
					HXP.server.postDataToGroup({
						type: "versusNewPlayer",
						team: selfTeam,
						number: selfNumber
					});

					sayHello = true;
				}
				// HXP.server.postDataToGroup({
				// 	type: "versusPlayerData",
				// 	team: selfPlayer.team,
				// 	number: selfPlayer.number,
				// 	Player: selfPlayer
				// });
			}
			HXP.server.onNetConnectionClosed = function(){
				HXP.server.quitRoom( gameID );
			}
			HXP.server.onNetGroupNeighborDisconnect = function(){
				// HXP.server.postDataToGroup({
				// 	type: "versusPlayerDelete",
				// 	team: selfPlayer.team,
				// 	number: selfPlayer.number,
				// 	Player: selfPlayer
				// });
			}
			HXP.server.onNetGroupPostingNotify = function( event:NetStatusEvent ){
				if( event.info.message.User._oCon != HXP.server.User._oCon )
				{
					if( event.info.message.type == "versusNewPlayer" )
					{
						var oPlayer:VersusPlayer = new VersusPlayer();
						// Player Team
						oPlayer.team   = event.info.message.team;
						// Player Number
						oPlayer.number = event.info.message.number;
						// Player User ID
						oPlayer.Player._bdID = event.info.message.User._bdID;
						// Player ActivePlayer ID
						oPlayer.Player._oCon = event.info.message.User._oCon;
						// Add VersusPlayer entity to the world
						add( oPlayer );
						// Push the entity to the players Array
						allPlayers.push( oPlayer );
					}
				}
				if( event.info.message.type == "versusPlayerData" )
				{
					// var oPlayer:VersusPlayer = new VersusPlayer();
					// oPlayer.team = event.info.message.team;
					// oPlayer.number = event.info.message.number;
					// oPlayer.Player = event.info.message.Player;
					// add( oPlayer );
					// allPlayers.push( oPlayer );
				}
				if( event.info.message.type == "versusPlayerMovment" )
				{
					// for( i in 0...allPlayers.length )
					// {
					// 	trace( allPlayers[i].Player.nearID );
					// 	if( allPlayers[i].Player.nearID == event.info.message.User.nearID )
					// 	{
					// 		allPlayers[i] = event.info.message.Player;
					// 	}
					// }
				}
			}
		}catch( msg:String ){
			trace("ERROR: "+msg);
		}
	}

	private function getRoomPlayers():Void
	{
		var url:String = "http://metioro.com/GolPlay/mongodb.php?collection=active_players&query=get&data="+gameID;
		flash.system.Security.allowDomain('*');
		var r:Http = new Http(url);
		r.onError = function( e ){
			trace('ERROR: ' + e);
		}
		r.onData = onGetRoomPlayersData;

		r.request( false );
	}

	public function onGetRoomPlayersData( e:String ):Void
	{
		if( e == "null" ){
			// The room is empty
			createServerRoomConnection();
			sayHello = true;
		}else{
			var players:Array<Dynamic> = TJSON.parse( e );
			// Loop throught all active players
			for( player in players )
			{
				var oPlayer:VersusPlayer = new VersusPlayer();
				// Player Team
				oPlayer.team   = player.team;
				// Player Number
				oPlayer.number = player.number;
				// Player User ID
				oPlayer.Player._bdID = player.user;
				// Player ActivePlayer ID
				oPlayer.Player._oCon = player.id;
				// Add VersusPlayer entity to the world
				add( oPlayer );
				// Push the entity to the players Array
				allPlayers.push( oPlayer );
			}
			// Set selfPlayer Team and Number
			checkTeams();
			autoBalance();
			// After added the other players, add the selfPlayer and make the connection
			createServerRoomConnection();
		}
	}

	public override function begin()
	{
		// Set Background
		addGraphic(new Image("gfx/vs_background.jpg"));
		// Teams and info layer
		addGraphic(new Image("gfx/vs_02.png"), 2, 0, 190);
		// Get the room actual players
		getRoomPlayers();
	}

	private function movePlayer()
	{
		// HXP.server.postDataToGroup({
		// 	type: "versusPlayerMovment",
		// 	Player: selfPlayer
		// });
		// var url:String = "http://metioro.com/GolPlay/mongodb.php?collection=active_players&query=update&data="+gameID;
		
		// var r:Http = new Http(url);
		// r.onError = function( e ){
		// 	trace('ERROR: ' + e);
		// }
		// r.onData = onGetRoomPlayersData;

		// r.request( false );

	}

	private function handleKeys()
	{
		checkTeams();

		if( Input.check("left") ){
			if( selfPlayer.team == 1 && team0NumPlayers < 7){
				selfPlayer.team = 0;
				selfTeam = 0;
				selfPlayer.number = team0NumPlayers + 1;
				team0NumPlayers++;
				selfNumber = selfPlayer.number;
				team1NumPlayers--;
				movePlayer();
			}
		}
		if( Input.check("right") ){
			if( selfPlayer.team == 0 && team1NumPlayers < 7){
				selfPlayer.team = 1;
				selfTeam = 1;
				selfPlayer.number = team1NumPlayers + 1;
				team1NumPlayers++;
				selfNumber = selfPlayer.number;
				team0NumPlayers--;
				movePlayer();
			}
		}
		if( Input.check("enter") ){
			HXP.world = new worlds.GameWorld( gameID, allPlayers );
		}
	}

	private function checkTeams()
	{
		team0NumPlayers = 0;
		team1NumPlayers = 0;
		for( player in allPlayers )
		{
			if( player.team == 0 ){
				team0NumPlayers+=1;
			}else{
				team1NumPlayers+=1;
			}
		}
		// trace( "Team: " + selfPlayer.team );
		// if( selfPlayer.team == 0 )
		// 	trace("Players in the team: "+selfPlayer.number);
		// else
		// 	trace("Players in the team: "+selfPlayer.number);
	}

	private function autoBalance():Void
	{
		if( (team0NumPlayers < 7) && (team0NumPlayers <= team1NumPlayers) ){
			// selfPlayer.team = 0;
			selfTeam = 0;
			selfNumber = team0NumPlayers + 1;
			team0NumPlayers+= 1;
		}else if( team1NumPlayers < 7 ){
			// selfPlayer.team = 1;
			selfTeam = 1;
			selfNumber = team1NumPlayers + 1;
			team1NumPlayers+= 1;
		}else{
			trace("ERROR: The room is full");
		}
		// trace( "selfTeam " + selfTeam );
		// trace( "selfNumber" + selfNumber );
	}

	public override function update()
	{
		handleKeys();

		super.update();
	}
}