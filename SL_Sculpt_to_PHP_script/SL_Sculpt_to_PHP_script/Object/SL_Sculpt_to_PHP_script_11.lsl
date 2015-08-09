// :CATEGORY:Sculpt
// :NAME:SL_Sculpt_to_PHP_script
// :AUTHOR:Falados Kapuskas 
// :CREATED:2012-09-18 15:38:34.433
// :EDITED:2013-09-18 15:39:03
// :ID:790
// :NUM:1089
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Sculpt: Data transfer.lsl
// :CODE:
//LinkCommands
integer COMMAND_NODES   = -7;
integer COMMAND_INTERP  = -8;
integer COMMAND_LERP    = -4;
integer COMMAND_COPY    = -9;

integer BROADCAST_CHANNEL;
integer COPY_CHANNEL;
integer MIRROR_CHANNEL;

integer MY_ROW;
string gNodeData;

integer gListenHandle;
integer gStreamsComplete;

//Linear Interpolation
integer LERP_CHANNEL;
integer gLerpStart;
integer gLerpEnd;
integer gLerpType;
list gPacketsReceived_H;
list gPacketsReceived_T;

//Copy
integer gCopyNumber;
list gPacketsReceived_C;

//Mirror
integer gMirrorNumber;
vector gMirrorPos = ZERO_VECTOR;
rotation gMirrorRot = ZERO_ROTATION;
vector MIRROR_AXIS;


rotation slerp( rotation a, rotation b, float f ) {
    float angleBetween = llAngleBetween(a, b);
    if ( angleBetween > PI )
        angleBetween = angleBetween - TWO_PI;
    return a*llAxisAngle2Rot(llRot2Axis(b/a)*a, angleBetween*f);
}

lerp(list params)
{
    llListenRemove(gListenHandle);
    LERP_CHANNEL = llList2Integer(params,0);
    gLerpStart = llList2Integer(params,1);
    gLerpEnd = llList2Integer(params,2);
    gLerpType = llList2Integer(params,3);
    if(MY_ROW == gLerpStart || MY_ROW == gLerpEnd)
    {
        string p =  "H" + (string)gLerpType;
        if(MY_ROW == gLerpEnd) p = "T" + (string)gLerpType;
        string send;
        if(gLerpType == 0)
        {
            send = (string)llGetPos();
        }else if(gLerpType == 1)
    {
        send = (string)llGetScale();
    } else if(gLerpType == 2)
    {
        send = (string)llGetRot();
    } else if (gLerpType == 3)
    {
        send = gNodeData;
    }
        integer packets = llCeil(llStringLength(send) / 1000.0);
        integer max_packets = packets;
        string header;
        integer sent = 0;
        llSleep(1.0); //Give them time to listen
        while(packets > 0)
        {
            header = p + "|" + (string)sent + "/" + (string)max_packets + "|";
            if(packets == 1) {
                llRegionSay(LERP_CHANNEL,header + send);
            } else {
                    llRegionSay(LERP_CHANNEL,header + llGetSubString(send,0,999));
                send = llGetSubString(send,1000,-1);
            }
            llSleep(0.25);
            --packets;
            ++sent;
        }
    } else if(MY_ROW > gLerpStart && MY_ROW < gLerpEnd) {
            gPacketsReceived_H = gPacketsReceived_T = [];
        gStreamsComplete = 0;
        gListenHandle = llListen(LERP_CHANNEL,"","","");
    }
}

mirror(list params, key id)
{
    llListenRemove(gListenHandle);
    gMirrorNumber = -1;
    list d = llGetObjectDetails(id,[OBJECT_POS,OBJECT_ROT]);
    gMirrorPos = llList2Vector(d,0);
    gMirrorRot = llList2Rot(d,1);
    MIRROR_CHANNEL = llList2Integer(params,0);
    MIRROR_AXIS = (vector)llList2String(params,1);
    list range_from = llList2List(params,2,3);
    list range_to = llList2List(params,4,5);
    integer len_from = (integer)llFabs(llList2Integer(range_from,-1) - llList2Integer(range_from,0));
    integer len_to = (integer)llFabs(llList2Integer(range_to,-1) - llList2Integer(range_to,0));
    integer SEND = FALSE;
    integer LISTEN = FALSE;
    //Can't Mirror uneven stuff
    if(len_from != len_to)
    {
        return;
    }

    integer SRC_START = llList2Integer(range_from,0);
    integer SRC_END = llList2Integer(range_from,-1);
    integer DST_START = llList2Integer(range_to,0);
    integer DST_END = llList2Integer(range_to,-1);

    if(DST_START > DST_END)
    {
        SEND = DST_START;
        DST_START = DST_END;
        DST_END = SEND;
    }
    if(SRC_START > SRC_END)
    {
        SEND = SRC_START;
        SRC_START = SRC_END;
        SRC_END = SEND;
    }
    SEND = FALSE;

    if( MY_ROW >= SRC_START && MY_ROW <= SRC_END ) SEND = TRUE;
    else if( MY_ROW >= DST_START && MY_ROW <= DST_END) {
        LISTEN = TRUE;
    }

    if(LISTEN)
    {
        float t = 0;
        if(len_to != 0) t = (MY_ROW - DST_START)/(llFabs(len_to));
        gMirrorNumber = SRC_START;
        if(len_from != 0)
        {
            gMirrorNumber += llRound(((float)len_from)*(1.0-t));
        }
        gListenHandle = llListen(MIRROR_CHANNEL,"","","");
        return;
    }
    if(SEND) {
        llSleep(1); //Give them time to listen?
        string header = (string)MY_ROW + "|";
        string send = llList2CSV([llGetPos(),llGetRot()]);
        llRegionSay(MIRROR_CHANNEL,header + send);
    }
}

