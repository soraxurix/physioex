
//***************************************************************************************
// overlay IMAGE code
//***************************************************************************************
import classes.au.com.cadre.cloe.*;
import mx.utils.Delegate;

class classes.au.com.cadre.cloe.Image{

	private var myURL:String;
	private var myX:Number;
	private var myY:Number;
	private var myScale:Number 	= 100;
	private var myRotation:Number 	= 0;
	public var myParent:Object;
	public var imageMC:MovieClip;
	public var myType:String = "image";

	//declare event handlers
	private var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;

	function Image(parent:Object){
		//initialise event dispatcher
		mx.events.EventDispatcher.initialize(this);
		//
		myParent = parent;
		var nd:Number = myParent.setMC.getNextHighestDepth();
		//create Image MC
		imageMC = myParent.setMC.createEmptyMovieClip("Image_"+nd, nd);
		imageMC.createEmptyMovieClip("holder", 1);
		var pc:Object 	= myParent.myParent.getCloeWindowCenter();
		imageMC._x 	= pc.x - 20;
		imageMC._y 	= pc.y;
		myURL 			= "default";
		myX 			= imageMC._x;
		myY 			= imageMC._y;
		//
		drawSquare ([0,0], [50,50], "333333")
		if (myParent.myParent.authoring) makeInteractive();
	}

	private function makeInteractive():Void{
		//allow for click and move image in authoring only
		imageMC.myRef 	= this;
		imageMC.onPress = function(){
			this.sx = this._x;
			this.sy  = this._y;
			this.sxm = this._parent._xmouse;
			this.sym  = this._parent._ymouse;
			this.onEnterFrame = function(){
				this.myRef.setImageLoc((this.sx + (this._parent._xmouse-this.sxm)), (this.sy + (this._parent._ymouse-this.sym)));
			}
		}
		imageMC.onRelease = function(){
			delete this.onEnterFrame;
			this.myRef.dispatch("onReleased");
		}
		imageMC.onReleaseOutside = function(){
			delete this.onEnterFrame;
		}
	}

	private function drawSquare (p1:Array, p2:Array, c:String):Void{
		var cnt:MovieClip = imageMC.holder.createEmptyMovieClip("square", imageMC.holder.getNextHighestDepth());
		//cnt.lineStyle(1, parseInt("0x"+c), 100);
		cnt.beginFill(parseInt("0x"+c), 100);
		cnt.moveTo(p1[0], p1[1]);
		cnt.lineTo(p2[0], p1[1]);
		cnt.lineTo(p2[0], p2[1]);
		cnt.lineTo(p1[0], p2[1]);
		cnt.lineTo(p1[0], p1[1]);
		cnt.endFill();
	}

	function setImage(url:String, x:Number, y:Number, scale:Number, rotation:Number):Void{
		//set all the values
		myURL 	= url;
		myX 		= x;
		myY 		= y;
		myScale 	= scale;
		myRotation = rotation;
		//clear default square
		imageMC.holder.clear();
		//set image holder MCs
		imageMC._x 	= myX;
		imageMC._y 	= myY;
		imageMC._xscale 	= imageMC._yscale = myScale;
		imageMC._rotation = myRotation;
		//
		imageMC.holder.loadMovie(myURL);
	}

	public function setImageLoc(x:Number,y:Number):Void{
		var moved:Boolean = false;
		if (myX!=x || myY!=y) moved = true;
		myX = imageMC._x = x;
		myY = imageMC._y = y;
		if (moved) dispatch("onImageMoved");
	}

	public function getMyData ():Object{
		return {url:myURL, x:myX, y:myY, scale:myScale, rotation:myRotation};
	}
	public function setMyData (obj:Object):Void{
		setImage(obj.url, obj.x, obj.y, obj.scale, obj.rotation);
	}

	public function deleteMe():Void{
		var pntr:Object = myParent.setObjects.images;
		var i:Number;
		var il:Number = pntr.length;
		for (i=0;i<il;i++) if (pntr[i]==this) pntr.splice(i,1);
		imageMC.removeMovieClip();
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
