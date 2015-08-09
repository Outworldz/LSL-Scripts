// :CATEGORY:Building
// :NAME:Open_Table
// :AUTHOR:Falados Kapuskas
// :CREATED:2011-08-09 01:00:22.220
// :EDITED:2013-09-18 15:38:59
// :ID:591
// :NUM:812
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// The chair script. Put this in a prim called '1 Prim Chair', or change the notecard to your chair
// :CODE:
//    This file is part of Open Round-Table.
//
//    Open Round-Table is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    Open Round-Table is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with Open Round-Table.  If not, see <http://www.gnu.org/licenses/>.
//
//    Author: Falados Kapuskas
//    Version: 1.0

vector wtf = <0,00, 90>;

float REFRESH_TIME = 1.0;

integer BROADCAST_CHANNEL=-1;
integer CHAIR_NUM;
integer MAX_CHAIRS;
float Z_OFFSET;
float RADIUS;
float ANGLE;
float ELBOW_ROOM;

integer CHANNEL_MASK = 0xFFFFFF00;
integer CHAIR_MASK = 0xFF;
key gTable;


apply()
{
    if(llKey2Name(gTable) == "") llDie();
        list params = llGetObjectDetails(gTable,[OBJECT_POS,OBJECT_ROT]);
        rotation rot = llList2Rot(params,1);
        vector pos = llList2Vector(params,0);
        float t = 0;
        float n = MAX_CHAIRS;
        float theta = ANGLE;
        if(n > 0)
        {
            t = llFabs(CHAIR_NUM/n);
            theta = ANGLE/(n);
        }
        float arc_len = RADIUS * theta;
        if(arc_len < ELBOW_ROOM)
        {
            RADIUS = ELBOW_ROOM / theta;
        }
        float tangle = t*ANGLE;
        vector o = <llCos(tangle),llSin(tangle),0>*RADIUS;
        o.z = Z_OFFSET;
        vector position = pos + o*rot;
        llSetPos(position);
        llSetRot( llEuler2Rot(<0,0,PI/2>) * llEuler2Rot(<0,0,tangle>)*rot );
}

default
{

    state_entry()
    {
        llSetSitText("Be Seated");
        rotation quat = llEuler2Rot(wtf* DEG_TO_RAD);
         llSitTarget(<0.0, 1.0, 0.1>,  quat);
    }


    on_rez(integer i)
    {
        BROADCAST_CHANNEL = i & CHANNEL_MASK;
        CHAIR_NUM = i & CHAIR_MASK;
        llListen(BROADCAST_CHANNEL,"","","");
    }

    listen(integer channel, string name, key id, string message)
    {
        if(llSubStringIndex(message,"#table#") == 0 )
        {
            list params = llCSV2List( llGetSubString(message,7,-1) );
            gTable = id;
            RADIUS = llList2Float(params,0);
            ANGLE = llList2Float(params,1);
            ELBOW_ROOM = llList2Float(params,2);
            Z_OFFSET = llList2Float(params,3);
            MAX_CHAIRS = llList2Integer(params,4);
            llSetTimerEvent(2.0);
            apply();
        }
        if(llSubStringIndex(message,"#die#") == 0 )
        {
            if( message == "#die#") llDie();
            list params = llCSV2List( llGetSubString(message,5,-1) );
            integer dienum = llList2Integer(params,0);
            if(dienum == CHAIR_NUM) llDie();
            if(dienum < CHAIR_NUM) --CHAIR_NUM;
            --MAX_CHAIRS;
        }
    }

    changed(integer change)
    {
        if(change & CHANGED_LINK)
        {
            integer i;
            integer prims = llGetNumberOfPrims();
            key sitting = llAvatarOnSitTarget();
            if( llAvatarOnSitTarget() == NULL_KEY) {
                for( i = 2; i <= prims; ++i)
                {
                    if( llGetAgentSize(llGetLinkKey(i)) != ZERO_VECTOR)
                    {
                        sitting = llGetLinkKey(i);
                        jump done;
                    }
                }
            }
            @done;
            if( sitting == NULL_KEY)
            {
                llRegionSay(BROADCAST_CHANNEL,"#unsit#" + llList2CSV([CHAIR_NUM]));
            } else {
                llRegionSay(BROADCAST_CHANNEL,"#sit#" + llList2CSV([CHAIR_NUM]));
            }
        }
    }

    timer()
    {
        apply();
    }
}

