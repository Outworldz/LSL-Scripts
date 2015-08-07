// :CATEGORY:Sculpt
// :NAME:SL_Sculpt_to_PHP_script
// :AUTHOR:Falados Kapuskas 
// :CREATED:2012-09-18 15:38:34.433
// :EDITED:2013-09-18 15:39:03
// :ID:790
// :NUM:1092
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Node: Node.lsl
// :CODE:
//    This file is part of OpenLoft.
//
//    OpenLoft is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    OpenLoft is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with OpenLoft.  If not, see <http://www.gnu.org/licenses/>.
//
//    Authors: Falados Kapuskas, JoeTheCatboy Freelunch

//-- CONSTANTS --//
integer NODE_CHANNEL;
integer BROADCAST_CHANNEL;
integer CHANNEL_MASK = 0xFFFFFF00;
integer CONTROL_POINT_MASK = 0xFF;
integer COMM_CHANNEL        = -2000;
integer SCALE_CHANNEL        = -2003;
list     NODE_SHAPE = [PRIM_TYPE,PRIM_TYPE_BOX,PRIM_HOLE_DEFAULT, <0,1,0>, 0.0, <0,0,0>, <1,1,0>, <0,0,0>];
list    CSECT_SHAPE = [PRIM_TYPE,PRIM_TYPE_SPHERE,PRIM_HOLE_DEFAULT, <0,1,0>, 0.0, <0,0,0>, <0,1,0>];
integer COLUMN;                //Set on_rez
integer ROW;                //Set on_rez
integer RETRY_COUNT            = 3;
float    MOVE_STEP            = 0.025;    //Move this much every step
float    MOVE_SEC            = 0.35; //Move ever X seconds
integer ACCESS_LEVEL=2;
integer ROWS;
integer COLUMNS;
//-- GLOBALS --//
key gRootDisk;
float gTravelTime;
vector gRootPos;
integer gRetry;
vector gOldPosition;
integer gListenHandle_Node;
integer gListenHandle_Comm;
integer gListenHandle_Broadcast;

//Get Color based on divisibility by 4
vector get_color(integer r, integer c)
{
    integer ASPECT_R = 1;
    integer ASPECT_C = 1;
    if(ROWS != 0) {
        if( ROWS < 32)
        {
            ASPECT_R = 32/ROWS;
        }
    }
    if(COLUMNS != 0)
    {
        if( COLUMNS < 32)
        {
            ASPECT_C = 32/COLUMNS;
        }
    }
    if( (r+2)*ASPECT_R % 4 == 0 && (c+2)*ASPECT_C % 4 == 0 ) return <1,0,0>;
    if( (r+1)*ASPECT_R % 2 == 0 && (c+1)*ASPECT_C % 2 == 0 ) return <0,1,0>;
    return <0,0,1>;
}

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

integer validCollision(key target,vector pos)
{
    if( llKey2Name(target) == llGetObjectName() ) return FALSE;
    if( llKey2Name(target) == "" ) return FALSE;
    list l = llGetBoundingBox(target);
    vector other_min = llList2Vector(l,0)+pos;
    vector other_max = llList2Vector(l,1)+pos;
    vector s = llGetScale();
    vector p = llGetPos();
    vector my_min = p - s*.5;
    vector my_max = p + s*.5;

    return     ( my_min.x < other_max.x ) && ( my_max.x > other_min.x ) &&
        ( my_min.y < other_max.y ) && ( my_max.y > other_min.y ) &&
            ( my_min.z < other_max.z ) && ( my_max.z > other_min.z );
}

parse_disk_info(string message)
{
    if(message == "#die#")
    {
        llDie();
        return;
    }
    list params = llCSV2List(message);
    string var;
    string val;
    while( params != [])
    {
        var = llList2String(params,0);
        val = llList2String(params,1);
        if(var == "al")
        {
            ACCESS_LEVEL = (integer)val;
        }
        if(var == "rw")
        {
            ROWS = (integer)val;
        }
        if(var == "cl")
        {
            COLUMNS = (integer)val;
        }
        if(var == "bc")
        {
            BROADCAST_CHANNEL = (integer)val;
            llListenRemove(gListenHandle_Broadcast);
            gListenHandle_Broadcast = llListen(BROADCAST_CHANNEL,"","","");
        }
        params = llDeleteSubList(params,0,1);
    }
}

