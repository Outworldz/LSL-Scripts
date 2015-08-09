// :CATEGORY:Radar
// :NAME:Find_Prim_by_Owner_Name__and_make_a
// :AUTHOR:Ferd Frederix
// :CREATED:2011-10-06 13:23:16.210
// :EDITED:2013-09-18 15:38:53
// :ID:301
// :NUM:400
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Put this script into a prim.  Wear the prim and fly around.  If it finds any prims owned by 'avatar', it will print a link to chat that you can click on.   It can only scan 96 meters, so you have to fly around to find all the prims.   
// :CODE:
// Change the next line to find an avatars prims

string avatar = "Ferd Frederix";

default
{
    state_entry()
    {
        llSensorRepeat("", NULL_KEY, ACTIVE|PASSIVE|SCRIPTED, 96, PI,2); // scan for objects within 96 meters
    }

    sensor(integer total_number) // total_number is the number of avatars detected.
    {
        integer i;
        for (i = 0; i < total_number; i++)
        {
            list things = llGetObjectDetails( llDetectedKey(i) , [OBJECT_OWNER, OBJECT_NAME]);
               
            string name = llKey2Name(llList2String(things,0));      // get owner name
            if ( name == avatar)
            {
                vector pos = llDetectedPos(i);          // get the position
               
                llOwnerSay(llList2String(things,1) + " at " + "http://www.slurl.com/secondlife/"       // and make a SLURL
                    + llEscapeURL(llGetRegionName())
                    + "/"
                    + (string) pos.x
                    + "/"
                    + (string) pos.y
                    + "/"
                    + (string) pos.z);
            }
        }
    }
   
}
