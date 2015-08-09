// :CATEGORY:Avatar 
// :NAME:Height_Detection
// :AUTHOR:Francis Chung
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:54
// :ID:375
// :NUM:519
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Height Detection.lsl
// :CODE:

//Title: Height Detector
//Date:11-16-2003 7:24 PM
//Scripter: Francis Chung
//ATTENTION GET RID OF THE // IN FRONT OF "DEFAULT" TO ACTIVATE THIS SCRIPT

//default
{ 
    state_entry() 
    { 
        llSetStatus(STATUS_PHANTOM, TRUE); 
        llSetText( "Touch to find out your height", < 1,1,1>, 1 ); 
    } 

    touch_start(integer total_number) 
    { 
        key avatar; 
        string name; 
        vector size; 
        vector pos; 
        string saeheight = ""; 
        float heightfeet; 

        avatar = llDetectedKey(0); 
        size   = llGetAgentSize( avatar ); 
        name   = llDetectedName(0); 
        pos    = llDetectedPos(0); 
        
        heightfeet = size.z * 3.28083; 
        saeheight  = (string)((integer) llFloor(heightfeet)) + " feet "; 
        
        heightfeet -= llFloor(heightfeet); 
        saeheight  += (string)((integer)(llRound(heightfeet * 12))) + " inches"; 

        llSay( 0, name + " is " + (string)size.z + " m (" + saeheight + ") tall. (counting your shoes)" ); 
        
        size.x = 0.5; 
        size.y = 0.5; 
        llSetScale( size ); 
        // pos.x += 0.5; 
        llSetPos( pos ); 

    } 
} // END //
