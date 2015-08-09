// :CATEGORY:Die
// :NAME:Touch_Die
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:07
// :ID:903
// :NUM:1279
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Touch Die.lsl
// :CODE:

//This is to delete objects by touch. Place this script in an object you wish to have self delete. This will self delete when anyone touches it.

//This is nice for experiments that go a bit wild and get in people's way, that way they can delete the object. Also if you lose an object that has this you likely don't have to worry too much about tracking it down. But still if you lose an object you should make every effort to find it so it's not in someone's way.


123//remove the 123 to be able to use this script. Just delete the numbers and make sure running in the lower left is checked and hit save.

//Make sure you save a copy of this script and all others in this package before removing the 123.

default
{
    state_entry()
    {
        llSetText("Touch Me To Delete!",<255,255,255>,100);
    }

    touch_start(integer total_number)
    {
        llDie();
    }
}
// END //
