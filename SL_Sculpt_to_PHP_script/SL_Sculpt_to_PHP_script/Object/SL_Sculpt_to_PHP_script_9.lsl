// :CATEGORY:Sculpt
// :NAME:SL_Sculpt_to_PHP_script
// :AUTHOR:Falados Kapuskas 
// :CREATED:2012-09-18 15:38:34.433
// :EDITED:2013-09-18 15:39:03
// :ID:790
// :NUM:1087
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Sculpt: Node Control.lsl
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
integer NODE_CHANNEL;
integer CHANNEL_MASK = 0xFFFFFF00;
integer CONTROL_POINT_MASK = 0xFF;
integer LERP_CHANNEL;
integer ENCLOSE_CHANNEL = -1;
integer MY_ROW;            //Set on_rez
integer COLUMNS             = 32;
integer ROWS                = 32;
integer ACCESS_LEVEL        = 2;
//Actions
integer SPAWN_NODES         = 0;
integer ATTACH_VERTS        = 1;
integer SEND_NODES          = 2;
integer RESET_VERTS         = 3;
integer SEND_SCALE          = 4;
//SculptTypes
integer SCULPT_POINT        = 0;
integer SCULPT_DISK         = 1;
integer SCULPT_NODE         = 2;
//LinkCommands
integer COMMAND_CTYPE       = -1;
integer COMMAND_RESET       = -2;
integer COMMAND_SCALE       = -3;
integer COMMAND_LERP        = -4;
integer COMMAND_RENDER      = -5;
integer COMMAND_CSECT       = -6;
integer COMMAND_NODES       = -7;
integer COMMAND_INTERP      = -8;
integer COMMAND_COPY        = -9;
integer COMMAND_SENDNODES   = -10;
integer COMMAND_SPAWNSHAPE  = -11;
integer COMMAND_SETUP_PARAMS= -12;

//-- GLOBALS --//
vector gScale;
vector gPosition;
rotation gRotation;
list gRezedNodes;
list gNodeInfo=[];
integer gSculptType;
integer gSpawnShape=0;
integer gListenHandle;
integer gListenHandle_Lerp;
integer gListenHandle_Copy;

//For Interpolation
vector gRootScale;
rotation gRootRot;
list gRootNodes;

//-- FUNCTIONS --//

// Performs actions using a common status notifier
performAction(integer action) {
    vector color = llGetColor(0);
    llMessageLinked(LINK_THIS,0,"<1,1,0>","recolor");
    gPosition = llGetPos();
    gRotation = llGetRot();
    gScale = llGetScale();
    if( action == SPAWN_NODES )
    {
        llSetText("Spawning Nodes\n"+(string)MY_ROW,<1,1,0>,1);
        spawnNodes();
    }
    if( action == ATTACH_VERTS )
    {
        llSetText("Attaching Verticies\n"+(string)MY_ROW,<1,1,0>,1);
        gNodeInfo = [];
        storeNodeInfo();
        rescale();
        gNodeInfo = [];
        gPosition = llGetPos();
        gScale = llGetScale();
        announce_nodes();
    }
    if( action == SEND_NODES )
    {
        llSetText("Sending Nodes\n"+(string)MY_ROW,<1,1,0>,1);
        sendNodes();
    }
    if( action == RESET_VERTS )
    {
        llSetText("Resetting Verticies\n"+(string)MY_ROW,<1,1,0>,1);
        gNodeInfo = [];
        announce_nodes();
    }
    if( action == SEND_SCALE )
    {
        llSetText("Sending Scale Information\n"+(string)MY_ROW,<1,1,0>,1);
        sendScaleInfo();
    }
    llMessageLinked(LINK_THIS,0,(string)color,"recolor");
    llSetText("",<0,0,1>,1);
}

vector get_node_offset(integer i, integer formula)
{
    if(!formula && gNodeInfo != [])
    {
        return (vector)llList2String(gNodeInfo,i);
    }
    float t = (float)i/COLUMNS;
    if(gSpawnShape == 0) //CIRCLE
    {
        t *= TWO_PI;
        return <llCos(t),llSin(t),0>;
    }else
    if(gSpawnShape == 1) //BOX
    {
        return <
            .25 - llFabs(t-0) + llFabs(t-.25) + llFabs(t-.5) - llFabs(t-.75),
            .25 - llFabs(t-.25) + llFabs(t-.5) + llFabs(t-.75) - llFabs(t-1),0>*4;

    }
    return ZERO_VECTOR;
}

