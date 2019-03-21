// :CATEGORY:Tour
// :NAME:Tour Bird
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:07
// :ID:907
// :NUM:1283
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Tour
// :CODE:


// WAYPOINT #10 PRIM SCRIPT
// When rezzed, does a llRegionSay on channel 300 of the word "number".  Other #10 prims hear this
// chats 10||Description on channel 300 when it hears 'number' on 300. 
// remembers the highest number it hears and sets the name to 1- that number


integer wanted = 0;
integer debugger = 1;

list prims;


debug(string message)
{
    if (debugger)
        llOwnerSay(message);
}

default
{
    state_entry()
    {
        llListen(300,"","","");
        wanted++;
        llRegionSay(300,"number");
        llSetTimerEvent(5.0);   // 5 seconds to hear from all prims
        llOwnerSay("Setting coordinates");
    }

    listen(integer channel,string name, key id, string message)
    {
        if (message == "die")
            llDie();

        else if (message =="where")
            llRegionSay(300,llGetObjectName() + "|" + (string) llGetPos() + "|" + llGetObjectDesc());

        else if (message =="number")
            llRegionSay(300,llGetObjectName());

        else if (wanted)
        {
            prims += (integer) message; // add to memory list
        }


    }

    timer()
    {
        wanted = 0;
        prims = llListSort(prims,1,0);  // sort descending
        integer num = (integer) llList2Integer(prims,0); // get highest number
        llSetObjectName((string) (num + 10));  // leave room for more prims to be added
        llOwnerSay("Name set to " + llGetObjectName() + ".  You can add text to be spoken when the tour reaches this location by adding some text to the description of this object.");

        llSetTimerEvent(0);
    }

    on_rez(integer p)
    {
        llResetScript();
    }
}


