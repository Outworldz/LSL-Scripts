// :CATEGORY:Pet
// :NAME:Mesh_Frog_Project
// :AUTHOR:Ferd Frederix
// :CREATED:2012-05-11 16:43:46.393
// :EDITED:2013-09-18 15:38:57
// :ID:512
// :NUM:692
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// tongue script
// :CODE:
// tongue

float visible = 1.0;
float invisible = 0;

default
{
    state_entry()
    {
        llSetAlpha(invisible,ALL_SIDES);
    }

    link_message(integer who, integer num, string str, key id)
    {
        if (str == "SIT")
        {
            llSetAlpha(invisible,ALL_SIDES);
        }
        else if (str == "HOP")
        {
            llSetAlpha(invisible,ALL_SIDES);
        }
        else  if (str  == "EAT")
        {
            llSetAlpha(visible,ALL_SIDES);
            llSleep(.3);
            llSetAlpha(invisible,ALL_SIDES);
        }
    }

}