default
{

    on_rez(integer param) {
        if(!param) return;
        NODE_CHANNEL = (param & CHANNEL_MASK);
        gListenHandle_Node = llListen(NODE_CHANNEL, "","","");
        COLUMN = param & CONTROL_POINT_MASK;
        llSetTimerEvent(30.0);
    }
    listen(integer channel, string name, key id, string message)
    {
        if( llGetOwnerKey(id) != llGetOwner()) return;
        parse_disk_info(message);
        ROW = (integer)llGetSubString(name,llSubStringIndex(name,":")+1,-1);
        llSetObjectName( "node:" + (string)ROW + "-" + (string)COLUMN );
        gRootDisk = id;
        state link_nodes;
    }
    timer() { llDie(); }
}

state link_nodes {
    state_entry() {
        llSleep(0.1);
        llSensor( "node:" + (string)ROW + "-" + (string)((COLUMN + 1) % COLUMNS),"",SCRIPTED,10.0,TWO_PI);
    }
    sensor(integer i) {
        particleBeam(llDetectedKey(0));
        state active;
    }
    no_sensor()
    {
        state active;
    }
}

state active {
    on_rez(integer p) { llDie(); }
    state_entry()
    {
        llSetScale(<1,1,1>*0.06);
        llSetColor(get_color(ROW,COLUMN),ALL_SIDES);
        llSetPrimitiveParams(NODE_SHAPE);
        gListenHandle_Node = llListen(NODE_CHANNEL,"",gRootDisk,"");
        gListenHandle_Broadcast = llListen(BROADCAST_CHANNEL,"","","");
        gListenHandle_Comm = llListen(COMM_CHANNEL,"","","");
        llSetTimerEvent(3.0);
    }

    listen(integer channel, string name, key id, string message)
    {
        if( llGetOwnerKey(id) != llGetOwner() ) return;

        if( message == "#show#") llSetAlpha(1.0,ALL_SIDES);
        if( message == "#hide#") llSetAlpha(0.0,ALL_SIDES);
        if( message == "#csect#") {
            gOldPosition = llGetPos();
            gRetry = RETRY_COUNT;
            state csect;
        }
        if( message == "#die#" )
        {
            llDie();
        }
        if( channel == NODE_CHANNEL )
        {
            parse_disk_info(message);
        }
    }
    timer() {
        if ( llGetObjectMass(gRootDisk) == 0.0 ) llDie();
    }
}

state csect
{
    state_entry()
    {
        gListenHandle_Node = llListen(NODE_CHANNEL,"",gRootDisk,"");
        gListenHandle_Broadcast = llListen(BROADCAST_CHANNEL,"","","");
        gTravelTime = llVecMag(gRootPos - llGetPos())*MOVE_SEC/MOVE_STEP; //Avoid the nasty infinite loop by limiting the seek time
        llSetScale(<1,1,1>*0.1);
        llResetTime();
        llSetPrimitiveParams(CSECT_SHAPE);
        llSetStatus(STATUS_PHANTOM,TRUE);
        llVolumeDetect(TRUE);
        llSetTimerEvent(MOVE_SEC);
        gRootPos = llList2Vector( llGetObjectDetails(gRootDisk,[OBJECT_POS]),0);
    }
    state_exit()
    {
        llVolumeDetect(FALSE);
        llSetStatus(STATUS_PHANTOM,TRUE);
    }
    listen(integer channel, string name, key id, string message)
    {
        if( llGetOwnerKey(id) != llGetOwner() ) return;
        if( message == "#die#" )
        {
            llDie();
        }
    }
    timer() {
        vector p = llVecNorm(gRootPos - llGetPos());
        llSetPos(llGetPos() + p*MOVE_STEP);
        if( llVecMag(gRootPos - llGetPos()) <= MOVE_STEP * 2 || llGetTime() > gTravelTime*1.2 )
        {
            llSetPos(gOldPosition);
            llResetTime();
            --gRetry;
            if( gRetry <= 0) {
                state active;
            }
        }
    }
    collision_end(integer total_number)
    {
        if(validCollision(llDetectedKey(0),llDetectedPos(0)))
            state active;
    }
    collision_start(integer total_number)
    {
        if(validCollision(llDetectedKey(0),llDetectedPos(0)))
            state active;
    }
}
