// :CATEGORY:Tandy
// :NAME:Tandy the Nymph
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:06
// :ID:867
// :NUM:1222
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Tandy
// :CODE:

// general purpose throwable object.
// This make the gadget fall and bounce, and then it dies.
// It will also die in a no-script zone.

default
{
    state_entry()
    {
        llSetStatus(PRIM_PHYSICS,TRUE);
        llSetStatus(PRIM_TEMP_ON_REZ, TRUE);
        llSetTimerEvent(30);
    }
    timer()
    {
        llDie();
    }
    
    touch_start(integer total_number)
    {
        llDie();
    }

    on_rez(integer po)
    {
        llResetScript();
    }
}
