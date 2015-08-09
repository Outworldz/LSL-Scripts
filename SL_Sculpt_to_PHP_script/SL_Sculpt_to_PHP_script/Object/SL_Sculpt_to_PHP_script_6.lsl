// :CATEGORY:Sculpt
// :NAME:SL_Sculpt_to_PHP_script
// :AUTHOR:Falados Kapuskas 
// :CREATED:2012-09-18 15:38:34.433
// :EDITED:2013-09-18 15:39:03
// :ID:790
// :NUM:1084
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// mirror.lsl
// :CODE:
integer CHANNEL_MASK = 0xFFFFFF00;
integer CONTROL_POINT_MASK = 0xFF;
integer BROADCAST_CHANNEL;
integer INPUT_CHANNEL = 9;
integer ACCESS_LEVEL = 2;
integer ROWS;

integer src_start;
integer src_end;
integer dst_start;
integer dst_end;

integer gListenHandle;
vector MAXIS = <1,0,0>;

processRootCommands(string message)
{
    if( llSubStringIndex(message,"#setup#") == 0)
    {
        list l = llCSV2List(llGetSubString(message,7,-1));
        ACCESS_LEVEL = (integer)llList2String(l,1);
        ROWS = (integer)llList2String(l,2);
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

dialog(key k)
{
    llListenRemove(gListenHandle);
    gListenHandle = llListen(INPUT_CHANNEL,"",k,"");
    list buttons = ["Mirror","----","Cancel"];
    if(MAXIS.x) buttons += ["X [x]"];
    else buttons += ["X [ ]"];

    if(MAXIS.y) buttons += ["Y [x]"];
    else buttons += ["Y [ ]"];

    if(MAXIS.z) buttons += ["Z [x]"];
    else buttons += ["Z [ ]"];

    llDialog(k,"Pick an action:",buttons,INPUT_CHANNEL);
}

integer startswith(string src, string pattern)
{
    return llSubStringIndex(src,pattern) == 0;
}

mirror()
{
    integer channel = (integer)(-1e6 - llFrand(1e6));
    llShout(BROADCAST_CHANNEL,"#bezier-stop#");
    llShout(BROADCAST_CHANNEL,"#mirror#" + llList2CSV([channel,MAXIS,src_start,src_end,dst_start,dst_end]));
}


integer parse_input(string message,key id)
{
    list sides = llParseString2List(llToLower(llStringTrim(message,STRING_TRIM)),["to"],[]);
    list src = llParseString2List(llStringTrim(llList2String(sides,0),STRING_TRIM),["-"],[]);
    list dst = llParseString2List(llStringTrim(llList2String(sides,1),STRING_TRIM),["-"],[]);
    if( llGetListLength(sides) != 2 )
    {
        llInstantMessage(id,"Malformed Input");
        return FALSE;
    }

    if( llGetListLength(src) == 1)
    {
        src_end = src_start = llList2Integer(src,0);
    } else {
            src_start = llList2Integer(src,0);
        src_end = llList2Integer(src,1);
    }

    if( llGetListLength(dst) == 1)
    {
        dst_end = dst_start = llList2Integer(src,0);
    } else {
            dst_start = llList2Integer(dst,0);
        dst_end = llList2Integer(dst,1);
    }


    if( src_end - src_start != dst_end-dst_start )
    {
        llInstantMessage(id,"Each side must be the same number of disks.");
        return FALSE;
    }

    if( src_end >= ROWS || src_start >= ROWS || dst_start >= ROWS || dst_end >= ROWS)
    {
        llInstantMessage(id,"Disk out of range (Max = " + (string)ROWS + ")");
        return FALSE;
    }

    return TRUE;
}

default
{
    on_rez(integer i)
    {
        BROADCAST_CHANNEL = (i & CHANNEL_MASK);
        llListen(BROADCAST_CHANNEL, "","","");
        llSetText("Touch to Setup",<1,1,1>,1.0);
    }
    state_entry()
    {
        llSetText("",<1,1,1>,1.0);
    }
    listen(integer channel, string name, key id, string message)
    {
        key k = llGetOwnerKey(id);
        if(!has_access(k)) return;
        if(channel == BROADCAST_CHANNEL)
        {
            processRootCommands(message);
            return;
        }
        if(channel == INPUT_CHANNEL)
        {
            llListenRemove(gListenHandle);
            if(parse_input(message,id))
            {
                state active;
            }
        }

    }
    touch_start(integer i)
    {
        key k = llDetectedKey(0);
        if(!has_access(k)) return;
        llListenRemove(gListenHandle);
        gListenHandle = llListen(INPUT_CHANNEL,"",k,"");
        llInstantMessage(k,"Say the Disk Set on channel " + (string)INPUT_CHANNEL + "\n"
            +"Example: '0-7 to 8-15' will mirror the disk set 0-7 onto 8-15\n");
    }
}

state active
{
    state_entry()
    {
        llListen(BROADCAST_CHANNEL, "","","");
        llSetText((string)src_start + " - " + (string)src_end + " // " + (string)dst_start + " - " + (string)dst_end,<0,1,0>,1.0);
    }
    touch_start(integer i)
    {
        key k = llDetectedKey(0);
        if(!has_access(k)) return;
        dialog(k);
    }
    listen(integer channel, string name, key id, string message)
    {
        key k = llGetOwnerKey(id);
        if(!has_access(k)) return;
        if(channel == BROADCAST_CHANNEL)
        {
            processRootCommands(message);
        }
        if(channel == INPUT_CHANNEL)
        {
            llListenRemove(gListenHandle);
            if( message != "Cancel" ) {
                if(startswith(message,"X")) { MAXIS.x = !(integer)MAXIS.x; dialog(id);}
                if(startswith(message,"Y")) { MAXIS.y = !(integer)MAXIS.y; dialog(id);}
                if(startswith(message,"Z")) { MAXIS.z = !(integer)MAXIS.z; dialog(id);}
                if(message == "Mirror") { mirror(); dialog(id);}
            }
        }
    }
}
