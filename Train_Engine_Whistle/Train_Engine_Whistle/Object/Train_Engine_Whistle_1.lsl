// :CATEGORY:Train
// :NAME:Train_Engine_Whistle
// :AUTHOR:Barney Boomslang
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:08
// :ID:915
// :NUM:1313
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Train_Engine_Whistle
// :CODE:
// copyright 2007 Barney Boomslang
//
// this is under the CC GNU GPL
// http://creativecommons.org/licenses/GPL/2.0/
//
// prim-based builds that just use this code are not seen as derivative
// work and so are free to be under whatever license pleases the builder.
//
// Still this script will be under GPL, so if you build commercial works
// based on this script, keep this script open!

// This script manages triggered sounds like the whistle

default
{
    link_message(integer sender, integer num, string str, key id)
    {
        if (str == "whistle")
        {
            llTriggerSound(llGetInventoryName(INVENTORY_SOUND, 0), 1.0);
        }
    }
}
