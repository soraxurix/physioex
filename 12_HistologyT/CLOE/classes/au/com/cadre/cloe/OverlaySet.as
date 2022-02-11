//***************************************************************************************
	// overlay SET code
	//***************************************************************************************
import classes.au.com.cadre.cloe.*;
import mx.utils.Delegate;

class classes.au.com.cadre.cloe.OverlaySet{

	public var setObjects:Object;
	public var setPoints:Array;
	public var setMC:MovieClip;
	private var keepOn:Boolean;
	public var myParent:Object;
	private var myActiveItem:Object;

	//declare event handlers
	private var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;


	function OverlaySet(parent:Object, cloeArrayPos:Object){
		//
		keepOn= false;
		setObjects = [ ];
		setPoints = [ ];
		//
		myParent = parent;
		//initialise event dispatcher
		mx.events.EventDispatcher.initialize(this);
		//
		var ns:Object = cloeArrayPos;
		setMC = createSetLayer();
		setMC._visible = false;
		//build labels
		var label:Array = ns.value.label;
		var x:Number, xl:Number=label.length;
		for (x=0;x<xl;x++){
			var atts:Object = label[x].attributes;
			if (!setObjects.label) setObjects.label = [ ];
			var nlab:Number = setObjects.label.push(new Label(this));
			setObjects.label[nlab-1].setLabel(label[x].value, Number(atts.x), Number(atts.y), atts.color, Number(atts.size), atts.bgcolor, Number(atts.bgalpha));
			setObjects.label[nlab-1].addEventListener("onReleased", Delegate.create(this, onItemActivated));
		}
		//build images
		var image:Array = ns.value.image;
		xl = image.length;
		for (x=0;x<xl;x++){
			var atts:Object = image[x].attributes;
			if (!setObjects.image) setObjects.image = [ ];
			var nImg:Number = setObjects.image.push(new Image(this));
			setObjects.image[nImg-1].setImage(atts.url, Number(atts.x), Number(atts.y), Number(atts.scale), Number(atts.rotation));
			setObjects.image[nImg-1].addEventListener("onReleased", Delegate.create(this, onItemActivated));
		}
		//build lines
		var line:Array = ns.value.line;
		xl = line.length;
		for (x=0;x<xl;x++){
			var atts:Object = line[x].attributes;
			if (!setObjects.line) setObjects.line = [ ];
			var nLine:Number = setObjects.line.push(new Line(this));
			setObjects.line[nLine-1].setLine(Number(atts.x1), Number(atts.y1), Number(atts.x2), Number(atts.y2), Number(atts.thickness), atts.color, atts.style);
			setObjects.line[nLine-1].addEventListener("onReleased", Delegate.create(this, onItemActivated));
		}
		//build circles
		var circ:Array = ns.value.circle;
		xl = circ.length;
		for (x=0;x<xl;x++){
			var atts:Object = circ[x].attributes;
			if (!setObjects.circle) setObjects.circle = [ ];
			var nCircle:Number = setObjects.circle.push(new Circle(this));
			setObjects.circle[nCircle-1].setMe(Number(atts.x), Number(atts.y), Number(atts.thickness), atts.color, Number(atts.radius), atts.style);
			setObjects.circle[nCircle-1].addEventListener("onReleased", Delegate.create(this, onItemActivated));
		}
		//draw brackets
		var bracket:Array = ns.value.bracket;
		xl=bracket.length;
		for (x=0;x<xl;x++){
			var atts:Object = bracket[x].attributes;
			if (!setObjects.bracket) setObjects.bracket = [ ];
			var nBracket:Number = setObjects.bracket.push(new Bracket(this));
			//x:Number, y:Number, tk:Number, c:String, w:Number, r:Number, s:Number, lh:Number, lo:Number
			setObjects.bracket[nBracket-1].setBracket(Number(atts.x), Number(atts.y), Number(atts.thickness), atts.color, Number(atts.width), Number(atts.rotation), Number(atts.skew), Number(atts.height), Number(atts.offset), Number(atts.legs), atts.style);
			setObjects.bracket[nBracket-1].addEventListener("onReleased", Delegate.create(this, onItemActivated));
		}
	}

	//adding new item
	public function addNewItem(item:String):Void{
		if (!setObjects[item]) setObjects[item] = [ ];
		if (item=="label") var nm:Number = setObjects[item].push(new Label(this));
		if (item=="image") var nm:Number = setObjects[item].push(new Image(this));
		if (item=="line") var nm:Number = setObjects[item].push(new Line(this));
		if (item=="circle") var nm:Number = setObjects[item].push(new Circle(this));
		if (item=="bracket") var nm:Number = setObjects[item].push(new Bracket(this));
		//
		setObjects[item][nm-1].addEventListener("onReleased", Delegate.create(this, onItemActivated));
	}

	//functions accessed by interface to check what item was activated
	private function onItemActivated(obj:Object):Void{
		myActiveItem = obj.target;
		dispatch("onActivateItem");
	}
	public function getActiveItemID():Object{
		return myActiveItem;
	}
	public function getActiveItemType():String{
		return myActiveItem.myType;
	}

	private function createSetLayer ():MovieClip{
		//
		var nextdepth = myParent.overlayMC.getNextHighestDepth();
		return myParent.overlayMC.createEmptyMovieClip("set_"+nextdepth, nextdepth);
	}


	//dispatch event with specified name
	private function dispatch(sEventName:String):Void {
		//trace("manager dispatching event : "+sEventName);
		dispatchEvent({type:sEventName, target:this});
	}

	//***************************************************************************************
	// ##########################################################
	//***************************************************************************************

}