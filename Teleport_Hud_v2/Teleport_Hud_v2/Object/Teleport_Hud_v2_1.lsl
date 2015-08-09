// :CATEGORY:Teleport
// :NAME:Teleport_Hud_v2
// :AUTHOR:donjr Spiegelblatt
// :CREATED:2012-06-04 08:22:04.420
// :EDITED:2013-09-18 15:39:06
// :ID:873
// :NUM:1233
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// This is my(Donjr Spiegelblatt) version of Teleport hud v2.lsl
// :CODE:
// Teleport HUD
// Jesse Barnett
// 1/16/08

/* **************************
One of my first "real" scripts from waaaaaay back when.
Hopefully users will do more than just use this script. Strided lists and
manipulating lists are the closest we get to arrays in LSL presently.
Even with all of the list juggling here, you will be surprised just how many
destinations you can add.

(donjr: Under MONO it's now 11 sims and 10 entries per sim or 110 max if you use all entries)

A lot of code but this is the only teleporter I have been using for over a year now.
No notecards or lists to fill out. Very user freindly.
Wherever you are, just touch the button, hit ""Add" and it will prompt you for the name
Type what you want to name it in open chat, hit enter and you are done
It will store the sim name, the name you gave it for the menu buttons and the location
automatically

(donjr: While I've been using a number of "teleporters" this one is always close at hand.)

******** old way
It will only show the destinations for the simulator you are in.
Pick the destination from the menu, touch the bubble that is rezzed in front of
you and you will instantly teleport to that spot.
You can also easily remove destinations by picking ""Remove" in the menu and then
touching the button name you wish to remove.
In case you are worried about loosing your destinations, you can also use the
"List" button to output the list of all destinations from all sims.
I have never lost the destinations because of sim resets etc.
Have lost them twice tweaking the script. But adding destinations again is so easy
it is no problem.

To use, create a button and attach it to the desired position on your HUD.
Place this script inside, Put the warp pos script into another object you want
to rez as the bubble, edit it so that when you left click, you will sit.
Take the "bubble" back into inventory and then place it in the HUD also.
********** end old way

*** Donjr Spiegelblatt  (new way) as of: 1/3/11

Add support for a "Backup TP menu" notecard (format is the same as the LISTing output)
Allows saving/tranfer of entries from one hud to another.

Now use RLV command llOwnerSay("@tpto:"...)  so you have to have RLV enabled for it to function.
But that means NO "bubble" and you can TP even to other sims without prompting.

Now you can also UP navagate and select another sim group. (support allowed by using RLV)

If there is no entries for the current 'sim' it starts at the sims level
Named teleport Entries are unique to a SIM

Other fixes to asure proper table handling and index searches
and caught a few undefined features that cheeped in unannounced.

May 29, 2012
Change how 'state add_dest' gets the Region Corner for the SIM. Now uses llGetRegionCorner, simpler.

Added a FLAG 'UseRLV' to switch from Using RLV to Using llMapDestination.
Added a Toggle to the Option menu (to toggle above flag), as sometimes a Map is useful instead
of a FORCE teleport.

Cleaned up a little of the 'state' logic,
also brought back the default selection as the current sim your in, if tp's exists for it.

Fixed handling of NO 'dest'ination at all conditions.
And selection of list sim in list, there use to be a hard to spot errous behavior.
(I have a selection of tp points that I defaultly load and hadn't hit those conditions in a while)

******************************************
*************************************** */ 

integer UseRLV = FALSE;     // toggle between RLV tpto and Map Destination
 
string sim;             // current working sim
list sims;              // list of sim names only
list dest;              // strided list with the following stride layout:
// [
// integer DEST_sim_name = 0;      // name of sim associated with this entry
integer DEST_name     = 1;      // name of this entry
integer DEST_loc      = 2;      // absolute location of this tp
// ];
integer DEST_Stride   = 3;

list main_menu;                 // current working menu
list menu_options =["Add", "Remove", "Back", "List", "Toggle"];     // option menu

integer menu_chan;
integer menu_chan_handle = 0;

integer edit_chan = 33; // Could change this to another channel if you want for privacy
                        // It is only used to enter the destination name when you use "Add"
integer edit_chan_handle = 0;

// load the "Backup TP menu" note card
key NCKey;
integer NCLine = 0;
string NCName = "Backup TP menu";

string current_sim = "";    // used by default to track change by other sources

