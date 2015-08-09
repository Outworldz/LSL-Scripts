// :CATEGORY:Hypergate
// :NAME:Hypergates
// :AUTHOR:Maria Korolov
// :KEYWORDS:
// :CREATED:2015-01-15 20:52:03
// :EDITED:2015-01-15
// :ID:1065
// :NUM:1708
// :REV:1
// :WORLD:OpenSim
// :DESCRIPTION:
Hypergate script for Opensim// :REVISION: 4
// :LICENSE: CC-0
// Maria Korolov's Hypergate script

integer Rev = 4;


key StatusQuery;     
integer FontSize;  

string SimName;
string SimAddress;
vector LandingPoint = <128.0, 128.0, 22.0>;
vector LookAt       = <1.0,1.0,1.0>;
 
list LastFewAgents; 

string FunctionName = "osTeleportAgent"; 
string FunctionPermitted = "No";
integer checked = 0;

SpecialEffect()
{    
        llPlaySound("d7a9a565-a013-2a69-797d-5332baa1a947", 1);    // change this to match your sim sound
        llParticleSystem([
            PSYS_PART_FLAGS, PSYS_PART_EMISSIVE_MASK,
            PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
            PSYS_SRC_MAX_AGE, 0.5,
            PSYS_PART_MAX_AGE, 1.0,
            PSYS_SRC_BURST_RATE, 0.01,
            PSYS_SRC_BURST_PART_COUNT, 50,
            PSYS_SRC_BURST_RADIUS, 0.3,
            PSYS_SRC_BURST_SPEED_MIN, 0.2,
            PSYS_SRC_BURST_SPEED_MAX, 3.0,
            PSYS_SRC_ACCEL, <0.0,0.0,0.0>,
            PSYS_PART_START_COLOR, <1, 1, 1>,
            PSYS_PART_START_ALPHA, 0.5,
            PSYS_PART_END_ALPHA, 0.0,
            PSYS_PART_START_SCALE, <0.3,0.3,0>,
            PSYS_PART_END_SCALE, <0.5,0.5,0>,
            PSYS_PART_FLAGS
                           , 0
                           | PSYS_PART_EMISSIVE_MASK
                           | PSYS_PART_INTERP_SCALE_MASK
                           ]); 
}

LoadDestination ()
{
    list Description = llParseString2List(llGetObjectDesc(), [", "],[","]);
    SimName = llList2String(Description,0);
    FontSize = (integer) (llStringLength(SimName)*(-2.25)+60.5);
    SimAddress = llList2String(Description,1);
    StatusQuery = llRequestSimulatorData(SimAddress, DATA_SIM_STATUS);
    string CommandList = ""; 
        CommandList = osMovePen( CommandList, 5, 55 );
        CommandList += "FontSize "+ (string) FontSize+";";
        CommandList = osDrawText( CommandList, SimName );
        osSetDynamicTextureDataBlendFace( "", "vector", CommandList, "width:256,height:256", FALSE, 2, 0, 255, 3 );
    
}

PerformTeleport( key WhomToTeleport )
{
    integer CurrentTime = llGetUnixTime();
    integer AgentIndex = llListFindList( LastFewAgents, [ WhomToTeleport ] );      
    if (AgentIndex != -1)                                                          
    {
        integer PreviousTime = llList2Integer( LastFewAgents, AgentIndex+1 );      
        if (PreviousTime >= (CurrentTime - 30)) return;                            
        LastFewAgents = llDeleteSubList( LastFewAgents, AgentIndex, AgentIndex+1); 
    }
    LastFewAgents += [ WhomToTeleport, CurrentTime ];                             
    if (FunctionPermitted == "Yes")
        osTeleportAgent( WhomToTeleport, SimAddress, LandingPoint, LookAt );
    else
        llMapDestination(SimAddress, LandingPoint, LookAt); 
}

default
{
    state_entry()
    {
        LoadDestination();
        llVolumeDetect(FALSE);    // toggle bug fix in Opensim
        llVolumeDetect(TRUE);
        FunctionPermitted = "Yes";
    }
    
    changed(integer what)
    {
        if (what & CHANGED_REGION_START)
        {
             llResetScript();
        }
    }
    
     on_rez(integer start_param)
     {
        LoadDestination(); 
        FunctionPermitted = "Yes";
     }
 
}

state Running
{
    state_entry()
    {
        llOwnerSay( "Results: "+ FunctionPermitted);
        LoadDestination();
        llSetTextureAnim(ANIM_ON | LOOP, 1, 4, 4, 0.0, 16, 5);
        llSetText("", ZERO_VECTOR, 0);
    }
     
    dataserver(key queryId, string data) //turn gate black if destination is down
    {
        if (data=="up")  llSetColor(<1.000, 1.000, 1.000>,1);
        else llSetColor(<0.067, 0.067, 0.067>,1); 
    }

    touch_start(integer number)
    {    
        LoadDestination();  
    }

    collision(integer number)
    {    
        SpecialEffect();
        PerformTeleport( llDetectedKey( 0 ));  
    }

    changed(integer what)
    {
        if (what & CHANGED_REGION_START)
         {
             llResetScript();
         }
    }
}
// :CODE:
    
