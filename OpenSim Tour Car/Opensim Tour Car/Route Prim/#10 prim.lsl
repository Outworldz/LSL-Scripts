// :CATEGORY:Tour
// :NAME:OpenSim Tour Car
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2014-09-07 10:50:19
// :EDITED:2014-09-07
// :ID:1040
// :NUM:1627
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Tour Routing prim for Opensim
// :CODE:


// WAYPOINT #10 PRIM SCRIPT
// When rezzed, does a llRegionSay on channel 300 of the word "number".  Other #10 prims hear this
// chats 10||Description on channel 300 when it hears 'number' on 300. 
// remembers the highest number it hears and sets the name to 10+ that number


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
            llRegionSay(300,llGetObjectDesc() + "|" + (string) llGetPos()  + "|" + (string) llGetRot());

        else if (message =="number")
            llRegionSay(300,llGetObjectDesc());

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
        llSetObjectDesc((string) (num + 10));  // leave room for more prims to be added
        llSetText((string)(num + 10),<1,1,1>,1.0); 
        llOwnerSay("Desc set to " + llGetObjectDesc());

        llSetTimerEvent(0);
    }

    on_rez(integer p)
    {
        llResetScript();
    }
}


