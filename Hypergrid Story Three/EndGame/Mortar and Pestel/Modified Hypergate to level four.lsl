// :SHOW:1
// :CATEGORY:Hypergate
// :NAME:Hypergate when you fall in 
// :AUTHOR:Ferd Frederix
// :KEYWORDS:Game, conteoller
// :REV:5.5
// :WORLD:OpenSim, Second life
// :DESCRIPTION:
// requires oSTeleport functions to be enabled
// :CODE:

//hop://www.outworldz.com:9000/Hypergrid Story Five/191/160/22

// Hypergate script by Ferd Frederix

vector LandingPoint ; // from the desscription
string DestName = "Hypergrid Story Five";     // Where you want the Avatar to arrive at

vector LookAt       = <0.0,0.0,-1.0>;           // which way you want them facing. 
list LastFewAgents;
string TargetAddress ;                               // In-Grid Teleport (Region Na

PerformTeleport( key AgentToTP )
{
    integer CurrentTime = llGetUnixTime();
    integer AgentIndex = llListFindList( LastFewAgents, [ AgentToTP ] );           // Is the agent we're teleporting already in the list?
    if (AgentIndex != -1)                                                          // If yes, check to make sure it's been > 5 seconds
    {
        integer PreviousTime = llList2Integer( LastFewAgents, AgentIndex+1 );      // Get the last time they were teleported
        if (PreviousTime >= (CurrentTime - 5)) return;                             // Less than five seconds ago? Exit without teleporting
        LastFewAgents = llDeleteSubList( LastFewAgents, AgentIndex, AgentIndex+1); // Delete the agent from the list
    }
    LastFewAgents += [ AgentToTP, CurrentTime ];                                   // Add the agent and current time to the list
    osTeleportAgent( AgentToTP, TargetAddress, LandingPoint, LookAt );             // Teleport agent to their target
    LastFewAgents = llDeleteSubList( LastFewAgents, 20, 100); // Delete the agent from the list
}

RESET_VOL_DET()
{
    llVolumeDetect( 0 ); // turn off volume detection
    llVolumeDetect( 1 ); // turn it back on again
}

 
default
{
    on_rez(integer int)
    {
       
        llResetScript();
    }
    state_entry()
    {
         llSetTextureAnim(FALSE, ALL_SIDES, 0, 0, 0.0, 0.0, 1.0);
        LandingPoint = (vector) llGetObjectDesc();
        TargetAddress = DestName;
        RESET_VOL_DET();
    }
    
    link_message(integer n, integer v,string text, key id )  // total_number is the number of avatars detected.
    {
       // llOwnerSay("link:" + (string) v);
        if (v == -1 ) {
           // llOwnerSay("Teleport");
            llSetTimerEvent(30);
        }
        
        
    }
    
    timer()
    {
        llSay(0, "You follow the cyberbeings into another dimension..... to " + DestName);
        TargetAddress = DestName;
        
        
        // PerformTeleport( llDetectedKey( 0 ));
         llSetTimerEvent(0);
    }
    changed(integer change) // something changed, take action
    {
        if(change & CHANGED_OWNER)
        {
            llOwnerSay("Owner Changed, Resetting Script");
            llResetScript();
        }
        else if (change & CHANGED_REGION_START) // that bit is set during a region restart
        {
            llResetScript();
        }
    }
}