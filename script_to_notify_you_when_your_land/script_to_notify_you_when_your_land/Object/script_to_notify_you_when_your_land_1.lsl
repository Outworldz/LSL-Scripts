// :CATEGORY:Land
// :NAME:script_to_notify_you_when_your_land
// :AUTHOR:Angel Fluffy
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:01
// :ID:723
// :NUM:988
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// script to notify you when your land sells by Angel Fluffy.lsl
// :CODE:

1
//********************************************************
//This Script was pulled out for you by YadNi Monde from the SL FORUMS at http://forums.secondlife.com/forumdisplay.php?f=15, it is intended to stay FREE by it s author(s) and all the comments here in ORANGE must NOT be deleted. They include notes on how to use it and no help will be provided either by YadNi Monde or it s Author(s). IF YOU DO NOT AGREE WITH THIS JUST DONT USE!!!
//********************************************************







//script to notify you when your land sells by Angel Fluffy
//It's very simple : it simply sends you an IM when your land is sold to someone else, then deletes itself. I've NOT tested it AT ALL, so I make no assurances AT ALL that it will work. It's intended to be more of an idea than anything else - if it works, consider that a bonus




integer ctime = 10;

default
{
    state_entry()
    {
        llSay(0, "Online. Will check every "+(string)ctime+" seconds. If land owner is NOT the same as object owner, will message object owner with location and 'your land sold' message, and self delete.");
        llSetTimerEvent((float)ctime);
    }

    timer() {
        if (llGetLandOwnerAt(llGetPos()) == llGetOwner())  {
            // object owner matches land owner
        } else {
            // object owner does NOT match land owner!
            llInstantMessage(llGetOwner(),"Your land at "+(string)llGetRegionName()+":"+(string)llGetPos()+" has been sold. The new buyer may be : "+llKey2Name(llGetLandOwnerAt(llGetPos()))+" (if this fails, a group now has it).");
            llDie();
        }
        
    }
}// END //
