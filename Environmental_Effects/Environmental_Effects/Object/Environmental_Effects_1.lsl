// :CATEGORY:Environment
// :NAME:Environmental_Effects
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:52
// :ID:286
// :NUM:384
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Environmental Effects.lsl
// :CODE:

1
list daySounds = ["",""];
list nightSounds = ["",""];

list nightAmbient = ["Cricket"];

default {
    state_entry() {
        llStopSound();
        llSetTimerEvent(2.0);
    }

    timer() {
        vector time = llGetSunDirection();
        list myList;
        float density = 0.9;

        if (time.z > 0.0) {
            myList = llListRandomize(daySounds, 1);
        }
else {
       myList = llListRandomize(nightSounds, 1);
      density = 0.98;
            
            // Ambient nighttime sound
            if (llFrand(1.0) > 0.85) {
                llStopSound();
            } else {
                llLoopSound(llList2String(nightAmbient, 0), 1.0);
            }
        }
        
        if (llFrand(1.0) > density) {
            llTriggerSound(llList2String(myList, 0), 1.0);
        }
    }
}
// END //
