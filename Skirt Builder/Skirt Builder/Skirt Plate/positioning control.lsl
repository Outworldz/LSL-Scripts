// :SHOW:
// :CATEGORY:Building
// :NAME:Skirt Builder
// :AUTHOR:Dalien
// :KEYWORDS:
// :CREATED:2016-05-02 13:03:26
// :EDITED:2016-05-02  12:03:26
// :ID:1104
// :NUM:1892
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// A nice skirt maker
// :CODE:
//
// Copyright (c) 2007 Dalien Talbot and few other folks thanks to whom this exists:
//
// Vint Falken, of course - the inspiration, pushing me to the idea, testing, and finding the software bugs :-)
// LSL wiki - the function reference
// Posing stand code - unknown author
// LoopRez v0.6, by Ged Larsen, 20 December 2006 - the math for placement of the skirt prims
//
// This work is distributed "as-is" with no warranty whatsoever.
//
//
// It is distributed under GPL license. Please have a look at the "EULA" and the "GNU License" notecards in the inventory
// to get familiar with the terms and conditions.
//
// All the derivatives of this work obviously have to comply with the GPL as well. Contact me (Dalien Talbot) if you require alternative licensing.
//
//

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// NOTE:
// Unless you know what you are doing, do NOT change anything below !
//
// The standard consulting fees mentioned in the manual will apply for the works on fixing the breakages :-)
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////






// CONFIGURATION PARAMETERS, they get reset from the main script!!!

integer myNumber = 0;                   // number of the prim
vector standPos;                        // position of the mothership
integer numObjects = 12;                // how many objects
float xRadius = .16;                    // ellipse x-axis radius in meters
float yRadius = .22;                        // ellipse y-axis radius in meters
float flareAngle = 45.0;                // how many DEGREES the bottom of object will flare outwards, the "poof" factor
float bendCoefficient = 0.0;            // makes a "saddle shape", bends DOWN this number of meters at extremes of X-axis
vector rotOffset = <0.0, 180.0, 0.0>;     // rotation offset in DEGREES -- fixes the rotation of ALL objects; for flexi prims, often you will want <180.0, 0.0, 0.0>
vector posOffset = <0.0, 0.0, 1.0>;        // position offset

string prompt = "Edit/move this prim\nto edit/move the skirt";

// linking permission acquired
integer miPermissionsAcquired = FALSE;
// current object being linked, when linked...
integer currObject = 0;

// idle counter - when it increments to 1000, we clean up the control prims.
integer idleCounter = 0;


////////////////////////////////////////////////////////////////////////////////
// No need to mess with anything below here


adjust_flare (vector currentPos, rotation currentRot, float flareAngle) {
	float rotateAngle = flareAngle; // how much to rotate per iteration (in degrees)
	rotation rot = currentRot;
	vector scale = llGetScale(); // return the size of the object
	vector offset = <0, 0, -scale.z/2>; // rotate the object around the center of its top
	vector offsetPosition = <0, 0, -scale.z/2>; // the position should be that of the top
	// the two values being the same is a bit coincidental..


	vector euler = <0, -1*rotateAngle*DEG_TO_RAD, 0>; // delta rotation expressed as a vector in radians
	rotation deltarot = llEuler2Rot(euler); // delta rotation expressed as a rotation
	rotation newrot = deltarot * rot; // new rotation for the object

	vector vvv =  offset * rot; // current offset of the rotation point vs. the prim center
	vector vvv2 = offset * newrot; // new offset of the rotation point vs. the prim center

	//vector currentPos = llGetPos(); // current position
	//vector rotPoint = llGetPos() + vvv; // current rotation point, not needed except for visualization

	vector newPos; // new position for the prim

	newPos = currentPos + (vvv - vvv2); // is a current position offsetted by a difference between the rotation point offsets

	//llRezObject("ball", rotPoint, ZERO_VECTOR, ZERO_ROTATION, 0); // visualize the rotation point

	// now we also need to adjust the position - so that the top is always at the same place..
	// the position that we have got is calculated for the center of the prim.
	newPos = newPos + offsetPosition;

	llSetPos(newPos); // set the new position
	llSetRot(newrot); // and the new rotation
}


