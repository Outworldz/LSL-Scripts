// :CATEGORY:Train
// :NAME:Train_Station_Engine_Rezzer
// :AUTHOR:Barney Boomslang
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:08
// :ID:918
// :NUM:1316
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Train_Station_Engine_Rezzer
// :CODE:
// copyright 2007 Barney Boomslang
//
// this is under the CC GNU GPL
// http://creativecommons.org/licenses/GPL/2.0/
//
// prim-based builds that just use this code are not seen as derivative
// work and so are free to be under whatever license pleases the builder.
//
// Still this script will be under GPL, so if you build commercial works
// based on this script, keep this script open!
//
// This is the rezzing script that rezzes a car behind the engine or
// another car. It needs adaption for offset, so the height is corrected,
// and for the distance it should have to the part that rezzes it.

// direct offset for rezzing
vector offset = <0,0,0.531>;

// distance in meter from the rezzing part
float distance = 2.0;

// current engine to rez
integer current = 0;

rezit()
{
    vector dir = llRot2Fwd(llGetRot());
    vector pos = llGetPos()+offset+dir*distance;
    if (current >= llGetInventoryNumber(INVENTORY_OBJECT))
    {
        current = 0;
    }
    llRezAtRoot(llGetInventoryName(INVENTORY_OBJECT, current), pos, ZERO_VECTOR, llGetRot(), 666);
    current++;
}

default
{
    state_entry()
    {
        llListen(474747, "", NULL_KEY, "");
    }
    
    listen(integer channel, string name, key id, string str)
    {
        if (llGetOwnerKey(id) == llGetOwner())
        {
            if (str == "start train")
            {
                rezit();
            }
        }
    }
    
    touch_start(integer num_detected)
    {
        if (llDetectedKey(0) == llGetOwner())
        {
            rezit();
        }
    }
    
    object_rez(key id)
    {
        llGiveInventory(id, llGetInventoryName(INVENTORY_NOTECARD, 0));
    }
}
