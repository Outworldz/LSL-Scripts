// :SHOW:
// :CATEGORY:HyperGate
// :NAME:Hyperica Hypergate
// :AUTHOR:Laxton Consulting for Maria Korolov
// :KEYWORDS:
// :CREATED:2015-03-08 23:52:12
// :EDITED:2015-03-08  22:52:12
// :ID:1070
// :NUM:1726
// :REV:5.1
// :WORLD:OpenSim
// :DESCRIPTION:
// Excellent Hypergate Script with Detection of destination and ossL command sets
// :CODE:
//:Rev: 5.1


/////////////////////////////////////////////////////////////////////////////////
// Rev 5.0 by Laxton Consulting for Maria Korolov
//    added/edited debug messages
//	  reduced default state to initialize
//    changed CHANGED_REGION_START to CHANGED_REGION_RESTART
//    changed FunctionPermitted to FunctionAvailable
//    added FunctionPermitted list to check OSSL 
//	  added code to set FunctionAvailable mode of operation
//    added state Checking
//	  changed state Running
//    implemented timer termination scheme
/////////////////////////////////////////////////////////////////////////////////
// rev 5.1 by Ferd Frederix
// Bool, and Integer cannot be compared in some worlds
// llListFindList compares lists, not list and string.

integer debug = FALSE;        // set to TRUE for DEBUG messages

/////////////////////////////////////////////////////////////////////////////////
// Changing anything below this line will risk breaking the script

DEBUG (string msg) { if (debug) llOwnerSay(llGetScriptName() + ":" + msg);}

integer WhichCheckFunction; 
integer NumberOfFunctionsToCheck;
list FunctionNames = [ "osTeleportAgent", "osKey2Name"];
list FunctionPermitted = []; // 0 = not permitted, 1 = permitted
 
integer isFunctionAvailable( string whichFunction )
{
    integer index = llListFindList( FunctionNames, [whichFunction] );
    if (index == -1) return 0;
    return llList2Integer( FunctionPermitted, index );
}

integer Rev = 5;
key httpkey;
string body_retrieved; 
key StatusQuery;     
integer FontSize;  

string SimName;
string SimAddress;
vector LandingPoint = <128.0, 128.0, 22.0>; 
vector LookAt       = <1.0,1.0,1.0>; 

list LastFewAgents; 

string FunctionName = "osTeleportAgent"; 
string FunctionAvailable = "No";
integer checked = 0;

SpecialEffect()
{    
        llPlaySound("d7a9a565-a013-2a69-797d-5332baa1a947", 1);
        llParticleSystem([
            PSYS_PART_FLAGS, PSYS_PART_EMISSIVE_MASK,
            PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
            PSYS_SRC_MAX_AGE, 0.5,
            PSYS_PART_MAX_AGE, 1.0,
            PSYS_SRC_BURST_RATE, .01,
            PSYS_SRC_BURST_PART_COUNT, 50,
            PSYS_SRC_BURST_RADIUS, .3,
            PSYS_SRC_BURST_SPEED_MIN, .2,
            PSYS_SRC_BURST_SPEED_MAX, 3.0,
            PSYS_SRC_ACCEL, <0.0,0.0,0.0>,
            PSYS_PART_START_COLOR, <1, 1, 1>,
            PSYS_PART_START_ALPHA, 0.5,
            PSYS_PART_END_ALPHA, 0.0,
            PSYS_PART_START_SCALE, <.3,.3,0>,
            PSYS_PART_END_SCALE, <.5,.5,0>,
            PSYS_PART_FLAGS
                           , 0
                           | PSYS_PART_EMISSIVE_MASK
                           | PSYS_PART_INTERP_SCALE_MASK
                           ]); 
}