makeLoop(integer n, vector standPos, integer numObjects, float xRadius, float yRadius,
	float flareAngle, float bendCoefficient, vector rotOffset, vector posOffset)
	{
		//integer n;                            // which object is being placed
		float theta;                        // angle in radians
		vector pos;                            // position
		rotation rot;                        // rotation in quaternion format

		//for(n = 0; n < numObjects; n++) {

		theta = TWO_PI * ( (float)n / (float)numObjects );

		pos.x = xRadius * llCos(theta);                            // ellipse: 2x xRadius meters wide
		pos.y = yRadius * llSin(theta);                            // ellipse: 2x yRadius meters wide
		pos.z = -bendCoefficient*llCos(theta)*llCos(theta);        // saddle shape, bending downwards on X-axis
		pos = pos + standPos + posOffset;

		rot = llEuler2Rot(<rotOffset.x*DEG_TO_RAD, rotOffset.y*DEG_TO_RAD, rotOffset.z*DEG_TO_RAD>);    // user-chosen rotation offset correction


		// the following make the objects face outwards properly for an ellipse; using theta alone is only correct for a circle
		// the scary formula calculates a unit vector TANGENTIAL to the ellipse, and llRotBetween is used to figure out how much the object needs to rotate to lie parallel to the tangent
		rot = rot * llRotBetween(<0.0,1.0,0.0>, <-1.0 * xRadius * llSin(theta) / ( llSqrt ( (yRadius*yRadius * llCos(theta) * llCos(theta)) + (xRadius*xRadius * llSin(theta) * llSin(theta))) ),yRadius * llCos(theta) / ( llSqrt ( (yRadius*yRadius * llCos(theta) * llCos(theta)) + (xRadius*xRadius * llSin(theta) * llSin(theta))) ),0.0>);
		if ( n== (numObjects/2) )        // LSL's implementation of llRotBetween at theta = pi radians is reversed at 180 degrees, so this manually corrects it
			rot = rot * llEuler2Rot( <0,PI,0> );


		//rot = rot * llEuler2Rot(<0, -1*flareAngle*DEG_TO_RAD, 0>);                                        // flare generation (poof)

		//llRezObject(objectName, pos, ZERO_VECTOR, rot, 0);
		//llSetPos(pos);
		//llSetRot(rot);

		// it will rotate the pieces and set their positions...
		adjust_flare(pos, rot, flareAngle);
		//}
	}

// are we a control prim (texture/shape/etc.) ?
integer isControlPrim = 0;
// a ball for skirt linkage
integer isLinkCenterPrim = 0;

// are we a geometry control prim (xradius/yradius/flare/z) ?
integer isGeomControlPrim = 0;
// how much the "real" waist size is different from the geometry control prim
float waistSizeDivizor = 5.0;


integer listenHandle = 0;
integer listenHandle2 = 0;
integer commChannelBase = 0;


position_geometry_prim()
{
	rotation rot = llEuler2Rot(<0.0, flareAngle * DEG_TO_RAD, 0.0 >);
	vector scale;
	scale.x = 0.01 + bendCoefficient;
	scale.y = yRadius * waistSizeDivizor;
	scale.z = xRadius * waistSizeDivizor;
	llSetRot(rot);
	llSetScale(scale);
}

new_position()
{
	// do the fancy math foobar only for the "normal" prims
	if ( (isControlPrim + isLinkCenterPrim + isGeomControlPrim) == 0) {
		makeLoop(myNumber, standPos, numObjects, xRadius, yRadius, flareAngle, bendCoefficient, rotOffset, posOffset);
	}
	if (isLinkCenterPrim) {
		// link center prim will need to be in the center (surprise surprize!)
		// since the Z is actually the top of the prims,
		// nothing much more to be done here
		// we position it here, since it needs to move with the "normal" prims.
		vector linkerPos = standPos + posOffset;
		llSetPos(linkerPos);
	}
}

position_master_prim()
{
	vector rotOffset =  <180,0,0>;
	rotation rot = llEuler2Rot(<rotOffset.x*DEG_TO_RAD, rotOffset.y*DEG_TO_RAD, rotOffset.z*DEG_TO_RAD>);
	// flare angle belongs to the flare control...
	//rot = rot * llEuler2Rot(<0, -1*flareAngle*DEG_TO_RAD, 0>);
	llSetRot(rot);

}



//------------------ prim mod slave


