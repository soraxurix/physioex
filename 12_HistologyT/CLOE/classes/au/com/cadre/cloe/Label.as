//***************************************************************************************
// overlay LABEL code
//***************************************************************************************
import classes.au.com.cadre.cloe.*;
import mx.utils.Delegate;

class classes.au.com.cadre.cloe.Label{

	private var myValue:String;
	private var myX:Number;
	private var myY:Number;
	private var mySize:Number 		= 12;
	private var myColor:String 		= "000000";
	private var myBgColor:String		= "FFFFFF";
	private var myBgAlpha:Number	= 100;
	public var myParent:Object;
	private var labelMC:MovieClip;
	public var myType:String = "label";

	//declare event handlers
	private var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;

	function Label(parent:Object){
		//initialise event dispatcher
		mx.events.EventDispatcher.initialize(this);
		//
		myParent = parent;
		var nd:Number = myParent.setMC.getNextHighestDepth();
		//create label MC
		labelMC = myParent.setMC.createEmptyMovieClip("Label_"+nd, nd);
		//create the label text field MC
		if (!labelMC.labeltext) labelMC.createTextField("labeltext", 2, 0, 0, 10, 10);
		var pc:Object = myParent.myParent.getCloeWindowCenter();
		labelMC._x = pc.x - 20;
		labelMC._y = pc.y;
		myValue = "New Label";
		myX = labelMC._x;
		myY = labelMC._y;
		//
		setLabel(myValue ,myX ,myY ,myColor ,mySize ,myBgColor ,myBgAlpha);
		if (myParent.myParent.authoring) makeInteractive();
	}

	private function makeInteractive():Void{
		labelMC.myRef 	= this;
		//
		labelMC.onPress = function(){
			this.sx = this._x;
			this.sy  = this._y;
			this.sxm = this._parent._xmouse;
			this.sym  = this._parent._ymouse;
			this.onEnterFrame = function(){
				this._x = this.sx + (this._parent._xmouse-this.sxm);
				this._y = this.sy + (this._parent._ymouse-this.sym);
				this.myRef.setImageLoc(this._x, this._y);
			}
		}
		labelMC.onRelease = function(){
			delete this.onEnterFrame;
			this.myRef.dispatch("onReleased");
		}
		labelMC.onReleaseOutside = function(){
			delete this.onEnterFrame;
		}
	}

	public function setLabel (value:String, x:Number, y:Number, c:String, s:Number, bgc:String, bga:Number):Void{
		//set all the values in case they have changed
		myValue 	= value;
		myX 	= x;
		myY 	= y;
		myColor 	= c;
		mySize 	= s;
		myBgColor = bgc;
		myBgAlpha = bga;
		labelMC._x = myX;
		labelMC._y = myY;
		//
		var myformat 	= new TextFormat();
		myformat.color = parseInt("0x"+myColor);
		myformat.font 	= "Arial";
		myformat.embedFonts = true;
		myformat.size 	= mySize;
		labelMC.labeltext.autoSize 	= true;
		labelMC.labeltext.embedFonts 	= true;
		labelMC.labeltext.selectable 	= false;
		labelMC.labeltext.text 		= myValue;
		labelMC.labeltext.setTextFormat(myformat);
		//create the Text label bg
		myParent.myParent.setTextBG(myBgColor, myBgAlpha, labelMC);
	}


	public function getMyData():Object{
		return {value:myValue ,x:myX ,y:myY ,color:myColor ,size:mySize ,bgcolor:myBgColor ,bgalpha:myBgAlpha};
	}
	public function setMyData(obj:Object):Void{
		setLabel(obj.value ,obj.x ,obj.y ,obj.color ,obj.size ,obj.bgcolor ,obj.bgalpha);
	}

	public function setImageLoc(x:Number, y:Number):Void{
		setLabel(myValue ,x ,y ,myColor ,mySize ,myBgColor ,myBgAlpha);
		dispatch("onLabelMoved");
	}

	function deleteMe():Void{
		var pntr:Object = myParent.setObjects.labels;
		var i:Number;
		var il:Number = pntr.length;
		for (i=0;i<il;i++) if (pntr[i]==this) pntr.splice(i,1);
		labelMC.removeMovieClip();
		delete this;
	}

	//dispatch event with specified name
	private function dispatch(sEventName:String):Void {
		//trace("manager dispatching event : "+sEventName);
		dispatchEvent({type:sEventName, target:this});
	}

}
//***************************************************************************************
// ######################################################################################
//***************************************************************************************