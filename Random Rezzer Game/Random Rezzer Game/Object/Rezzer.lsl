// :CATEGORY:Games
// :NAME:Random Rezzer Game
// :AUTHOR:Anonymous
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:00
// :ID:675
// :NUM:917
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Random Rezzer
// :CODE:

// Put objects in this box and it will rez them at various speeds and places.
// Make sure the boxes are physical and temporary or you will quickly have a pile of prims

default
{
    on_rez(integer start_param)
    {
        llResetScript();    // when you rez it, we have to start a listener
    }
    state_entry()
    {
        llSetTimerEvent(1); // rez in 1 second at startup.
    }
    timer()    {

        integer howmany = llGetInventoryNumber(INVENTORY_OBJECT);    // how many items, 1,2,3

        integer whichone = llCeil(llFrand(howmany)) -1 ;    // pick one  at random
        string name = llGetInventoryName(INVENTORY_OBJECT,whichone);    // get the name of the object
        llSay(0, "Now in play: "+ name);
        float x = llFrand(9) + 1;    // up to a MAXIMUM of 10 meters away, no closer than 1 meter away. Cannot rez furrhaer than 10
        float y = llFrand(9) + 1;    // up to a MAXIMUM of 10 meters away, no closer than 1 meter away. Cannot rez furrhaer than 10
        float pushx = llFrand(1);    // Give it a velocity
        float pushy = llFrand(1);    // Give it a velocity 
        vector pos = llGetPos();
        float z = pos.z;
        pos.x += x;                // add the current position to the random rez place
        pos.y += y;                // add the current position to the random rez place
        
            
        llRezObject( name,pos,<pushx,pushy,0>,ZERO_ROTATION,1);    // rez an object at random location and speeds at 1 meter height so it bounces
        llSetTimerEvent(llFrand(20) + 10); // rez from 10 to 30 seconds, randomly
    }
}