setParams(list alist)
{
	list res = [ ];
	integer i;
	integer len = llGetListLength(alist);
	//string aStart = elapsed("");
	//string aElapsed;
	string token;
	integer slen;
	
	integer int;
	// skip the first token - so start from 1
	for(i=1; i<len; i++) {
		token = llList2String(alist, i);
		slen = llStringLength(token);
		//llOwnerSay("i:" + (string)i + ", slen: " + (string)slen + ", '" + token + "'");

		if (slen == 36) {
			// for length of 36 we assume key
			res = res + [ token ];
		} else if (slen >= 30 && slen <= 33) {
				// assume vector
				res = res + (vector)token;
		} else {
				// assume integer or float
				int = (integer)token;
			if (token == (string) int) {
				res = res + [ int ];
			} else {
					res = res + [ (float) token ];
			}
		}

	}
	//aElapsed = elapsed(aStart);

	//llOwnerSay("result:" + llDumpList2String(res, ":"));
	//llOwnerSay("Time taken: " + aElapsed);
	llSetPrimitiveParams(res);
}




// ------------------------- prim mod master

list sideTextures = [ ];
list sideTexgen = [ ];
list sideColors = [ ];
list sideAlphas = [ ];


list tokens = [ ];

// saved position/rotation for the timer events
vector myLastPos;
vector myLastRot;


// the mask for the delayed update processing
// the values are similar to "mask" in the change event

integer mask = 0;


sendCommand(string cmd)
{
	//llOwnerSay(cmd);
	llSay(commChannelBase - 1, cmd);
}

resetSideCaches()
{
	sideTextures = [ ];
	sideTexgen = [ ];
	sideColors = [ ];
	sideAlphas = [ ];
}



checkTextures()
{
	integer i;
	integer num = llGetNumberOfSides();
	list result = llGetPrimitiveParams( [ PRIM_TEXGEN, ALL_SIDES, PRIM_TEXTURE, ALL_SIDES ] );
	list newTextures = [ ];

	for(i=0;i<num; i++) {
		list param = llList2List(result, num + i*4, num + i*4+3);
		list currparam = llList2List(sideTextures, i*4, i*4+3);
		integer currparam_len = llGetListLength(currparam);

		if (currparam_len == 0 || llListFindList(param, currparam) == -1) {
			tokens = tokens + [ PRIM_TEXTURE, i ] + param;
		}
		if (llList2Integer(result, i) != llList2Integer(sideTexgen, i)) {
			tokens = tokens + [ PRIM_TEXGEN, i, llList2Integer(result, i) ];
		}

	}
	sideTexgen = llList2List(result, 0, num - 1);
	sideTextures = llList2List(result, num, -1);
	//llOwnerSay("!checkTextures end");

}



checkColor()
{
	integer i;
	integer num = llGetNumberOfSides();
	list newColors;
	string cmd = "color";
	for(i=0;i<num; i++) {
		vector color = llGetColor(i);
		newColors = newColors + [ color ];

		if ((vector)llList2String(sideColors, i) != color) {
			cmd = cmd + ":" + (string)i + ":" + (string)color;
		}
	}
	sideColors = newColors;
	sendCommand(cmd);

}

checkAlpha()
{
	integer i;
	integer num = llGetNumberOfSides();
	list newAlphas;
	string cmd = "alpha";
	for(i=0;i<num; i++) {
		float alpha = llGetAlpha(i);
		newAlphas = newAlphas + [ alpha ];

		if ((float)llList2String(sideAlphas, i) != alpha) {
			cmd = cmd + ":" + (string)i + ":" + (string)alpha;
		}
	}
	sideAlphas = newAlphas;
	sendCommand(cmd);

}

checkShape()
{
	list result = llGetPrimitiveParams([ PRIM_FLEXIBLE, PRIM_TYPE ]);
	sendCommand("prim_params:" + llDumpList2String([ PRIM_TYPE ] + llList2List(result, 7, -1), ":"));


	//tokens = tokens + [ PRIM_TYPE ] + llList2List(result, 7, -1) + [ PRIM_FLEXIBLE ] + llList2List(result, 0, 6);
	tokens = tokens + [ PRIM_FLEXIBLE ] + llList2List(result, 0, 6);
}

checkScale()
{
	vector scale = llGetScale();
	vector scale0 = scale;
	scale0.z = scale0.z - 0.01;
	// workaround against the flex objects not rendering if z size not changed...
	sendCommand("prim_params:" + llDumpList2String([ PRIM_SIZE, scale0 ], ":"));

	tokens = tokens + [ PRIM_SIZE, scale ];
	return;
}



