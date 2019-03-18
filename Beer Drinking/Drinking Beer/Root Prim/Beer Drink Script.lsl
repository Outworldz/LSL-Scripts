// :SHOW:
// :CATEGORY:Drink
// :NAME:Beer Drinking
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2015-05-29 12:25:47
// :EDITED:2015-05-29  11:25:47
// :ID:87
// :NUM:116
// :REV:1.1
// :WORLD:Second Life, Opensim
// :DESCRIPTION:
// Drink Script - makes it seem like beer is being drunk
// :CODE:
//: LICENSE: CC-0 (Open Source)
//: DESCRIPTION:
// 1) Make a cylinder and a glass, lets say, of beer.  Texture the cylinder to look like the beer liquid - mostly brown, with white foam at one end, and put white on the top of the cylinder. Put this cylinder inside the beer glass.    Or make a tapered cylinder and and fit it into another glass.
// 2) Link the glass and any other prims to the beer cylinder. The cylinder need to be the last thing clicked to make it the root prim.  
//  This script currently requires there be AT LEAST 2 prims.  Otherwise LINKNUM must be a 0 for a single prim, or the number of the prim that is the beer prim.
// 3) Add the script below to the root prim.     When reset, the beer should dissappear,   and appear to fill back up.
// 4) type this in chat:
//   /942 Drink
//  The beer will decrease by 10% rthwn empty, it shudl announce with a whsiper that "XX, your glass is empty."

// globals
float drink_left;
integer LINKNUM = 1;  // Assumes that the cylinder that is being drunk is the root prim.
string DECREASE_FOOD = "Drink";
float X = 1.0;
float Y = 1.0;
float  Z = 1.0; // the length of the cylinder

fill()
{
    float i = 0 ;
       
    //loop around cutting the length to fuill
    while (i < Z)
    {
        llSetLinkPrimitiveParamsFast(LINKNUM,[PRIM_SLICE, <0, i,0>]);           
        llSleep(.1);
        i += .020 ;            // ad 1/10 of a Z each loop
    }
    drink_left = 1; // 100%
}

drink()
{
    drink_left  = drink_left - 0.1;
    llSetLinkPrimitiveParamsFast(LINKNUM,[PRIM_SLICE, <0, drink_left,0>]);           
    if (drink_left <= 0)
    {
        drink_left = 0;
        llWhisper(0,llKey2Name(llGetOwner()) + " your glass is empty.");
        return;
    }
}

default
{
    state_entry()
    {
        // set to empty, then fill it
       
        llSetLinkPrimitiveParamsFast(LINKNUM,[PRIM_SLICE, <0, 0,0>]);  
        fill();
        llListen(942,"","","");
    }

    listen(integer channel, string name, key id, string message)
    {
        if (message == DECREASE_FOOD)
        {
            drink();
        }
    }

} 
