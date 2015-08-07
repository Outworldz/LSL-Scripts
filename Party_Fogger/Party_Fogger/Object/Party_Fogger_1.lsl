// :CATEGORY:Particles
// :NAME:Party_Fogger
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-17 21:48:39
// :ID:615
// :NUM:839
// :REV:OBSOLETE
// :WORLD:Second Life
// :DESCRIPTION:
// Party Fogger.lsl
// :CODE:


key SMOKE_SPRITE = "b85073b6-d83f-43a3-9a89-cf882b239488";       

float SPRITE_SIZE = 3.0;
float LIFETIME = 10.0;
integer NUM_PARTICLES = 20;
//  What initial velocity magnitude should particles have (in meters/s)?
float SPRITE_VELOCITY = 0.15;
//  Width of cone (in Radians) about the object's Z axis where particle will be directed
float ARC = 0.5;
//  Offset distance from the object center to generate the system
vector OFFSET = <0,0,-2.5>;

default
{
     state_entry()   
        {
            
            //llGiveInventory(llGetOwner(), "Party Fogger Instructions");
            state stopped;
        }
    

}     
state smoking
{
    state_entry()
    {
        llWhisper(0, "Fogger on");
        llSetTimerEvent(2.0);
        llTargetOmega(<0,0,1>, 2, 2);
    }
 
    touch_start (integer num_detected)
    { 
        llSetTimerEvent(0.0);
        state stopped;
    }
    timer()
    {
        if (llFrand(1.0) < 0.5)
        {
            // 
            //  Make some smoke
            //
            llMakeSmoke( NUM_PARTICLES, 1.0, 0.2, 
                        LIFETIME, 1.0, SMOKE_SPRITE, OFFSET);
        }
    }
}
    
state stopped
{
    state_entry()
    {
        llTargetOmega(<0,0,1>, 0, 0);
        llWhisper(0, "Fogger off");
    }
    touch_start (integer num_detected)
    {
       state smoking;
    }          
}
// END //
