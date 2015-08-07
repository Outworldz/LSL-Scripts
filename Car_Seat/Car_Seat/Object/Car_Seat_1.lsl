// :CATEGORY:Vehicles
// :NAME:Car_Seat
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:50
// :ID:157
// :NUM:225
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Car Seat.lsl
// :CODE:

default
{
    state_entry()
    {
        llSitTarget(<0,0,0.5>, llEuler2Rot(<0,-0.4,0> ));
    }

}
// END //
