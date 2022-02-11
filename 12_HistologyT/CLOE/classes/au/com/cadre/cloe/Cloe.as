/*
 * Cadre Label Overlay Engine class
 */
import classes.au.com.cadre.cloe.*;
import mx.utils.Delegate;

 class classes.au.com.cadre.cloe.Cloe  {

	public var cloeMC:MovieClip;
	public var overlayMC:MovieClip;
	public var cloeWidth:Number;
	public var cloeHeight:Number;
	private var cloeArray:Object;
	public var cloeObjects:Object;
	private var cloeXMLobject:CloeXML;
	private var myAuthoring:Boolean = false;
	private var myActiveSet:Object;

	 //declare event handlers
	private var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;

	public function Cloe(target:MovieClip, w:Number, h:Number){
		//initialise event dispatcher
		mx.events.EventDispatcher.initialize(this);
		 //
		 cloeObjects = [ ];
		 //
		 //create overlay MC if not already existing
		 if (!target.overlay) target.createEmptyMovieClip("overlay", target.getNextHighestDepth());

		cloeWidth = w;
		cloeHeight = h;
		cloeMC = target;
		overlayMC = cloeMC.overlay;
		drawBorder ();
		drawMask ();

	 }




	 public function loadXML (file:String):Void{
		cloeArray = [ ];
		//register XML class
		cloeXMLobject = new CloeXML();
		cloeXMLobject.loadCXO(file);
		cloeXMLobject.addEventListener("xmlLoaded", Delegate.create(this, xmlLoaded));
	 }

	 public function xmlLoaded():Void{
		cloeArray = cloeXMLobject.getArray();
		fillOverlay();
	 }



	 private function drawBorder ():Void{
		 //make draw border code instead of resize existing!?
		cloeMC.window_border._width = cloeWidth;
		cloeMC.window_border._height = cloeHeight;
	 }
	private function drawMask ():Void{
		 //make draw mask code instead of resize existing!?
		cloeMC.window_mask._width = cloeWidth;
		cloeMC.window_mask._height = cloeHeight;
	 }

	 //set & get if the Cloe is in authoring mode
	 //to allow for special interaction
	public function set authoring(b:Boolean):Void{
		myAuthoring = b;
	}
	public function get authoring():Boolean{
		return myAuthoring;
	}

	//called to get & set data for MainImage & MainTitle
	public function getItemData(item:String, n:Number):Object{
		return cloeObjects[item][n].getMyData();
	}
	public function setItemData(item:String, n:Number, obj:Object):Void{
		cloeObjects[item][n].setMyData(obj);
	}

	//called to get & set data for items in the overlay sets
	public function getSetItemData(set:Number, item:String, n:Number):Object{
		return cloeObjects.sets[set].setObjects[item][n].getMyData();
	}
	public function setSetItemData(set:Number, item:String, n:Number, obj:Object):Void{
		cloeObjects.sets[set].setObjects[item][n].setMyData(obj);
	}


	//get the object pointer to a set number
	public function getSetID(n:Number):Object{
		return cloeObjects.sets[n];
	}

	 public function makeDefaultSet():Void{
		 cloeObjects = [ ];
		cloeArray = [ ];
		cloeArray.main_label = [ ];
		cloeArray.main_label[0] = {attributes:{color:"000000", align:"center", valign:"top", size:"12", bgcolor:"FFFFFF", bgalpha:"0"}, value:""};
		cloeArray.main_image = [ ];
		cloeArray.main_image[0] = {attributes:{url:"", scale:"100"}, value:[ ]};
		cloeArray.set = [ ];
		cloeArray.set[0] = {attributes:[ ], value:[ ]};
		fillOverlay();
	 }

	//
	//build overlay called from the XML class onLoad success
	private function fillOverlay ():Void{
		overlayMC = cloeMC.overlay;
		//set header text
		var hdr:Object = cloeArray.main_label;
		var i:Number;
		var il:Number = hdr.length;
		for (i=0;i<il;i++){
			//create the header MC
			var hdra:Object = hdr[i];
			if (!cloeObjects.main_label) cloeObjects.main_label = [ ];
			var nl:Number = cloeObjects.main_label.push(new MainTitle(this, hdra));
		}
		//load bg image or SWF file
		var img:Object = cloeArray.main_image;
		il = img.length;
		for (i=0;i<il;i++){
			//create the image MC
			var imga:Object = img[i];
			if (!cloeObjects.main_image) cloeObjects.main_image = [ ];
			var nl:Number = cloeObjects.main_image.push(new MainImage(this, imga));
		}

		//build sets
		var sets:Object = cloeArray.set;
		il= sets.length;
		for (i=0;i<il;i++){
			//create the image MC
			var setsa:Object = sets[i];
			if (!cloeObjects.sets) cloeObjects.sets = [ ];
			var nl:Number = cloeObjects.sets.push(new OverlaySet(this, setsa));
		}
		dispatch("onLoaded");
	}
	//***************************************************************************************
	// #########################################################
	//***************************************************************************************

	 //***************************************************************************************
	// Adding items to active set
	//***************************************************************************************
	//
	public function get activeSet(){
		return myActiveSet;
	}
	public function set activeSet(n:Number):Void{
		myActiveSet = cloeObjects.sets[n];
	};
	//***************************************************************************************
	// #########################################################
	//***************************************************************************************



	 //***************************************************************************************
	// manage overlay sets code
	//***************************************************************************************
	//
	public function addSet ():Object{
		if (!cloeObjects.sets) cloeObjects.sets = [ ];
		return cloeObjects.sets.push(new OverlaySet(this, {value:[ ], attributes:[ ]}));
	}

	public function getSetLength():Number{
		return cloeObjects.sets.length;
	}
	public function getKeepSetOn(id:Number):Boolean{
		return cloeObjects.sets[id].keepon;
	}
	public function setKeepSetOn(id:Number, bool:Boolean):Void{
		cloeObjects.sets[id].keepon = bool;
	}



	public function showSet(n:Number):Void{
		cloeObjects.sets[n].setMC._visible = 1;
	};

	public function hideSet(n){
		cloeObjects.sets[n].setMC._visible = 0;
	};
	public function showAllSets(){
		var i:Number = cloeObjects.sets.length;
		while(--i-(-1)) cloeObjects.sets[i].setMC._visible = 1;
	};
	public function hideAllSets(){
		var i:Number = cloeObjects.sets.length;
		while(--i-(-1)) if (!getKeepSetOn(i)) cloeObjects.sets[i].setMC._visible = 0;
	};
	//***************************************************************************************
	// #########################################################
	//***************************************************************************************


	 //***************************************************************************************
	// overlay UTILITY code
	//***************************************************************************************

	 //finding the center of the current Cloe viewable area
	public function getCloeWindowCenter():Object{
		var x1 = (cloeWidth/2) - cloeMC.overlay._x;
		var y1 = (cloeHeight/2) - cloeMC.overlay._y;
		return {x:x1, y:y1};
	}
	//***************************************************************************************
	// ##########################################################
	//***************************************************************************************





	//***************************************************************************************
	// overlay SET TEXT BG code
	//***************************************************************************************

	public function setTextBG(bgc:String, bga:Number, tmc:MovieClip):Void{
		//enlarge var
		var el:Number = 2;
		//
		if (!tmc.bg) {
			var hbg:MovieClip = tmc.createEmptyMovieClip("bg", 1);
		}else{
			var hbg:MovieClip = tmc.bg;
			hbg.clear();
		}
		var w:Number = tmc._width;
		var h:Number = tmc._height;
		with (hbg){
			beginFill(parseInt("0x"+bgc), bga);
			//lineStyle(1, 0x000000, 0);
			moveTo(-el,0);
			lineTo(w+el, 0);
			lineTo(w+el, h);
			lineTo(-el, h);
			lineTo(-el, 0);
		}
	}
	//***************************************************************************************
	// ######################################################################################
	//***************************************************************************************

	//dispatch event with specified name
	private function dispatch(sEventName:String):Void {
		//trace("manager dispatching event : "+sEventName);
		dispatchEvent({type:sEventName, target:this});
	}
 }