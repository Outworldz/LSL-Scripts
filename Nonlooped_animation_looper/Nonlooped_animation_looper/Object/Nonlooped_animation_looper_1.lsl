// :CATEGORY:Animation Timer
// :NAME:Nonlooped_animation_looper
// :AUTHOR:Ferd Frederix
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:58
// :ID:561
// :NUM:765
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Nonlooped_animation_looper
// :CODE:

// non-looped animation looper v0.3
// Clang Bailey
// 3/38/2008


string anim = "_horizondance";

key anim_key;
key av;
float anim_time;
list anim_list;

default
{
    state_entry()
    {
    }
   
    touch(integer num_detected)
    {
        av = llDetectedKey(0);
        state init;
    }
}


state init
{
    state_entry()
    {
        llRequestPermissions(av, PERMISSION_TRIGGER_ANIMATION);
    }

    touch_start(integer total_number)
    {
        llStopAnimation(anim);
        llStartAnimation("stand");
        llResetScript();
    }
   
    run_time_permissions(integer perm)
    {
        if(perm & PERMISSION_TRIGGER_ANIMATION)
        {
            anim_key = llGetInventoryKey(anim);
            anim_list = llGetAnimationList(av);
            integer i;
            for(i = 0; i < llGetListLength(anim_list); i++)
            {
                llStopAnimation(llList2Key(anim_list, i));
            }
            llResetTime();
            llStartAnimation(anim);
            llSetTimerEvent(.01); // Yes. This is a very fast timer. But, it is only
                                            // for the first pass through the animation.
                                            // So, the concern for lag is minimal. The
                                            // fast timer gives you a fairly accurate play
                                            // time, and subsequent plays through the
                                            // animation uses that time.
        }
    }
   
    timer()
    {
        anim_list = llGetAnimationList(av);
        if(llListFindList(anim_list, [anim_key]) == -1)
        {
            anim_time = llGetTime();
            llSetTimerEvent(0);
            state animate;
        }
    }
}

state animate
{
    state_entry()
    {
        llStartAnimation(anim);
        llSetTimerEvent(anim_time + .2); // ".2" added to make up for latency.
    }
   
    timer()
    {
        llStartAnimation(anim);
    }
   
    touch(integer num_detected)
    {
        llStopAnimation(anim);
        llStartAnimation("stand");
        llResetScript();
    }
} 
