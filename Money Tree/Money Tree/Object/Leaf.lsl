// :CATEGORY:Money Tree
// :NAME:Money Tree
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2014-02-20 14:27:38
// :EDITED:2014-02-20
// :ID:1027
// :NUM:1597
// :REV:1
// :WORLD:Opensim, SecondLife
// :DESCRIPTION:
// Makes a Money Tree. This is the Leaf Prim
// :CODE:

// Put this in a a prim
// Put this prim in the server
// It will fall and if touched, send money

integer channel = -76576;  //  a very secret number/password also found in the boxes that fall.

integer ready = FALSE;

default
{
    on_rez(integer param)
    {
        ready = param;    // for safety, we make it so if rezzed with no param, it does not spend money
        llSetTimerEvent((float) param);
        llSetStatus(STATUS_PHYSICS,TRUE);
    }
    timer()
    {
        llDie();
    }
    touch_start(integer total_number)
    {
        if (ready) {
            llSay(channel,llDetectedKey(0));
            llDie();
        }
    }
}
