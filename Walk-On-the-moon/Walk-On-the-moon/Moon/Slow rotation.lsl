// :SHOW:
// :CATEGORY:World
// :NAME:Walk-On-the-moon
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2013-11-19 16:49:18
// :EDITED:2017-03-11  11:22:42
// :ID:1003
// :NUM:1912
// :REV:2
// :WORLD:Second Life, Opensim
// :DESCRIPTION:
// an optional script to slowly rotate the moon
// :CODE:


default
{
    state_entry()
    {         
        llTargetOmega(<.5,0.0,0.0>*llGetRot(),0.1,0.01);
    }

}
