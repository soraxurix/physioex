//***************************************************************************************
// overlay BRACKET code
//***************************************************************************************
import classes.au.com.cadre.cloe.*;
import mx.utils.Delegate;

class classes.au.com.cadre.cloe.Bracket extends classes.au.com.cadre.cloe.Drawing{

	private var point1:Point;
	private var myThickness:Number 	= 2;
	private var myColor:String 		= "000000";
	private var myWidth:Number 	= 100;
	private var myRotation:Number 	= 0;
	private var mySkew:Number 	= 0;
	private var myHeight:Number 	= 20;
	private var myOffset:Number 	= 0;
	private var myLegs:Number 		= 2;
	private var myStyle:String		= "solid";
	public var myParent:Object;
	private var bracketMC:MovieClip;

	public var myType:String = "bracket";

	//declare event handlers
	private var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;

	function Bracket(parent:Object){

		//initialise event dispatcher
		mx.events.EventDispatcher.initialize(this);
		//
		myParent = parent;
		var nd:Number = myParent.setMC.getNextHighestDepth();
		bracketMC = myParent.setMC.createEmptyMovieClip("Bracket_"+nd, nd);
		//create the center and leg MCs
		bracketMC.createEmptyMovieClip("centerbg", bracketMC.getNextHighestDepth());
		for (var x:Number = 1; x<7;x++){
			bracketMC.createEmptyMovieClip("leg"+x+"bg", bracketMC.getNextHighestDepth());
		}
		bracketMC.createEmptyMovieClip("center", bracketMC.getNextHighestDepth());
		for (var x:Number = 1; x<7;x++){
			bracketMC.createEmptyMovieClip("leg"+x, bracketMC.getNextHighestDepth());
		}
		//find the center of window
		var pc:Object = myParent.myParent.getCloeWindowCenter();
		point1 = new Point(pc.x, pc.y, this, myParent.setMC, false);
		//register points with the current OverlaySet
		myParent.setPoints.push(point1);
		drawBracket();
		if (myParent.myParent.authoring) makeInteractive();
	}

	private function makeInteractive ():Void{
		bracketMC.myRef = this;
		bracketMC.onPress = function(){
			this.sx = this._x;
			this.sy  = this._y;
			this.sxm = this._parent._xmouse;
			this.sym  = this._parent._ymouse;
			this.onEnterFrame = function(){
				this._x = this.sx + (this._parent._xmouse-this.sxm);
				this._y = this.sy + (this._parent._ymouse-this.sym);
				this.myRef.updateLoc(this._x, this._y);
			}
		}
		bracketMC.onRelease = function(){
			delete this.onEnterFrame;
			this.myRef.dispatch("onReleased");
		}
		bracketMC.onReleaseOutside = function(){
			delete this.onEnterFrame;
			this._alpha = 0;
		}
	}

	private function updateLoc(x:Number, y:Number):Void{
		setBracket (x, y, myThickness, myColor, myWidth, myRotation, mySkew, myHeight, myOffset, myLegs, myStyle);
		dispatch("onBracketMoved");
	}

	public function setBracket (x:Number, y:Number, tk:Number, c:String, w:Number, r:Number, s:Number, h:Number, o:Number, l:Number, st:String):Void{
		//update attributes
		point1.x 		= x;
		point1.y 		= y;
		myThickness 	= tk;
		myColor 		= c;
		myWidth 		= w;
		myRotation 	= r;
		mySkew 		= s;
		myHeight 		= h;
		myOffset 		= o;
		myLegs			= l;
		myStyle 		= st;
		//
		drawBracket();
	}

	function getMyData ():Object{
		return {x:point1.x, y:point1.y, thickness:myThickness, color:myColor, width:myWidth, rotation:myRotation, skew:mySkew, height:myHeight, offset:myOffset, legs:myLegs, style:myStyle}
	}
	function  setMyData (obj:Object):Void{
		setBracket (obj.x, obj.y, obj.thickness, obj.color, obj.width, obj.rotation, obj.skew, obj.height, obj.offset, obj.legs, obj.style)
	}

	function deleteMe(setID, id){
		var pntr:Object = myParent.setObjects.bracket;
		var i:Number;
		var il:Number = pntr.length;
		for (i=0;i<il;i++) if (pntr[i]==this) pntr.splice(i,1);
		point1.deletePoint();
		bracketMC.removeMovieClip();
		delete this;
	}

	private function drawBracket ():Void{
		bracketMC._x = point1.x;
		bracketMC._y = point1.y;
		bracketMC._rotation = myRotation;
		//body
		bracketMC.center.clear();
		bracketMC.center.lineStyle(myThickness, parseInt("0x"+myColor), 100);
		bracketMC.centerbg.clear();
		bracketMC.centerbg.lineStyle(myThickness+2, 0xFFFFFF, 100);
		if (myStyle=="dashed"){
			dashTo(bracketMC.center, -myWidth/2, 0, myWidth/2, 0, 8, 8);
			dashTo(bracketMC.centerbg, -myWidth/2, 0, myWidth/2, 0, 8, 8);
		}else if (myStyle=="dotted"){
			dashTo(bracketMC.center, -myWidth/2, 0, myWidth/2, 0, 2, 6);
			dashTo(bracketMC.centerbg, -myWidth/2, 0, myWidth/2, 0, 2, 6);
		}else{
			bracketMC.center.moveTo(-myWidth/2, 0);
			bracketMC.centerbg.moveTo(-myWidth/2, 0);
			bracketMC.center.lineTo(myWidth/2, 0);
			bracketMC.centerbg.lineTo(myWidth/2, 0);
		}
		
		//legs
		//first clear all
		for (var x:Number = 1; x<7;x++){
			bracketMC["leg"+x].clear();
			bracketMC["leg"+x+"bg"].clear();
		}
		//check how many divisions needed
		var div:Number = myWidth/(myLegs-1);
		for (var x:Number = 1;x<myLegs+1;x++){
			//colored foreground
			bracketMC["leg"+x]._x = -myWidth/2 + (div*x - div);
			bracketMC["leg"+x]._y = 0;
			bracketMC["leg"+x]._rotation = mySkew;
			bracketMC["leg"+x].lineStyle(myThickness, parseInt("0x"+myColor), 100);
			bracketMC["leg"+x].moveTo(0, -myOffset);
			bracketMC["leg"+x].lineTo(0, myHeight-myOffset);
			//white BG edge
			bracketMC["leg"+x+"bg"]._x = -myWidth/2 + (div*x - div);
			bracketMC["leg"+x+"bg"]._y = 0;
			bracketMC["leg"+x+"bg"]._rotation = mySkew;
			bracketMC["leg"+x+"bg"].lineStyle(myThickness+2, 0xFFFFFF, 100);
			bracketMC["leg"+x+"bg"].moveTo(0, -myOffset);
			bracketMC["leg"+x+"bg"].lineTo(0, myHeight-myOffset);
			//
		}
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
