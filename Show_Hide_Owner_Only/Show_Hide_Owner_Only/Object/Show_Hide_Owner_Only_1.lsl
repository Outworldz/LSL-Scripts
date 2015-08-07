// :CATEGORY:Building
// :NAME:Show_Hide_Owner_Only
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:02
// :ID:748
// :NUM:1031
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Show_Hide (Owner Only).lsl
// :CODE:

1// Remove this number for this script to work





//This is the command used to make the onject show itself. You can change it to what ever you like.
string sCommand = "show";

//This is the command used to make the onject hide itself. You can change it to what ever you like.
string hCommand = "hide";

//This is the channel which the object will listen to. It is set to channel 9 so to make it work you will say '/9' then the command.
integer chan = 9;

//this is the time that the object will display itself for before it         automatically hides itself, it is set to 0 so you will se the box when you rez it.
integer time = 0;

//This script automatically turns the object to phantom, If you wish it to be solid then change this value to FALSE.
integer switch = TRUE;

//---------------------------------------------------------------------

default
{
    state_entry()
    {
        llListen(chan,"",llGetOwner(),"");
        llSetStatus(STATUS_PHANTOM,switch);
        llSetTimerEvent(time);
    }

    listen(integer channel, string name, key id, string msg)
    {
        if (msg == sCommand)
        {
            llSetAlpha(1,ALL_SIDES);
            llSetTimerEvent(time);
           
        }
        
        if (msg == hCommand)
        {
            llSetAlpha(0,ALL_SIDES);
        }
    }
    timer()
    {
        llSetAlpha(0,ALL_SIDES);
    }
    on_rez(integer start_param)
    {
        llResetScript();
    }
        
        
}
// END //
