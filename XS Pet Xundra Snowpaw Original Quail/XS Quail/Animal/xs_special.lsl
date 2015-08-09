// :CATEGORY:XS Pet
// :NAME:XS Pet Xundra Snowpaw Original Quail
// :AUTHOR:Xundra Snowpaw
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:11
// :ID:989
// :NUM:1477
// :REV:1
// :WORLD:Second Life, Opensim
// :DESCRIPTION:
// Original Pet Quail
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


