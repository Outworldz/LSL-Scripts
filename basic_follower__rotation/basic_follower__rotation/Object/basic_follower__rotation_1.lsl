// :CATEGORY:Pet
// :NAME:basic_follower__rotation
// :AUTHOR:Logan Bauer
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:48
// :ID:79
// :NUM:106
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// basic follower + rotation.lsl
// :CODE:


////////////////////////////////////////////////////////////////
// Open Basic Follower/Facing Script, by Logan Bauer. //
////////////////////////////////////////////////////////////////
// OFFSET is the position of your pet in relation to it's owner's position.
// For example, in the default setting below, "vector offset =<-1,0,1>;"
// I.E. (x,y,z), the -1 puts it 1m back behind owner, the 0 means don't have
// it stay left or right, and 1 means have it stay 1m above it's owner.  
// So, if you wanted the script to make it follow directly in front of you,
// and to the left, then you would change it to "vector offset =<1,1,0>;"


vector offset =<-1,0,1>;

startup()
{
        vector pos = llGetPos();
        llSetStatus(STATUS_ROTATE_Z,TRUE);
        llSetStatus(STATUS_PHYSICS, TRUE);
        key id = llGetOwner();
        llSensorRemove();
        llSensorRepeat("",llGetOwner(),AGENT,200,2*PI,.5);
}

default
{
        state_entry()
    {
        startup();

       
    }

    on_rez(integer start_param)
    {
        startup();
    }

    sensor(integer total_number)
    {
        vector pos = llDetectedPos(0);
        llMoveToTarget(pos+offset*llDetectedRot(0),.3);     
        llLookAt(pos, .1 , 1);
    }
} 
      
// END //
