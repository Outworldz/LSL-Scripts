// :CATEGORY:Follower
// :NAME:Keyframe Follower
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2014-12-04 12:15:10
// :EDITED:2014-12-04
// :ID:1058
// :NUM:1687
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Wing flap script for a X-wing uses a special texture, 1/4 wing upperl left, 1/4 wing lower right
// :CODE:
default
{
    state_entry()
    {
        llSetTextureAnim( ANIM_ON | LOOP, ALL_SIDES, 1, 2, 0.0, 2.0, 5); 
    }
    
    link_message(integer sender, integer num, string str, key id)
    {
     //   llOwnerSay(str);
        if (str=="up"){
            llSetTextureAnim( ANIM_ON | LOOP, ALL_SIDES, 1, 2, 0.0, 2.0, 5); 
            llSetTimerEvent(0.5);
        }
        else if (str=="down") {
            llSetTextureAnim( ANIM_ON | LOOP, ALL_SIDES, 1, 2, 0.0, 2.0, 2); 
            llSetTimerEvent(0.7);
        }
        else if (str=="land") {
            llSetTimerEvent(0);
            llStopSound();
        }

    }
    
    timer()
    {
        llTriggerSound("wing4", 0.5);
    }
    
    on_rez(integer p)
    {
        llResetScript();   
    }
}  
