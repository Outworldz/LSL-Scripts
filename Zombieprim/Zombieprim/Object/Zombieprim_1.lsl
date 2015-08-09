// :CATEGORY:Weapons
// :NAME:Zombieprim
// :AUTHOR:Nitsuj Kidd
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:11
// :ID:992
// :NUM:1487
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Zombieprim
// :CODE:
//Zombie-prim
//By TSL Resident: Nitsuj Kidd
string target = "Put an avatars name here";
integer up = 5;
integer force = 2;
default
{
    state_entry()
    {
        llListen(0,"",llGetOwner(),"");
        llListen(2,"",llGetOwner(),"");
        llSensorRepeat("","",AGENT,30,TWO_PI,2);
    }
    listen(integer chan, string name, key id, string msg)
    {
        if(llToLower(llGetSubString(msg,0,llStringLength("attack")))=="attack ")
        {
            target = llToLower(llDeleteSubString(msg,0,llStringLength("attack")));
            llOwnerSay("Target set to " + target);
        }
        else if(llToLower(llGetSubString(msg,0,llStringLength("force")))=="force ")
        {
            force = (integer)llDeleteSubString(msg,0,llStringLength("force"));
            llOwnerSay("Target set to " + (string)force);
        }
    }
    sensor(integer num)
    {
        integer i;
        for(i=0; i<num; i++)
        {
            if(llSubStringIndex(llToLower(llDetectedName(i)),target)!=-1)
            {
                llApplyImpulse(((llDetectedPos(i)-llGetPos())*force)+<0,0,up>,FALSE);
            }
        }
    }
}
