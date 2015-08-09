// :CATEGORY:Chat
// :NAME:Chat_Logger_Script
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:50
// :ID:169
// :NUM:240
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Chat Logger Script.lsl
// :CODE:

list names;
list speech;
list colours=["002EB8","FF6633","006600","660066","660033","663300","1A9900","FF14B1","001A99","#B88A00"];
list unique_names;

default
{
    state_entry()
    {
        llSetText("This is a chat logger - currently only for testing",<0,0,0>,1.0);
        integer i;
        integer c;
        for (i=0;i<llGetListLength(names);i++)
        {
            c = llListFindList(unique_names,llList2List(names,i,i)  );
            while (c >= llGetListLength(colours)) // dont crash if I run out of colours
                c -= llGetListLength(colours);
            llSetObjectName("[color=#" + llList2String(colours,c)
                + "]" + llList2String(names,i) );
            llOwnerSay( llList2String(speech,i) + "[/color]" );
        }
        names = [];
        speech = [];
        unique_names = [];
        llSetObjectName("Patch's Funky Chat Logger");
    }

    on_rez(integer i)
    {
        llResetScript();
    }
    
    touch_start(integer total_number)
    {
        if (llDetectedKey(0) == llGetOwner() )
        {
            llSay(0, "logging on!.");
            state logging_chat;
        }
    }
}

state logging_chat
{
    state_entry()
    {
        llListen(0,"",NULL_KEY,"");
    }

    on_rez(integer i)
    {
        llOwnerSay("Logging still on! Touch to get playback");
    }
    
    touch_start(integer total_number)
    {
        if (llDetectedKey(0) == llGetOwner() )
        {
            llSay(0, "chat logging now off - replaying log!.");
            state default;
        }
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if(llListFindList(unique_names,[name]) == -1)
        {
            unique_names += name;
        }
        names += name;
        speech += message;
    }

} 
// END //
