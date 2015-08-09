// :SHOW:
// :CATEGORY:Collision
// :NAME:Reliable llVolumeDetect
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2014-10-21 20:08:23
// :EDITED:2015-05-29  11:26:03
// :ID:1053
// :NUM:1672
// :REV:2
// :WORLD:Second Life
// :DESCRIPTION:
// Forces reliable collisions in Opensim
// :CODE:
//integer CHANGED_REGION_RESTART = 1024;

default
{
    state_entry()
    {
        llVolumeDetect(TRUE);
    }
    collision_start(integer total_number)
    {
        llSay(0, "Bumped: "+(string)total_number);
    }
    changed(integer what)
    {
        if (what &  CHANGED_REGION_START)   
        {
            llVolumeDetect(FALSE);    // toogle fix bug in Opensim
            llVolumeDetect(TRUE);
        }
    }
}
