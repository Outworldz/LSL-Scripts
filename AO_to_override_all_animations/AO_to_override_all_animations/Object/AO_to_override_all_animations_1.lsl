// :CATEGORY:AO
// :NAME:AO_to_override_all_animations
// :AUTHOR:Ferd Frederix
// :CREATED:2011-05-08 20:15:22.530
// :EDITED:2013-09-18 15:38:47
// :ID:48
// :NUM:66
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// From the Second Life wiki - http://wiki.secondlife.com/wiki/LlGetAnimationList, Copyright © 2007-2009 Linden Research, Inc. and licensed under the Creative Commons Attribution-Share Alike 3.0 License at http://creativecommons.org/licenses/by-sa/3.0
// :CODE:
//Simple Animation Override for Walk
key old_anim = "6ed24bd8-91aa-4b12-ccc7-c97c857ab4e0";
string new_anim="yoga_float";
integer status;
list check;
key owner;
 
default
{
    state_entry()
    {
        owner = llGetOwner();
        llRequestPermissions(owner, PERMISSION_TRIGGER_ANIMATION);
        check = [old_anim];
    }
 
    run_time_permissions(integer p)
    {
        if(p & PERMISSION_TRIGGER_ANIMATION)
        {
            llSetTimerEvent(0.2);
        }
    }
 
    timer()
    {
        if(llGetAgentInfo(owner) & AGENT_WALKING)
        {
            list anims = llGetAnimationList(owner);
            if(~llListFindList(anims, check))
            {
                status = 1;
                llStartAnimation(new_anim);
                llStopAnimation(old_anim);
            }
        }
        else if(status)
        {
            llStopAnimation(new_anim);
            status = 0;
        }
    }
 
    on_rez(integer p)
    {
        llResetScript();
    }
}
