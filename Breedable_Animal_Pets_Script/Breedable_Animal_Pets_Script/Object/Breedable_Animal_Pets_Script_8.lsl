// :CATEGORY:Animal
// :NAME:Breedable_Animal_Pets_Script
// :AUTHOR:Xundra Snowpaw
// :CREATED:2011-07-25 13:48:33.917
// :EDITED:2013-09-18 15:38:49
// :ID:115
// :NUM:163
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Animal: xs_special.lsl
// :CODE:
default
{
    link_message(integer sender, integer num, string str, key id)
    {
        if (num == 1010) {
            if (str == "Normal") {
                llRemoveInventory("xs_special");
            } else {
                    // add states for specific specails
                }
        }
    }
}

