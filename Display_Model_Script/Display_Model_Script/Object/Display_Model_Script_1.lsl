// :CATEGORY:Die
// :NAME:Display_Model_Script
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:51
// :ID:241
// :NUM:331
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Display Model Script.lsl
// :CODE:

// Inter-object commands
string commandDerez = "derez";

// This is the channel the main vendor talks to rezzed models on
integer commChannel;

default {
    state_entry() {
        llTargetOmega(<0,0,1>,0.2,1.0);
    }

    on_rez(integer startParam) {
        commChannel = startParam;
        llListen(commChannel, "", NULL_KEY, commandDerez);
    }
    
    listen(integer channel, string name, key id, string message) {
        llDie();
    }
}
// END //
