// :CATEGORY:Building
// :NAME:Highlight_Face
// :AUTHOR:Aki Kojima
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:54
// :ID:382
// :NUM:530
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Highlight Face.lsl
// :CODE:

//Title: Highlight Face 
//Date: 01-22-2004 02:49 PM
//Scripter: Aki Kojima 

integer i = 0; 

default 
{ 
    state_entry() 
    { 
        llSetColor(<1,1,1>, ALL_SIDES); 
    } 

    touch_start(integer total_number) 
    { 
        for(i=0;i<6;i++) 
        { 
            llSetColor(<1,0,0>, i); 
            if (i != 0) 
            { 
                integer e = i - 1; 
                llSetColor(<1,1,1>, e); 
            } 
            llWhisper(0, "Side: "+(string)i); 
            llSleep(3); 
        } 
    } 
} 
// END //
