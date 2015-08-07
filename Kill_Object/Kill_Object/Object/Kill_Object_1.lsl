// :CATEGORY:Die
// :NAME:Kill_Object
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:55
// :ID:424
// :NUM:580
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Kill Object.lsl
// :CODE:

1// remove this number for the script to work.

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
