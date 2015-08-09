// :CATEGORY:Updater
// :NAME:Script Updater
// :AUTHOR:Ferd Frederix
// :KEYWORDS:Update, updater
// :CREATED:2014-01-30 12:17:30
// :EDITED:2014-02-14 12:33:24
// :ID:1017
// :NUM:1581
// :REV:1.1
// :WORLD:Second Life, OpenSim
// :DESCRIPTION:
// Central prim updater for scripts.  Just drop a (non running) script in here and click the prim.  Scripts are sent to the registered clients
// :CODE:

// Rev 1.1 on 2-13-2014 fixes timeout bugs, adds 
// 


integer debug = TRUE;       // chat a message

// tunables     
integer TITLE = TRUE;      // show how many scripts can be updated in hover text
integer UNIQ = 1246;       // the private channel unique to the owner of this prim - MUST MATCH in client and server
integer CHECKIN = 172860;  // 86400 seconds = 1 day X 2 + 60. This is twice the client setting plus one minute to allow for a dropped packet and slop in LSLEditor

// globals
integer comChannel ;       // we listen on this channel. It is unioque to this owner and a subchannel
integer MINUTE = 60;       // seconds in a minute, seems inefficient, but debug is a lot faster this way!

DEBUG (string msg) { if (debug) llSay(0,llGetScriptName() + ":" + msg);}

// The list is a PIN to update, a timestamp, thre name of the script, the UUID of the prim it was found in
// This is a small searchable database whose primary key (uniq) is name + UUID
integer STRIDE = 4;    // size of this list:
list lScripts;  // +0 (integer) PIN - remote prims random PIN
                // +1 (integer) time stamp last heard from
                // +2 (string) name of script
                // +3 (key) UUID

update()
{
    integer toDo = llGetInventoryNumber(INVENTORY_SCRIPT);        // how many  scripts checked in?
    integer PrimToDo  = llGetListLength(lScripts);

    llOwnerSay((string) (toDo -1)  + " scripts in inventory to send");
    // DEBUG(llDumpList2String(lScripts,","));
    
    integer index;

    // scan all scripts in our inventory, could be more than one needs updating.
    for (index = 0; index < toDo; index++)
    {
        string name = llGetInventoryName(INVENTORY_SCRIPT,index);

        
        // check to see if the name of the script we just found in our inventory matches ourself. if so, skip it
        
        if (name != llGetScriptName()) {
            DEBUG( "Processing script "  + name);
            integer countAllScripts = llGetListLength(lScripts);   

            integer indexer;
            integer counter;
            // Scan over all scripts
            for (indexer = 0; indexer < countAllScripts; indexer += STRIDE) 
            {
                // check to see if the name of the script we just found in our inventory matches any item in the list
                if (llList2String(lScripts,indexer + 2) == name) {
                    
                    key targetUUID = llList2Key(lScripts,indexer + 3);  // yup, the name matches, lets fetch the UUID
                    integer pin = llList2Integer(lScripts,indexer );  //  get the pin
                    DEBUG("Sending " + name + " PIN:" + (string) pin + " UUID:" + (string) targetUUID);
                    llRemoteLoadScriptPin(targetUUID,name,pin, TRUE,0);    // and send it set to run
                    counter++;
                }
            }
            DEBUG("Updated " + (string) counter + " scripts named " + name);
        }
    }
    llOwnerSay("Done!");            

}

default
{
    state_entry()
    {
        if (! TITLE) {
            llSetText("",<1,1,1>,1.0);
        }
        
        // make a private chat channel
        comChannel = (((integer)("0x"+llGetSubString((string)llGetOwner(),-8,-1)) & 0x3FFFFFFF) ^ 0xBFFFFFFF ) + UNIQ;    // UNIQ is the private channel for this owner
        llListen(comChannel,"","","");
        llOwnerSay("Put non-running scripts into inventory and touch this to send them to remote prims.");
        llSetTimerEvent(CHECKIN);  
    }

    listen(integer channel, string name, key id, string msg)
    {
        list params = llParseString2List(msg,["^"],[]);
        string message = llList2String(params,0);
        integer pin = (integer) llList2String(params,1);
        
        integer index;
        integer len = llGetListLength(lScripts);
        integer found = FALSE;

        // CRU of CRUD process
        // try to find a script in that prim previously recorded. If found update
        for ( index = 0; index < len; index += STRIDE) {
            // primary key is composite of UUID of prim and script name
            if (llList2String(lScripts,index+2) == message && llList2Key(lScripts,index+3) == id) {
                // found a prim and script that has already checked in.  
                DEBUG("Located script " + llList2String(lScripts,index+2));
                lScripts = llListReplaceList([pin,llGetUnixTime(),message,pin],lScripts,index,index+3);
                found = TRUE;
                index = len;    // skip to end
            }
        }

        if (!found) {

            DEBUG("Adding script " + message);
            lScripts += pin;                // the remote prim pin
            lScripts += llGetUnixTime();    // time stamp it
            lScripts += message;            // remote prim name
            lScripts += id;                 // remote prim UUID
        }
    }

    touch_start( integer what)
    {
        if (llDetectedKey(0) == llGetOwner()) {
             update();
        }
    }

    // D of CRUD process
    // scan for missing checked-in prims and clean up the list 
    timer()
    {
        integer len = llGetListLength(lScripts);
        
        while (len > 0)
        {
            // look for late checkins, which means a script was stopped or a prim removed.
            // Every day or two plus a minute for message delays is good to prevent RAM from filling up,
            /// and still allows allows one missed message
            
            integer timeago = llGetUnixTime() - llList2Integer(lScripts,len-STRIDE);
            DEBUG("Timeago " + (string) timeago);
            
            if ( timeago > (CHECKIN*2 + MINUTE))
            {
                DEBUG("Have not heard from script named " + llList2String(lScripts,len-2) + ": Script named " + llKey2Name(llList2Key(lScripts,len-1))  );
                lScripts = llDeleteSubList(lScripts,len-STRIDE,len);
                len = llGetListLength(lScripts);
            } else
                len -= 3;
        }

        len = llGetListLength(lScripts);
        if (TITLE) {
            llSetText((string) (len/3) + " scripts",<1,1,1>,1.0);
        }
    }




    
}
