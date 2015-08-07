// :CATEGORY:Pet
// :NAME:Follower
// :AUTHOR:Anonymous
// :KEYWORDS:
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2014-01-30 19:59:25
// :ID:525
// :NUM:709
// :REV:1.1
// :WORLD:Second Life
// :DESCRIPTION:
// A gadget that follows a target when rezzed by a controller. Useful in attack huds and rezzers
// :CODE:

// follower

integer unichan = -123458;    // this is the channel used by the controller and objects to sync

integer handle;            // handle for the listen function
vector my_offset;        // original offset, set at first activation
rotation my_orientation;    // original rotation, set at first activation
integer my_num;            // position in the chain of redundancy

default
{
    on_rez(integer p)
    {
        llResetScript();
    }
    
    state_entry()
    {
        my_num = (integer)llGetSubString(llGetScriptName(), -1, -1);
        handle = llListen(unichan + my_num, "", "", "");
    }
    
    listen(integer chan, string name, key id, string mesg)
    {
        if (mesg == "k")
               llDie();

        integer index = llSubStringIndex(mesg, "*");
        my_offset = llGetPos() + llGetRegionCorner() - (vector)llGetSubString(mesg, 0, index - 1);
        my_orientation = llGetRot();
        my_offset = my_offset / my_orientation;
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
        state default;
    }
    
    state_entry()
    {
        handle = llListen(unichan + my_num, "", "", "");
    }
    
    listen(integer chan, string name, key id, string mesg)
    {
        if (mesg == "k")
            llDie();        
        list info = llParseString2List(mesg, ["*"], []);
        rotation rtarget = my_orientation * llEuler2Rot(<0,0,(float)((integer)llList2String(info, 1)) * DEG_TO_RAD>);
        vector target = my_offset * rtarget + (vector)llList2String(info, 0) - llGetRegionCorner();
        llSetPrimitiveParams([PRIM_POSITION, target, PRIM_ROTATION, rtarget]);
    }    

    state_exit()
    {
        llListenRemove(handle);
    }
}