integer rez_node(integer i)
{
    if(i >= COLUMNS) return FALSE;
    vector offset;
    rotation rot = ZERO_ROTATION;
    integer f = llGetListLength(gNodeInfo) != COLUMNS;
    if(gSpawnShape==0)
    {
        offset = get_node_offset(i,f);
        rot = llEuler2Rot( <0,0,1>* (float)i/COLUMNS*TWO_PI);
    }
    llRezObject("node",unpackNode(offset),ZERO_VECTOR,rot*gRotation, NODE_CHANNEL |  (i & CONTROL_POINT_MASK) );
    return TRUE;
}
//Announces nodes within the prim
announce_nodes()
{
    if( gSculptType != SCULPT_POINT) {
        if(gNodeInfo == [])
        {
            gPosition = llGetPos();
            gRotation = llGetRot();
            gScale = llGetScale();
            if( gSculptType == SCULPT_NODE) storeNodeInfo();
            if( gSculptType == SCULPT_DISK) resetVerts();
        }
        llMessageLinked(LINK_THIS,COMMAND_NODES,llList2CSV(gNodeInfo),"");
    } else {
            llMessageLinked(LINK_THIS,COMMAND_NODES,(string)ZERO_VECTOR,"");
    }
}
// Spawns the individual nodes that can be moved around
integer spawnNodes(){
    gRezedNodes = [];
    gPosition = llGetPos();
    gRotation = llGetRot();
    gScale = llGetScale();
    return rez_node(0);
}

// Resets the verticies back into a disk
resetVerts()
{
    integer i;
    gNodeInfo = [];
    float t;
    vector offset;
    for( i = 0; i < COLUMNS; ++i) {
        gNodeInfo = (gNodeInfo = []) + gNodeInfo + get_node_offset(i,TRUE);
    }
}

// Applys the new position, rotation, and gScale information to normalized data
vector unpackNode(vector node) {
    node.x *= (gScale.x/2);
    node.y *= (gScale.y/2);
    return node * gRotation+gPosition;
}

// Removes all relative information, thereby normalizing the data
vector packNode(vector node) {
    node -= gPosition;
    node /= gRotation;
    node.x /= (gScale.x/2);
    node.y /= (gScale.y/2);
    return node;
}

// Retrieves and normalizes all individual nodes, storing them in the dumplist
storeNodeInfo() {
    gNodeInfo = [];
    integer MAX = llGetListLength(gRezedNodes);
    integer i;
    for( i = 0; i < MAX; ++i)
    {
        gNodeInfo = (gNodeInfo = []) + gNodeInfo +
            packNode(llList2Vector(llGetObjectDetails(llList2Key(gRezedNodes,i),[OBJECT_POS]),0));
    }
}

// Sends nodes to the server for processing
sendNodes(){
    string r = (string)MY_ROW;
    if( gSculptType == SCULPT_POINT ) { llMessageLinked(LINK_THIS,COMMAND_SENDNODES,(string)llGetPos(),r); return; }
    if( gNodeInfo == []) resetVerts();
    integer i;
    integer MAX = llGetListLength(gNodeInfo);
    string dump;
    for( i = 0; i < MAX; ++i) {
        dump += (string)( unpackNode((vector)llList2String(gNodeInfo,i)) );
        if( i < MAX-1 ) dump += ",";
    }
    llMessageLinked(LINK_THIS,COMMAND_SENDNODES,dump,r);
}

//Get extreme points
list getExtrema()
{

    integer i;
    integer MAX = llGetListLength(gNodeInfo);
    vector v;
    vector max = <1,1,1>*-9999;
    vector min = <1,1,1>*9999;
    for( i = 0; i < MAX; ++i) {
        if(gRezedNodes == [])
            v = unpackNode(llList2Vector(gNodeInfo,i));
        else
            v = llList2Vector(llGetObjectDetails(llList2Key(gRezedNodes,i),[OBJECT_POS]),0);
        if( v.x > max.x ) max.x = v.x;
        if( v.y > max.y ) max.y = v.y;
        if( v.z > max.z ) max.z = v.z;

        if( v.x < min.x ) min.x = v.x;
        if( v.y < min.y ) min.y = v.y;
        if( v.z < min.z ) min.z = v.z;
    }
    return [min,max];
}

//Rescale the box based on extrema
rescale()
{
    list minmax = getExtrema();
    vector min = llList2Vector(minmax,0);
    vector max = llList2Vector(minmax,1);
    vector center = (min + max)*0.5;
    vector scale = <0,0,0.05>;

    if( llFabs(max.x-center.x) > llFabs(min.x-center.x) ) scale.x = 2*llFabs(max.x-center.x);
    else scale.x = 2*llFabs(min.x-center.x);

    if( llFabs(max.y-center.y) > llFabs(min.y-center.y) ) scale.y = 2*llFabs(max.y-center.y);
    else scale.y = 2*llFabs(min.y-center.y);

    llSetPos(center);
    llSetScale(scale);
}

// Announces the extreme points, used for scaling the bounding box
sendScaleInfo() {
    llSleep(llFrand(3.0));
    if( gSculptType == SCULPT_POINT ) {
        llShout(ENCLOSE_CHANNEL,(string)llGetPos());
        return;
    }
    list d;
    if( gNodeInfo == [] ) {
        vector p = llGetPos();
        rotation r = llGetRot();
        d = llGetBoundingBox(llGetKey());
        d = ( d=[]) + [llList2Vector(d,0)*r + p,llList2Vector(d,1)*r + p];
    } else {
            d = getExtrema();
    }
    llShout(ENCLOSE_CHANNEL,llList2String(d,0) + "|" + llList2String(d,1));
}

