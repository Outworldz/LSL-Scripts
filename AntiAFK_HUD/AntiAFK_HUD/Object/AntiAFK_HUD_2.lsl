// :CATEGORY:HUD
// :NAME:AntiAFK_HUD
// :AUTHOR:Noland Brokken
// :CREATED:2010-11-08 12:18:03.007
// :EDITED:2013-09-18 15:38:47
// :ID:42
// :NUM:56
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Position the HUD on attach
// :CODE:
vector brOffset = <0.0,  0.04,  0.1>;
vector bmOffset = <0.0,  0.0,    0.1>;
vector blOffset = <0.0, -0.04,  0.1>;
vector trOffset = <0.0,  0.04, -0.06>;
vector tmOffset = <0.0,  0.0,   -0.06>;
vector tlOffset = <0.0, -0.04, -0.06>;

default
{
    attach(key id)
    {
        if (id != NULL_KEY)
        {
            integer attachPoint = llGetAttached();
            
            // Nasty if else block
            
            if (attachPoint == 32) // HUD Top Right
            {
                llSetPos(trOffset);
            }
            else if (attachPoint == 33) // HUD Top
            {
                llSetPos(tmOffset);
            }
            else if (attachPoint == 34) // HUD Top Left
            {
                llSetPos(tlOffset);
            }
            else if (attachPoint == 36) // HUD Bottom Left
            {
                llSetPos(blOffset);
            }
            else if (attachPoint == 37) // HUD Bottom
            {
                llSetPos(bmOffset);
            }
            else if (attachPoint == 38) // HUD Bottom Right
            {
                llSetPos(brOffset);
            }
        }
    }
}
