// :CATEGORY:Die
// :NAME:Chat_Die
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:50
// :ID:167
// :NUM:238
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Chat Die.lsl
// :CODE:

//This is to delete objects by chat. Place this script in an object you wish to have self delete. Say or Shout (hold ctrl while hitting enter) the word delete, and your object will self delete.

123//remove the 123 to be able to use this script. Just delete the numbers and make sure running in the lower left is checked and hit save.

//Make sure you save a copy of this script and all others in this package before removing the 123.


default
{
    state_entry()
    {
        llListen(0,"",llGetOwner(),"");
    }

    listen(integer channel, string name, key id, string m)
    {
        if (m=="delete");llDie();
    }
}
// END //
