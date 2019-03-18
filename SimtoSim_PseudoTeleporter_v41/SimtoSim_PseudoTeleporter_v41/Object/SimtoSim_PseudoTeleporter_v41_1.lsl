// :CATEGORY:Teleport
// :NAME:SimtoSim_PseudoTeleporter_v41
// :AUTHOR:donjr Spiegelblatt
// :CREATED:2012-05-18 10:30:39.843
// :EDITED:2013-09-18 15:39:02
// :ID:770
// :NUM:1057
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// modified by: Donjr Spiegelblatt  (May 17, 2012)// add support for://    multi-users of the menu system at the same time//    Cancel button when only one menu is used//    suppot for comment lines in Data starting with # character// new features:
//    PrettyButton  layout of the buttons in dialogs
//    combined placeNames, simNames and locationVectors  into a two strided list called places
// :CODE:

// Modified to use SLURs by Fred Beckhusen (Ferd Frederix) 6-7-2013
// modified by: Donjr Spiegelblatt  (May 17, 2012)
//add support for:
//   multi-users of the menu system at the same time
//   Cancel button when only one menu is used
//   suppot for comment lines in Data starting with # character
//new features:
//   PrettyButton  layout of the buttons in dialogs
//   combined placeNames, simNames and locationVectors  into a two strided list called places
// Sheena Desade's Sim-to-Sim Teleporter Script and Notecard (v3.1).
// Includes dynamic smart menu and instant teleportation (no confirmation required) via chat link.
// Missing sanity checks, so format things correctly!
// Public domain (open-source) since April 10, 2012.

/* 
This script was made April 10, 2012 by Sheena Desade. It is meant only to be redistributed freely
(not ever to be sold)! Leave this header intact; other than those two requirements, do what you
will with it. And if you make an improvement, feel free to send me a copy. :-)
*/ 

/* *********************************
modified by: Donjr Spiegelblatt  (May 17, 2012)
add support for:
   multi-users of the menu system at the same time
   Cancel button when only one menu is used
   suppot for comment lines in Data starting with # character
new features:
   PrettyButton  layout of the buttons in dialogs
   combined placeNames, simNames and locationVectors  into a two strided list called places
********************************** */

// Modded by Fred Beckhusen (Ferd Frederix) on 5-30-2013 to run in OpenSim


// ******** OPTIONAL SETTINGS **********
string hoverText    = "Sim-to-Sim Pseudo Teleporter - click for destinations.";
integer menuWait    = 30;       // How long to wait for the user to pick a menu choice
integer menuChannel = -14469;   // what channel for the object to 'listen' on.
                                // You can change this channel as needed,
                                // it's not calling out to an object outside of itself.
string menuText = "Please select your destination:";
string itemDataNotecard = "Data";
                                // The name of the notecard to read from
// ******** END OF OPTIONAL SETTINGS **********

// ******** SYSTEM SETTINGS - DO NOT MODIFY **********
// General variables
list menu_users = [];           // strided list of menu users
// [
// integer MENU_user    = 0;       // key of this menu user, unique one entry per user
integer MENU_handle  = 1;       // listen handle of this users llListen
integer MENU_timeout = 2;       // creation time of this dialog
integer MENU_curList = 3;       // the current page for this user
// ];
integer MENU_stride  = 4;       // Length of one strided of this list

// The following are required to read the notecard properly
integer notecardLine   = 0;
key currentDataRequest = NULL_KEY;
key notecarduuid       = NULL_KEY;

integer length;             // How many menu pages we have
list places;                // strided list of Placename and Sim/position

string BLANK  = " ";        // used for filler space(s) in dialogs

string Prev   = "<< Prev ";
string Cancel = "Cancel ";
string Next   = "Next >> ";
list Navigate ;     // the full navagation functions
// ******** END OF SYSTEM SETTINGS and Globals **********

list PrettyButtons(list options, list utilitybuttons)   // from SchmoDialog
{
    // returns a list formatted to that "options" will start in the top left of a dialog,
    // and "utilitybuttons" will start in the bottom right
    list spacers;
    list combined = options + utilitybuttons;
    while (llGetListLength(combined) % 3 != 0 && llGetListLength(combined) < 12)
    {
        spacers += [BLANK];
        combined = options + spacers + utilitybuttons;
    }

    return llList2List(combined, 9, 11)
         + llList2List(combined, 6,  8)
         + llList2List(combined, 3,  5)
         + llList2List(combined, 0,  2);
}

