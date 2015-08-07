// :SHOW:
// :CATEGORY:Sound
// :NAME:Play-Sound-and-Animation
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2015-02-25 22:55:57
// :EDITED:2015-02-25  21:55:57
// :ID:1069
// :NUM:1724
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Plays a sound and an animation
// :CODE:
// partly from From the SL wiki at http://wiki.secondlife.com/wiki/LlStartAnimation  with just a few mods:

default
{
    touch_start(integer detected)
    {
        llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
    }
    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_TRIGGER_ANIMATION)
        {
            llStartAnimation("Animation");  // you can also copy and past a UUID here from your inventory
            llPlaySound("Sound",1.0);
            llSetTimerEvent(5.0); // 5 seconds, in this case
        }
    }
    timer()
    {
        llSetTimerEvent(0.0);
        llStopAnimation("Animation");  // Must match the name or UUID of the animation you started
        llStopSound();
    }
}


