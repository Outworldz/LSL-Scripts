// :CATEGORY:Replication
// :NAME:Self_Replicator
// :AUTHOR:Fred Kinsei
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:02
// :ID:734
// :NUM:1002
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Be careful with this script, if left running by itself, it can get you banned.
// :CODE:
default
{
    on_rez(integer start_param)
    {
        llListen(0,"","","");
        llSleep(5);
        llRezObject("Child", llGetPos() + <0,0,1>, ZERO_VECTOR, ZERO_ROTATION, 0);
    }
    listen(integer channel, string name, key id, string message)
    {
        if(message == "die")
        {
            llDie();
        }
    }
    object_rez(key child) 
    { 
        llGiveInventory(child, llKey2Name(child));
    } 
}
