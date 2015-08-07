// :CATEGORY:NPC
// :NAME:NPC rotator
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2014-09-24 14:52:44
// :EDITED:2014-09-24
// :ID:1048
// :NUM:1660
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Script ot make a NPC rotate and walk in a circle
// :CODE:
float RANGE = 5;   // how far to sense
float RATE = 5;     // how often
float SPEED = 0.1;  // how fast to spin

integer running = FALSE;

doIt()
{
    if (running) {
        llTargetOmega(<0,0,1>,SPEED,1);
        llMessageLinked(LINK_SET,1,"go","");
    } else {
        llTargetOmega(<0,0,0>,0,1);
        llMessageLinked(LINK_SET,1,"quit","");
    } 
}
default
{
    
    state_entry() {
        llSensorRepeat("","", AGENT, RANGE, PI, RATE);
    }
    
    sensor(integer n)
    {
        if (running == TRUE)
            return; // no need to do anything
        integer i;
        for ( i = 0; i < n; i++) {
            key aviKey = llDetectedKey(i);
            if (! osIsNpc(aviKey)) {
                running = TRUE;
            }
        }
        
        doIt();

    }
    
    no_sensor() {
        if (running == FALSE)
            return;  // no need to do anything
            
        running = FALSE;
        doIt();
        
    }
    
    touch_start(integer p)
    {
        running = ~ running;
        doIt();
        
    }
    
}
