// :CATEGORY:Tour Guide
// :NAME:Valentines_Day_tour_bird
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2011-02-04 22:42:15.247
// :EDITED:2014-03-11
// :ID:946
// :NUM:1363
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Waypoint script.  This is a cube that you name '10'.  Rez them to set up a route.   
// :CODE:

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

