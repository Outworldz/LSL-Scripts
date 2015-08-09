// :CATEGORY:Sculpt
// :NAME:SL_Sculpt_to_PHP_script
// :AUTHOR:Falados Kapuskas 
// :CREATED:2012-09-18 15:38:34.433
// :EDITED:2013-09-18 15:39:03
// :ID:790
// :NUM:1082
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// control.lsl
// :CODE:
integer CHANNEL_MASK = 0xFFFFFF00;
integer CONTROL_POINT_MASK = 0xFF;
integer BROADCAST_CHANNEL;
integer CONTROL_POINT_NUM;
integer ACCESS_LEVEL;

integer MAX_CONTROL_POINTS;
integer MAX_INTER_POINTS;

integer gListenHandle;
integer gPointType;

//Shoot a beam of particles from one node to the next
particleBeam(key target)
{
    if( target)
        llParticleSystem([
            PSYS_PART_FLAGS,
        PSYS_PART_EMISSIVE_MASK|
        PSYS_PART_FOLLOW_VELOCITY_MASK|
        PSYS_PART_TARGET_LINEAR_MASK|
        PSYS_PART_TARGET_POS_MASK|
        PSYS_PART_WIND_MASK,
        PSYS_SRC_PATTERN,PSYS_SRC_PATTERN_ANGLE,
        PSYS_SRC_BURST_RADIUS,0.000000,
        PSYS_SRC_ANGLE_BEGIN,0.000000,
        PSYS_SRC_TARGET_KEY,target,
        PSYS_PART_START_COLOR,<1.000000, 1.000000, 1.000000>,
        PSYS_PART_START_ALPHA,1.000000,
        PSYS_PART_START_SCALE,<0.050000, 0.100000, 0.000000>,
        PSYS_SRC_TEXTURE,"5748decc-f629-461c-9a36-a35a221fe21f",
        PSYS_PART_MAX_AGE,1.000000,
        PSYS_SRC_BURST_RATE,0.1,
        PSYS_SRC_BURST_PART_COUNT,1
            ]);
    else llParticleSystem([]);
}
processRootCommands(string message)
{
    if( llSubStringIndex(message,"#ctrl#") == 0 )
    {
        list parameters = llCSV2List( llGetSubString(message,6,-1));
        MAX_CONTROL_POINTS = llGetListLength(parameters);
        CONTROL_POINT_NUM = llListFindList(parameters,[(string)llGetKey()]);
        if( CONTROL_POINT_NUM == -1) llDie();
        if(CONTROL_POINT_NUM == 0 || CONTROL_POINT_NUM == MAX_CONTROL_POINTS-1 || gPointType == 1)
        {
            state anchor_point_loop;
        } else {
                state control_point_loop;
        }
    }
    if( llSubStringIndex(message,"#setup#") == 0)
    {
        list l = llCSV2List(llGetSubString(message,7,-1));
        ACCESS_LEVEL = (integer)llList2String(l,1);
    }
    if( llSubStringIndex(message,"#anchors#") == 0)
    {
        list parameters = llCSV2List( llGetSubString(message,9,-1));
        integer anchor = llListFindList(parameters,[(string)llGetKey()]);
        if(CONTROL_POINT_NUM == 0 || CONTROL_POINT_NUM == MAX_CONTROL_POINTS-1 || anchor != -1)
        {
            state anchor_point_loop;
        } else {
                state control_point_loop;
        }
    }
    if( message == "#die#") { llDie(); }
}

//Get Access Allowed/Denited
integer has_access(key agent)
{
    //Everyone has access
    if(ACCESS_LEVEL == 0) return TRUE;
    else
        //Owner has access
        if(ACCESS_LEVEL == 2)
        {
            return agent == llGetOwner();
        }
    else
        //Group has access
        if(ACCESS_LEVEL == 1)
        {
            return llSameGroup(agent);
        }
    //Failed
    return FALSE;
}

default
{
    on_rez(integer i)
    {
        BROADCAST_CHANNEL = (i & CHANNEL_MASK);
        gListenHandle = llListen(BROADCAST_CHANNEL, "","","");
        CONTROL_POINT_NUM = i & CONTROL_POINT_MASK;
        llSetObjectDesc((string)CONTROL_POINT_NUM);
        llSetText(llGetObjectDesc(),<1,1,1>,1.0);
    }
    listen(integer channel, string name, key id, string message)
    {
        processRootCommands(message);
    }
    sensor(integer n)
    {
        integer i;
        integer num;
        for(i = 0; i < n; ++i)
        {
            num = llList2Integer(llGetObjectDetails(llDetectedKey(i),[OBJECT_DESC]),0);
            if( num == CONTROL_POINT_NUM + 1)
            {
                particleBeam(llDetectedKey(i));
                return;
            }
        }
    }
}

state control_point_loop {
    state_entry() { state control_point;}
}
state control_point
{
    state_entry()
    {
        gPointType=0;
        llSetColor(<1,0,0>,-1);
        gListenHandle = llListen(BROADCAST_CHANNEL, "","","");
        llSetObjectName("control");
    }
    listen(integer channel, string name, key id, string message)
    {
        processRootCommands(message);
    }
    touch_end(integer i)
    {
        if(!has_access(llDetectedKey(0))) return;
        state anchor_point;
    }
}
state anchor_point_loop {
    state_entry() { state anchor_point;}
}
state anchor_point
{
    state_entry()
    {
        gPointType=1;
        llSetColor(<0,0,1>,-1);
        gListenHandle = llListen(BROADCAST_CHANNEL, "","","");
        llSetObjectName("anchor");
    }
    listen(integer channel, string name, key id, string message)
    {
        processRootCommands(message);
    }
    touch_end(integer i)
    {
        if(!has_access(llDetectedKey(0))) return;
        if(CONTROL_POINT_NUM == 0 || CONTROL_POINT_NUM == MAX_CONTROL_POINTS-1)
        {
            return;
        }
        state control_point;


    }
}
