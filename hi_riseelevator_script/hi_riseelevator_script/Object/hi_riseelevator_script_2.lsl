// :CATEGORY:Building
// :NAME:hi_riseelevator_script
// :AUTHOR:Shine Renoir
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:54
// :ID:380
// :NUM:528
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// For moving up to the platform, you could use a space elevator. Move it along the x-axis beside the platform on ground. On sit up it pushs you a bit, which moves you on the platform.
// :CODE:
// Space elevator
//
// 2007 Copyright by Shine Renoir (fb@frank-buss.de)
// Use it for whatever you want, but keep this copyright notice
// and credit my name in notecards etc., if you use it in
// closed source objects

// direction and power to push after sit up
vector push = <50.0, 0.0, 0.0>;

// target height
float height = 2005.0;

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
                while (pos.z < height) {
                    pos = llGetPos();
                }
                llSetStatus(STATUS_PHYSICS, FALSE);
                pos = llGetPos();
                llSleep(0.1);
                llUnSit(av);
                llPushObject(av, push, ZERO_VECTOR, FALSE);
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
