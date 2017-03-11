// :CATEGORY:World
// :NAME:Walk-On-the-moon rotate
// :AUTHOR:Ferd Frederix
// :CREATED:2013-11-19 16:49:18
// :ID:1003
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
