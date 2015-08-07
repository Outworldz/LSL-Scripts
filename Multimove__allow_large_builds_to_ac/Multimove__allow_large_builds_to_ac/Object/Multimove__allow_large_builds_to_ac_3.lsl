// :CATEGORY:Vehicle
// :NAME:Multimove__allow_large_builds_to_ac
// :AUTHOR:Amanda Vanness
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:58
// :ID:542
// :NUM:731
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// move1 script
// :CODE:
// Move
//
// Multimove follower

integer offchan = -100;    // this is the unique identifier for this type of vehicle
integer unichan;    // the channel used by the controller and objects to
            // sync and move, will be composed of this and part
            // of your UUID

integer handle;            // handle for the listen function

vector my_offset;        // original offset, set at first activation
rotation my_orientation;    // original rotation, set at first activation
integer my_num;            // position in the chain of redundancy
float azimut;

vector old_offset;
rotation old_orientation;

default
{
    on_rez(integer p)
    {
        unichan = offchan - (integer)("0x" + llGetSubString((string)llGetOwner(), 0, 6));
        llListenRemove(handle);
        handle = llListen(unichan + my_num, "", "", "");
    }
    
    state_entry()
    {
        unichan = offchan - (integer)("0x" + llGetSubString((string)llGetOwner(), 0, 6));
        my_num = (integer)llGetSubString(llGetScriptName(), -1, -1);
        handle = llListen(unichan + my_num, "", "", "");
    }
    
    listen(integer chan, string name, key id, string mesg)
    {
        if (mesg == "k") llDie();
        else if (mesg == "s") return;

        integer index = llSubStringIndex(mesg, "*");
        
        my_offset = llGetPos() + llGetRegionCorner() - (vector)llGetSubString(mesg, 0, index - 1);
        my_orientation = llGetRot() / (rotation)(llDeleteSubString(mesg, 0, index));
        my_offset = my_offset / llGetRot();
        state running;
    }
    
    state_exit()
    {
        llListenRemove(handle);
    }
}

state running
{
    on_rez(integer p)
    {
        unichan = offchan - (integer)("0x" + llGetSubString((string)llGetOwner(), 0, 6));
        llListenRemove(handle);
        handle = llListen(unichan + my_num, "", "", "");
    }
    
    state_entry()
    {
        handle = llListen(unichan + my_num, "", "", "");
    }
    
    listen(integer chan, string name, key id, string mesg)
    {
        if (mesg == "k")
        {
            llDie();
        } else if (mesg == "s")
        {
            state default;
        } else {
            integer index = llSubStringIndex(mesg, "*");
            rotation rtarget = my_orientation * (rotation)llDeleteSubString(mesg, 0, index);
            vector target = my_offset * rtarget + (vector)llGetSubString(mesg, 0, index - 1) - llGetRegionCorner();
            llSetPrimitiveParams([PRIM_POSITION, target, PRIM_ROTATION, rtarget]);
        }
    }

    link_message(integer source, integer code, string s, key id)
    {
        if (s == "detach")
        {
            if (my_offset == ZERO_VECTOR) return;
            
            llListenRemove(handle);
            old_orientation = my_orientation;
            my_orientation = ZERO_ROTATION;
            old_offset = my_offset;
            my_offset = ZERO_VECTOR;
            handle = llListen(code + my_num, "", "", "");
        } else if (s == "attach")
        {
            if (old_offset == ZERO_VECTOR) return;
            llListenRemove(handle);
            my_orientation = old_orientation;
            my_offset = old_offset;
            handle = llListen(unichan + my_num, "", "", "");
        }
    }
    
    state_exit()
    {
        llListenRemove(handle);
    }
}
