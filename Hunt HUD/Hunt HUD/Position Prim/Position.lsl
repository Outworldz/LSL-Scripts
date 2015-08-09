// :CATEGORY:Map
// :NAME:Hunt HUD
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:55
// :ID:396
// :NUM:551
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Positioner script
// :CODE:

// dot script to show your position

integer debug = 1;

DEBUG(string msg)
{
    if (debug) llOwnerSay(msg);
}

default
{

    link_message(integer sender_number, integer number, string message, key id)
    {
        if (number == 0)
        {
            list nums = llParseString2List(message,["|"],[]);
            float Y = (float) llList2String(nums,0);
            float X = (float) llList2String(nums,1);
            rotation rot = (rotation) llList2String(nums,2);
            
            vector newrot = llRot2Euler(rot) * RAD_TO_DEG;
            newrot = <newrot.z - 90,0,0> * DEG_TO_RAD;
            rotation lastrot = llEuler2Rot(newrot);
            
           // DEBUG("r:" + (string) newrot);
            // rot is around Z.
            // map to a 
            llSetPos(<0,-X,Y>);
            llSetLocalRot(ZERO_ROTATION / lastrot); 
        }
    } 

}
