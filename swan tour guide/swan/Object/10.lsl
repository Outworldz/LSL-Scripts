// :CATEGORY:Tour
// :NAME:swan tour guide
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-11-27 13:38:09
// :ID:854
// :NUM:1545
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Tour Guide setup prim.
// Rez this from inventory to m,ake a route.  Use the recorder to gather the route
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