// these are udateded used by GetCurrent_Sim().  dest_sim_loc is used in part to convert index into pointer
integer dest_sim_loc = -1;      // start of current sim menu in dest
integer dest_end_loc = -1;      // end of current sim menu in dest
string  currentsim   = "";
list GetCurrent_Sim()
{
    if (dest_sim_loc == -1 || currentsim != sim)
    {
        currentsim = sim;

        // Calculates the last entry in the current sim
        integer loc = llListFindList(sims,[sim]) + 1;
        // in sims find this sim plus one to find the next name in the list
        dest_end_loc = llListFindList(dest,[llList2String(sims, loc)]);
        if(~dest_end_loc)           // only subtract 1 only if the entry was found
            dest_end_loc -= 1;      // selection of last sim in list hits the not found condition.

        // 1st entry in list for the current sim
        dest_sim_loc = llListFindList(dest,[sim]);
    }
    // return a list containing only destinations that are in the current selected sim
    list tmp= llList2ListStrided(llDeleteSubList(dest, 0, 0), dest_sim_loc, dest_end_loc, DEST_Stride);
    // llOwnerSay("debug GetCurrent_Sim tmp=["+llDumpList2String(tmp,", ")+"]");
    // llOwnerSay("debug  dest_sim_loc="+(string)dest_sim_loc+"  dest_end_loc="+(string)dest_end_loc);
    return tmp;
}

default
{
    state_exit()
    {
        llSetTimerEvent(0);
        llListenRemove(menu_chan_handle);
        menu_chan_handle = 0;
    }
    state_entry()
    {
        // llOwnerSay("state default");
        dest_sim_loc = -1; // mark that they need to be gotten again
        menu_chan = (integer)llFrand(-100000 - 99999999) - 100000;
        if ( dest == [] )
            state LoadData;
        current_sim = llGetRegionName();
    }
    touch_start(integer num_detected)
    {
        llSetColor(<1,0,0>,ALL_SIDES);
        if(sim != "" || current_sim != llGetRegionName())
        {
            sim = llGetRegionName();        // default to the current location
            if(~llListFindList(sims,[sim]))
                state Current_Sim;
        }
        state select_sim;
    }
}

state LoadData
{
    state_entry()
    {
        llOwnerSay("Reading notecard...");
        if(llGetInventoryType(NCName) != INVENTORY_NOTECARD)
            state select_sim;
        NCKey = llGetNotecardLine(NCName, NCLine=0);
    }
    dataserver(key NC2, string data)
    {
        if ( NCKey == NC2 )
        {
            if ( data == EOF )
            {
                sims = [];
                if(dest == [])
                    state select_sim;
                //  else
                dest = llListSort((dest=[]) + dest, DEST_Stride, TRUE);
                list tmp = llList2ListStrided(dest,0,-1,DEST_Stride);
                while(tmp != [])
                {
                    string wrk = llList2String(tmp,0);
                    tmp = llDeleteSubList((tmp=[])+tmp,0,0);
                    sims += wrk;
                    while(llList2String(tmp,0) == wrk)
                        tmp = llDeleteSubList((tmp=[])+tmp,0,0);
                }
                state list_mem;
            }
            else
            {
                data = llStringTrim(data, STRING_TRIM);     // remove those pesky trailing blanks
                integer pos = llSubStringIndex(data,": ");
                if ( pos > -1 )
                {
                    data = llGetSubString(data, pos+2,-1);      // remove time and object name
                    pos = llSubStringIndex(data," , ");
                    string sim_name = llGetSubString(data, 0, pos-1);
                    integer np = llSubStringIndex(data," = ");
                    string location = llGetSubString(data, np+3, -1);
                    if ( llGetSubString(location, -1,-1) == "/" )
                        location = llGetSubString(location, 0,-2);
                    string name = llGetSubString(data, pos+3,np-1);
                    llOwnerSay("sim="+sim_name+" name="+name+" location="+location);
                    dest += [ sim_name, name, location ];
                }
                NCKey = llGetNotecardLine(NCName, NCLine++);
            }
        }
    }
}

state select_sim
{
    state_exit()
    {
        llSetTimerEvent(0);
        llListenRemove(menu_chan_handle);
        menu_chan_handle = 0;
    }
    state_entry()
    {
        sim = "";
        main_menu = ["Options"] + sims;
        menu_chan_handle = llListen(menu_chan, "", llGetOwner(), "");
        llSetTimerEvent(20);
        llDialog(llGetOwner(), "Choose Sim or Options to add/remove destinations", main_menu, menu_chan);
        llSetColor(<1,1,1>,ALL_SIDES);
    }
    touch_start(integer num_detected)
    {
        llSetTimerEvent(20);
        llDialog(llGetOwner(), "Choose Sim or Options to add/remove destinations", main_menu, menu_chan);
    }
    listen(integer channel, string lm, key id, string message)
    {
        if (~llListFindList(main_menu + menu_options,[message]))
        {
            if (message == "Options" || message == "Toggle")
            {
                if(message == "Toggle")
                    UseRLV = ! UseRLV;
                string stp = "Map Destination";
                if(UseRLV)
                    stp = "RLV tpto force";
                llSetTimerEvent(20);
                llDialog(llGetOwner(), "Pick an option!\nCurrent tp="+stp, menu_options, channel);
            }
            else if (message == "Back")
            {
                llSetTimerEvent(20);
                llDialog(llGetOwner(), "Choose Sim or Options to add/remove destinations", main_menu, channel);
            }
            else if (message == "Add")
            {
                sim = llGetRegionName();
                main_menu = ["Options","UP"];
                if(llListFindList(sims,[sim]) == -1)
                {
                    if(llGetListLength(main_menu) > 11)
                    {
                        sim = "";
                        llOwnerSay("You can NOT add any more sims");
                        state default;
                    }
                    // add_dest is about to add the first entry for this sim
                }
                else
                    main_menu += GetCurrent_Sim();  // current sim selection
                state add_dest;
            }
            else if (message == "Remove")
            {
                state rem_sim;
            }
            else if (message == "List")
            {
                state list_mem;
            }
            else
            {
                sim = message;
                state Current_Sim;
            }
        }
    }
    timer()
    {
        state default;
    }
}