LoadDestination ()
{
	SimName=llGetObjectName();
	SimAddress=llGetObjectDesc();
    FontSize = (integer) (llStringLength(SimName)*(-2.25)+60.5);
    FontSize = ((integer) (FontSize >= 10 ) * FontSize ) + ((integer)(FontSize<10 ) * 10); 
    FontSize = ((integer) (FontSize <= 40 ) * FontSize ) + ((integer)(FontSize>40 ) * 40);
    DEBUG ("Object Name is "+SimName + " with font size of " + (string) FontSize);
    DEBUG ("Object Address is "+SimAddress);
    StatusQuery = llRequestSimulatorData(SimAddress, DATA_SIM_STATUS);
    string CommandList = ""; 
        CommandList = osMovePen( CommandList, 5, 55 );
        CommandList += "FontSize "+ (string) FontSize+";";
        CommandList = osDrawText( CommandList, SimName );
        osSetDynamicTextureDataBlendFace( "", "vector", CommandList, "width:256,height:256", FALSE, 2, 0, 255, 3 );
    DEBUG("CommandList is "+CommandList);
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
    if (FunctionAvailable == "Yes")
        osTeleportAgent( WhomToTeleport, SimAddress, LandingPoint, LookAt );
    else
        llMapDestination(SimAddress, LandingPoint, LookAt); 
}

default //initializes the gate
{
    state_entry()
    {
        DEBUG("default state_entry");
        LoadDestination(); // load destination in case we changed it on the gate and reset the script manually
        llVolumeDetect(TRUE);
        state Checking;
    }
    
    changed(integer what)
    {
        if (what & CHANGED_REGION_RESTART)
         {
             DEBUG("detected region restart, resetting...");
             llVolumeDetect(FALSE);    // toggle bug fix in Opensim
             llVolumeDetect(TRUE);
             llResetScript();
         }
    }
    
    on_rez(integer start_param)
    {
        LoadDestination(); // initial load may be empty fields
    }
}

state Checking // checks to see whether we are able to use osTeleportAgent
{
    state_entry()
    {
        NumberOfFunctionsToCheck = llGetListLength( FunctionNames );
        WhichCheckFunction = -1;
        llSetTimerEvent( 0.25 ); // runs one time for each OSSL function check in FunctionPermitted list
    }

    timer()
    {
        string s;
        key key1;
        if (++WhichCheckFunction == NumberOfFunctionsToCheck) 
        {
            llSetTimerEvent( 0.0 ); // disable timer
            state Running;
        }
        DEBUG( "Checking function " + llList2String( FunctionNames, WhichCheckFunction ));
        if (WhichCheckFunction == 0) osTeleportAgent(key1,ZERO_VECTOR,ZERO_VECTOR);
        else if (WhichCheckFunction == 1) s=osKey2Name(key1); 
        FunctionPermitted = llListReplaceList( FunctionPermitted, [ 1 ], WhichCheckFunction, WhichCheckFunction );
        llSetTimerEvent( 0.25 ); // restarts timer to check next OSSL function in FunctionPermitted list
    }
}

state Running
{
    state_entry()
    {
        DEBUG("state Running");
        string s = "These OSSL functions are available: ";
        string t = "These OSSL functions are not available: ";
        integer i = llGetListLength( FunctionNames );
        while (i--)
            if (llList2Integer( FunctionPermitted, i )) s += llList2String( FunctionNames, i ) + " ";
            else t += llList2String( FunctionNames, i ) + " ";
            DEBUG( s );
            DEBUG( t );
        if (isFunctionAvailable( "osTeleportAgent" )) FunctionAvailable="Yes"; // sets FunctionAvailable for mode of gate operation
        else FunctionAvailable="No";
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
        LoadDestination(); // load destination 
    }

    collision(integer number)
    {    
        SpecialEffect();
        PerformTeleport( llDetectedKey( 0 ));  
    }
    changed(integer what)
    {
        if (what & CHANGED_REGION_RESTART)
         {
             DEBUG("detected region restarted, resetting VolumeDetect");
             llVolumeDetect(FALSE);    // toggle bug fix in Opensim
             llVolumeDetect(TRUE);
             llResetScript();
         }
    }
}
