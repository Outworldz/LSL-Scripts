// :CATEGORY:Building
// :NAME:hi_riseelevator_script
// :AUTHOR:Shine Renoir
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:54
// :ID:380
// :NUM:527
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// An example how to build a platform at 2,000 meters. Place this script in a box, and place an object named "Sky Platform" in the box. Then sit down on the box. At 2,000 meters it rezzes the Sky Platform. Note: There are some strange rules at this altitude, e.g. when you try to move an object, it will be placed at 768 m height. Same for llSetPos. But looks like the physical movement commands are working.// // See below for an elevator to this height.
// :CODE:
// Space builder
//
// 2007 Copyright by Shine Renoir (fb@frank-buss.de)
// Use it for whatever you want, but keep this copyright notice
// and credit my name in notecards etc., if you use it in
// closed source objects
//
default
{
    state_entry()
    {
        llSitTarget(<0, 0, 0.5>, ZERO_ROTATION);
    }

    changed(integer change)
    {
        // if someone sits down
        if (change & CHANGED_LINK) {
            key av = llAvatarOnSitTarget();
            if (av) {
                vector start = llGetPos();
                llOwnerSay("space lift engaged, destination: 2,000 m");
                llSetBuoyancy(2.0);
                llSetStatus(STATUS_PHYSICS, TRUE);
                vector pos = llGetPos();
                while (pos.z < 2000.0) {
                    pos = llGetPos();
                }
                llSetStatus(STATUS_PHYSICS, FALSE);
                pos = llGetPos();
                llRezObject("Sky Platform", pos, ZERO_VECTOR, ZERO_ROTATION, 0);
                llSleep(0.1);
                llUnSit(av);
                llDie();
                float delta = 1.0;
                while (delta > 0.1) {
                    llSetPos(start);
                    pos = llGetPos();
                    delta = pos.z - start.z;
                }
            }
        }
    }
}