copy(list params)
{
    llListenRemove(gListenHandle);
    gCopyNumber = -1;
    gPacketsReceived_C = [];
    COPY_CHANNEL = llList2Integer(params,0);
    list range_from = llList2List(params,1,2);
    list range_to = llList2List(params,3,4);
    integer len_from = llList2Integer(range_from,-1) - llList2Integer(range_from,0);
    integer len_to = llList2Integer(range_to,-1) - llList2Integer(range_to,0);
    integer SEND = FALSE;
    integer LISTEN = FALSE;
    integer MIRROR = 0;

    //Copy Only
    if(llFabs(len_from) != llFabs(len_to))
    {
        //Cant copy x1-x2 to y1-y2 when they are not 1-to-1
        //It's ambiguous.  We can copy 1 disk to several disks
        if((integer)llFabs(len_from) != 1) return;
    }

    //Check for the mirror case (Exclusive or)
    if( len_from < 0 && len_to > 0)
    {
        len_from = -len_from;
        MIRROR = 1;
    }
    if( len_to < 0 && len_from > 0 )
    {
        len_to = -len_to;
        MIRROR = 1;
    }

    integer SRC_START = llList2Integer(range_from,0);
    integer SRC_END = llList2Integer(range_from,-1);
    integer DST_START = llList2Integer(range_to,0);
    integer DST_END = llList2Integer(range_to,-1);

    if(DST_START > DST_END)
    {
        SEND = DST_START;
        DST_START = DST_END;
        DST_END = SEND;
    }
    if(SRC_START > SRC_END)
    {
        SEND = SRC_START;
        SRC_START = SRC_END;
        SRC_END = SEND;
    }
    SEND = FALSE;

    if( MY_ROW >= SRC_START && MY_ROW <= SRC_END ) SEND = TRUE;
    else if( MY_ROW >= DST_START && MY_ROW <= DST_END) {
        LISTEN = TRUE;
    }

    if(LISTEN)
    {
        float t = 0;
        if(len_to != 0) t = (MY_ROW - DST_START)/(llFabs(len_to));
        if(len_from == 0) {
            gCopyNumber = SRC_START;
        } else {
                gCopyNumber = SRC_START + llFloor(llFabs(len_from)*llFabs((float)MIRROR-t));
        }
        gListenHandle = llListen(COPY_CHANNEL,"","","");
        return;
    }
    if(SEND) {
        llSleep(1); //Give them time to listen?
        string send = gNodeData;
        integer packets = llCeil(llStringLength(send) / 1000.0);
        integer max_packets = packets;
        string header;
        integer sent = 0;
        while(packets > 0)
        {
            llSleep(0.25);
            header = (string)MY_ROW + "|" + (string)sent + "/" + (string)max_packets + "|";
            if(packets == 1) {
                llRegionSay(COPY_CHANNEL,header + send);
            } else {
                    llRegionSay(COPY_CHANNEL,header + llGetSubString(send,0,999));
                send = llGetSubString(send,1000,-1);
            }
            --packets;
            ++sent;
        }
    }
}

link_commands(integer sn, integer i, string str, key id)
{
    if( i == COMMAND_NODES && str != "")
    {
        gNodeData = str;
    }
}

