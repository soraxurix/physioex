
	//***************************************************************************************
	// overlay MAIN Header TITLE code
	//***************************************************************************************
import mx.utils.Delegate;
import classes.au.com.cadre.cloe.*;

class classes.au.com.cadre.cloe.MainTitle{

	private var value:String 		= "New Title";
	private var color:String 		= "000000";
	private var size:Number 		= 2;
	private var align:String 		= "center";
	private var valign:String 		= "top";
	private var bgcolor:String 		= "FFFFFF";
	private var bgalpha:Number  	= 100;
	private var headerMC:MovieClip;
	private var myParent:Object;

	//declare event handlers
	private var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;

	//
	function MainTitle(parent:Object, cloeArrayPos:Object){
		myParent = parent;
		//initialise event dispatcher
		mx.events.EventDispatcher.initialize(this);
		//
		value 	= (cloeArrayPos.value==undefined)? "": cloeArrayPos.value;
		color	= cloeArrayPos.attributes.color;
		size 	= Number(cloeArrayPos.attributes.size);
		align 	= cloeArrayPos.attributes.align;
		valign 	= cloeArrayPos.attributes.valign;
		bgcolor 	= cloeArrayPos.attributes.bgcolor;
		bgalpha = Number(cloeArrayPos.attributes.bgalpha);
		//create MCs if not already
		myParent.cloeMC.header.removeMovieClip();
		headerMC = myParent.cloeMC.createEmptyMovieClip("header", myParent.cloeMC.getNextHighestDepth());
		headerMC.createTextField("headertext", 2, 0, 0, 10, 10);
		//set header
		setMainTitle({color:this.color, align:this.align, valign:this.valign, size:this.size, value:this.value, bgcolor:this.bgcolor, bgalpha:this.bgalpha});
	}


	//main title function
	public function setMainTitle(obj:Object):Void{
		//store new values in case they have changed
		color = obj.color;
		align = obj.align;
		valign = obj.valign;
		size = obj.size;
		value = obj.value;
		bgcolor = obj.bgcolor;
		bgalpha = obj.bgalpha;

		var myformat:TextFormat = new TextFormat();
		myformat.color = parseInt("0x"+obj.color);
		myformat.align = obj.align;
		myformat.font = "Arial";
		myformat.size = Number(obj.size);
		with (headerMC.headertext){
			autoSize = true;
			selectable = false;
			text = obj.value;
			setTextFormat(myformat);
		}
		//align header in display window
		if (obj.align=="left") 	headerMC._x = 0;
		if (obj.align=="center") 	headerMC._x = (myParent.cloeWidth/2)-(headerMC.headertext._width/2);
		if (obj.align=="right")	headerMC._x = myParent.cloeWidth-headerMC.headertext._width;
		if (obj.valign=="top") 	headerMC._y = 0;
		if (obj.valign=="center") headerMC._y = (myParent.cloeHeight/2)-(headerMC.headertext._height/2);
		if (obj.valign=="bottom") headerMC._y = myParent.cloeHeight-headerMC.headertext._height;
		//create the header bg
		myParent.setTextBG(bgcolor, bgalpha, headerMC);
	}
	public function getMyData():Object{
		return {color:this.color, align:this.align, valign:this.valign, size:this.size, value:this.value, bgcolor:this.bgcolor, bgalpha:this.bgalpha};
	}
	public function setMyData(obj:Object):Void{
		setMainTitle({color:obj.color, align:obj.align, valign:obj.valign, size:obj.size, value:obj.value, bgcolor:obj.bgcolor, bgalpha:obj.bgalpha});
	}


	//dispatch event with specified name
	private function dispatch(sEventName:String):Void {
		//trace("manager dispatching event : "+sEventName);
		dispatchEvent({type:sEventName, target:this});
	}
	//***************************************************************************************
	// ######################################################################################
	//***************************************************************************************


}