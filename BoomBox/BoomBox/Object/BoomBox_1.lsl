// :CATEGORY:Sound
// :NAME:BoomBox
// :AUTHOR:Mitz
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:49
// :ID:111
// :NUM:152
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// boombox.lsl
// :CODE:
//BoomBox by Mitz
integer counter;
integer soundCount;
list songs;
list NEXT;

GetSongNames()
{
    integer i;
    for(i=0;i < llGetInventoryNumber(INVENTORY_SOUND);i++)
    {
        songs += llGetInventoryName(INVENTORY_SOUND, i);
    }
}


default

{
    
    changed(integer what)
    {
        if (what & CHANGED_INVENTORY)
            llResetScript();
    }
    on_rez(integer rez)
    {
        llResetScript();
    }

    state_entry()
    {
        counter =0;
        llStopSound();
        GetSongNames();
        //PreLoadSongs();
        soundCount = llGetInventoryNumber(INVENTORY_SOUND);
        llListen(-1, "", llGetOwner(), "");
        NEXT = llList2List(songs, 0, 8);
    }

    touch_start(integer fingers)
    {
        if(llDetectedKey(0) == llGetOwner() )
        {
            llDialog(llGetOwner(), "Songs", NEXT + ["< Prev", "Stop", "Next >"], -1);
        }
    }

    listen(integer channel, string name, key id, string message)
    {
        if(message != "< Prev" && message != "Stop" && message != "Next >" )
        {
            llLoopSound(message, 1);
            llOwnerSay("Now Playing " + llToUpper(message) );
        }else{
                if(message == "< Prev")
                {
                    counter = counter - 9;
                    NEXT = [];
                    NEXT = llList2List(songs, counter , -1);
                    if( llGetListLength(NEXT) > 9)
                    {
                        NEXT = llDeleteSubList(NEXT, 9, -1);
                    }
                    llDialog(llGetOwner(), "Songs", NEXT + ["< Prev", "Stop", "Next >"], -1);
                }

            if(message == "Stop")
            {
                llStopSound();
            }

            if(message == "Next >")
            {
                counter = counter + 9;
                NEXT = [];
                NEXT = llList2List(songs, counter , -1);
                if( llGetListLength(NEXT) > 9)
                {
                    NEXT = llDeleteSubList(NEXT, 9, -1);
                }
                llDialog(llGetOwner(), "Songs", NEXT + ["< Prev", "Stop", "Next >"], -1);
            }
        }
    }
}

