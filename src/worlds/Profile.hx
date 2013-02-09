package worlds;

import com.haxepunk.HXP;
import com.haxepunk.World;
import com.haxepunk.Entity;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.graphics.Image;
// MongoDB CONNECTION
import haxe.Json;
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.events.IOErrorEvent;
// TO DISPLAY LISTS
import com.haxepunk.graphics.Text;
import entities.Link;
// TO CHANGE MOUSE CURSOR
import flash.ui.Mouse;

class Profile extends World
{
	private static inline var CONTAINER_WIDTH  = 240;
	private static inline var CONTAINER_HEIGHT = 414;
	private static inline var CONTAINER_ICON_WIDTH  = 210;
	private static inline var CONTAINER_ICON_HEIGHT = 88;
	private static inline var BUTTON_WIDTH  = 251;
	private static inline var BUTTON_HEIGHT = 90;

	private var button:Entity;

	public function new()
	{
		super();
		Mouse.cursor = "auto";
	}
	public override function begin()
	{
		addGraphic(new Image("gfx/profile_background.jpg"));
		
		addGraphic(new Image("gfx/avatar-edit-profile.png"), 2, 43, 180);

		createMenu(470, 180);

		button = createButton(500, 592);
	}
	private function createMenu(x:Int, y:Int)
	{
		addGraphic(new Image("gfx/stf-edit-profile.png"), 2, x, y);
	}
	private function createButton(x:Int, y:Int):Entity
	{
		var box:Entity = new Entity(x, y);
		
		box.graphic = new Image("gfx/lobby_playbtn.png");
		
		box.setHitbox( BUTTON_WIDTH, BUTTON_HEIGHT );
		box.type = "button";

		add(box);

		return box;
	}
	public function clickOn(e:Entity):Bool
	{
		if (collidePoint(e.type, Input.mouseX, Input.mouseY) != null) {
			if (Input.mouseReleased)
				return true;
		}
		return false;
	}
	public function handleMouseEvents()
	{
		if( clickOn(button) )
			HXP.world = new worlds.Versus( "--" );
	}
	public override function update()
	{
		handleMouseEvents();

		super.update();
	}
}