package resources;

// import flash.display.Sprite;
// import flash.display.Graphics;
// import flash.Lib;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Graphiclist;

import com.eclecticdesignstudio.motion.Actuate;
import nme.display.Sprite;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.text.TextFormat;
import nme.text.TextField;
import nme.text.TextFieldType;
import nme.Assets;
import nme.Lib;
import nme.events.Event;

class Lightbox extends Entity
{
	// Background variables
	private var background:Image;
	private static inline var backgroundColor:Int = 0xFFFFFF;
	private static inline var backgroundAlpha:Float = 0.5;
	// PopUp variables
	private var popUp:Image;
	private var popUpWidth = 300;
	private var popUpHeight = 400;
	private static inline var popUpColor:Int = 0x000000;
	// Graphiclist for final graphic
	private var graphicList:Graphiclist;

	public function new( ?x:Int = 0, ?y:Int = 0 )
	{
		super(x, y);

		background = Image.createRect(HXP.width, HXP.height, backgroundColor);

		background.alpha = 0.5;

		createPopUp();

		graphicList = new Graphiclist([background, popUp]);

		graphic = graphicList;

		setHitbox(HXP.width, HXP.height);

		type = "lightbox";

		layer = 1;

		createText();
	}

	public function Lightbox( x, y:Int )
	{
		new Lightbox(x, y);
	}

	public function createPopUp( )
	{
		popUp = Image.createRect(popUpWidth, popUpHeight, popUpColor);
		popUp.x = HXP.halfWidth - popUpWidth / 2;
		popUp.y = HXP.halfHeight - popUpHeight / 2;

	}
	private function createText( )
	{
		// var font = Assets.getFont ("assets/font/arial.ttf");
		// var format = new TextFormat (font.fontName, 24, 0xFF0000);
		var textField = new TextField ();
		// textField.defaultTextFormat = format;
		textField.selectable = true;
		// textField.embedFonts = true;
		textField.width = 160;
		textField.height = 40;
		textField.x = 0;
		textField.y = 450;

		textField.text = "Hello World!";
		textField.type = TextFieldType.INPUT;
		textField.addEventListener (Event.CHANGE, TextField_onChange);

		Lib.current.addChild( textField );
	}
	private function TextField_onChange( event:Event ):Void 
	{
		var textField:TextField = event.currentTarget;
		trace (textField.text); 
	}
}