//Hashes the color using a simple hashing function
vector getColorHash()
{
    integer i;
    integer MAX = llGetListLength(gNodeInfo);
    vector v = ZERO_VECTOR;
    for( i = 0; i < MAX; ++i) {
        v += ((vector)llList2String(gNodeInfo,i));
    }
    v.x = llFabs(v.x);
    v.y = llFabs(v.y);
    v.z = llFabs(v.z);
    if(v == ZERO_VECTOR) v = <1,1,1>;
    return llVecNorm(v);
}

integer parse_setup_string(string message)
{
    if( llSubStringIndex(message,"#setup#") == 0)
    {
        list l = llCSV2List(llGetSubString(message,7,-1));
        if(COLUMNS != (integer)llList2String(l,0) )
        {
            COLUMNS = (integer)llList2String(l,0);
            performAction(RESET_VERTS);
        }
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
        NODE_CHANNEL = (integer)(llFrand(-1e6) - 1e6) & CHANNEL_MASK;
        BROADCAST_CHANNEL = (param & CHANNEL_MASK);
        gListenHandle = llListen(BROADCAST_CHANNEL, "","","");
        MY_ROW = param & CONTROL_POINT_MASK;
        gSculptType = SCULPT_DISK;
        gRezedNodes = [];
        announce_nodes();
        llSetText("",<1,1,1>,1);
    }
    listen(integer channel, string name, key id, string message)
    {
        parse_setup_string(message);
    }
    link_message( integer send_num, integer num, string str, key id)
    {
        if( num == COMMAND_CTYPE) {
            integer new = (integer)str;
            if( new == gSculptType) return;
            if( new == SCULPT_NODE ) {
                //Stop Bezier Interpolation for this disk
                llMessageLinked(LINK_THIS,0,"","#bez_stop#");
                //Unpack Nodes
                performAction(SPAWN_NODES);
            }
            if( new == SCULPT_DISK )
            {
                performAction(ATTACH_VERTS);
                if( gNodeInfo != [] )
                {
                    llMessageLinked(LINK_THIS,0,(string)getColorHash(),"recolor");
                }
                gRezedNodes = [];
                llShout(NODE_CHANNEL,"#die#");
            }
            if( new == SCULPT_POINT) { gRezedNodes = []; gNodeInfo = []; }
            gSculptType = new;
        }

        if( num == COMMAND_RESET ) {
            if( gSculptType == SCULPT_DISK ) {
                performAction(RESET_VERTS);
                llMessageLinked(LINK_THIS,0,"<1,1,1>","recolor");
            }
        }
        if( num == COMMAND_RENDER ) {
            if( gSculptType == SCULPT_NODE ) performAction(ATTACH_VERTS);
            performAction(SEND_NODES);
        }
        if( num == COMMAND_SCALE ) {
            ENCLOSE_CHANNEL = (integer)str;
            if( gSculptType == SCULPT_NODE) performAction(ATTACH_VERTS);
            performAction(SEND_SCALE);
        }
        if( num == COMMAND_CSECT ) {
            if( gSculptType == SCULPT_NODE) llShout(NODE_CHANNEL,"#csect#");
        }
        if( num == COMMAND_COPY)
        {
            gNodeInfo = llCSV2List(str);
            llMessageLinked(LINK_THIS,COMMAND_NODES,str,"");
            llMessageLinked(LINK_THIS,0,(string)getColorHash(),"recolor");
        }
        if( num == COMMAND_INTERP)
        {
            gNodeInfo = [];
            list tailnodes = llCSV2List((string)id);
            float p;
            list headnodes = llParseString2List(str,["|"],[]);
            p = llList2Float(headnodes,0);
            headnodes = llCSV2List(llList2String(headnodes,1));
            integer i = 0;
            integer len = llGetListLength(tailnodes);
            for( i = 0; i < len; ++i)
            {
                gNodeInfo = (gNodeInfo = []) + gNodeInfo + [(vector)llList2String(headnodes,i)*(1.0-p) + (vector)llList2String(tailnodes,i)*p];
            }
            tailnodes = [];
            gRootNodes = [];
            llMessageLinked(LINK_THIS,COMMAND_NODES,llList2CSV(gNodeInfo),"");
            llMessageLinked(LINK_THIS,0,(string)getColorHash(),"recolor");
        }
        if(num == COMMAND_SPAWNSHAPE)
        {
            gSpawnShape = (integer)str;
            performAction(RESET_VERTS);
            llMessageLinked(LINK_THIS,0,"<1,1,1>","recolor");
        }
    }
    object_rez(key id)
    {
        gRezedNodes = (gRezedNodes = []) + gRezedNodes + id;
        integer i = llGetListLength(gRezedNodes);
        if(!rez_node(i))
        {
            llShout(NODE_CHANNEL,llList2CSV(["al",ACCESS_LEVEL,"rw",ROWS,"cl",COLUMNS,"bc",BROADCAST_CHANNEL]));
        }
    }
}
