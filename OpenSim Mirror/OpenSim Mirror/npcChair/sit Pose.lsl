// :CATEGORY:NPC
// :NAME:OpenSim Mirror
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2013-09-08
// :EDITED:2014-02-14 12:32:45
// :ID:1023
// :NUM:1588
// :REV:1
// :WORLD:OpenSim
// :DESCRIPTION:
// A chair for the NPC to sit in
// :CODE:

// put this in a prim for the NPC to sit on

vector myPos = <0.0, 0.0, 0.1>;  // sit pose relative to the pose ball, must NOT be all zeros!
integer chat = -483498;

default
{
    state_entry()
    {
         llSetAlpha(1,ALL_SIDES);
         llListen(chat,"","","");
         
        llSitTarget(myPos, ZERO_ROTATION);    // one forware, not to the size, 1 up.
    }
    
    on_rez(integer p)
    {
        llResetScript();
    }
    listen(integer channel, string name, key id, string str)
    {
        if (str == "Mirror")
        {
            llSetText(str,<1,1,1>,1.0);
            llSetAlpha(1.0,ALL_SIDES);
        }
        else
        {
            llSetText(str,<1,1,1>,1.0);
            llSetAlpha(0.0,ALL_SIDES);
        }
    }
}
