// :CATEGORY:Door
// :NAME:Drawer_Script
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:52
// :ID:261
// :NUM:352
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Drawer Script.lsl
// :CODE:


//Drawer Script
//===quote===
//You will want to put something like this in all three drawer parts. Touching any of the three parts will trigger all the drawer parts to open/close.

//For each drawer, you need to change the drawer_num to a different number.
//EG: it should be set to 1 for all three pieces of the 1st drawer, 2 for all pieces of the 2nd drawer, etc...

//Put a copy of this script into each of the drawer prims.

//Link the 3 drawer prims in with all the other bookcase prims making sure the base prim of the bookcase is selected last. Unless you have other special prims in the bookcase that require a certain link order, only the base prim matters as to what order it's linked in as this determines what the +X axis of the entire object is.
//=== end quote ===

integer drawer_num = 2;  // this is the top drawer - all componenets
                         // of a drawer should use the same number.
                         // EG: change to 2 for all 2nd drawer prims
float slide_dist = 0.5;  // distance in meters drawer should open
integer is_open = FALSE; // assume drawer starts out closed
string close_message = "CLOSE DRAWER"; // Close message to send to other prims
string open_message = "OPEN DRAWER";   // Open message to send to other prims

default
{

    state_entry()
    {
    }   // end of state_entry state

    touch_start(integer nullvar)
    {
        if ( is_open )
        {   // it's open, so close it
            is_open = FALSE;
            llMessageLinked(LINK_ALL_OTHERS, drawer_num, close_message, NULL_KEY);
            llSetPos(<-slide_dist, 0.0, 0.0> + llGetLocalPos());
        }
        else
        {   // it's closed so open it
            is_open = TRUE;
            llMessageLinked(LINK_ALL_OTHERS, drawer_num, open_message, NULL_KEY);
            llSetPos(<slide_dist, 0.0, 0.0> + llGetLocalPos());
        }
    }   // end of touch_start state

    link_message(integer sender_num, integer num, string str, key id)
    {
        if ( num == drawer_num )
        {
            if ( str == open_message )
            {   // we are bing asked to open
                if ( ! is_open )
                {   // if closed, then open.  Otherwise do nothing
                    llSetPos(<slide_dist, 0.0, 0.0> + llGetLocalPos());
                    is_open = TRUE;
                }
            }

            if ( str == close_message )
            {   // we are bing asked to close
                if ( is_open )
                {   // if open then close.  Otherwise do nothing
                    llSetPos(<-slide_dist, 0.0, 0.0> + llGetLocalPos());
                    is_open = FALSE;
                }
            }
        }
    }   // end of link_message state
}// END //
