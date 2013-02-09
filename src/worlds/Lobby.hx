package worlds;

import com.haxepunk.HXP;
import com.haxepunk.World;
import com.haxepunk.Entity;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.graphics.Image;
// MongoDB CONNECTION
import tjson.TJSON;
import haxe.Http;
// TO DISPLAY LISTS
import com.haxepunk.graphics.Text;
import entities.Link;
// TO CHANGE MOUSE CURSOR
import flash.ui.Mouse;
// RESOURCES
import resources.Lightbox;

class Lobby extends World
{
	// DATABASE CONNECTION CONSTANTS
	private static inline var DB_PROTOCOL:String 			= "http://";
	private static inline var DB_DOMAIN:String 				= "metioro.com/";
	private static inline var DB_DRIVER:String 				= "GolPlay/mongodb.php";
	/*private static inline var DB_PORT:String 				= "28012";
	private static inline var DB_HOST_NAME:String 			= "localhost";
	private static inline var DB_NAME:String 				= "golplay";*/
	private static inline var DB_ROOM_COLLECTION:String 	= "rooms";
	// CONTAINER SIZE CONSTANTS
	private static inline var CONTAINER_WIDTH:Int  			= 240;
	private static inline var CONTAINER_HEIGHT:Int 			= 414;
	private static inline var CONTAINER_ICON_WIDTH:Int  	= 210;
	private static inline var CONTAINER_ICON_HEIGHT:Int 	= 88;
	// CONTAINER TEXT CONSTANTS
	private static inline var CONTAINER_TEXT_COLOR:Int 		= 0xFFFFFF;
	private static inline var CONTAINER_TEXT_SIZE:Int 		= 13;
	private static inline var CONTAINER_TEXT_FONT:String 	= "font/arial.ttf";
	private static inline var CONTAINER_TEXT_SPACING:Int 	= 18;
	private static inline var CONTAINER_TEXT_STARTING_Y:Int = 300;
	private static inline var CONTAINER_TEXT_STARTING_X1:Int= 80;
	private static inline var CONTAINER_TEXT_STARTING_X2:Int= 280;
	// PLAY BUTTON CONSTANTS
	private static inline var BUTTON_WIDTH:Int  = 251;
	private static inline var BUTTON_HEIGHT:Int = 90;
	// REFRESH BUTTON CONSTANTS
	private static inline var REFRESH_WIDTH:Int  = 28;
	private static inline var REFRESH_HEIGHT:Int = 22;
	private static inline var REFRESH_YLINE:Int  = 200;

	public function new()
	{
		super();
	}
	
	public override function begin()
	{
		// Set Background
		addGraphic(new Image("gfx/lobby_background.jpg"));
		/*
		 *	RANK LIST CONTAINER AND BUTTONS
		 */
		// Create Rank Container
		createContainer(20, 170);
		// Add lobby icon graphic
		addGraphic(new Image("gfx/lobby_contico_01.png"), 2, 35, 190);
		// Create rank search button
		createSearch( 35, 276, 210, 30 );
		// Create rank refresh button 
		// createRefresh( 126, 400, "rank" );
		/*
		 *	ROOMS LIST CONTAINER AND BUTTONS
		 */ 
		// Create Games Container
		createContainer(260, 170);
		// Add games icon graphic
		addGraphic(new Image("gfx/lobby_contico_02.png"), 2, 275, 190);
		// Create rooms search button 
		createMoreRooms( 275, 276, 105, 30);
		createNewRoom( 380, 276, 105, 30);
		// Create rooms refresh button
		// createRefresh( 20, 400, "rooms" );
		/*
		 *	PROFILE LIST CONTAINER AND BUTTONS
		 */
		// Create Profile Container
		createContainer(500, 170);
		// Add profile icon graphic
		addGraphic(new Image("gfx/lobby_contico_03.png"), 2, 515, 190);
		// Create edit profile button
		createEditProfile( 515, 276, 210, 30 );
		// Create Play Button
		createPlayButton(255, 592);
		// Fill Rank & Game Containers with content
		query( DB_ROOM_COLLECTION );

		add(new Lightbox());
	}

	private function createContainer(x:Int, y:Int):Entity
	{
		var box:Entity = new Entity(x, y);

		box.graphic = new Image("gfx/lobby_contbgn.png");

		add(box);

		return box;
	}

	private function createRefresh(x:Float, y:Float, action:String):Entity
	{
		var box:Entity = new Entity(x, y);

		box.graphic = new Image("gfx/bt-lobby_refresh.png");

		box.setHitbox(REFRESH_WIDTH, REFRESH_HEIGHT );
		box.type = "refresh-" + action;

		add( box );

		return box;
	}

	private function createSearch(x, y:Int, ?width=0, ?height=0):Entity 
	{
		var box:Entity = new Entity(x, y);

		// box.graphic = new Image("gfx/bt-lobby_search.png");
		box.graphic = new Image("gfx/bt_1.png");

		box.setHitbox( width, height );
		box.type = "search";

		add( box );

		return box;
	}

