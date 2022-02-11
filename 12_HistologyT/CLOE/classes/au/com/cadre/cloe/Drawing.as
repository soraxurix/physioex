///

class classes.au.com.cadre.cloe.Drawing{
	//
	
	//
	function Drawing(){
		//empty
	}
	

	
	//draw a dashed line
	 private function dashTo(mcTarget:MovieClip, x0:Number, y0:Number, x1:Number, y1:Number, lengthOn:Number, lengthOff:Number) {
		 // =============
		 // mc.dashTo() - by Ric Ewing (ric@formequalsfunction.com) - version 1.2 - 5.3.2002
		 // 
		 // x0, y0 = beginning of dashed line
		 // x1, y1 = end of dashed line
		 // lengthOn = length of dash
		 // lengthOff = length of gap between dashes
		 // ==============
		 //
		 // if too few arguments, bail
		 if (arguments.length<5) {
		     return false;
		 }
		 // init vars
		 var segmentLength, segmentCount, dx, dy, ds, cx, cy, radians:Number;
		 // calculate the legnth of a segment
		 segmentLength = lengthOn+lengthOff;
		 // calculate the length of the dashed line
		 dx = x1-x0;
		 dy = y1-y0;
		 ds = Math.sqrt((dx*dx)+(dy*dy));
		 // calculate the number of segments needed
		 segmentCount = Math.floor(Math.abs(ds/segmentLength));
		 // get the angle of the line in radians
		 radians = Math.atan2(dy, dx);
		 // start the line here
		 cx = x0;
		 cy = y0;
		 // add these to cx, cy to get next seg start
		 dx = Math.cos(radians)*segmentLength;
		 dy = Math.sin(radians)*segmentLength;
		 // loop through each seg
		 for (var n = 0; n<segmentCount; n++) {
		     mcTarget.moveTo(cx, cy);
		     mcTarget.lineTo(cx+Math.cos(radians)*lengthOn, cy+Math.sin(radians)*lengthOn);
		     cx += dx;
		     cy += dy;
		 }
		 // handle last segment as it is likely to be partial
		 mcTarget.moveTo(cx, cy);
		 ds = Math.sqrt((x1-cx)*(x1-cx)+(y1-cy)*(y1-cy));
		 if (ds>lengthOn) {
		     // segment ends in the lengthOff, so draw a full dash
		     mcTarget.lineTo(cx+Math.cos(radians)*lengthOn, cy+Math.sin(radians)*lengthOn);
		 } else if (ds>0) {
		     // segment is shorter than dash so only draw what is needed
		     mcTarget.lineTo(cx+Math.cos(radians)*ds, cy+Math.sin(radians)*ds);
		 }
		 // move the pen to the end position
		 mcTarget.moveTo(x1, y1);
	     }



	
}