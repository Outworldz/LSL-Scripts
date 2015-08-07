// :CATEGORY:Teleport
// :NAME:Local_Teleport
// :AUTHOR:Dustin Widget
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:56
// :ID:489
// :NUM:656
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// his script is useful for anyone needing a tp script attached to something that will be moved and rezzed regularly, such as a home.
// :CODE:
//Local Teleport v 1.1.2
//by Dustin Widget
//use and distribute freely, I only ask you keep my name at the top
//repeats a reset every 3 minutes, to update tp position in case of being rotated
//this timer wouldnt be needed if sl recognized a rotation as a move

float ud = 1;  //distance to move up or down of the tp obect. (up is positive, down is negative)
float ew = 0;  //distance to move east or west of the tp obect. ( is positive, is negative)
float ns = 0;  //distance to move north or south of the tp obect. ( is positive, is negative)
string sitText = "Teleport";

default
{
    state_entry()
    {
        llSitTarget(<ns,ew,ud> * (ZERO_ROTATION / llGetRot()),ZERO_ROTATION / llGetRot());
        llSetSitText(sitText);
        llSetTimerEvent(180);
    }
    
    on_rez(integer param)
    {
        llResetScript();
    }
    
    moving_end()
    {
        llResetScript();
    }
    
    timer()
    {
        llResetScript();
    }
    
    changed(integer change)
    {
        key av = llAvatarOnSitTarget();
        if(change & CHANGED_LINK && av!=NULL_KEY)
        {
            llSleep(0.3);
            llUnSit(llAvatarOnSitTarget());
        }
    }    
} 
