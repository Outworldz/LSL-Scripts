// :CATEGORY:Sculpt
// :NAME:SL_Sculpt_to_PHP_script
// :AUTHOR:Falados Kapuskas 
// :CREATED:2012-09-18 15:38:34.433
// :EDITED:2013-09-18 15:39:03
// :ID:790
// :NUM:1088
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Sculpt: HTTP Sender.lsl
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
integer DISPLAY_CHANNEL     = -131415;
integer DATA_CHANNEL         = 0;
integer BROADCAST_CHANNEL;
integer CHANNEL_MASK = 0xFFFFFF00;
integer CONTROL_POINT_MASK = 0xFF;
integer SUCCESS_CHANNEL        = -2001;
integer ERROR_CHANNEL        = -2002;
string URL;
list HTTP_PARAMS = [
    HTTP_METHOD, "POST",
    HTTP_MIMETYPE,"application/x-www-form-urlencoded"
        ];

integer MY_ROW;    //Set on_rez

//-- GLOBALS --//
key gHTTPRequest;
integer gListenHandle_DISPLAY;
//-- FUNCTIONS --//

sendNodes(integer row, string data) {

    if(DATA_CHANNEL != 0)
    {
        list l = llCSV2List(data);
        if( llGetListLength(l) > 1) {
            llSay(DATA_CHANNEL,llList2CSV([0]+llList2List(l,0,15)));
            llSay(DATA_CHANNEL,llList2CSV([16]+llList2List(l,16,-1)));
        } else {
                llSay(DATA_CHANNEL,data);
        }
    } else {
            MY_ROW = row;
        string request = "action=upload&row=" + (string)row;
        gHTTPRequest = llHTTPRequest(URL + request,HTTP_PARAMS,"verts=" + llEscapeURL(data));
    }
}

//-- STATES --//

default {
    on_rez(integer param) {
        if (!param) return;
        BROADCAST_CHANNEL = (param & CHANNEL_MASK);
        MY_ROW = param & CONTROL_POINT_MASK;
        gListenHandle_DISPLAY = llListen(DISPLAY_CHANNEL,"","","");
    }
    listen(integer channel, string name, key id, string msg) {
        if( llGetOwner() != llGetOwnerKey(id)) return;
        if(channel == DISPLAY_CHANNEL)
        {
            DATA_CHANNEL = (integer)msg;
        }
    }

    link_message( integer send_num, integer num, string str, key id) {
        if( num == -5)
        {
            URL = str;
        }
        if( num == -10) {
            if( llSubStringIndex(URL,"http") == 0 ) {
                sendNodes(MY_ROW , str);
            }
        }
    }
    http_response(key request_id, integer status, list meta, string message)
    {
        if( request_id == gHTTPRequest) {
            if( llStringTrim(message,STRING_TRIM) == "") {
                llShout(SUCCESS_CHANNEL,(string)MY_ROW);
            } else {
                    llShout(ERROR_CHANNEL,(string)MY_ROW + ": " + message);
            }
        }
    }
}