// this function gets called from the timer, and fires up the commands to the
// other prims to adjust themselves
// the reason for calling it from timer is to make the processing
// a little bit lighter... (LSL's string/list parsing is a pain in the butt and
// is a main reason for slowness...)
check_changed()
{
	if (isControlPrim) {
		// prim's characteristics replicate to others
		tokens = [ ];
		if(mask & CHANGED_SHAPE){
			// changing the prim type can change everything
			checkShape();
			mask = mask | CHANGED_COLOR | CHANGED_SCALE | CHANGED_TEXTURE;

		}
		if(mask & CHANGED_COLOR){
			checkColor();
			checkAlpha();
		}


		if(mask & CHANGED_TEXTURE){
			checkTextures();
		}
		if(mask & CHANGED_SCALE){
			checkScale();
		}
		if (llGetListLength(tokens) > 0) {
			sendCommand("prim_params:" + llDumpList2String(tokens, ":"));
			if (mask & CHANGED_SHAPE || mask & CHANGED_SCALE) {
				// changing shapes involves recalculation of the position
				sendCommand("reposition");
			}

		}
	}

	if(isGeomControlPrim) {
		// z scale = xradius
		// y scale = yradius
		// y axis tilt (handled elsewhere) = flare
		// x scale - 0.01 = bend coefficient
		vector scale = llGetScale();
		scale.x = scale.x - 0.01;
		scale.y = scale.y / waistSizeDivizor;
		scale.z = scale.z / waistSizeDivizor;
		if(mask & CHANGED_SCALE) {
			llSay(commChannelBase, "geometry:" + (string)scale);
		}
	}


	// reset all the changed notifications - we've done what we had to do...
	mask = 0;

}

restart_timer()
{
	// stop the timer and restart it
	llSetTimerEvent(0);
	llSetTimerEvent(1);
}

// ugggly hack - but since i am reusing the list of global vars...
set_globals_from_list(list aList, integer i)
{
	standPos = (vector)llList2String(aList, i); i=i+1;
	numObjects = llList2Integer(aList, i); i=i+1;
	xRadius = llList2Float(aList, i); i=i+1;
	yRadius = llList2Float(aList, i); i=i+1;
	flareAngle = llList2Float(aList, i); i=i+1;
	bendCoefficient = llList2Float(aList, i); i=i+1;
	rotOffset = (vector)llList2String(aList, i); i=i+1;
	posOffset = (vector)llList2String(aList, i); i=i+1;
}

// tell child to tell back its id so we could link it...
ask_child_to_link()
{
	llSay(commChannelBase + 1 + currObject, "link");
}

