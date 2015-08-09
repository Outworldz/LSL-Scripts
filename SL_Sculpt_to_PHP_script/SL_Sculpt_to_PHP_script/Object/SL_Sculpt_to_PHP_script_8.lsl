// :CATEGORY:Sculpt
// :NAME:SL_Sculpt_to_PHP_script
// :AUTHOR:Falados Kapuskas 
// :CREATED:2012-09-18 15:38:34.433
// :EDITED:2013-09-18 15:39:03
// :ID:790
// :NUM:1086
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Sculpt: State Control.lsl
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
integer BROADCAST_CHANNEL;
integer CHANNEL_MASK = 0xFFFFFF00;
integer CONTROL_POINT_MASK = 0xFF;
integer ACCESS_LEVEL        = 2;    //2 = OWNER, 1 = GROUP, 0 = ALL
integer MY_ROW;            //Set on_rez
integer ROWS;
integer COLUMNS;

//SculptTypes
integer SCULPT_POINT    = 0;
integer SCULPT_DISK        = 1;
integer SCULPT_NODE        = 2;

//LinkCommands
integer COMMAND_CTYPE       = -1;
integer COMMAND_RESET       = -2;
integer COMMAND_SCALE       = -3;
integer COMMAND_LERP        = -4;
integer COMMAND_RENDER      = -5;
integer COMMAND_CSECT       = -6;
integer COMMAND_NODES       = -7;
integer COMMAND_SPAWNSHAPE  = -11;
integer COMMAND_SETUP_PARAMS= -12;

//-- GLOBALS --//
integer gListenHandle_Broadcast;
integer gListenHandle_Dialog;
vector gScale;
vector gLastColor;
integer gSculptType;
integer gSpawnShape;
integer gListenHandle;

//-- DIALOGS ---//
list DISK_DIALOG = [
    "[EDIT] Edit the verticies","EDIT",
    "[POINT] Transform into a point","POINT",
    "[SQUARE] Transform into a square","SQUARE",
    "[CIRCLE] Transform into a Circle","CIRCLE",
    "[RESET] Reset modified verticies to default","RESET"
        ];

list NODE_DIALOG = [
    "[SAVE] - Save the custom verticies back into the shape","SAVE",
    "[CSECT] Attempt to collide with physical objects penetrating the disk","CSECT"
        ];

list POINT_DIALOG = [
    "[EXPAND] Expand back into a disk","EXPAND"
        ];


//-- FUNCTIONS --//

