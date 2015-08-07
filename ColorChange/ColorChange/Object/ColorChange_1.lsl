// :CATEGORY:Color
// :NAME:ColorChange
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:51
// :ID:197
// :NUM:270
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// ColorChange.lsl
// :CODE:

vector c;
default
{ 
    state_entry()
    {
        llListen(0,"","","colors"); 
        llListen(0,"","","stop");
        c=llGetColor(0);
    }
    listen (integer channel, string name, key id, string message)
    {
        if (message == "colors")
        {
            float random = llFrand(1.9)+.5;
            llSetTimerEvent(random);
        }
        if (message == "stop")
        {
            llSetTimerEvent(0.0);
            llSetColor(c,-1);
        }
    
    }
    timer()
    { 
        float x = llFrand(1.0);
        float y = llFrand(1.0);
        float z = llFrand(1.0);
        llSetColor(<x,y,z>,-1);
    }

} // END //
