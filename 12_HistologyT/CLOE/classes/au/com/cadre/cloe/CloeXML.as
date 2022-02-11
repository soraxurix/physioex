//
import mx.utils.Delegate;


class classes.au.com.cadre.cloe.CloeXML{

	private var xO:XML;
	private var loadCheck:Number;
	private var cloeArray:Object;

	//declare event handlers	private var dispatchEvent:Function;	public var addEventListener:Function;	public var removeEventListener:Function;

	//
	function CloeXML (){
		//initialise event dispatcher		mx.events.EventDispatcher.initialize(this);
		//
		xO = new XML();
		xO.ignoreWhite = true;

	}

	public function loadCXO(file:String):Void{
		var owner:CloeXML = this;
		xO.onLoad = function (success:Boolean):Void{
			owner.startParsing();
		}
		xO.load(file);
	}

	private function startParsing():Void{
		cloeArray = recurseXML(xO.firstChild);
		dispatch("xmlLoaded");
	}

	public function getArray():Object{
		return cloeArray;
	}

	//***************************************************
	//* parsing according to CADRE ProSym style 01 *
	//***************************************************
	private function recurseXML(passedNode:XMLNode):Object {
		var node:XMLNode = passedNode.firstChild;
		var tarray:Object = [ ];
		while (node) {
			var nn:String = node.nodeName;
			//trace("nn: "+nn);
			if (nn != null) {
				if (!tarray[nn]) tarray[nn] = [ ];
				var apos:Number = tarray[nn].push([ ])-1;
				tarray[nn][apos] = [];
				tarray[nn][apos]["attributes"] = [ ];
				for (var x:String in node.attributes) {
					tarray[nn][apos]["attributes"][x] = node.attributes[x];
				}
				// add children if any
				if (node.firstChild.nodeValue.length>0 && node.firstChild.nodeValue!=undefined){
					tarray[nn][apos].value = (node.firstChild.nodeValue)? node.firstChild.nodeValue: "";
				}else{
					if (node.childNodes.length>0){
						tarray[nn][apos].value = recurseXML(node);
					}
				}
			}
			node = node.nextSibling;
		}
		return tarray;
	}

	//dispatch event with specified name	private function dispatch(sEventName:String):Void {		//trace("manager dispatching event : "+sEventName);		dispatchEvent({type:sEventName, target:this});	}

}