state Current_Sim
{
    state_exit()
    {
        llSetTimerEvent(0);
        llListenRemove(menu_chan_handle);
        menu_chan_handle = 0;
    }
    state_entry()
    {
        // Now menu list is built only showing destinations that are in the current selected sim
        main_menu = ["Options","UP"] + llListSort(GetCurrent_Sim(), 1, TRUE);

        menu_chan_handle = llListen(menu_chan, "", llGetOwner(), "");
        llSetTimerEvent(20);
        llDialog(llGetOwner(), "Choose destination or Options to add/remove destinations:\nCurrent selected sim is: "+sim, main_menu, menu_chan);
        llSetColor(<1,1,1>,ALL_SIDES);
    }
    touch_start(integer num_detected)
    {
        llSetTimerEvent(20);
        llDialog(llGetOwner(), "Choose destination or Options to add/remove destinations:\nCurrent selected sim is: "+sim, main_menu, menu_chan);
    }
    listen(integer channel, string lm, key id, string message)
    {
        if (~llListFindList(main_menu + menu_options,[message]))
        {
            if (message == "UP")
                state select_sim;
            else if (message == "Options" || message == "Toggle")
            {
                if(message == "Toggle")
                    UseRLV = ! UseRLV;
                string stp = "Map Destination";
                if(UseRLV)
                    stp = "RLV tpto force";
                llSetTimerEvent(20);
                llDialog(llGetOwner(), "Pick an option!\nCurrent selected sim is: "+sim+"\nCurrent tp="+stp, menu_options, channel);
            }
            else if (message == "Back")
            {
                llSetTimerEvent(20);
                llDialog(llGetOwner(), "Choose destination or Options to add/remove destinations:\nCurrent selected sim is: "+sim, main_menu, channel);
            }
            else if (message == "Add")
            {
                state add_dest;
            }
            else if (message == "Remove")
            {
                state rem_dest;
            }
            else if (message == "List")
            {
                state list_mem;
            }
            else // if (llListFindList(GetCurrent_Sim(),[message]) != -1)
            {
                // search within Names in the current SIM group only, Allows names to be unique to a SIM
                integer index = llListFindList(GetCurrent_Sim(), [message]);
                if (~index)
                {
                    // convert sub menu index into dest array pointer
                    index = dest_sim_loc + (index * DEST_Stride);
                    string sHome = llList2String(dest, index + DEST_loc);
                    // llOwnerSay("sHome="+sHome);
                    if(UseRLV)
                    {
                        llOwnerSay ("Teleporting");
                        llOwnerSay ("@tpto:"+sHome+"=force");
                    }
                    else
                    {
                        // display a map
                        // first convert sHome to a Vector
                        list t = llParseString2List(sHome,["/"],[]);
                        vector pos = <(float)llList2String(t,0),(float)llList2String(t,1),(float)llList2String(t,2)>;
                        // then turm it into a realative offset
                        pos -= llGetRegionCorner();
                        // llOwnerSay("llMapDestination("+llGetRegionName()+", pos="+(string)pos);
                        // then display on map
                        llMapDestination(llGetRegionName(), pos, ZERO_VECTOR );
                    }
                }
                state default;
            }
        }
    }

    timer()
    {
        state default;
    }
}

state list_mem
{
    state_entry()
    {
        if (dest == [])
            llOwnerSay("No Destinations Available.");
        else
        {
            integer stop = llGetListLength(dest);
            integer i;
            for (i = 0; i < stop; i += DEST_Stride)
            {
                string sim_name = llList2String(dest, i);   // + DEST_sim_name
                string name     = llList2String(dest, i + DEST_name);
                string location = llList2String(dest, i + DEST_loc);
                llOwnerSay(sim_name + " , " + name + " = " + location);
            }
        }
        state default;
    }
    on_rez(integer xxx)
    {
        state default;
    }
}