// :AUTHOR:Maria Korolov
// :DESCRIPTION: Hypergate script for Opensim
// :REVISION: 4
// :LICENSE: CC-0
// Maria Korolov's Hypergate script

integer Rev = 4;


key StatusQuery;     
integer FontSize;  

string SimName;
string SimAddress;
vector LandingPoint = <128.0, 128.0, 22.0>;
vector LookAt       = <1.0,1.0,1.0>;
 
list LastFewAgents; 

string FunctionName = "osTeleportAgent"; 
string FunctionPermitted = "No";
integer checked = 0;

SpecialEffect()
{    
        llPlaySound("d7a9a565-a013-2a69-797d-5332baa1a947", 1);    // change this to match your sim sound
        llParticleSystem([
            PSYS_PART_FLAGS, PSYS_PART_EMISSIVE_MASK,
            PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
            PSYS_SRC_MAX_AGE, 0.5,
            PSYS_PART_MAX_AGE, 1.0,
            PSYS_SRC_BURST_RATE, 0.01,
            PSYS_SRC_BURST_PART_COUNT, 50,
            PSYS_SRC_BURST_RADIUS, 0.3,
            PSYS_SRC_BURST_SPEED_MIN, 0.2,
            PSYS_SRC_BURST_SPEED_MAX, 3.0,
            PSYS_SRC_ACCEL, <0.0,0.0,0.0>,
            PSYS_PART_START_COLOR, <1, 1, 1>,
            PSYS_PART_START_ALPHA, 0.5,
            PSYS_PART_END_ALPHA, 0.0,
            PSYS_PART_START_SCALE, <0.3,0.3,0>,
            PSYS_PART_END_SCALE, <0.5,0.5,0>,
            PSYS_PART_FLAGS
                           , 0
                           | PSYS_PART_EMISSIVE_MASK
                           | PSYS_PART_INTERP_SCALE_MASK
                           ]); 
}

LoadDestination ()
{
    list Description = llParseString2List(llGetObjectDesc(), [", "],[","]);
    SimName = llList2String(Description,0);
    FontSize = (integer) (llStringLength(SimName)*(-2.25)+60.5);
    SimAddress = llList2String(Description,1);
    StatusQuery = llRequestSimulatorData(SimAddress, DATA_SIM_STATUS);
    string CommandList = ""; 
        CommandList = osMovePen( CommandList, 5, 55 );
        CommandList += "FontSize "+ (string) FontSize+";";
        CommandList = osDrawText( CommandList, SimName );
        osSetDynamicTextureDataBlendFace( "", "vector", CommandList, "width:256,height:256", FALSE, 2, 0, 255, 3 );
    
}

PerformTeleport( key WhomToTeleport )
{
    integer CurrentTime = llGetUnixTime();
    integer AgentIndex = llListFindList( LastFewAgents, [ WhomToTeleport ] );      
    if (AgentIndex != -1)                                                          
    {
        integer PreviousTime = llList2Integer( LastFewAgents, AgentIndex+1 );      
        if (PreviousTime >= (CurrentTime - 30)) return;                            
        LastFewAgents = llDeleteSubList( LastFewAgents, AgentIndex, AgentIndex+1); 
    }
    LastFewAgents += [ WhomToTeleport, CurrentTime ];                             
    if (FunctionPermitted == "Yes")
        osTeleportAgent( WhomToTeleport, SimAddress, LandingPoint, LookAt );
    else
        llMapDestination(SimAddress, LandingPoint, LookAt); 
}

default
{
    state_entry()
    {
        LoadDestination();
        llVolumeDetect(FALSE);    // toggle bug fix in Opensim
        llVolumeDetect(TRUE);
        FunctionPermitted = "Yes";
    }
    
    changed(integer what)
    {
        if (what & CHANGED_REGION_START)
        {
             llResetScript();
        }
    }
    
     on_rez(integer start_param)
     {
        LoadDestination(); 
        FunctionPermitted = "Yes";
     }
 
}

state Running
{
    state_entry()
    {
        llOwnerSay( "Results: "+ FunctionPermitted);
        LoadDestination();
        llSetTextureAnim(ANIM_ON | LOOP, 1, 4, 4, 0.0, 16, 5);
        llSetText("", ZERO_VECTOR, 0);
    }
     
    dataserver(key queryId, string data) //turn gate black if destination is down
    {
        if (data=="up")  llSetColor(<1.000, 1.000, 1.000>,1);
        else llSetColor(<0.067, 0.067, 0.067>,1); 
    }

    touch_start(integer number)
    {    
        LoadDestination();  
    }

    collision(integer number)
    {    
        SpecialEffect();
        PerformTeleport( llDetectedKey( 0 ));  
    }

    changed(integer what)
    {
        if (what & CHANGED_REGION_START)
         {
             llResetScript();
         }
    }
}
