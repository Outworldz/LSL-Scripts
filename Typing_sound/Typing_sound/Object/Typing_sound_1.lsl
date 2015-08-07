// :CATEGORY:Keyboards
// :NAME:Typing_sound
// :AUTHOR:Davy Maltz
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:08
// :ID:931
// :NUM:1337
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Typing_sound
// :CODE:
integer typing;
integer ffirst;
integer tfirst;
default
{
    state_entry()
    {
        llSetTimerEvent(0.01);
        tfirst = TRUE;
        ffirst = FALSE;
    }
    timer()
    {
        if(llGetAgentInfo(llGetOwner()) & AGENT_TYPING)
        {
            typing = TRUE;
        }
        if(!(llGetAgentInfo(llGetOwner()) & AGENT_TYPING))
        {
            typing = FALSE;
        }
        if(typing == TRUE && tfirst == TRUE)
        {
            tfirst = FALSE;
            ffirst = TRUE;
            llPlaySound("",1.0);
        }
        else if(typing == FALSE && ffirst == TRUE)
        {
            ffirst = FALSE;
            tfirst = TRUE;
            llPlaySound("",1.0);
        }
    }
}
