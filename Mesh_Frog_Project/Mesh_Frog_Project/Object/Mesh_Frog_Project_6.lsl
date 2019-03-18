// :CATEGORY:Pet
// :NAME:Mesh_Frog_Project
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2012-05-11 16:43:46.393
// :EDITED:2013-09-18 15:38:57
// :ID:512
// :NUM:690
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Rear leg #3 script
// :CODE:
// rear leg #3, in front of the very back set

float visible = 1.0;
float invisible = 0;

default
{
    state_entry()
    {
        llSetAlpha(visible,ALL_SIDES);
    }

    link_message(integer who, integer num, string str, key id)
    {
        if (str == "SIT")
        {
            llSetAlpha(visible,ALL_SIDES);
        }
        else if (str == "HOP")
        {
            llSetAlpha(invisible,ALL_SIDES);
            llSleep(.5);
            llSetAlpha(visible,ALL_SIDES);
        }
        else  if (str  == "EAT")
        {
            llSetAlpha(invisible,ALL_SIDES);
            llSleep(1);
            llSetAlpha(visible,ALL_SIDES);
        }
    }

}