advancedMenu(key user, integer curList)
{
    integer StartTimer = (menu_users == []);       // check if the timer needs starting
    integer p = llListFindList(menu_users,[user]);
    if(~p)      // update the returning user's "creation time and curList"
        menu_users = llListReplaceList( menu_users, [llGetUnixTime(), curList], p + MENU_timeout, p+MENU_curList);
    else if(llGetListLength(menu_users) > 63)    // make sure a listen is aviable
    {
        llInstantMessage(user, "Please try again later the system is currently full!");
        return;
    }
    else        // first time menu user open there listen and create there entry
        menu_users += [user, llListen(menuChannel,"",user,""),llGetUnixTime(), curList];

    list buttons = llList2ListStrided(places,0,-1,2);   // make a list of only Places
    list utility = [Cancel];          // user should always have a Cancel option
    if (length > 1)
    {
        // We have more than one page of places.
        p = 9 * curList; // Figures out the start of the subsection of places to display
        buttons = llList2List(buttons, p, p+8);     // 'buttons' now has one to nine places
        utility = Navigate;         // give full navigation buttons
    }
    buttons = PrettyButtons(buttons, utility);
    // the 'buttons' list also now has other options besides our Places
    // and the 'utility' button(s) are always on the bottom row.

    llDialog(user,menuText,buttons,menuChannel);  // Sends a dialog to the user with the new improved button list
    if(StartTimer)
        llSetTimerEvent(5.0); // how often to check for possible timeouts, low number here would just waste processor time
}

remove(integer index, string message)
{
    // Close this users Listen
    llListenRemove(llList2Integer(menu_users, index+MENU_handle));
    // Instant message the message to the user
    llInstantMessage(llList2Key(menu_users, index), message);
    // delete there menu_users entry
    menu_users = llDeleteSubList(menu_users, index, index+MENU_stride-1);
    if(menu_users == [])        // if there are no current users
        llSetTimerEvent(0.0);       // stop the timer
}

default
{
    on_rez(integer param)
    {
        llResetScript(); // Resets script on rez
    }
   
    state_entry()
    {
        Navigate = [ Prev, Cancel, Next ];     // the full navagation functions
        llOwnerSay("Initializing...");
        llOwnerSay("Reading item data...");
        // we start reading the notecard at line 0, the first line specify our initial request
        if(llGetInventoryType(itemDataNotecard) == INVENTORY_NOTECARD)
        {
            notecardLine=0;
            currentDataRequest = llGetNotecardLine(itemDataNotecard,notecardLine);
        }
        else
        {
            state configured;            // Handle the condition of no Data notecard
        }
    }
   
    dataserver(key query, string data)
    {
        if (query == currentDataRequest) // if we are trying to read the notecard
        {
            llOwnerSay(data);
            
            currentDataRequest = NULL_KEY; // Prevent a bug that occurs with dataserver events.
            if (data == EOF) // If it the end of the file
            {
                     // Define how many pages of entries we have in the places list
                length = llGetListLength(places) / 2;
                if(length < 12)
                    length = 1;
                else
                    length = length / 9 + 1;
                llOwnerSay ("Done reading data.");
                state configured;
            }
            else
            {
                // **** IMPORTANT: I did not put any sanity checks in here, so you'll need to type
                // it all correctly, in the format "Store Name | Sim Name @ x/y/z" or it will not
                // work correctly! ****
                data = llStringTrim(data, STRING_TRIM);    // remove pesky leading and trailing whitespace
                if(llGetSubString(data,0,0) != "#" && data != "")         // lines starting with # are comments
                {
                         // We're looking for the | and @ symbol in our data line
                    list psv = llParseString2List(data,["|","@"],[]);
                    if(llGetListLength(psv) == 3) // If we found them
                    {
                            // note: Appending the BLANK make Ignore not a key word
                        string place = llStringTrim(llList2String(psv,0), STRING_TRIM)+BLANK;
                            // make sure it NOT a BLANK or one of the navigation entries
                        if(llListFindList(Navigate+[BLANK], [place]) == -1)   // these we don't want
                        {
                            string sim = llDumpList2String(llParseString2List(llStringTrim(llList2String(psv,1), STRING_TRIM), [" "], [""]), "%20");
                            // into sim erasing all internal spaces and replacing them with %20... there might be a better way to do this

                                // Generate a new temp record entry
                            list tmp = [place, sim+"/"+llStringTrim(llList2String(psv,2), STRING_TRIM)];

                            //  update entry matching on 'place' or append new entry to end of list
                            integer x = llListFindList(llList2ListStrided(places+tmp,0,-1,2),[place])*2;
                            places = llListReplaceList(places, tmp, x, x+1);

                            // We put it here so that it will not add the location unless there are also sim and placeNames.
                            // (donjr) No you put it here as you don't have all the info until this point
                        }
                    }
                    else
                    {
                        integer s = llSubStringIndex(data, "="); // Now we are looking for the = symbol
                        if(~s) // if we find it
                        {
                            string token = llToLower(llStringTrim(llDeleteSubString(data, s, -1), STRING_TRIM));
                            // use our tokens to determine which variable we are defining
                            data = llStringTrim(llDeleteSubString(data, 0, s), STRING_TRIM);
                            // use our data to define our chosen variable
                            if (token == "hover_text")
                                hoverText = data;
                            else if (token == "menu_text")
                                menuText = data;
                            else if (token == "menu_channel")
                                menuChannel = (integer)data;
                            else if (token == "selection_wait_time")
                                menuWait = (integer)data;
                        }
                    }
                }
                // Get the next line
                currentDataRequest = llGetNotecardLine(itemDataNotecard, ++notecardLine);
            }
        }
    }
    

}

