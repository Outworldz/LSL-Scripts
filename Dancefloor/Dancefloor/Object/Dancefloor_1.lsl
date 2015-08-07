// :CATEGORY:Dance
// :NAME:Dancefloor
// :AUTHOR:Siggy Romulus
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:51
// :ID:213
// :NUM:288
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Dancefloor.lsl
// :CODE:

//======================================================================
// Low Lag 10 x 10 Disco Floor -  Siggy Romulus - Get_Toe() Script
//----------------------------------------------------------------------
// Use a single script to control 15 randomly changing danceflor
// squares
//======================================================================
// Variables
//----------------------------------------------------------------------

integer LISTEN_HANDLER;

// Overall set of colors and a list to randomise

integer CURRENT;    // current place in the color list

list COLORSET = [   <1.0, 0.0, 0.0>, <0.0, 1.0, 0.0>, <0.0, 0.0, 1.0>,
                    <1.0, 1.0, 0.0>, <1.0, 0.0, 1.0>, <1.0, 1.0 ,1.0>,
                    <1.0, 0.5, 0.0>, <0.5, 1.0, 0.0>, <0.0, 0.5, 1.0>,
                    <0.5, 0.0, 1.0>, <1.0, 0.0, 0.0>, <0.0, 1.0, 0.0>,
                    <0.0, 0.0, 1.0>, <1.0, 1.0, 0.0>, <1.0, 0.0, 1.0>,
                    <0.0, 1.0 ,1.0>, <1.0, 0.5, 0.0>, <0.5, 1.0, 0.0>,
                    <0.0, 0.5, 1.0>, <0.5, 0.0, 1.0>, <1.0, 0.0, 0.0>,
                    <0.0, 1.0, 0.0>, <0.0, 0.0, 1.0>, <1.0, 1.0, 0.0>,
                    <1.0, 0.0, 1.0>, <0.0, 1.0 ,1.0>, <1.0, 0.5, 0.0>,
                    <1.0, 1.0, 0.0>, <0.0, 0.5, 1.0>, <0.5, 0.0, 1.0>]; 
list COLORUSE;
//======================================================================
// Functions
//----------------------------------------------------------------------
Init()
{
    integer x;
    
    for (x = 2; x < 27; x++)
    {
        llSetLinkColor(x, <1,1,1>, ALL_SIDES);      // Set All Squares White
    }
    COLORUSE = llListRandomize(COLORSET, 1);        // Scramble the colors
    for (x = 2; x < 27; x++)
    {
        llSetLinkColor(x, llList2Vector(COLORUSE, x), ALL_SIDES);
    }
    COLORUSE = llListRandomize(COLORSET, 1);        // Rescramble them
}
//----------------------------------------------------------------------
Update_Squares()
{
    integer x;
    integer y;
    
    for (x = 0; x < 20; x++)        // Update 10 squares
    {
        y = (integer) llFrand(25.0);
        y +=2;
        
        llSetLinkColor(y, llList2Vector(COLORUSE, CURRENT), ALL_SIDES);
        
        CURRENT++;
        
        if (CURRENT > 20)
            CURRENT = 0;
           
    }
}
//======================================================================
// States
//----------------------------------------------------------------------

default
{
    state_entry()
    {        
        llSetLinkColor(LINK_SET, <0,0,0>, ALL_SIDES);
        Init();
        LISTEN_HANDLER = llListen(0, "", llGetOwner(), "");  
               
    }
    
    listen(integer channel, string name, key id, string msg)
    {
        if (msg == "START!")
        {
            llSetLinkColor(1, <0,0,0.2>, ALL_SIDES);
            llSetTimerEvent(1.50);          // Every second    
        }
        else if (msg == "STOP!")
        {
            llSetLinkColor(1, <0,0,0>, ALL_SIDES);
            llSetTimerEvent(0.00);          // Reset timer
        }
        else if (msg == "RESET!")
        {
            llSetLinkColor(1, <0,0,0.2>, ALL_SIDES);
            Init();
            llSetTimerEvent(1.50);    
        }  
    }
    
    timer()
    {
        Update_Squares();        
    }
    
    
    on_rez(integer start_param)
    {
        Init();   
    }
}
// END //
