// :CATEGORY:Collider
// :NAME:Super_Collider
// :AUTHOR:Rickard Roentgen
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:05
// :ID:845
// :NUM:1175
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Add this to a prim called 'pool of blood' and put it inside
// :CODE:
integer listen1;
vector scale;

default
{
    state_entry()
    {
        scale = <0.1, 0.1, 0.05>;
        llSetScale(scale);
    }
    
    on_rez(integer sparam)
    {
        llListenRemove(listen1);
        listen1 = llListen(20, "", NULL_KEY, (string)llGetOwner() + "revive");
        scale = <0.1, 0.1, 0.05>;
        llSetScale(scale);
        llSetTimerEvent(0.1);
    }
    
    timer()
    {
        if (scale.x < 1.0) {
            scale += <0.025, 0.025, 0.0>;
            llSetPrimitiveParams([PRIM_SIZE, scale]);
        } else {
            llSetTimerEvent(0.0);
        }
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (llGetOwnerKey(id) == llGetOwner()) {
            llDie();
        }
    }
}
