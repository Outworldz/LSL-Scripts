// :CATEGORY:Map
// :NAME:Hunt HUD
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:55
// :ID:396
// :NUM:550
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// large map uncovers itself as you travel
// :CODE:

// Map prim

integer debug = 1;
DEBUG(string msg)
{
    if (debug) llOwnerSay(msg);
}


vector rootScale;

default
{
    state_entry()
    {
        llSetAlpha(1.0, ALL_SIDES); // visible
    }
    touch_start(integer total_number)
    {
        llSay(0, "Touched: "+(string)llGetPos());
    }

    link_message(integer sender_number, integer number, string message, key id)
    {
        if (number == 3)
        {
            rootScale = (vector) message;
           // DEBUG("Scale" + message);
        }
        else if (number == 4)
        {
            ///DEBUG("VISIBLE");
            llSetAlpha(1.0, ALL_SIDES);
        }
        else if (number == 0)
        {
             list nums = llParseString2List(message,["|"],[]);
            float Y = (float) llList2String(nums,0);
            float X = (float) llList2String(nums,1);  
            X = -X;
            //lSetPos(<0,X,Y>); // same as the arrowhead
            // Y = L-R
            // Z = Up/down
            
            vector myScale = llGetScale();        // my size
            //DEBUG("my Scale:" + (string) myScale);

            // find edges of my box
            vector localPos = llGetLocalPos() ;
            //DEBUG("local Pos:" + (string) localPos);
            
            float myLeft = localPos.y - myScale.y/2;
            float myRight = localPos.y + myScale.y/2;                        
            float myBottom = localPos.z - myScale.z/2;
            float myTop = localPos.z + myScale.z/2;


            if (X >= myLeft && X < myRight && Y >= myBottom && Y < myTop)
            {
                llSetAlpha(0,ALL_SIDES);
            }

        }
    }
}
