// :CATEGORY:Building
// :NAME:Open_Table
// :AUTHOR:Falados Kapuskas
// :CREATED:2011-08-09 01:00:22.220
// :EDITED:2013-09-18 15:38:59
// :ID:591
// :NUM:810
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Table script. Add to the table this script and a  chair. The name should be 1 Prim Chair, or you must change the name in the notecard
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

integer BROADCAST_CHANNEL;
integer OCCUPIED=0;
integer TOTAL_CHAIRS=0;
integer MIN_CHAIRS=1;
float Z_OFFSET = 0.0;
float RADIUS = 4;
float ANGLE = TWO_PI;
float ELBOW_ROOM = 1.5;
string CHAIR_OBJECT;
key gDataserverRequest;
integer CHANNEL_MASK = 0xFFFFFF00;
integer CHAIR_MASK = 0xFF;
integer MAX_CHAIRS = 0xFF;
integer gReadLine;

check()
{
    if( OCCUPIED >= TOTAL_CHAIRS || TOTAL_CHAIRS < MIN_CHAIRS )
    {
        if( TOTAL_CHAIRS < MAX_CHAIRS )  //Dont overflow the mask (Max 255 chairs)
        {
            rotation quat = llEuler2Rot(<0, 0, -90> * DEG_TO_RAD );
            llRezObject(CHAIR_OBJECT,llGetPos()+llRot2Fwd(llGetRot())*RADIUS,ZERO_VECTOR,llGetRot() * quat,BROADCAST_CHANNEL | TOTAL_CHAIRS);
        }
    }
}

default
{
    on_rez(integer param)
    {
        llResetScript();
    }
    state_entry()
    {
        if( llGetInventoryType("Config") == INVENTORY_NOTECARD)
        {
            gReadLine = 1;
            gDataserverRequest = llGetNotecardLine("Config",gReadLine);
        } else {
            llOwnerSay("Couldn't Find Notecard: 'Config'");
        }
    }
    dataserver(key req, string data)
    {
        if(req == gDataserverRequest)
        {
            if(data == EOF) state active;
            if(gReadLine == 1)
            {
                CHAIR_OBJECT = data;
                if(llGetInventoryType(data) == INVENTORY_NONE) return;
            }
            if(gReadLine == 3) RADIUS = (float)data;
            if(gReadLine == 5) ELBOW_ROOM = (float)data;
            if(gReadLine == 7)
            {
                MIN_CHAIRS = (integer)data;
                if(MIN_CHAIRS < 1) MIN_CHAIRS = 1;
            }
            if(gReadLine == 9) Z_OFFSET = (float)data;
            if(gReadLine == 11)
            {
                MAX_CHAIRS = (integer)data;
                if(MAX_CHAIRS > 255 ) MAX_CHAIRS = 255; //Over 255 will overflow the mask
                else if(MAX_CHAIRS < 1) MAX_CHAIRS = 1; //What the hell are you doing?
            }
            gReadLine += 2;
            gDataserverRequest = llGetNotecardLine("Config",gReadLine);
        }
    }
    changed(integer change)
    {
        if( llGetInventoryType("Config") == INVENTORY_NOTECARD)
        {
            gReadLine = 1;
            gDataserverRequest = llGetNotecardLine("Config",gReadLine);
        } else {
            llOwnerSay("Couldn't Find Notecard: 'Config'");
        }
    }
}


state active
{
    state_entry()
    {
        BROADCAST_CHANNEL = (integer)(llFrand(-1e6) - 1e6) & CHANNEL_MASK;
        llListen(BROADCAST_CHANNEL,"","","");
        check();
    }

    on_rez(integer param)
    {
        llRegionSay(BROADCAST_CHANNEL,"#die#");
        llResetScript();
    }

    listen(integer channel, string name, key id, string message)
    {
        if( llSubStringIndex(message,"#sit#") == 0)
        {
            ++OCCUPIED;
        }
        if( llSubStringIndex(message,"#unsit#") == 0)
        {
            --OCCUPIED;
            if( TOTAL_CHAIRS > MIN_CHAIRS)
            {
                llRegionSay(BROADCAST_CHANNEL,"#die#" + llGetSubString(message,7,-1));
                --TOTAL_CHAIRS;
            }
        }
        check();
    }

    changed(integer change)
    {
        if(change && CHANGED_INVENTORY)
        {
            llRegionSay(BROADCAST_CHANNEL,"#die#");
            llResetScript();
        }
    }
    object_rez(key id)
    {
        llShout(BROADCAST_CHANNEL,"#table#" + llList2CSV([RADIUS,ANGLE,ELBOW_ROOM,Z_OFFSET,++TOTAL_CHAIRS]));
        check();
    }
}
