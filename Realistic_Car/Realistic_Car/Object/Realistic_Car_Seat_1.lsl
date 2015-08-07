// :CATEGORY:Vehicles
// :NAME:Realistic_Car
// :AUTHOR:Aaron Perkins
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:01
// :ID:686
// :NUM:933
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Realistic Car Seat.lsl
// :CODE:

//**********************************************
//Title: Car Seat
//Author: Aaron Perkins
//Date: 2/17/2004
//**********************************************

default
{
    state_entry()
    {
        llSitTarget(<0,0,0.5>, llEuler2Rot(<0,-0.4,0> ));
    }

}
// END //