dialog(string message, list dialog, key id, integer channel)
{
    llListenRemove(gListenHandle_Dialog);
    gListenHandle_Dialog = llListen(channel,"",id,"");
    string m = message + llDumpList2String( llList2ListStrided(dialog,0,-1,2) , "\n");
    llDialog(id,m,llList2ListStrided( llDeleteSubList(dialog,0,0), 0,-1,2),channel);
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

//Get LOD Color
vector get_color(integer r)
{
    integer ASPECT_R = 1;
    if(ROWS < 32 && ROWS != 0)
    {
        ASPECT_R = 32/ROWS;
    }
    if( (r+2)*ASPECT_R % 4 == 0) return <1,0,0>;
    if( (r+1)*ASPECT_R % 2 == 0) return <0,1,0>;
    return <0,0,1>;
}

//Shoot a beam of particles from one disk center to the next
particleBeam(key target)
{
    if( target)
        llParticleSystem([
            PSYS_PART_FLAGS,
        PSYS_PART_EMISSIVE_MASK|
        PSYS_PART_FOLLOW_VELOCITY_MASK|
        PSYS_PART_FOLLOW_SRC_MASK|
        PSYS_PART_TARGET_POS_MASK,
        PSYS_PART_MAX_AGE, 1.0,
        PSYS_PART_START_ALPHA,0.99,
        PSYS_PART_START_COLOR,<1,1,1>,
        PSYS_PART_START_SCALE,<1,1,1>*0.2,
        PSYS_SRC_BURST_RADIUS,0.0,
        PSYS_SRC_BURST_RATE,0.1,
        PSYS_SRC_BURST_PART_COUNT,1,
        PSYS_SRC_PATTERN,PSYS_SRC_PATTERN_DROP,
        PSYS_SRC_TARGET_KEY,target,
        PSYS_SRC_TEXTURE,"cce0f112-878f-4586-a2e2-a8f104bba271" //White Dot
            ]);
    else llParticleSystem([]);
}

//Sets the shape of the prim depending on the type
setShape(vector color)
{
    vector DEFAULT_COLOR = get_color(MY_ROW);
    gLastColor = color;
    if( gSculptType == SCULPT_POINT ) {
        llSetPrimitiveParams([
            PRIM_TYPE,PRIM_TYPE_SPHERE,PRIM_HOLE_DEFAULT ,<0,1,0>,0.0,<0,0,0>,<0,1,0>,
            PRIM_TEXTURE,ALL_SIDES,"5748decc-f629-461c-9a36-a35a221fe21f", <1,1,0>, <0,0,0>, 0,
            PRIM_COLOR,ALL_SIDES,DEFAULT_COLOR,1.0,
            PRIM_SIZE,<.05,.05,.05>
                ]);
    }
    if(gSpawnShape == 0 && gSculptType == SCULPT_DISK) {
        llSetPrimitiveParams([
            PRIM_TYPE,PRIM_TYPE_CYLINDER, PRIM_HOLE_DEFAULT, <0,1,0>, 0.0, <0,0,0>, <1,1,0>, <0,0,0>,
            PRIM_TEXTURE,0,"2cc5dcb6-595d-cbb9-e559-7d9e78270f2c", <1,1,0>, <0,0,0>, -PI_BY_TWO,
            PRIM_TEXTURE,1,"5748decc-f629-461c-9a36-a35a221fe21f", <1,1,0>, <0,0,0>, 0,
            PRIM_TEXTURE,2,"2cc5dcb6-595d-cbb9-e559-7d9e78270f2c", <1,1,0>, <0,0,0>, -PI_BY_TWO,
            PRIM_COLOR,0,color,1.0,
            PRIM_COLOR,1,DEFAULT_COLOR,1.0,
            PRIM_COLOR,2,color*.5,1.0,
            PRIM_SIZE,gScale
                ]);
    }
    if(gSpawnShape == 1 || gSculptType == SCULPT_NODE) {
        llSetPrimitiveParams([
            PRIM_TYPE,PRIM_TYPE_BOX,PRIM_HOLE_DEFAULT,<0, 1, 0>, 0, <0, 0, 0>, <1, 1, 0>, <0, 0, 0>,
            PRIM_TEXTURE,0,"2cc5dcb6-595d-cbb9-e559-7d9e78270f2c", <1, 1, 0>, <0, 0, 0>, -PI_BY_TWO,
            PRIM_TEXTURE,1,"5748decc-f629-461c-9a36-a35a221fe21f", <1, 1, 0>, <0, 0, 0>, 0,
            PRIM_TEXTURE,2,"5748decc-f629-461c-9a36-a35a221fe21f", <1, 1, 0>, <0, 0, 0>, 0,
            PRIM_TEXTURE,3,"5748decc-f629-461c-9a36-a35a221fe21f", <1, 1, 0>, <0, 0, 0>, 0,
            PRIM_TEXTURE,4,"5748decc-f629-461c-9a36-a35a221fe21f", <1, 1, 0>, <0, 0, 0>, 0,
            PRIM_TEXTURE,5,"2cc5dcb6-595d-cbb9-e559-7d9e78270f2c", <1, 1, 0>, <0, 0, 0>, -PI_BY_TWO,
            PRIM_COLOR,0,color, .9,
            PRIM_COLOR,1,DEFAULT_COLOR, .9,
            PRIM_COLOR,2,DEFAULT_COLOR, .9,
            PRIM_COLOR,3,DEFAULT_COLOR, .9,
            PRIM_COLOR,4,DEFAULT_COLOR, .9,
            PRIM_COLOR,5,color*.5, .9,
            PRIM_SIZE,gScale
                ]);
    }
}

list params(string command, string message)
{
    if(llStringLength(command) == llStringLength(message)) return [];
    return llCSV2List(llGetSubString(message,llStringLength(command),-1));
}

integer handleRootCommand(string message) {
    integer s = gSculptType;
    list params;
    if( message == "#die#") { llDie(); }
    if( llSubStringIndex(message,"#die#") == 0)
    {
        params = params("#die#",message);
        if( MY_ROW == llList2Integer(params,0) ) llDie();
    }
    if(parse_setup_string(message)) return s;
    if( llSubStringIndex(message,"#lerp#") == 0)
    {
        llMessageLinked(LINK_THIS,COMMAND_LERP,llList2CSV(params("#lerp#",message)),"#lerp#");
    }
    if( llSubStringIndex(message,"#render#") == 0 ) { llMessageLinked(LINK_THIS,COMMAND_RENDER,llGetSubString(message,8,-1),""); }
    if( message == "#show#" ) { llSetAlpha(1.0,ALL_SIDES); }
    if( message == "#hide#" ) { llSetAlpha(0.0,ALL_SIDES); }
    if( llSubStringIndex(message,"#enclose#") == 0) { llMessageLinked(LINK_THIS,COMMAND_SCALE,llGetSubString(message,9,-1),""); }
    return s;
}

integer parse_setup_string(string message)
{
    if( llSubStringIndex(message,"#setup#") == 0)
    {
        list l = llCSV2List(llGetSubString(message,7,-1));
        COLUMNS = (integer)llList2String(l,0);
        ACCESS_LEVEL = (integer)llList2String(l,1);
        ROWS = (integer)llList2String(l,2);
        return TRUE;
    }
    return FALSE;
}

//-- STATES --//

default
{
    on_rez(integer param)
    {
        if (!param) return;
        BROADCAST_CHANNEL = (param & CHANNEL_MASK);
        gListenHandle = llListen(BROADCAST_CHANNEL, "","","");
        MY_ROW = param & CONTROL_POINT_MASK;

        gSculptType = SCULPT_DISK;
        gScale = <0.5,0.5,0.05>;
        llSetObjectName("sculpt:" + (string)MY_ROW);
        setShape(<1,1,1>);
        llListen(BROADCAST_CHANNEL,"","","");
    }
    state_entry() {
        gSculptType = SCULPT_DISK;
        if( gScale != ZERO_VECTOR) setShape(<1,1,1>);
    }
    listen( integer channel, string name, key id, string message )
    {
        if( !has_access(llGetOwnerKey(id)) ) return;
        //Establishes Link between the loft-root and this disk
        if(channel == BROADCAST_CHANNEL)
        {
            if(parse_setup_string(message))
            {
                state link_disks;
            }
        }
    }
}

//Links a particle beam between the disks
state link_disks {
    state_entry() {
        //ROW 32 *should* trigger no_sensor
        llSensor("sculpt:" + (string)(MY_ROW+1),"",SCRIPTED,10.0,TWO_PI);
    }
    sensor(integer total_number)
    {
        particleBeam(llDetectedKey(0));
        if(gSculptType == SCULPT_POINT) state point;
        else state disk;
    }
    no_sensor() {
        if(gSculptType == SCULPT_POINT) state point;
        else state disk;
    }
}

//Handles Actions in the POINT state

state point {
    state_entry() {
        gSculptType=SCULPT_POINT;
        setShape(ZERO_VECTOR);
        llMessageLinked(LINK_THIS,COMMAND_CTYPE,(string)SCULPT_POINT,"");
        llListen(BROADCAST_CHANNEL,"","","");
    }
    listen( integer channel, string name, key id, string message)
    {
        if( channel == BROADCAST_CHANNEL ) {
            integer i = handleRootCommand(message);
            if( i != gSculptType ) {
                if( i == SCULPT_NODE ) state nodes;
                if( i == SCULPT_POINT ) state point;
            }
            return;
        }
        llListenRemove(gListenHandle_Dialog);
        if( message == "EXPAND" ) {
            state disk;
        }
    }
    touch_start(integer n) {
        if( !has_access(llDetectedKey(0)) ) return;
        if( llGetLinkNumber() == 0) { //Not Linked
            integer a = (integer)llFrand(-100000);
            dialog("Pick an action for Row "  + (string)MY_ROW + "\n",POINT_DIALOG,llDetectedKey(0),a);
        }
    }
    link_message(integer sender_number, integer num, string str, key id)
    {
        if( (string)id == "recolor" ) {
            setShape((vector)str);
        }
    }
}
state disk {
    state_entry() {
        llListen(BROADCAST_CHANNEL,"","","");
        gSculptType=SCULPT_DISK;
        setShape(<1,1,1>);
        llMessageLinked(LINK_THIS,COMMAND_CTYPE,(string)SCULPT_DISK,"");
    }
    state_exit()
    {
        gScale = llGetScale();
    }
    touch_start(integer n) {
        if( !has_access(llDetectedKey(0)) ) return;
        if( llGetLinkNumber() == 0) { //Not Linked
            integer a = (integer)llFrand(-100000);
            dialog("Pick an action for Row "  + (string)MY_ROW + "\n",DISK_DIALOG,llDetectedKey(0),a);
        }
    }
    listen( integer channel, string name, key id, string message)
    {
        if( channel == BROADCAST_CHANNEL ) {
            integer i = handleRootCommand(message);
            if( i != gSculptType ) {
                if( i == SCULPT_NODE ) state nodes;
                if( i == SCULPT_POINT ) state point;
            }
            return;
        }
        llListenRemove(gListenHandle_Dialog);
        if( message == "EDIT" ) {
            state nodes;
        }
        if( message == "POINT" ) {
            state point;
        }
        if( message == "RESET" ) {
            llMessageLinked(LINK_THIS, COMMAND_RESET,"","");
        }
        if( message == "SQUARE")
        {
            gSpawnShape = 1;
            llMessageLinked(LINK_SET,COMMAND_SPAWNSHAPE,(string)gSpawnShape,"");
            setShape(gLastColor);
        }
        if( message == "CIRCLE")
        {
            gSpawnShape = 0;
            llMessageLinked(LINK_SET,COMMAND_SPAWNSHAPE,(string)gSpawnShape,"");
            setShape(gLastColor);
        }
    }
    link_message(integer sender_number, integer num, string str, key id)
    {
        if( (string)id == "recolor" ) {
            gScale = llGetScale();
            setShape((vector)str);
        }
    }
}

//Handles actions for the NODE state
//Will Revert back to DISK if anything happens
state nodes {
    state_entry() {
        gSculptType=SCULPT_NODE;
        setShape(<1,1,1>);
        llMessageLinked(LINK_THIS,COMMAND_CTYPE,(string)SCULPT_NODE,"");
        llListen(BROADCAST_CHANNEL,"","","");
    }
    touch_start(integer n) {
        if( !has_access(llDetectedKey(0)) ) return;
        if( llGetLinkNumber() == 0) { //Not Linked
            integer a = (integer)llFrand(-100000);
            dialog("Pick an action for Row "  + (string)MY_ROW + "\n",NODE_DIALOG,llDetectedKey(0),a);
        }
    }
    state_exit()
    {
        gScale = llGetScale();
    }
    //Node Actions
    listen( integer channel, string name, key id, string message)
    {
        if( channel == BROADCAST_CHANNEL ) {
            integer i = handleRootCommand(message);
            if( i != gSculptType ) {
                if( i == SCULPT_NODE ) state nodes;
                if( i == SCULPT_POINT ) state point;
            }
            return;
        }
        llListenRemove(gListenHandle_Dialog);
        if( message == "SAVE" ) {
            state disk;
        }
        if( message == "CSECT" ) {
            llMessageLinked(LINK_SET,COMMAND_CSECT,"","");
        }
    }

    link_message( integer send_num, integer num, string str, key id)
    {
        if( (string)id == "recolor" ) {
            gScale = llGetScale();
            setShape((vector)str);
        }
        if( num == -5 ) {
            if( str == "disk" ) {
                state disk;
            }
        }
    }
    //Collapse All Children if this becomes ROOT
    //If they have verticies outside of the disk, they
    //are instantly attached
    changed( integer i )
    {
        if( llGetLinkNumber() == LINK_ROOT) {
            llMessageLinked(LINK_ALL_OTHERS, -5, "disk","");
            state disk;
        }
    }
}
