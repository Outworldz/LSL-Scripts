// :CATEGORY:Sculpt
// :NAME:SL_Sculpt_to_PHP_script
// :AUTHOR:Falados Kapuskas 
// :CREATED:2012-09-18 15:38:34.433
// :EDITED:2013-09-18 15:39:03
// :ID:790
// :NUM:1091
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// sculpt: Bezier Controller.lsl
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
integer IS_ACTIVE = FALSE;

//LinkCommands
integer COMMAND_CTYPE       = -1;
integer COMMAND_RESET       = -2;
integer COMMAND_SCALE       = -3;
integer COMMAND_VISIBLE     = -4;
integer COMMAND_RENDER      = -5;
integer COMMAND_CSECT       = -6;
integer COMMAND_INTERP      = -7;
integer COMMAND_SIZE        = -8;
integer COMMAND_COPY        = -9;
integer COMMAND_SENDNODES   = -10;
integer COMMAND_SPAWNSHAPE  = -11;
integer COMMAND_SETUP_PARAMS= -12;

string control_points;

//Globals
integer gListenHandle;
//-- FUNCTIONS --//

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

handleRootCommand(string message)
{
    if(llSubStringIndex(message,"#ctrl#")==0)
    {
        control_points = llGetSubString(message,6,-1);
        if(IS_ACTIVE)
        {
            llMessageLinked(LINK_THIS,0,llList2CSV([ROWS+1,MY_ROW]),"#bez_info#");
            llMessageLinked(LINK_THIS,0,control_points,"#bez_start#");
        }
    }
    if(message == "#bezier-start#")
    {
        llSetScriptState("bezier",TRUE);
    }
    if(message == "#bezier-stop#")
    {
        llMessageLinked(LINK_THIS,0,"","#bez_stop#");
    }
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
    on_rez(integer i)
    {
        BROADCAST_CHANNEL = (i & CHANNEL_MASK);
        gListenHandle = llListen(BROADCAST_CHANNEL, "","","");
        MY_ROW = i & CONTROL_POINT_MASK;
    }
    listen( integer channel, string name, key id, string message )
    {
        if( !has_access(llGetOwnerKey(id)) ) return;
        handleRootCommand(message);
        if(parse_setup_string(message))
        {
            state active;
        }
    }
}

state active
{
    state_entry()
    {
        llListen(BROADCAST_CHANNEL,"","","");
        IS_ACTIVE = TRUE;
        llMessageLinked(LINK_THIS,0,llList2CSV([ROWS+1,MY_ROW]),"#bez_info#");
        llMessageLinked(LINK_THIS,0,control_points,"#bez_start#");
    }
    listen( integer channel, string name, key id, string message )
    {
        if( !has_access(llGetOwnerKey(id)) ) return;
        handleRootCommand(message);
    }
}
