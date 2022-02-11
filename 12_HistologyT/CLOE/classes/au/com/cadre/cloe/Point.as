//AW - histology class
// Robert Bleeker
import mx.utils.Delegate;
import classes.au.com.cadre.cloe.*;


class classes.au.com.cadre.cloe.Point{

	private var myX:Number;
	private var myY:Number;
	private var myParent:Object;
	private var pointMC:MovieClip;
	private var scopeMC:MovieClip;
	private var isInteractive:Boolean = false;

	//declare event handlers	private var dispatchEvent:Function;	public var addEventListener:Function;	public var removeEventListener:Function;


	function Point(newX:Number, newY:Number, parent:Object, mcScope:MovieClip, interactive:Boolean){
		//initialise event dispatcher		mx.events.EventDispatcher.initialize(this);
		 //
		myParent = parent;
		scopeMC = mcScope;
		myX = newX;
		myY = newY;
		isInteractive = interactive;
		//
		if (isInteractive) makeInteractive();
	}

	public function setPoint(x:Number, y:Number):Void{
		myX = x;
		myY = y;
		if (isInteractive) {
			pointMC._x = myX;
			pointMC._y = myY;
			dispatch("onChanged");
		}
	}

	public function movePoint(x:Number, y:Number):Void{
		myX = Number(myX) + Number(x);
		myY = Number(myY) + Number(y);
		if (isInteractive) {
			pointMC._x = myX;
			pointMC._y = myY;
		}
	}

	public function set x(n:Number):Void{
		myX = n;
		if (isInteractive) {
			pointMC._x = myX;
			pointMC._y = myY;
		}
	}
	public function get x(){
		return myX;
	}

	public function set y(n:Number):Void{
		myY = n;
		if (isInteractive) {
			pointMC._x = myX;
			pointMC._y = myY;
		}
	}
	public function get y(){
		return myY;
	}

	public function deletePoint(){
		//
		pointMC.removeMovieClip();
		delete this;
	}


// 	private function crossHair(parent:Object):Void{
// 		parent.cntp = parent.target.createEmptyMovieClip("centerPoint", parent.target.getNextHighestDepth());
// 		//draw a small crosshair
// 		with (parent.cntp){
// 			lineStyle(1, 0x000000, 30);
// 			moveTo(0,0);
// 			lineTo(0,10);
// 			moveTo(0,0);
// 			lineTo(0,-10);
// 			moveTo(0,0);
// 			lineTo(10,0);
// 			moveTo(0,0);
// 			lineTo(-10,0);
// 			_visible = 0;
// 		}
// 	}

	public function makeInteractive():Void{
		var nd:Number = scopeMC.getNextHighestDepth();
		pointMC = scopeMC.createEmptyMovieClip("point_"+nd, nd);
		//trace ("scopeMC: "+scopeMC._target);
		pointMC.myRef = this;
		pointMC._x = myX;
		pointMC._y = myY;
		pointMC._alpha = 0;
		var tn:Number = myParent.myThickness *2;
		pointMC.onRollOver = function(){
			this._alpha = 100;
		}
		pointMC.onRollOut = function(){
			this._alpha = 0;
		}
		pointMC.onPress = function(){
			this.sx = this._x;
			this.sy  = this._y;
			this.sxm = this._parent._xmouse;
			this.sym  = this._parent._ymouse;
			this.onEnterFrame = function(){
				this._x = this.sx + (this._parent._xmouse-this.sxm);
				this._y = this.sy + (this._parent._ymouse-this.sym);
				this.myRef.setPoint(this._x, this._y);
			}
		}
		pointMC.onRelease = function(){
			delete this.onEnterFrame;
			this.myRef.dispatch("onReleased");
		}
		pointMC.onReleaseOutside = function(){
			delete this.onEnterFrame;
			this._alpha = 0;
		}
		drawDot(pointMC, [0,0], tn, "FF0000", 100);
	}

	private function drawDot (item:MovieClip, center:Object, rad:Number, fillColor:String, fillAlpha:Number) :Void{
		//trace("ddraw dot");
		var controlOffset:Number = Math.sin(24*Math.PI/180)*rad;
		item.clear();
		item.lineStyle(1, 0x000000, 0);
		item.beginFill(parseInt(fillColor, 16), fillAlpha);
		item. moveTo(center[0], center[1]-rad);
		item.curveTo(center[0]+controlOffset, center[1]-rad, center[0]+Math.cos(45*Math.PI/180)*rad, center[1]-Math.sin(45*Math.PI/180)*rad);
		item.curveTo(center[0]+rad, center[1]-controlOffset, center[0]+rad, center[1]);
		item.curveTo(center[0]+rad, center[1]+controlOffset, center[0]+Math.cos(45*Math.PI/180)*rad, center[1]+Math.sin(45*Math.PI/180)*rad);
		item.curveTo(center[0]+controlOffset, center[1]+rad, center[0], center[1]+rad);
		item.curveTo(center[0]-controlOffset, center[1]+rad, center[0]-Math.cos(45*Math.PI/180)*rad, center[1]+Math.sin(45*Math.PI/180)*rad);
		item.curveTo(center[0]-rad, center[1]+controlOffset, center[0]-rad, center[1]);
		item.curveTo(center[0]-rad, center[1]-controlOffset, center[0]-Math.cos(45*Math.PI/180)*rad, center[1]-Math.sin(45*Math.PI/180)*rad);
		item.curveTo(center[0]-controlOffset, center[1]-rad, center[0], center[1]-rad);
		item.endFill();
	}


	//dispatch event with specified name	private function dispatch(sEventName:String):Void {		//trace("manager dispatching event : "+sEventName);		dispatchEvent({type:sEventName, target:this});	}
}