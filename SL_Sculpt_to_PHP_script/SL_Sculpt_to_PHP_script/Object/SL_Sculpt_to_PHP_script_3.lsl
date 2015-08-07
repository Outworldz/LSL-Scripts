// :CATEGORY:Sculpt
// :NAME:SL_Sculpt_to_PHP_script
// :AUTHOR:Falados Kapuskas 
// :CREATED:2012-09-18 15:38:34.433
// :EDITED:2013-09-18 15:39:03
// :ID:790
// :NUM:1081
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// BezierRez.lsl
// :CODE:
vector ORIGIN;
vector SIZE = <10,10,10>;
integer gRezed;
integer CONTROL_POINTS = 4;
integer INTERP_POINTS = 15;
integer CHANNEL;
integer CHANNEL_MASK = 0xFFFFFF00;
string CONTROL_OBJECT;
string INTERP_OBJECT;
integer OFF = FALSE;
list gControlPoints;
list gAnchorPoints;
integer gRezState;
integer gDiskNum;
integer gAnnounceFinish;
go_pos(vector p)
{
    while(llGetPos() != p) {
        llSetPos(p);
    }
}

integer rez_disk(integer i)
{
    if(i >= INTERP_POINTS) return FALSE;
    llRezObject(INTERP_OBJECT,llGetPos(),ZERO_VECTOR,ZERO_ROTATION,CHANNEL | (i & 0xFF) );
    llSetText("Rezing Disks : " + (string)(i+1) + " of " + (string)INTERP_POINTS,<0,1,0>,1.0);
    llSleep(0.2);
    return TRUE;
}

default
{
    link_message(integer sn, integer i, string str, key id)
    {
        if(id == "#rez#")
        {
            gAnnounceFinish = TRUE;
            list params = llCSV2List(str);
            CHANNEL = i & CHANNEL_MASK;
            integer i;
            vector p = llGetPos();
            vector pos;
            rotation rot;
            ORIGIN = llGetPos() + <0,0,.5>;
            CONTROL_POINTS = llList2Integer(params,0);
            INTERP_POINTS = llList2Integer(params,1);
            CONTROL_OBJECT = llList2String(params,2);
            INTERP_OBJECT = llList2String(params,3);
            integer type = llList2Integer(params,4);
            float magic = 0.551784;
            list cpos;
            list crot;
            if(type == 1)
            {
                cpos = [
                    ORIGIN + <0,0,0>,
                    ORIGIN + <0,2.5*magic,0>,
                    ORIGIN + <0,2.5,2.5-2.5*magic>,
                    ORIGIN + <0,2.5,2.5>,
                    ORIGIN + <0,2.5,2.5+2.5*magic>,
                    ORIGIN + <0,2.5*magic,5>,
                    ORIGIN + <0,0,5>,
                    ORIGIN + <0,-2.5*magic,5>,
                    ORIGIN + <0,-2.5,2.5+2.5*magic>,
                    ORIGIN + <0,-2.5,2.5>,
                    ORIGIN + <0,-2.5,2.5-2.5*magic>,
                    ORIGIN + <0,-2.5*magic,0>,
                    ORIGIN + <0,0,0>
                        ];
                crot = [
                    llEuler2Rot(<-PI_BY_TWO,0,0>),
                    llEuler2Rot(<-PI_BY_TWO,0,0>),
                    llEuler2Rot(<0,0,0>),
                    llEuler2Rot(<0,0,0>),
                    llEuler2Rot(<0,0,0>),
                    llEuler2Rot(<PI_BY_TWO,0,0>),
                    llEuler2Rot(<PI_BY_TWO,0,0>),
                    llEuler2Rot(<PI_BY_TWO,0,0>),
                    llEuler2Rot(<PI,0,0>),
                    llEuler2Rot(<PI,0,0>),
                    llEuler2Rot(<PI,0,0>),
                    llEuler2Rot(<-PI_BY_TWO,0,0>),
                    llEuler2Rot(<-PI_BY_TWO,0,0>)
                        ];
            }
            gRezed = 0;
            gRezState = 0;
            gControlPoints = [];
            gAnchorPoints = [];
            for( i = 0; i < CONTROL_POINTS; ++i)
            {
                if(type == 1)
                {
                    pos = llList2Vector(cpos,i);
                    rot = llList2Rot(crot,i);
                } else {
                        pos = ORIGIN + <0,0,5> * ((float)i/(float)(CONTROL_POINTS-1));
                    rot = ZERO_ROTATION;
                }
                llSetText("Rezing Control Points : " + (string)(i+1) + " of " + (string)CONTROL_POINTS,<1,1,0>,1.0);
                go_pos(pos);
                llRezObject(CONTROL_OBJECT,pos,ZERO_VECTOR,rot,CHANNEL | (i & 0xFF) );
            }
            go_pos(p);
            gDiskNum = 0;
            rez_disk(gDiskNum);
            return;
        }
        if(id == "#add_control#")
        {
            gAnnounceFinish = FALSE;
            vector p = llGetPos();
            gRezState = 0;
            list details = llGetObjectDetails(llList2Key(gControlPoints,-1),[OBJECT_POS,OBJECT_ROT]);
            vector pos = llList2Vector(details,0);
            rotation rot = llList2Rot(details,1);
            if(pos == ZERO_VECTOR) return;
            pos += llRot2Up(rot);
            ++CONTROL_POINTS;
            go_pos(pos);
            llRezObject(CONTROL_OBJECT,pos,ZERO_VECTOR,rot,CHANNEL | (CONTROL_POINTS-1 & 0xFF) );
            go_pos(p);
        }
        if( id == "#remove_control#" )
        {
            if(llGetListLength(gControlPoints) > 2)
            {
                key k = llList2Key(gControlPoints,-1);
                if(llKey2Name(k) == "") return;
                --CONTROL_POINTS;
                --gRezed;
                gControlPoints = llDeleteSubList(gControlPoints,-1,-1);
                llRegionSay(CHANNEL,"#ctrl#"+llList2CSV(gControlPoints));
            }
        }
    }
    object_rez(key k)
    {
        ++gRezed;
        if(gRezState == 0)
        {
            gControlPoints =(gControlPoints=[])+gControlPoints+[k];
            if( (gRezed-1) % 3 == 0 ) gAnchorPoints += k;
            if( llGetListLength(gControlPoints) == CONTROL_POINTS ) gRezState = 1;
        }
        if( gRezed == CONTROL_POINTS )
        {
            llRegionSay(CHANNEL,"#ctrl#"+llList2CSV(gControlPoints));
            llSleep(.20);
            llRegionSay(CHANNEL,"#anchors#"+llList2CSV(gAnchorPoints));
        }
        if(gRezState == 1)
        {
            if(!rez_disk(++gDiskNum))
            {
                gRezState = 2;
            }
        }
        if( gRezed >= (CONTROL_POINTS + INTERP_POINTS) )
        {
            gRezed = 0;
            llSetText("",ZERO_VECTOR,0.0);
            llRegionSay(CHANNEL,"#ctrl#"+llList2CSV(gControlPoints));
            if(gAnnounceFinish) llMessageLinked(LINK_THIS,0,"","#rez_fin#");
        }
    }
}
