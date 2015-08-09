// :CATEGORY:Die
// :NAME:Kill_Object_1
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:55
// :ID:425
// :NUM:581
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Kill Object 1.0.lsl
// :CODE:

default
{
    state_entry()
    {
        key id = llGetOwner();
        llListen(0,"",id,"kill object");
    }

    listen(integer number, string name, key id, string m)
     {
        if (m=="kill object")
        {
            llDie();
        }
    }
}

// END //
