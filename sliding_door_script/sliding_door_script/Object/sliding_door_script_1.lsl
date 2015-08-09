// :CATEGORY:Door
// :NAME:sliding_door_script
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:04
// :ID:797
// :NUM:1107
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// sliding door script.lsl
// :CODE:

integer es;
default
{
    state_entry()
    {
        es = 0;
    }
    touch_start(integer total_number)
    {
            vector er = llGetScale();
            if(es == 0)
            {
                llSetPos(llGetLocalPos() - <er.x*2,0,0>);
                es = 1;
            }
            else
            {
                llSetPos(llGetLocalPos() + <er.x*2,0,0>);
                es = 0;
            }
    }
}
// END //
