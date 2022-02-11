	//***************************************************************************************
	// overlay MAIN IMAGE code
	//***************************************************************************************
import mx.utils.Delegate;
import classes.au.com.cadre.cloe.*;

class classes.au.com.cadre.cloe.MainImage{

	private var imgURL:String 	= "default";
	private var imgScale:Number	= 100;
	private var imgholder:MovieClip;
	private var myParent:Object;

	//declare event handlers	private var dispatchEvent:Function;	public var addEventListener:Function;	public var removeEventListener:Function;

	function MainImage (parent:Object, cloeArrayPos:Object){
		myParent = parent;
		//initialise event dispatcher		mx.events.EventDispatcher.initialize(this);
		//
		//create image holder if not already existing
		if (!myParent.overlayMC.image_holder) myParent.overlayMC.createEmptyMovieClip("image_holder", myParent.overlayMC.getNextHighestDepth());
		//store the image holder MC
		imgholder = myParent.overlayMC.image_holder;
		//store image array position
		imgURL 		= cloeArrayPos.attributes.url;
		imgScale 	= Number(cloeArrayPos.attributes.scale);
		setMainImage(imgURL, imgScale);
	}

	//load main image function
	public function 	setMainImage(newUrl:String, newScale:Number):Boolean{
		//set the variable in array in case they have changed
		imgURL	= newUrl;
		imgScale 	= (!newScale)? 100: newScale;
		imgholder._xscale = imgholder._yscale = imgScale;
		//listen for loaded
		listenForLoad();
		//
		return true;
	}
	public function getMyData():Object{
		return {url:imgURL, scale:imgScale};
	}
	public function setMyData(obj:Object):Void{
		setMainImage( obj.url, obj.scale);
	}

	private function listenForLoad():Void{
		//register current object
		var owner:MainImage = this;
		//use mcloader class before we make interactive
		var mclListener:Object = new Object();
		mclListener.onLoadInit = function(target_mc:MovieClip) {
			// if image bigger than the cloe window make draggable
			if (owner.imgholder._width>owner.myParent.cloeWidth || owner.imgholder._height>owner.myParent.cloeHeight) owner.makeInteractive();
			owner.dispatch("onLoaded");
		};
		var image_mcl:MovieClipLoader = new MovieClipLoader();
		image_mcl.addListener(mclListener);
		image_mcl.loadClip(imgURL, imgholder);

	}

	//make interactive for dragging image
	private function makeInteractive():Void{
		//set overlay draggable
		imgholder.maxX = myParent.cloeWidth - imgholder._width;
		imgholder.maxY = myParent.cloeHeight - imgholder._height;
		imgholder.onRollOver = function(){ this.useHandCursor=0;}
		imgholder.onPress = function(){
			var tp = this._parent;
			this.sx = tp._x;
			this.sy  = tp._y;
			this.sxm = tp._parent._xmouse;
			this.sym  = tp._parent._ymouse;
			this.onEnterFrame = function(){
				tp._x = Math.min(0, Math.max(this.maxX, this.sx + (tp._parent._xmouse-this.sxm)));
				tp._y = Math.min(0, Math.max(this.maxY, this.sy + (tp._parent._ymouse-this.sym)));
			}
		}
		imgholder.onRelease = function(){
			delete this.onEnterFrame;
		}
		imgholder.onReleaseOutside = function(){
			delete this.onEnterFrame;
		}
	}

	//dispatch event with specified name	private function dispatch(sEventName:String):Void {		//trace("manager dispatching event : "+sEventName);		dispatchEvent({type:sEventName, target:this});	}

	//***************************************************************************************
	// ######################################################################################
	//***************************************************************************************

}