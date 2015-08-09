// :SHOW:
// :CATEGORY:Tour
// :NAME:OpenSim Tour Car
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2015-02-25 22:55:43
// :EDITED:2015-02-25  21:55:43
// :ID:1040
// :NUM:1723
// :REV:1
// :WORLD:Opensim or Secondlife
// :DESCRIPTION:
// Tour car seat for Multi-vehicle script - place this in any seat and adjust the TARGET and ROT as necessary
// :CODE:


vector TARGET = <0,0,0.1>; // sit position on the root prim. Ste this to <0,0,0> if you want to not to be able to sit on the base
vector ROT = <0,0,0>;   // and the rotation, if they sit


default
{
    state_entry()
    {
        llSetCameraEyeOffset(<5, 0, 0> );
        llSetCameraAtOffset(<0, 0, 1>);

        rotation rot     = llEuler2Rot(ROT * DEG_TO_RAD);     // convert the degrees to radians,
                                                              // then convert that vector into a rotation
        llSitTarget(TARGET, rot); // where they sit
    
    }

    changed( integer what )
    { 
        if (what & CHANGED_LINK)
        {
            key av = llAvatarOnSitTarget();
            if (av != NULL_KEY) {
                llMessageLinked(LINK_SET,0, "Sit","");
            }
        }
    }



    
}
