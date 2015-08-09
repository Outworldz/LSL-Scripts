// :CATEGORY:Spy
// :NAME:Mission_Spy
// :AUTHOR:Sparti Carroll
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:57
// :ID:514
// :NUM:696
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Caution. Use of this script may violate the TOS. Think of it as a weapon// // // Don't use this to spy on people without their permission// // 
// NO REALLY - DON'T
// 
// 
// SECURITY
// I take the Open Source security software attitude to this. You can't increase security through obscurity. All users of SL should be aware that tiny, invisible objects might be relaying their conversations to other AVs, or even sending IMs or HTTP messages out of SL. A bit like real life really, it's just that bugging is easier in SL.
// 
// If you want a semblance of privacy then use a one time pad code end to end in a sim which is completely off limits to all except your invited guests; deny others the ability to execute scripts or place objects; return all objects and check for running scripts (using estate tools) before you start your conversation.
// :CODE:


// Mission Spy

//Simple OpenSource Licence (I am trusting you to be nice)
//1.  PLEASE SEND ME UPDATES TO THE CODE
//2.  You can do what you want with this code and object including selling it in other objects and so on. 
//You can sell it in closed source objects if you must, but please try to send any updates or
//improvements back to me for possible inclusion in the main trunk of development.
//3.  You must always leave these instructions in any object created; notecard written; posting to
//any electronic medium such as Forum, Email &c. of the source code & generally be nice (as
//already requested!)
//4.  You must not claim that anyone apart from sparti Carroll wrote the original version of this software.
//5.  You can add and edit things below =THE LINE= but please try  to keep it all making sense.
//Thank you for your co-operation
//sparti Carroll



integer FLAGdebug = 0;

string version = "1.1";

list visitor_list;
key k_owner; 

string my_notecard = "SETTINGS";

// idea is this object orbits around and every 10 seconds announces who is there by saying or IM to owner

// Notecard handler based on http://secondlife.com/badgeo/wakka.php?wakka=LibrarySettingsNotecard
key kCurrentDataRequest;
string sSettingsNotecard;

//notecard configurable parameters
float range;     // sensor range, in m
integer channel;
integer h_listen;
integer h_zero;  // listening on 0
integer FLAGincludeowner;
integer FLAGtrack;  // move to specified person's location + offset then stay there
integer FLAGuseIM;
string trackname;   // who to track
string my_label;
float t_scan;  // how often to scan
vector track_offset = <0,0,3>;

// time slices
float t_slice;     // number of seconds /slice
integer ts_count;
integer ts_clearlist;

// spy control
integer FLAGspy;   // listen to ch 0


// reset function for params, use notecard values if present
reset() {
    visitor_list = [];
   range = 100.0;     // sensor range, in m
   channel = 55;
   FLAGincludeowner = 0;
   FLAGspy = 1;
   FLAGtrack = 0;
   trackname = "";
    k_owner = llGetOwner();
    FLAGuseIM = 0;
    llSetAlpha(0.0,ALL_SIDES);
}

sayowner(string s) {
    if (FLAGuseIM) llInstantMessage(k_owner,s);
    else llOwnerSay(s);
}

// time itself and dependencies
reset_time() {
   t_scan = 5.0;  // how often to scan in seconds (independent of time slices)
   t_slice = 5.0;  // time slice - speed of object (smallest division of time)
   ts_count = 0;  // time slice counter
   ts_clearlist = 360;  // clear list every 30 mins
}

// Functions
integer isNameOnList( string name )
{
    integer len = llGetListLength( visitor_list );
    integer test_len = llStringLength(name);
    integer i;
   for( i = 0; i < len; i++ ) {
        string list_name = llList2String(visitor_list,i);
        if (llGetSubString(list_name,0,test_len) != name) return TRUE;
    }
    return FALSE;
}

integer iNoteCardLine;

set_position(vector targetpos) {
   while (llVecDist(llGetPos(),targetpos) > 0.001) llSetPos(targetpos);
}


default
{
    on_rez( integer param ) {
        llResetScript();
        reset();
    }

    state_entry() {
        reset();
      integer iNotecardCount = llGetInventoryNumber( INVENTORY_NOTECARD );
        integer iNotecardIndex = 0;
        integer FLAGfoundmycard = FALSE;
        while( FLAGfoundmycard == FALSE && iNotecardCount > iNotecardIndex )  {  // if any notecards exist, get name of them until find my_notecard
            sSettingsNotecard = llGetInventoryName( INVENTORY_NOTECARD, iNotecardIndex );
            if (sSettingsNotecard == my_notecard) {
               iNoteCardLine = 0;
               FLAGfoundmycard = TRUE;
               // YYY get notecard lines one at a time (drops key as only one request ?)
               // ZZZ should do timer here, in case dataserver fails to return
               kCurrentDataRequest = llGetNotecardLine( sSettingsNotecard, iNoteCardLine );
            } else {
               iNotecardIndex += 1;  // go try next notecard
            }
        }
        if (FLAGfoundmycard == FALSE) {  // there are no useable notecards... 0 or none called my_notecard
            sayowner( "No notecard found. Please read configuration instructions. Using defaults." );
            state running;
        }
    }

    dataserver( key kQuery, string sData ) {
       // YYY see above, notecard lines arrive one at a time
      if( sData != EOF ) {
            list cmdline = llParseString2List(sData,[" ","="],[]);
            string cmd = llList2String(cmdline,0);
            string par = llList2String(cmdline,1);
            if (cmd == "range") range = (float)par;
            if (cmd == "time") t_scan = (float)par;
            if (cmd == "channel") channel = (integer)par;
            if (cmd == "owner") FLAGincludeowner = (integer)par;
            if (cmd == "useim") FLAGuseIM = (integer)par;
            if (cmd == "spy") FLAGspy = (integer)par;
            kCurrentDataRequest = llGetNotecardLine( sSettingsNotecard, ++iNoteCardLine );  // YYY get rest of card, if any
        } else {
           // We have failed, so run it anyway
           state running;
        }
    }
}  // end state default


