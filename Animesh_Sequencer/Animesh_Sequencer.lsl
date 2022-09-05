integer debug = TRUE; // set this top FALSE to shut the chat up.
integer idx = 0;	  // a counter to fiund the thing we need.
string prioranimation  = "";  // where we keep thje last anim,ation so we can stop it.

// example list of animations to play
// 1,2,3 seconds in this case
// plays "soundfIle on the 1st and last  animation.
list animations = ["idle_1", "soundFile1", 1.0,
				"idle_2", "", 2.0,
				"idle_3","soundFile3", 3.0
				];
			
// The above list is the names or UUIDS of animations in the prim, optionally a sound file name or UUID, and the time to play them.
// List is a 3-stride list so to play no animation, and a sound for 10 seconds, use
// "","soundfile name", 10,
			
// for just an animation for 2 seconds, use this:
// "animationame","", 2.0
			
// for an animation for 20 secondsw with a wav file, use this:
// "animationame", "soundfilename", 20

// And there is no comma at the end of the list!!
			
default {
	state_entry()	{		// all we do in this ewvent is start a timer. Never rest inside this event! It's an endless loop!
		if (debug) llSay(0,"reset");
		llSetTimerEvent(1);
	}
	on_rez(integer p){		// in case you rez the prim
		llResetScript();
	}
	changed(integer what)	{
		if (what & CHANGED_REGION_START) {	// in case the OAR was loaded
			llResetScript();
		}
		if (what & CHANGED_INVENTORY) {		// reset if you change any items in the prim inventory
			llResetScript();
		}
	}		
	timer()	{
		// check for end of list, if so start over
		if (idx >= llGetListLength(animations))	{
			idx = 0;
		}
		
		// Start an animation after sttopping the prior
		string animation = llList2String(animations,idx);
		if (debug) {
			llSay(0,"Playing " + animation);
		}
		llStopObjectAnimation(prioranimation);
		llStartObjectAnimation(animation);
		prioranimation = animation;
		
		// Set Sound
		string sound = llList2String(animations,idx+1);
		if (debug) {
			llSay(0,"Sound " + sound);
		}
		if (llStringLength(sound)> 0 ) {
			llPlaySound(sound, 1.0);
		}
		
		// Set timer
		float t = (float) llList2String(animations,idx+2);
		llSetTimerEvent(t);
		if (debug) llSay(0,"Timer Set to " + (string) t );		
		idx+= 3;
	}
}
