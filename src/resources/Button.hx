package resources;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

class Button extends Entity
{
	public var onHovered(getHovered, setHovered):Dynamic = null;
	public var onClick(getCallback, setCallback):Dynamic = null;
	public var hovered:Bool = false;

	public function new(?x=0, ?y=0:Float, ?type:String=null, ?graphic=null:String, ?width=10, ?height=10:Int)
	{
		super(x, y);

		if(graphic != null)
			this.graphic = new Image(graphic);
		
		if(type != null){
			setHitbox( width, height );
			type = type;
		}else{
			this.type = null;
		}
	}

	private function handeHover():Bool
	{
		if( this.type != null){
			if( collidePoint(this.type, Input.mouseX, Input.mouseY) != null ){
				return true;
			}
		}
		return false;
	}

	public function getHovered():Dynamic
	{
		return hovered;
	}

	public function setHovered( callback:Dynamic ):Void 
	{
		this.onHovered = callback;
	}

	private function handleClick(callback):Bool
	{
		if( this.type != null){
			if( collidePoint(this.type, Input.mouseX, Input.mouseY) != null ){
				if (Input.mouseReleased){
					if( callback != null ){
						callback( type );
					}
					return true;
				}
			}
		}
		return false;
	}

	public function getCallback():Dynamic
	{
		return this.callback;
	}

	public function setCallback( callback:Dynamic ):Void
	{
		this.callback = callback;
	}

	public override function update()
	{
		this.hovered = handeHover();

		if( this.hovered && onHovered != null){
			onHovered();
		}

		handleClick();

		super.update();
	}
}