state running {
     on_rez(integer start_param) {
         llResetScript();
         state default;
         
     }
    state_entry()
    {
        reset_time();
        llSetText(my_label,<1.0,1.0,1.0>,1.0);
        llSetTimerEvent(t_slice);
        llSensorRepeat( "", "", AGENT, range, TWO_PI, t_scan );
        h_listen = llListen(channel, "", k_owner, "");
    }
    
    sensor( integer number_detected )
    {
        integer i;
          integer trackname_len = llStringLength(trackname);
        for( i = 0; i < number_detected; i++ ) {
            key detected_key = llDetectedKey(i);
            string detected_name = llDetectedName(i);
            vector detected_pos = llDetectedPos(i);
                if (FLAGtrack) {
                    string detected_subname = llToLower(llGetSubString(detected_name,0,trackname_len - 1));
                    if (detected_subname == trackname) {
                        set_position(detected_pos + track_offset);
                    }
                }
                string region_name = llGetRegionName();
            if ( FLAGincludeowner || detected_key != k_owner ) {
                if ( isNameOnList( detected_name ) == FALSE ) {
                     visitor_list += detected_name + " at " + (string)detected_pos + " in " + region_name;
                            llInstantMessage(k_owner,detected_name + " spotted at " + (string)detected_pos + " in " + region_name);
                }
            }
        }    
    }

    listen( integer chan, string name, key id, string message )
    {
      if (chan == 0) {
         llInstantMessage(k_owner,">>" + name + "<< '" + message + "'");
      }
        else if (chan == channel) {
            list cmdline = llParseString2List(message,[" ","="],[]);
            string cmd = llList2String(cmdline,0);
            string par = llList2String(cmdline,1);
            string par2 = llList2String(cmdline,2);
            if (cmd == "range") {
                range = (float)par;
                llSensorRepeat( "", "", AGENT, range, TWO_PI, t_scan );
                sayowner("Scan range set to " + par);
            }
            else if (cmd == "channel") {
                llListenRemove(h_listen);
                channel = (integer)par;
                h_listen = llListen(channel, "", k_owner, "");
                sayowner("Command channel changed to " + (string)channel);
            }
            else if (cmd == "owner") {
                par = llToLower(par);
                if (par == "0" || par == "n" || par == "no") {
                    FLAGincludeowner = 0;
                    sayowner("Owner will no longer be detected");
                }
                else {
                    FLAGincludeowner = 1;
                    sayowner("Owner will be detected");
                }
            }
            else if (cmd == "spy") {
                par = llToLower(par);
                if (h_zero != 0) {
                    llListenRemove(h_zero);
                    h_zero = 0;
                }
                if (par == "0" || par == "n" || par == "no") {
                    FLAGspy = 0;
                    sayowner("Spy mode deactivated");
                }
                else {
                    FLAGspy = 1;
                    h_zero = llListen(0,"","","");
                    sayowner("Spy mode activated");
                }
            }
            else if (cmd == "useim") {
                par = llToLower(par);
                if (par == "1" || par == "y" || par == "yes") {
                    FLAGuseIM = 1;
                    sayowner("Using IM reporting channel");
                }
                else {
                    FLAGuseIM = 0;
                    sayowner("Using OwnerSay reporting channel");
                }
            }
            else if (cmd == "track") {
                if (par == "") {
                    if (trackname == "") sayowner("Not tracking");
                    else sayowner("Currently tracking " + trackname);
                } else if (par == "off") {
                    FLAGtrack = 0;
                } else {
                    if (par2 != "") trackname= par + " " + par2;
                    else trackname = par;
                    trackname = llToLower(trackname);
                    FLAGtrack = 1;
                    sayowner("Now tracking " + trackname);
                }
            }
            else if( message == "report" ) {
            sayowner("ScanReport:");
            integer len = llGetListLength( visitor_list );
            integer i;
            for( i = 0; i < len; i++ ) {
                sayowner(llList2String(visitor_list, i));
            }
            sayowner("Total = " + (string)len ); 
        }
        else if( message == "reset" ) {
              state default;
          }
          else if (message == "die") {
              sayowner( "Terminated");
              llDie();
          }
      }
    }   // end listen()
    
   timer()  { // now under t_slice control
      ts_count++;
      if (ts_count % ts_clearlist == 0) { // clear list of people
         visitor_list = [];
      }
   }      
} // end state run_object
