/*
 * Cadre Label Overlay Engine class
 */
import classes.au.com.cadre.cloe.*;
import mx.utils.Delegate;


 class classes.au.com.cadre.cloe.CloeViewer extends MovieClip {

	  // Identify the symbol name that this class is bound to.
	  static var symbolName:String = "classes.au.com.cadre.cloe.CloeViewer";

	  // Identify the fully qualified package name of the symbol owner.
	  static var symbolOwner:Object = Object(classes.au.com.cadre.cloe.CloeViewer);

	  // Provide the className variable.
	  var className:String = "CloeViewer";

	public var cloeMC:MovieClip;
	public var overlayMC:MovieClip;
	public var cloeWidth:Number;
	public var cloeHeight:Number;
	private var cloeArray:Object;
	public var cloeObjects:Object;
	private var cloeXMLobject:CloeXML;
	private var myAuthoring:Boolean = false;
	private var myActiveSet:Object;
	 private var cloeFile:String;
	  private var defaultSet:Number;

	 //declare event handlers
	private var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;

	// Define an  constructor.
	function CloeViewer() {
		//initialise event dispatcher
		mx.events.EventDispatcher.initialize(this);
		 //
		 cloeObjects = [ ];
		 //

		cloeMC = this;

		 //create overlay MC
		cloeMC.createEmptyMovieClip("overlay", cloeMC.getNextHighestDepth());
		//create the mask MC
		cloeMC.createEmptyMovieClip("window_mask", cloeMC.getNextHighestDepth());
		//
		//
		overlayMC = cloeMC.overlay;

		//register how big the user has dragged the cloe viewer window on stage
		cloeWidth = cloeMC._width;
		cloeHeight = cloeMC._height;
		cloeMC._xscale = cloeMC._yscale = 100;
		drawBorder ();
		drawMask ();
		if (this.cloeFile.length>0) loadOverlay(this.cloeFile);
	 }


	private function resetMe():Void{
		//
		 cloeObjects = [ ];
		 //
		cloeMC.overlay.removeMovieClip();
		cloeMC.window_mask.removeMovieClip();
		//create overlay MC
		cloeMC.createEmptyMovieClip("overlay", cloeMC.getNextHighestDepth());
		//create the mask MC
		cloeMC.createEmptyMovieClip("window_mask", cloeMC.getNextHighestDepth());
		//
		//
		overlayMC = cloeMC.overlay;

		drawBorder ();
		drawMask ();

	}

	 public function loadOverlay(file:String, n:Number):Void{
		 //first reset all variables
		resetMe();
		 //
		 if (n!=undefined) defaultSet = n;
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
		 //
		 cloeMC.createEmptyMovieClip("window_border", cloeMC.getNextHighestDepth());
		 //make draw border code
		cloeMC.window_border.clear();
		cloeMC.window_border.lineStyle(1, 0x000000, 100);
		cloeMC.window_border.moveTo(0, 0);
		cloeMC.window_border.lineTo(cloeWidth, 0);
		cloeMC.window_border.lineTo(cloeWidth, cloeHeight);
		cloeMC.window_border.lineTo(0, cloeHeight);
		cloeMC.window_border.lineTo(0, 0);
	 }
	private function drawMask ():Void{
		//register mask
		cloeMC.overlay.setMask(cloeMC.window_mask);
		 //make draw mask code
		cloeMC.window_mask.clear();
		cloeMC.window_mask.lineStyle(1, 0x000000, 100);
		cloeMC.window_mask.beginFill(0xFFFFFF, 100);
		cloeMC.window_mask.moveTo(0, 0);
		cloeMC.window_mask.lineTo(cloeWidth, 0);
		cloeMC.window_mask.lineTo(cloeWidth, cloeHeight);
		cloeMC.window_mask.lineTo(0, cloeHeight);
		cloeMC.window_mask.lineTo(0, 0);
		cloeMC.window_mask.endFill();
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
			cloeObjects.main_image[nl-1].addEventListener("onLoaded", Delegate.create(this, mainImageLoaded));
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
		if (defaultSet!=undefined) showSet(defaultSet);
	}
	//***************************************************************************************
	// #########################################################
	//***************************************************************************************

	//
	//Main image loaded
	//
	private function mainImageLoaded():Void{
		dispatch("main_imageLoaded");
	}



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