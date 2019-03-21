// :SHOW:1
// :CATEGORY:Gaming
// :NAME:Hypergate water by Fred Beckhusen (Ferd Frederix)
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:Water, Game, Hypergate
// :REV:2.0
// :WORLD:OpenSim
// :DESCRIPTION:
// teleport a game player back a step when they violate a game rule.
// Useful when placed under water, or over their heads to stop flying, and next to obstacles to keep them from going around it.
// To use, put the destination coordinate vector in the Description of the prim. When collided, they get tp'ed away.
// Requires osTeleportAgent to be enabled
// :CODE:

// Rev 2.0 with Linux reset bug patched

string msg = "You fell in!";

vector LandingPoint;     // Where you want the Avatar to arrive at comes from the description
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
    llSleep(1.0);
    llResetScript();
}

RESET_VOL_DET()
{
    llSetStatus(STATUS_PHANTOM, FALSE); // Rev 2.
    llVolumeDetect(FALSE);
    llSleep(0.1);
    llVolumeDetect(TRUE);
}

 
default
{
    on_rez(integer int)
    {
        llResetScript();
    }
    state_entry()
    {
        LandingPoint = (vector) llGetObjectDesc();
        TargetAddress = llGetRegionName();
        RESET_VOL_DET();
    }
    
    collision_start(integer total_number)  // total_number is the number of avatars detected.
    {
        if (osIsNpc(llDetectedKey(0)))
                return;

        llSay(0, msg);
        TargetAddress = llGetRegionName();
        PerformTeleport( llDetectedKey(0));
        RESET_VOL_DET();
    }
    
    changed(integer change) // something changed, take action
    {
        if(change & CHANGED_OWNER)
        {
            llResetScript();
        }
        else if (change & CHANGED_REGION_START) // that bit is set during a region restart
        {
            llResetScript();
        }
    }
}