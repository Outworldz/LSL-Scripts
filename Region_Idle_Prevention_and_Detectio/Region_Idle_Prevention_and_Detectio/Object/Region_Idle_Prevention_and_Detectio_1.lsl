// :CATEGORY:Lag Meter
// :NAME:Region_Idle_Prevention_and_Detectio
// :AUTHOR:Void
// :CREATED:2012-07-02 15:19:02.050
// :EDITED:2013-09-18 15:39:01
// :ID:688
// :NUM:936
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Region Idling Detection Script// // If this script has red hovertext above it after everyone leaves the sim, your server is being slowed down. 
// :CODE:
default{
    state_entry(){
        llSetText( "No Idling detected yet", <0.0, 1.0, 0.0>, 1.0 );
        llSetTimerEvent( 600.0 );
    }
    
    timer(){
        if ((integer)llGetEnv( "region_idle" )){
            llSetText( "Region Idling confirmed at " + (string)llGetTimestamp(), <1.0, 0.0, 0.0>, 1.0 );
            llSetTimerEvent( 0.0 );
        }
    }
}
