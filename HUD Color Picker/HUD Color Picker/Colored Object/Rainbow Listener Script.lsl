// :SHOW:
// :CATEGORY:HUD
// :NAME:HUD Color Picker
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2015-07-15 10:04:20
// :EDITED:2015-07-15  09:04:20
// :ID:1082
// :NUM:1801
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Rainbow Palette Color picker listener for a product//:LICENSE: CC-BY-SA 3.0
// :CODE:
// Rainbow Palette Listen Script originally by Rui Clary
// Second component of Rainbow Palette 
// Add this script to the object to be colorized.

// Modified by Ferd Frederix 2015.07.14 to have intensity control and be non-UUID specific (Opensim compatible).

// Available under the Creative Commons Attribution-ShareAlike 3.0 license
// http://creativecommons.org/licenses/by-sa/3.0/

// tunable things
integer colorall = TRUE; // set to FALSE to color just one prim, TRUE = all prims
integer FACE = ALL_SIDES; // the face of the prim to color, from 1 to N
string productName = "pal";// change this to match your HUD name
integer channel = 4;  // pick a channel that matches the listener prim

// no changes needed after this

default
{
    state_entry()
    {
        llListen( channel, productName, NULL_KEY, "" ); 
    }

    listen( integer channel, string name, key id, string message )
    {
        // only listen to the owner-provided commands to prevent crosstalk
        list detail = llGetObjectDetails(id,[OBJECT_OWNER]);
        if (llList2Key(detail,0)  != llGetOwner())
            return;

        // color one, or all prims to FACE
        if (colorall)
        {
            integer i;
            integer j = llGetNumberOfPrims();
            for (i = 1; i < j; i++)
            {
                llSetLinkColor(i,(vector)message,FACE);
            }
                
        } else {
            llSetColor((vector)message,FACE);
        }
    }
}
