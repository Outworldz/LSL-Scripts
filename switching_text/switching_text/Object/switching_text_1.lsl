// :CATEGORY:HoverText
// :NAME:switching_text
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:06
// :ID:861
// :NUM:1198
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// switching text.lsl
// :CODE:

string text="Put your text here";
integer switch=TRUE;
default
{
    state_entry()
    {
        llSay(0, "floating text");
        llSetTimerEvent(2);
    }

    on_rez(integer start_param)
    {
        llResetScript();
    } 
    
    timer()
    {
        if(switch) 
        {
            switch=FALSE;
            llSetText(text,<1,1,1>,1.0);
        }
        else
        {
            switch=TRUE;
            llSetText(text,<1,0,0>,1.0);
        }
    }
}
// END //
