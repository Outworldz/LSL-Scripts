// :CATEGORY:hover
// :NAME:hover_upright
// :AUTHOR:Martin
// :CREATED:2010-06-27 10:45:51.780
// :EDITED:2013-09-18 15:38:55
// :ID:387
// :NUM:535
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// used this for air hockey game i made
// :CODE:
default
{
    state_entry()
    {
        llSetStatus(STATUS_PHYSICS, TRUE);
        llGroundRepel(0.5, TRUE, 0.2); // In a 1/2 meter cube this is roughly the minimum height for any noticeable effect.
        // to
        llGroundRepel (1.0, TRUE, 0.2); // There is no restrictive maximum.
        // CHANGE the  1.0 to a reasonble numberfor height))
        {
         
        llSetStatus(STATUS_ROTATE_X | STATUS_ROTATE_Y | STATUS_ROTATE_Z, FALSE); // Set a block on all physical rotation.
        llSetStatus(STATUS_PHYSICS, TRUE); // Set physical.

 



}
    
    
    }
    
}
