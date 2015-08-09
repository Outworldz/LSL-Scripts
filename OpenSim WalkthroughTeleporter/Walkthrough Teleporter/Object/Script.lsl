// :CATEGORY:HyperGate
// :NAME:OpenSim WalkthroughTeleporter
// :AUTHOR:John Lester (PathFinder)  
// :KEYWORDS:
// :CREATED:2014-02-09
// :EDITED:2014-02-08 08:13:30
// :ID:1022
// :NUM:1586
// :REV:1
// :WORLD:OpenSim
// :DESCRIPTION:
// An instant Hypergrid jump to a different grid simply by walking
// :CODE:
// This is the script I use in my WarpGates. Its a Hypergrid script I got on Pathlandia and I use it everywhere. 
// For more info see http://becunningandfulloftricks.com/2010/10/29/the-metaphor-of-portals
// anti-loop code added by Jag Nishi/The Ham

string  GridName     = "Visit Pathlandia\n(4000,4000)\n";
string  SimAddress   = "pathlandia.dlinkddns.com:9000:Pathlandia"; // use region name for inworld locations
string  LastVerified = "\nLast Verified: 04/05/2012";
string  Message      = "";
string  BoilerPlate  = "\nWalk through to teleport";
vector  LandingPoint = <123.0, 130.0, 13.0>;
vector  TextColor    = <0,1,1>;
vector  LookAt       = <1.0,1.0,0.0>;

key     AgentToTransfer;
list    LastFewAgents;

string  CONTROLLER_ID       = "A";
integer AUTO_START          = TRUE;
list    particle_parameters = [];
list    target_parameters   = [];

StartEffects()
{
    // llCollisionSound("Magic Chimes", 1.0);
    
    particle_parameters = [
        PSYS_SRC_TEXTURE,          llGetInventoryName(INVENTORY_TEXTURE, 0), 
        PSYS_PART_START_SCALE,     <0.10,0.10, FALSE>,
        PSYS_PART_END_SCALE,       <1.00,1.00, FALSE>, 
        PSYS_PART_START_COLOR,     <1,1,1>,
        PSYS_PART_END_COLOR,       <1,1,1>, 
        PSYS_PART_START_ALPHA,     (float)1.0,
        PSYS_PART_END_ALPHA,       (float)0.0,     
        PSYS_SRC_BURST_PART_COUNT, 500, 
        PSYS_SRC_BURST_RATE,       (float)0.01,   
        PSYS_PART_MAX_AGE,         (float)1.0, 
        PSYS_SRC_MAX_AGE,          (float)0.6,  
        PSYS_SRC_PATTERN,          2,
        PSYS_SRC_ACCEL,            <0.0,0.0,-3.0>,  
        PSYS_SRC_BURST_SPEED_MIN,  (float)1.2,
        PSYS_SRC_BURST_SPEED_MAX,  (float)5.01, 
        PSYS_SRC_ANGLE_BEGIN,      (float)0.25*PI,
        PSYS_SRC_ANGLE_END,        (float)0.00*PI,  
        PSYS_SRC_OMEGA,            <0,0,0>,       
        PSYS_PART_FLAGS, ( 0
                            | PSYS_PART_INTERP_COLOR_MASK   
                            | PSYS_PART_INTERP_SCALE_MASK   
                            | PSYS_PART_EMISSIVE_MASK   
                            | PSYS_PART_FOLLOW_VELOCITY_MASK
                            | PSYS_PART_WIND_MASK            
                         )                   
    ];
        
    if ( AUTO_START ) llParticleSystem( particle_parameters );
}

PerformTeleport( key WhomToTeleport )
{
    integer CurrentTime = llGetUnixTime();
    integer AgentIndex = llListFindList( LastFewAgents, [ WhomToTeleport ] );
    if (AgentIndex != -1)
    {
        integer PreviousTime = llList2Integer ( LastFewAgents, AgentIndex+1 );
        if (PreviousTime >= (CurrentTime -5)) return;
        LastFewAgents = llDeleteSubList( LastFewAgents, AgentIndex, AgentIndex+1);
    }
    LastFewAgents += [ WhomToTeleport, CurrentTime ];
    osTeleportAgent( WhomToTeleport, SimAddress, LandingPoint, LookAt );
}

default
{   
    on_rez(integer start_param)
    {
        llResetScript(); 
    }
    
    state_entry()
    {
        //llSetTextureAnim(ANIM_ON | SMOOTH | LOOP, ALL_SIDES, 0, 0, 0, 0, .05);
        llSetText(GridName + SimAddress + BoilerPlate + LastVerified + Message, TextColor, 1);  
    }
    
    collision_start(integer num_detected)
    {
        StartEffects();
    
        if(llDetectedKey(0) != AgentToTransfer)
        {
            AgentToTransfer=llDetectedKey(0);
            PerformTeleport( llDetectedKey(0));
        }
        else
        {
            llSetTimerEvent(3);
        }
    }
    
    timer()
    {
        AgentToTransfer="";
        llSetTimerEvent(0);
    }
    
    touch_start(integer num_detected)
    {
        llGiveInventory(llDetectedKey(0),llGetInventoryName(INVENTORY_NOTECARD, 0));
    }
    
    link_message( integer sibling, integer num, string mesg, key target_key )
    {
        if ( mesg != CONTROLLER_ID ) { // this message isn't for me.  Bail out.
            return;
        } else if ( num == 0 ) { // Message says to turn particles OFF:
            llParticleSystem( [ ] );
        } else if ( num == 1 ) { // Message says to turn particles ON:
            llParticleSystem( particle_parameters + target_parameters );
        } else if ( num == 2 ) { // Turn on, and remember and use the key sent us as a target:
            target_parameters = [ PSYS_SRC_TARGET_KEY, target_key ];
            llParticleSystem( particle_parameters + target_parameters );
        } else { // bad instruction number
            // do nothing.
        }            
    }
}

//// "Explosion" PARTICLE TEMPLATE v1 - by Jopsy Pendragon - 4/8/2008
//// You are free to use this script as you please, so long as you include this line:
//** The original 'free' version of this script came from THE PARTICLE LABORATORY. **//