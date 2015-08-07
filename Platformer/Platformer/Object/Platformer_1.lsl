// :CATEGORY:Platform
// :NAME:Platformer
// :AUTHOR:Davy Maltz
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:59
// :ID:633
// :NUM:860
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// The script for the worn attachment, which rezzes the platforms when the platformer is turned on(Assuming the platform object is in the attachment's inventory): 
// :CODE:
default
{
    state_entry()
    {
        llListen(0,"","","");
    }
    on_rez(integer start_param)
    {
        llResetScript();
    }
    listen(integer channel,string name,key id,string message)
    {
        if(message==".on")
        {
            llSetTimerEvent(0.01);
        }
        if(message==".off")
        {
            llSetTimerEvent(0.0);
        }
    }
    timer()
    {
    llRezObject("plat",llGetPos() - (llGetAgentSize(llGetOwner())  / 2) - <0,0,0.145>,ZERO_VECTOR,llGetRot(),1);
    }
}