default
{
	touch_start(integer channel)
	{
		// ask the stand prim to show the menu, and avoid the spam in the chat
		if (commChannelBase != 0) {
			if (llDetectedKey(0) == llGetOwner()) {
				llSay(commChannelBase, "menu");
			} else {
					llInstantMessage(llDetectedKey(0), "Only owner can modify the skirt - get your free copy - right-click the posing stand and buy it for L$0");
			}
		}

	}
	on_rez(integer channel) {
		if (channel == 0) {
			if (llGetNumberOfPrims() > 1) {
				// need to check if we are linked and if yes - then delete the script...
				llRemoveInventory(llGetScriptName());
			}
			// if channel = 0 means we have been rezzed by the user - so do not do anything...
			return;
		}
		commChannelBase = channel;
		listenHandle = llListen(channel, "", "", "");
		// request the boot parameters
		llSay(channel, "boot");
	}
	run_time_permissions(integer parm)
	{
		if (parm & PERMISSION_CHANGE_LINKS)
		{

			//set permission flag
			miPermissionsAcquired = TRUE;
			// reset any pending events...
			llSetTimerEvent(0);
			// start the linking...
			currObject = 0;
			llOwnerSay("Linking will take some time, please be patient...");
			ask_child_to_link();
		} else {
				llOwnerSay("ERROR: permission was not acquired, can not link...");
		}
	}


	changed(integer changed_mask)
	{
		if ((changed_mask & CHANGED_LINK) && (!isLinkCenterPrim) && (!isControlPrim) && (!isGeomControlPrim) ) {
			if (llGetNumberOfPrims() > 1) {
				// need to check if we are linked and if yes - then delete the script...
				// the link centre prim will remove the script from itself,
				// either on next rez, or when it finishes linking us.
				llRemoveInventory(llGetScriptName());
			}

		} else {
				if (isControlPrim || isGeomControlPrim) {
					// set the appropriate flags
					// so that timer event would fix it.
					restart_timer();
					mask = mask | changed_mask;
				}
		}

	}
	timer() {
		idleCounter = idleCounter + 1;

		if (isControlPrim || isGeomControlPrim) {
			if (idleCounter > 1000) {
				// the stand is gone and did not remind about itself... go away then.
				llOwnerSay("Did not hear from the stand - so it must have been taken away - self-destroying...");
				llDie();
			}
		} else {
				if (idleCounter > 20) {
					// the stand is gone and did not remind about itself... go away then.
					llOwnerSay("Did not hear from the stand - so it must have been taken away - self-destroying...");
					llDie();
				}
		}
		if (isControlPrim) {
			// control prim
			vector myCurrentPos = llGetPos();
			vector delta = myCurrentPos - myLastPos;

			if ( (mask & CHANGED_SCALE) == 0) {
				// if both the scale AND position is changed - do not move
				// since when the scale changes via the mouse, the center drifts away...

				if (llVecDist(myLastPos, myCurrentPos) > 0) {
					llSay(commChannelBase, "move:" + (string)delta);
					//llOwnerSay("moved!");
				}
			}
			myLastPos = myCurrentPos;
		}
		if (isGeomControlPrim) {
			// geometry control prim - check the tilt, the scale is checked elsewhere
			vector myCurrentRot = llRot2Euler(llGetRot());
			if (llVecDist(myLastRot, myCurrentRot) > 0) {
				llSay(commChannelBase, "flare:" + (string)(myCurrentRot.y / DEG_TO_RAD));
			}
			myLastRot = myCurrentRot;
		}

		if (mask != 0) {
			// naive attempt at optimization...
			check_changed();
		}
	}



	listen(integer channel, string name, key id, string message)
	{
		integer i = 1; // first parameter;
		//llOwnerSay("message: '" + message + "'");
		if (channel == commChannelBase) {
			// init string
			// init:myNumber:boot_string
			// where boot string is:
			// [myPos, numObjects, xRadius, yRadius, flareAngle, bendCoefficient, rotOffset, posOffset]
			list aList = llParseString2List(message, [":"], []);
			if (llList2String(aList, 0) == "init") {

				llListenRemove(listenHandle);
				myNumber = llList2Integer(aList, i); i=i+1;
				llSetObjectName((string)myNumber);


				// object number ranges from 0 to numObjects-1
				// if we have got the number "numObjects" then we are the "control" prim - should not react to position change requests.

				// start listening for mothership only
				listenHandle = llListen(commChannelBase + 1 + myNumber, "", "", "");
				listenHandle = llListen(commChannelBase - 1, "", "", "");


				// report back to mothership that we are ok to fly on our own so it continues to generate the prims
				llSay(commChannelBase, "init_ok");

				// set the global parameters from the list
				set_globals_from_list(aList, i);

				isControlPrim = 0;
				isLinkCenterPrim = 0;
				isGeomControlPrim = 0;

				// set the keepalive timer for the precaution self-destruction
				// in the skirt prims - for the special prims the timer will be faster...
				llSetTimerEvent(120);


				if (myNumber == -10) {
					// control prim - change its appearance and it replicates...
					isControlPrim = 1;
					llSetObjectName("Primskirt builder control prim");

					llSetText(prompt, <0, 1, 0>, 1.0);

					position_master_prim();
					myLastPos = llGetPos();
					// for move/rotate and delayed prim replication
					restart_timer();
				} else if (myNumber == -11) {
						// link center prim - a ball to use as a root for the skirt
						isLinkCenterPrim = 1;
					llSetObjectName("Prim Skirt");


				} else if (myNumber == -12) {
						// geometry control prim
						isGeomControlPrim = 1;
					llSetObjectName("Waist size/flare/bend control prim");
					llSetText("X size: bend\nY size: yradius\nZ size: xradius\nY rotate: flare", <0, 1, 0>, 1.0);
					// the new position
					position_geometry_prim();
				}

				// notify the owner (debug)
				//llOwnerSay("got:" + llDumpList2String([myNumber, standPos, numObjects, xRadius, yRadius, flareAngle, bendCoefficient, rotOffset, posOffset], ":"));
				// and position ourselves properly
				new_position();

			} else {
					llOwnerSay("Unknown init message:'" + message + "'");
			}
		} else {
				// control messages from the mothership or the control prim
				list aList = llParseString2List(message, [":"], []);
			string command = llList2String(aList, 0);
			integer len = llGetListLength(aList);
		    i = 1;
			// reset the idle counter
			idleCounter = 0;
			if (command == "echo") {
				// reply to those that care
				llSay(commChannelBase, "echo_reply");
			} else if (command == "die") {
					llDie();
			} else if (isControlPrim == 1) {
					// do not respond to change position and all
					if (command == "repost") {
						// we need to push the prim characteristics
						mask = mask | CHANGED_SHAPE | CHANGED_COLOR | CHANGED_SCALE | CHANGED_TEXTURE;
						resetSideCaches();
						restart_timer();
					}
			} else if (isGeomControlPrim == 1) {
					// only allow to modify the shape
					// special kind of prim_params
					if (command == "gc_prim_params") {
						setParams(aList);
					} else if (command == "bulk") {
							// "bulk" is essentially the same as init, except "myNumber" is not sent.
							set_globals_from_list(aList, i);
						// position sets the box according to current parameters
						new_position();
					} else if (command == "repost") {
							// we need to push the prim characteristics
							mask = mask | CHANGED_SHAPE | CHANGED_COLOR | CHANGED_SCALE | CHANGED_TEXTURE;
						myLastRot = myLastRot * <1,1,1,0.5>; // just to "touch" the rotation so timer updates the things
						restart_timer();
					}
			} else if (isLinkCenterPrim == 1) {
					if (command == "die_skirt") {
						// only the ball and the skirt prims obey this
						llDie();
					} else if (command == "bulk") {
							// bulk works for linkcenter too, but most of it is ignored in processing...
							set_globals_from_list(aList, i);
						// and position ourselves properly
						new_position();
					} else if (command == "lc_prim_params") {
							// special kind of prim_params
							setParams(aList);
					} else if (command == "link") {
							llRequestPermissions(llGetOwner(), PERMISSION_CHANGE_LINKS);
					} else if (command == "linkme") {
							// someone wants to be linked...
							//llOwnerSay("linkme rcvd!");
							if (miPermissionsAcquired) {
								integer num = currObject + 1;
								llOwnerSay("Linking prim " + (string)num + " of " + (string)numObjects + ", please wait...");
								llCreateLink(id, TRUE);
								currObject = currObject + 1;
								if (currObject < numObjects) {
									ask_child_to_link();
								} else {
										vector pos = llGetPos() + <-1.0, 1.0, 0.0>;
									llSetPos(pos);
									llOwnerSay("Finished linking, please pick up your skirt!");
									llOwnerSay("If you enjoy using this tool, feel free to tip the creator Dalien Talbot according to the level of your enjoyment :-)");
									// clean up the script...
									llRemoveInventory(llGetScriptName());
								}
							} else {
									llOwnerSay("ERROR: permissions not acquired, can not link...");
							}

					}

			} else {
					if (command == "die_skirt") {
						// only the ball and the skirt prims obey this
						llDie();
					} else if (command == "link") {
							// kind of echo, but for linking...
							llSay(commChannelBase + 1 - 11, "linkme");
						//llOwnerSay("linkme!");
					} else if (command == "bulk") {
							// "bulk" is essentially the same as init, except "myNumber" is not sent.
							set_globals_from_list(aList, i);
						// notify the owner (debug)
						//llOwnerSay("got:" + llDumpList2String([myNumber, standPos, numObjects, xRadius, yRadius, flareAngle, bendCoefficient, rotOffset, posOffset], ":"));
						// and position ourselves properly
						new_position();
					} else if (command == "prim_params") {
							setParams(aList);
					} else if (command == "reposition") {
							new_position();
					} else if (command == "scale") {
							vector scale = (vector)llList2String(aList, 1);
						llSetScale(scale);
					} else if (command == "color") {
							while(i < len) {
								integer side = (integer)llList2String(aList, i);
								vector color = (vector)llList2String(aList, i+1);
								llSetColor(color, side);
								i = i+2;
							}
					} else if (command == "alpha") {
							while(i < len) {
								integer side = (integer)llList2String(aList, i);
								float alpha = (float)llList2String(aList, i+1);
								llSetAlpha(alpha, side);
								i = i+2;
							}
					}
			}

		}
	}

}
