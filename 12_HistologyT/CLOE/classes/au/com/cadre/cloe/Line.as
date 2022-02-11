//AW - histology class
// Robert Bleeker

	//***************************************************************************************
	// overlay LINE code
	//***************************************************************************************
import classes.au.com.cadre.cloe.*;
import mx.utils.Delegate;

class classes.au.com.cadre.cloe.Line extends classes.au.com.cadre.cloe.Drawing{


	private var point1:Point;
	private var point2:Point;
	private var myThickness:Number 	= 2;
	private var myColor:String 	= "000000";
	private var myStyle:String		= "solid";
	public var myParent:Object;
	public var lineMC:MovieClip;
	public var myType:String = "line";

	//declare event handlers
	private var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;

	function Line(parent:Object){
		//initialise event dispatcher
		mx.events.EventDispatcher.initialize(this);
		//
		myParent = parent;
		var nd:Number = myParent.setMC.getNextHighestDepth();
		lineMC = myParent.setMC.createEmptyMovieClip("Line_"+nd, nd);
		// create line body for drawing in
		lineMC.createEmptyMovieClip("bodybg", lineMC.getNextHighestDepth());
		lineMC.createEmptyMovieClip("body", lineMC.getNextHighestDepth());
		var pc:Object = myParent.myParent.getCloeWindowCenter();
		point1 = new Point(pc.x, pc.y, this, myParent.setMC, false);
		point2 = new Point(pc.x+50, pc.y+50, this, myParent.setMC, (myParent.myParent.authoring)? true: false);
		//register points with the current OverlaySet
		myParent.setPoints.push(point1);
		myParent.setPoints.push(point2);
		//listener for the point movements
		point1.addEventListener("onChanged", Delegate.create(this, drawLine));
		point2.addEventListener("onChanged", Delegate.create(this, drawLine));
		drawLine();
		if (myParent.myParent.authoring) makeInteractive();
	}

	public function setLine (x1:Number, y1:Number, x2:Number, y2:Number, tk:Number, cl:String, st:String):Void{
		point1.x = x1;
		point1.y = y1;
		point2.x = x2;
		point2.y = y2;
		myThickness = tk;
		myColor = cl;
		myStyle 		= st;
		drawLine();
	}

	private function updatePoints(x:Number, y:Number):Void{
		point1.movePoint(x, y);
		point2.movePoint(x, y);
	}


	public function getMyData():Object{
		return {x1:point1.x, y1:point1.y, x2:point2.x, y2:point2.y, thickness:myThickness, color:myColor, style:myStyle};
	}

	public function setMyData(obj:Object):Void{
		setLine (obj.x1, obj.y1, obj.x2, obj.y2, obj.thickness, obj.color, obj.style);
	}

	public function deleteMe(){
		var pntr:Object = myParent.setObjects.lines;
		var i:Number;
		var il:Number = pntr.length;
		for (i=0;i<il;i++) if (pntr[i]==this) pntr.splice(i,1);
		point1.deletePoint();
		point2.deletePoint();
		lineMC.removeMovieClip();
		delete this;
	}

	private function drawLine(){
		//draw the line
		lineMC._x = point1.x;
		lineMC._y = point1.y;
		var x2:Number = (point2.x - point1.x);
		var y2:Number = (point2.y-point1.y);
		lineMC.body.clear();
		lineMC.bodybg.clear();
		lineMC.body.lineStyle(myThickness, parseInt("0x"+myColor), 100);
		lineMC.bodybg.lineStyle(myThickness+2, 0xFFFFFF, 100);
		lineMC.body.moveTo(0, 0);
		lineMC.bodybg.moveTo(0, 0);
		if (myStyle=="dashed"){
			dashTo(lineMC.body, 0, 0, x2, y2, 8, 8);
			dashTo(lineMC.bodybg, 0, 0, x2, y2, 8, 8);
		}else if (myStyle=="dotted"){
			dashTo(lineMC.body, 0, 0, x2, y2, 2, 6);
			dashTo(lineMC.bodybg, 0, 0, x2, y2, 2, 6);
		}else{
			lineMC.body.lineTo(x2, y2);
			lineMC.bodybg.lineTo(x2, y2);
		}
		dispatch("onLineDrawn");
	}

	public function makeInteractive():Void{
		lineMC.myRef = this;
		lineMC.onPress = function(){
			this.sx = this._x;
			this.sy  = this._y;
			this.lx = this._x;
			this.ly = this._y;
			this.sxm = this._parent._xmouse;
			this.sym  = this._parent._ymouse;
			this.onEnterFrame = function(){
				this._x = this.sx + (this._parent._xmouse-this.sxm);
				this._y = this.sy + (this._parent._ymouse-this.sym);
				this.myRef.updatePoints(this._x-this.lx, this._y-this.ly);
				this.lx = this._x;
				this.ly = this._y;
			}
		}
		lineMC.onRelease = function(){
			delete this.onEnterFrame;
			this.myRef.dispatch("onReleased");
		}
		lineMC.onReleaseOutside = function(){
			delete this.onEnterFrame;
			this._alpha = 0;
		}
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