package entities; 

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;


class Link extends Entity
{
	public var id(getID, setID):String = '0';

	public function new( x, y:Int, text:Image )
	{
		super(x, y);

		graphic = text;
	}

	public function getID():String
	{
		return this.id;
	}

	public function setID( id:String ):String
	{
		this.id = id;
		return this.id;
	}
}