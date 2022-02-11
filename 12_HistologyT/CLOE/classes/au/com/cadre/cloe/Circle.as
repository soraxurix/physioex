//***************************************************************************************
// overlay BRACKET code
//***************************************************************************************
import classes.au.com.cadre.cloe.*;
import mx.utils.Delegate;

class classes.au.com.cadre.cloe.Circle{

	private var point1:Point;
	private var myThickness:Number 	= 2;
	private var myColor:String 		= "000000";
	private var myRadius:Number 	= 20;
	private var myRotation:Number 	= 0;
	private var myStyle:String		= "solid";
	public var myParent:Object;
	private var myMC:MovieClip;

	public var myType:String = "circle";

	//declare event handlers
	private var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;

	function Circle(parent:Object){

		//initialise event dispatcher
		mx.events.EventDispatcher.initialize(this);
		//
		myParent = parent;
		var nd:Number = myParent.setMC.getNextHighestDepth();
		myMC = myParent.setMC.createEmptyMovieClip("Circle_"+nd, nd);
		//create the center
		myMC.createEmptyMovieClip("centerbg", myMC.getNextHighestDepth());
		myMC.createEmptyMovieClip("center", myMC.getNextHighestDepth());
		//find the center of window
		var pc:Object = myParent.myParent.getCloeWindowCenter();
		point1 = new Point(pc.x, pc.y, this, myParent.setMC, false);
		//register points with the current OverlaySet
		myParent.setPoints.push(point1);
		drawMe();
		if (myParent.myParent.authoring) makeInteractive();
	}

	private function makeInteractive ():Void{
		myMC.myRef = this;
		myMC.onPress = function(){
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
		myMC.onRelease = function(){
			delete this.onEnterFrame;
			this.myRef.dispatch("onReleased");
		}
		myMC.onReleaseOutside = function(){
			delete this.onEnterFrame;
			this._alpha = 0;
		}
	}

	private function updateLoc(x:Number, y:Number):Void{
		setMe(x, y, myThickness, myColor, myRadius);
		dispatch("onMoved");
	}

	public function setMe (x:Number, y:Number, tk:Number, c:String, r:Number, st:String):Void{
		//update attributes
		point1.x 		= x;
		point1.y 		= y;
		myThickness 	= tk;
		myColor 		= c;
		myRadius 		= r;
		myStyle 		= st;
		//
		drawMe();
	}

	function getMyData ():Object{
		return {x:point1.x, y:point1.y, thickness:myThickness, color:myColor, radius:myRadius, style:myStyle}
	}
	function  setMyData (obj:Object):Void{
		setMe (obj.x, obj.y, obj.thickness, obj.color, obj.radius, obj.style)
	}

	function deleteMe(setID, id){
		var pntr:Object = myParent.setObjects.circle;
		var i:Number;
		var il:Number = pntr.length;
		for (i=0;i<il;i++) if (pntr[i]==this) pntr.splice(i,1);
		point1.deletePoint();
		myMC.removeMovieClip();
		delete this;
	}

	private function drawMe ():Void{
		myMC._x = point1.x;
		myMC._y = point1.y;
		var center:Array = [0,myRadius];
		//body
		var rad:Number= myRadius;
		var controlOffset:Number = Math.sin(24*Math.PI/180)*rad;
		myMC.center.clear();
		myMC.center.lineStyle(myThickness, parseInt("0x"+myColor), 100);
		//myMC.center.beginFill(0x00000, 100);
		myMC.center. moveTo(center[0], center[1]-rad);
		myMC.center.curveTo(center[0]+controlOffset, center[1]-rad, center[0]+Math.cos(45*Math.PI/180)*rad, center[1]-Math.sin(45*Math.PI/180)*rad);
		myMC.center.curveTo(center[0]+rad, center[1]-controlOffset, center[0]+rad, center[1]);
		myMC.center.curveTo(center[0]+rad, center[1]+controlOffset, center[0]+Math.cos(45*Math.PI/180)*rad, center[1]+Math.sin(45*Math.PI/180)*rad);
		myMC.center.curveTo(center[0]+controlOffset, center[1]+rad, center[0], center[1]+rad);
		myMC.center.curveTo(center[0]-controlOffset, center[1]+rad, center[0]-Math.cos(45*Math.PI/180)*rad, center[1]+Math.sin(45*Math.PI/180)*rad);
		myMC.center.curveTo(center[0]-rad, center[1]+controlOffset, center[0]-rad, center[1]);
		myMC.center.curveTo(center[0]-rad, center[1]-controlOffset, center[0]-Math.cos(45*Math.PI/180)*rad, center[1]-Math.sin(45*Math.PI/180)*rad);
		myMC.center.curveTo(center[0]-controlOffset, center[1]-rad, center[0], center[1]-rad);
		//make the white BG colour
		myMC.centerbg.clear();
		myMC.centerbg.lineStyle(myThickness+2, 0xFFFFFF, 100);
		//myMC.center.beginFill(0x00000, 100);
		myMC.centerbg. moveTo(center[0], center[1]-rad);
		myMC.centerbg.curveTo(center[0]+controlOffset, center[1]-rad, center[0]+Math.cos(45*Math.PI/180)*rad, center[1]-Math.sin(45*Math.PI/180)*rad);
		myMC.centerbg.curveTo(center[0]+rad, center[1]-controlOffset, center[0]+rad, center[1]);
		myMC.centerbg.curveTo(center[0]+rad, center[1]+controlOffset, center[0]+Math.cos(45*Math.PI/180)*rad, center[1]+Math.sin(45*Math.PI/180)*rad);
		myMC.centerbg.curveTo(center[0]+controlOffset, center[1]+rad, center[0], center[1]+rad);
		myMC.centerbg.curveTo(center[0]-controlOffset, center[1]+rad, center[0]-Math.cos(45*Math.PI/180)*rad, center[1]+Math.sin(45*Math.PI/180)*rad);
		myMC.centerbg.curveTo(center[0]-rad, center[1]+controlOffset, center[0]-rad, center[1]);
		myMC.centerbg.curveTo(center[0]-rad, center[1]-controlOffset, center[0]-Math.cos(45*Math.PI/180)*rad, center[1]-Math.sin(45*Math.PI/180)*rad);
		myMC.centerbg.curveTo(center[0]-controlOffset, center[1]-rad, center[0], center[1]-rad);
		//myMC.center.ebdFill();
		//trace("drawn circle: "+myMC._x+", "+myMC._y);
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