state configured
{
    on_rez(integer param)
    {
        llResetScript(); // Resets script on rez
    }




    state_entry()
    {
            // collects our notecarduuid as soon as we enter this state
        notecarduuid = llGetInventoryKey(itemDataNotecard);
        if (hoverText != "none")
            llSetText(hoverText, <1.0,1.0,1.0>, 1); // if you want hovertext
        else
            llSetText("", <1.0, 1.0, 1.0>, 0); // if you do not want hovertext
        llWhisper(0, "Ready and waiting.");
    }
   
    changed(integer change)        
    {
        // We want to reload the Data notecard if it changed
        if (change & CHANGED_INVENTORY)
        {
            if(notecarduuid != llGetInventoryKey(itemDataNotecard)) // If the change was triggered by saving the NC
            {
                llOwnerSay("Notecard change detected, resetting script.");
                llResetScript(); // resets the script
            }
        }
    }

    timer()
    {
        integer dietime = llGetUnixTime() - menuWait;
        // moving backward through the list/array
        // allows us to delete records without messing up the index.
        integer index = llGetListLength(menu_users);
        while(index)
        {
            index -= MENU_stride;
            if(llList2Integer(menu_users, index+MENU_timeout) < dietime)
                remove(index, "Menu session timed out.");
        }
    }
   
    touch_start(integer num)
    {
        do {
            --num;
            advancedMenu(llDetectedKey(num), 0); // Send the user the dialog box, first page
        } while(num);
    }
   
    listen(integer index,string name,key user,string message)
    {
        // this is for the script to follow instructions based on what happens with the menu.
        index = llListFindList(menu_users,[user]);
        if(~index)          // not sure this will ever fail, but proper Bookkeeping requires it
        {
            integer curList = llList2Integer(menu_users, index + MENU_curList);
            if(message == Prev || message == Next || message == BLANK)
            {
                if(message == Prev)
                {
                    if(curList == 0)            // If we're on the first page
                        curList = length - 1;       // wrap to the last page
                    else                        // If we're not on page one
                        curList--;                  // Go backwards a page
                }
                else if(message == Next)
                    curList = (curList + 1) % length;   // this takes care of the wraping
                // else if (message == BLANK)
                //   { } // do nothing here user selected a spacer just redisplay the same menu
                advancedMenu(user, curList);          // Give the user the dialog menu
            }
            else
            {
                if(message == Cancel)
                    remove(index, "Teleport cancelled.");
                else
                {
                         // determine which location we are teleporting to
                    integer loc = llListFindList(llList2ListStrided(places,0,-1,2), [message]);
                    if(~loc) // if it's an actual location
                    {
                        loc *= 2; // convert from Record number to index
                             // Give them the link to click
                        message = "http://slurl.com/secondlife/" + llList2String(places, loc+1);


 
 
                        remove(index, "Click this link to teleport to your target location - "+message);
                    }
                    else        // on unknown message just give the dialog back to the user
                        advancedMenu(user, curList);          // Give the user the dialog menu
                }
            }
        }
    }
}