state add_dest
{
    on_rez(integer xxx)
    {
        state default;
    }
    state_entry()
    {
        integer b = ((llGetListLength(main_menu)) <= 11);
        // Only allows 11 entries per simulator
        integer m = (llGetFreeMemory() >= 1000);
        // Make sure we have enough memory to manipulate the lists
        if (!b || !m)
        {
            if(!m)
                llOwnerSay("Out of free working memory no more destinations can be added.");
            else
                llOwnerSay("You can NOT add any more destinations to this sim.");
            state default;
        }
        llOwnerSay("Enter the name in the text box or type the destination name on channel /" + (string)edit_chan );
        llSetTimerEvent(40);
        edit_chan_handle = llListen(edit_chan, "", llGetOwner(), "");
        llTextBox(llGetOwner(),"What do you want to name this destination?",edit_chan);
    }
    state_exit()
    {
        llSetTimerEvent(0.0);
        llListenRemove(edit_chan_handle);
        edit_chan_handle = 0;
    }
    listen(integer chan, string name, key id, string msg)
    {
        // llOwnerSay("Heard: "+msg);
        if (llListFindList(sims,[sim]) == -1)
            sims = llListSort((sims=[]) + sims + [sim], 1, TRUE);  // add a new sims entry
        else
        {
            integer i = llListFindList(GetCurrent_Sim(), [msg]);
            if(~i)
            {
                // an entry by that name already exists in this SIM group, so delete it
                // convert sub menu index into dest array pointer
                i = dest_sim_loc + (i * DEST_Stride);
                dest = llDeleteSubList((dest=[])+dest, i, i + DEST_Stride - 1);
            }
        }
        vector vHome = llGetRegionCorner() + llGetPos();
        dest  += [sim, msg, (string)vHome.x+"/"+(string)vHome.y+"/"+(string)vHome.z];
        dest   = llListSort(dest, DEST_Stride, TRUE); //Sorts the list in Strides according to sim
        llOwnerSay("Added: " + sim + " , " + msg + " = " + (string)vHome.x+"/"+(string)vHome.y+"/"+(string)vHome.z);
        // llOwnerSay("dest=["+llDumpList2String(dest,", ")+"]");
        state default;
    }
    timer()
    {
        llOwnerSay("Timeout. Click TP HUD to start again");
        state default;
    }
}

state rem_dest
{
    on_rez(integer xxx)
    {
        state default;
    }
    state_entry()
    {
        llSetTimerEvent(20);
        menu_chan_handle = llListen(menu_chan, "", llGetOwner(), "");
        llDialog(llGetOwner(), "Which desination do you want to remove?", main_menu, menu_chan);
    }
    state_exit()
    {
        llSetTimerEvent(0.0);
        llListenRemove(menu_chan_handle);
        menu_chan_handle = 0;
    }
    listen(integer i, string name, key id, string msg)
    {
        if ((i = llListFindList(GetCurrent_Sim(), [msg])) != -1)
        {
            // convert sub menu index into dest array pointer
            i = dest_sim_loc + (i * DEST_Stride);
            dest = llDeleteSubList((dest=[])+dest, i, i + DEST_Stride - 1);
            llOwnerSay("Removed : " + msg);
            if (llListFindList(llList2ListStrided(dest,0,-1,DEST_Stride),[sim]) == -1)
            {
                // this was the only entry for this sim also remove it's sims entry.
                i = llListFindList(sims,[sim]);
                sims = llDeleteSubList((sims=[])+sims, i, i);
            }
            state default;
        }
    }
    timer()
    {
        llOwnerSay("Timeout. Click TP HUD to start again");
        state default;
    }
}

state rem_sim
{
    on_rez(integer xxx)
    {
        state default;
    }
    state_entry()
    {
        llSetTimerEvent(20);
        menu_chan_handle = llListen(menu_chan, "", llGetOwner(), "");
        llDialog(llGetOwner(), "Which SIM (entries) do you want to remove?", ["Cancel "]+sims, menu_chan);
    }
    state_exit()
    {
        llSetTimerEvent(0.0);
        llListenRemove(menu_chan_handle);
        menu_chan_handle = 0;
    }
    listen(integer i, string name, key id, string msg)
    {
        if((i = llListFindList(sims,[msg])) != -1)
        {
            sim = msg;
            GetCurrent_Sim();
            // we want dest_sim_loc and dest_end_loc updated not the temp list that returned
            // Now delete the 'sims' entry
            sims = llDeleteSubList((sims=[])+sims,i,i);
            // Now delete all the 'dest' entries referencing this sim(msg)
            dest = llDeleteSubList((dest=[])+dest, dest_sim_loc, dest_end_loc);
        }
        state default;
    }
    timer()
    {
        llOwnerSay("Timeout. Click TP HUD to start again");
        state default;
    }
}