	private function createMoreRooms(x, y:Int, ?width=0, ?height=0):Entity
	{
		var box:Entity = new Entity(x, y);

		box.graphic = new Image("gfx/bt_2.png");

		box.setHitbox( width, height );
		box.type = "more-rooms";

		add( box );

		return box;
	}

	private function createNewRoom(x, y:Int, ?width=0, ?height=0):Entity 
	{
		var box:Entity = new Entity(x, y);

		box.graphic = new Image("gfx/bt_3.png");

		box.setHitbox( width, height );
		box.type = "new-room";

		add( box );

		return box;	
	}

	private function createEditProfile(x, y:Int, ?width=0, ?height=0):Entity
	{
		var box:Entity = new Entity(x, y);

		// box.graphic = new Image("gfx/bt-lobby_edit.png");
		box.graphic = new Image("gfx/bt_4.png");

		box.setHitbox( width, height );
		box.type = "edit-profile";

		add( box );

		return box;
	}

	private function createPlayButton(x:Int, y:Int):Entity
	{
		var box:Entity = new Entity(x, y);
		
		box.graphic = new Image("gfx/lobby_playbtn.png");
		
		box.setHitbox( BUTTON_WIDTH, BUTTON_HEIGHT );
		box.type = "play-now";

		add(box);

		return box;
	}
	
	private function createLink( txt:String, id:String, x, y:Int, ?fontOptions:TextOptions=null ):Link
	{
		// Add text and return Entity
		var text:Text = new Text(txt, 0, 0, 0, 0, fontOptions);
		
		var textEntity:Link = new Link(x, y, text);
		
		textEntity.id = id;

		add( textEntity );
		// Add button beheivor
		textEntity.setHitbox( CONTAINER_WIDTH, CONTAINER_TEXT_SPACING );
		textEntity.type = "link";

		// Return the Entity
		return textEntity;
	}

	private function query( ?collection:String = DB_ROOM_COLLECTION, ?query:String = ""):Void
	{
		var url:String = DB_PROTOCOL+DB_DOMAIN+DB_DRIVER+"?collection="+collection+"&query="+query;
		flash.system.Security.allowDomain('*');
		var r:Http = new Http(url);
		r.onError = function( e ){
			trace('ERROR: ' + e);
		}
		r.onData = function( e:String ){
			var rooms:Dynamic = TJSON.parse( e );
			fillContainers( null, rooms );
		}
		r.request( false );
	}

	private function fillContainers(rankList:Dynamic, roomList:Array<Dynamic> ):Void
	{
		// Font options
		var fontOptions:TextOptions = { 
			size: 	CONTAINER_TEXT_SIZE, 
			color:	CONTAINER_TEXT_COLOR, 
			font: 	CONTAINER_TEXT_FONT
		};
		// FILL RANKS
		// Starting Y
		// var selfY:Int = CONTAINER_TEXT_STARTING_Y;
		// for( rankName in ["Those", "are", "testing", "names", "for", "testing", "propouses"] ){
		// 	// Create item
		// 	var link:Link = createLink( rankName, "asd", CONTAINER_TEXT_STARTING_X1, selfY, fontOptions );
		// 	// Breake line
		// 	selfY += CONTAINER_TEXT_SPACING;
		// }
		// FILL GAMES
		
		// GET DATA FROM ACTIVES IN COLLECTION		
		
		// Starting Y
		var i:Int = 0;
		var selfY:Int = CONTAINER_TEXT_STARTING_Y;
		for( room in roomList ){
			// Create item
			var link:Link = createLink( room.name, room.id, CONTAINER_TEXT_STARTING_X2, selfY, fontOptions );
			// Breake line
			selfY += CONTAINER_TEXT_SPACING;
		}
	}
	
	public function clickOn( type:String, ?callbackFn:Dynamic = null ):Bool
	{
		if( collidePoint(type, Input.mouseX, Input.mouseY) != null ){
			if (Input.mouseReleased){
				if( callbackFn != null ){
					callbackFn( type );
				}
				return true;
			}
		}
		return false;
	}

	public function handleHover( types:Array<String> ):Void
	{
		var collideOne:Bool = false;
		for( type in types ){
			if( !collideOne )
				collideOne = (collidePoint(type, Input.mouseX, Input.mouseY) != null);
		}
		if( (collideOne || (collidePoint("link", Input.mouseX, Input.mouseY)   != null)) &&
			(collidePoint("lightbox", Input.mouseX, Input.mouseY)==null) ){
			Mouse.cursor = "button";
		}else{
			Mouse.cursor = "auto";
		}
	}

	public function clickOnLink():Void
	{
		var handleLink:Entity = collidePoint("link", Input.mouseX, Input.mouseY);
		if( (handleLink != null) && Input.mouseReleased ){
			var link:Link = cast(handleLink, Link);
			HXP.world = new worlds.Versus( link.id );
		}
	}
	
	public override function update()
	{
		handleHover(["play-now", "edit-profile"]);

		clickOn("play-now", function(){
			HXP.world = new worlds.Versus( "--" );
		});

		clickOn("edit-profile", function(){
			HXP.world = new worlds.Profile();
		});

		clickOnLink();

		super.update();
	}
}