default
{
    on_rez(integer param)
    {
        if (!param) return;
        MY_ROW = param & 0xFF;
        BROADCAST_CHANNEL = param & 0xFFFFFF00;
        llListen(BROADCAST_CHANNEL,"","","");
    }
    link_message(integer sn, integer i, string str, key id)
    {
        link_commands(sn,i,str,id);
    }
    listen(integer channel, string name, key id, string message)
    {
        if(channel == BROADCAST_CHANNEL)
        {
            if(llSubStringIndex(message,"#lerp#") == 0)
            {
                lerp(llCSV2List(llGetSubString(message,6,-1)));
            }
            if(llSubStringIndex(message,"#copy#") == 0)
            {
                copy(llCSV2List(llGetSubString(message,6,-1)));
            }
            if(llSubStringIndex(message,"#mirror#") == 0)
            {
                mirror(llCSV2List(llGetSubString(message,8,-1)),id);
            }
            return;
        }
        if(channel == MIRROR_CHANNEL)
        {
            list params = llParseString2List(message,["|"],[]);
            list details = llCSV2List(llList2String(params,1));
            integer MIR_NUM = llList2Integer(params,0);
            if(gMirrorNumber != MIR_NUM) {
                return;
            }
            vector pos = (vector)llList2String(details,0);
            rotation rot = (rotation)llList2String(details,1);
            vector relPos = (pos - gMirrorPos)/gMirrorRot;
            rotation relRot = rot/gMirrorRot;
            vector relRot2 = llRot2Euler(relRot);

            if(MIRROR_AXIS.x) // If X Axis option is set...
            {
                relPos.x *= -1;
                relRot2.z *= -1;
                relRot2.y *= -1;
                relRot2 = llRot2Euler(<-0, -1, -0, 0> * llEuler2Rot(relRot2));
            }
            if(MIRROR_AXIS.y) // If Y Axis option is set...
            {
                relPos.y *= -1;
                relRot2.x *= -1;
                relRot2.z *= -1;
                relRot2 = llRot2Euler(<1, -0, -0, 0> * llEuler2Rot(relRot2));
            }
            if(MIRROR_AXIS.z) // If Z Axis option is set...
            {
                relPos.z *= -1;
                relRot2.x *= -1;
                relRot2.y *= -1;
            }
            relRot = llEuler2Rot(relRot2);
            pos = gMirrorPos + (relPos*gMirrorRot);
            rot = relRot * gMirrorRot;
            llSetPrimitiveParams([PRIM_POSITION,pos,PRIM_ROTATION,rot]);
        }
        if(channel == COPY_CHANNEL)
        {
            list params = llParseString2List(message,["|"],[]);
            list packets = llParseString2List(llList2String(params,1),["/"],[]);
            integer COPY_NUM = llList2Integer(params,0);
            if(gCopyNumber != COPY_NUM) {
                return;
            }
            gPacketsReceived_C = (gPacketsReceived_C = []) + gPacketsReceived_C + [llList2Integer(packets,0),llList2String(params,2)];
            if( llGetListLength(gPacketsReceived_C) / 2 == llList2Integer(packets,1))
            {
                packets = [];
                params = [];
                llMessageLinked(LINK_THIS,0,"","#bez_stop#");
                llMessageLinked(LINK_THIS,COMMAND_COPY,
                    llDumpList2String(llList2ListStrided(llDeleteSubList(llListSort(gPacketsReceived_C,2,TRUE),0,0),0,-1,2),"")
                        ,"");
                list details = llGetObjectDetails(id,[OBJECT_ROT]);
                list bbox = llGetBoundingBox(id);
                vector scale = llList2Vector(bbox,1)-llList2Vector(bbox,0);
                scale.z = 0.05;
                llSetPrimitiveParams([PRIM_SIZE,scale,PRIM_ROTATION,llList2Rot(details,0)]);
                gCopyNumber = -1;
                gPacketsReceived_C = [];
                llListenRemove(gListenHandle);
            }
        }
        if(channel == LERP_CHANNEL)
        {
            list params = llParseString2List(message,["|"],[]);
            list packets = llParseString2List(llList2String(params,1),["/"],[]);
            integer IS_HEAD = (llGetSubString(llList2String(params,0),0,0) == "H");
            gLerpType = (integer)(llGetSubString(llList2String(params,0),1,-1));
            if(IS_HEAD)
            {
                gPacketsReceived_H += [llList2Integer(packets,0),llList2String(params,2)];
                //Received All Packets
                if( llGetListLength(gPacketsReceived_H) / 2 == llList2Integer(packets,1))
                {
                    packets = [];
                    params = [];
                    ++gStreamsComplete;
                }
            } else {
                    gPacketsReceived_T += [llList2Integer(packets,1),llList2String(params,2)];
                if( llGetListLength(gPacketsReceived_T) / 2 == llList2Integer(packets,1))
                {
                    packets = [];
                    params = [];
                    ++gStreamsComplete;
                }
            }
            //Both Packet Streams are done, interpolate now
            if(gStreamsComplete >= 2)
            {
                string tdata = llDumpList2String((gPacketsReceived_H=[]) + llList2ListStrided(llDeleteSubList(llListSort(gPacketsReceived_H,2,TRUE),0,0),0,-1,2),"");
                string hdata = llDumpList2String((gPacketsReceived_T=[]) + llList2ListStrided(llDeleteSubList(llListSort(gPacketsReceived_T,2,TRUE),0,0),0,-1,2),"");
                float t = (MY_ROW - gLerpStart) / (float)(gLerpEnd - gLerpStart);
                if(gLerpType == 0)
                {
                    llSetPos(t * ((vector)hdata) + ((vector)tdata)*(1-t));
                }else if(gLerpType == 1)
            {
                llSetScale(t * ((vector)hdata) + ((vector)tdata)*(1-t));
            } else if(gLerpType == 2)
            {
                llSetRot(slerp((rotation)tdata,(rotation)hdata,t));
            } else if (gLerpType == 3)
            {
                llMessageLinked(LINK_THIS,COMMAND_INTERP,(string)t + "|" + tdata,hdata);
            }
                llListenRemove(gListenHandle);
            }
        }
    }
}
