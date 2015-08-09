// :CATEGORY:Movement
// :NAME:Moving_Mountains__like_in_Avatar
// :AUTHOR:Ferd Frederix
// :CREATED:2010-07-18 11:46:58.413
// :EDITED:2013-09-18 15:38:57
// :ID:527
// :NUM:712
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// The numbers at the top set the range the rocks will move.  Just make some large prim rocks,  drop this script inside, and set your max X and Y parameyers.  You can set the height range as well as how close to the edge it goes.  The value 20 is the amount i wanted to move.  If you change this to a lower number, and change the timer to run faster, you can make rocks that move as if they are in a breeze
// :CODE:
float maxX = 150;    // 255 max
float minXY = 10;    // get no closer than 10 meters to any edge
float maxY= 180;     // 255 max
float minH = 35;	   // go no lower than this
float maxH = 100;    // go no higher than this

default
{
    state_entry()
    {
        llSetTimerEvent(600.0);	// every 10 minutes, move mountains
    }

    timer()
    {
        vector C;

        C= llGetPos();
        
        if (C.y > maxY) // N
            C.y -= 20;
        
        if (C.x > maxX)  // E
            C.x -= 20;

        if (C.x < minXY)   // W
            C.x += 20;   
        
        if (C.y  < minXY)    // S
            C.y += 20;
        
        if (C.z > maxH)   // U
            C.z -= 20;   
        
        if (C.z < minH)    // D
            C.z += 20;
            
            
        float sign = llFrand(2.0);    
        if (sign > 1.0)
            C.x += llFrand(10);
        else
            C.x -= llFrand(10);
        
        sign = llFrand(2.0);    
        if (sign > 1.0)
            C.y += llFrand(10);
        else
            C.y -= llFrand(10);
            
        sign = llFrand(2.0);    
        if (sign > 1.0)
            C.z += llFrand(10);
        else
            C.z -= llFrand(10);

        
        llSetPos(C);

    }
}
