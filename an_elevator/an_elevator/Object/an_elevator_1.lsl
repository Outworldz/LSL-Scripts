// :CATEGORY:Elevator
// :NAME:an_elevator
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:47
// :ID:33
// :NUM:44
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// an elevator.lsl
// :CODE:

vector pos;//Base Postion
vector end;//Target Position
key owner;
default
{
    state_entry()
    {
        owner=llGetOwner();
        llListen(0,"",owner,"");
        llListen(34,"","","first");
        llListen(34,"","","second");
        llSetStatus(STATUS_ROTATE_X|STATUS_ROTATE_Y|STATUS_ROTATE_Z,FALSE);
    }

    listen(integer a, string n, key id, string m)
    {
        // When the object hears align, it will grab the base position, and after which, all moves will be made by adjusting the z-coordinate of the base position.
        if(m=="align")
        {
            pos=llGetPos();
            llSetStatus(STATUS_PHYSICS,TRUE);
            llMoveToTarget(pos,1.5); 
        } 
        
        //  For the first floor, we want the elevator to be at its base position, so end(final resting place of the elevator) is the same as pos.  I showed the addition of the vector <0,0,0> merely for continuity.  The same comments about tau that apply to the llSetHoverHeight, apply to llMoveTarget.
        if(m=="first")
        {
            end=pos;
            llMoveToTarget(end,1.5);            
        }
    
        if(m=="second")
        {
            end=pos+<0,0,3.29>;
            llMoveToTarget(end,1.5);            
        }
          
    }
}
// END //
