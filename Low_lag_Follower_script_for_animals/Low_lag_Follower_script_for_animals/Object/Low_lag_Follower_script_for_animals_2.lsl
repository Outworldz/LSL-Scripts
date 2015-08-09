// :CATEGORY:Animal
// :NAME:Low_lag_Follower_script_for_animals
// :AUTHOR:Ferd Frederix
// :CREATED:2011-08-04 16:17:15.970
// :EDITED:2013-09-18 15:38:56
// :ID:496
// :NUM:664
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// This Chaser Script goes into an invisible prim.  Make it large and visible at first. or you will certainly have an invisible, tiny, hard to catch prim wandering your sim!
// :CODE:
// Primchaser script 
// Author: Ferd Frederix

// Copyright 2011.   Licensed under the GNU open source license GPLv3
// http://www.gnu.org/copyleft/gpl.html
// You must make this script copy/tranfer AND mod and leave the headers, including this license and other attributions intact.
// modifications are allowed, but the code must always be open. See the GPL for details on your responsibilities under this license.

// requires a notecard "named Route"
// Notecard format 

//there are 6 columns:
//column 1: wait interval (floating point number)  This is the numbner of seconds the prim will wait when it reads this coordinate.  Must be a 0 for no wait.
//column 2: x coordinate (floating point number)
//column 3: y coordinate (floating point number)
//column 4: z coordinate (floating point number)
//column 5: a space, or text to be spoken on a chat 'CommandChannel', which is -236. This allow you to open doors, gates, and such at specifi points in the tour
//column 6: a command, currently only one command is used Speed: N, where N is anumber for how quickly the Chaser will go from one point to another, in seconds. 1 = 1 meter a second, 2 = 2 meters a second

// for some strange reason llParseString2List does not work without some content between the separators,
// Here, I use a space

//Typical notecard:
// 0|56|131|24| | |           //goto 56,131,29
// 0|66|123|23| |Speed: 0.5|  //goto 66,123,23 at double speed
// 0|76|122|22| |Speed:1|     //default speed
// 0|84|122|22| |Speed:20|    //really slow
// 30|97|125|23| | |          //pause 30 seconds at end of tour


integer _debug = FALSE;  // set to TRUE for progress messages

integer CommandChannel = -236; // a possible command channel to open gates, close doors, whatever

list lTimeouts = [];        // storages for notecard columns
list lCoordinate = [];
list lDescriptions = [];
list lCommands = [];

vector priorpos;

// notecard reading
integer iIndexLines;
string NOTECARD = "Route";        // the notecard for configuring

key kNoteCardLines;        // the key of the notecard
key kGetIndexLines;        // the key of the current line
integer i = 0;
integer count = 0;


// speed control
float DAMPING = 1;  // 1 meters per second
vector TargetLocation;    // where we are heading at any moment in time
float INTERVAL = .2; // seconds of timer tick to push us, slower = jerjier motion

string SpeakThis;  // what is to be said


// modified from the original wiki, which is basically broken
string left(string src, string divider) {
    integer index = llSubStringIndex( src, divider );
    if(~index)
        return llDeleteSubString( src, index , -1);
    return src;
}
 
string right(string src, string divider) {
    integer index = llSubStringIndex( src, divider );
    if(~index)
        return llDeleteSubString( src, 0, index + llStringLength(divider) - 1);
    return src;
}

// stripo white spaces
string strip( string str)
{
    string out;
    integer i;

    for ( ; i < llStringLength(str); i++)
    {
        out += llGetSubString(str,i,i);
        out = llStringTrim(out, STRING_TRIM);
    }
    return out;
}

string Getline(list Input, integer line)
{
    return strip(llList2String(Input, line));
}


default
{
    on_rez(integer param)
    {
        llResetScript();
    }

    state_entry()
    {
        llSetAlpha(1.0,ALL_SIDES);
        kNoteCardLines = llGetNumberOfNotecardLines(NOTECARD);
        kGetIndexLines = llGetNotecardLine(NOTECARD,0);
        llSay (0, "Tour guide initialising. Please wait.");
    }

    // read notecard on bootup
    dataserver(key queryid, string data)
    {
        vector TempLocation;
        if (queryid == kNoteCardLines)
            iIndexLines = (integer) data;
        if (queryid == kGetIndexLines)
        {
            if (data != EOF)
            {
                queryid = llGetNotecardLine(NOTECARD, i);
                list lLine = (llParseString2List(data, ["|"], []));
                                
                float Timeout   = (float) Getline(lLine,0);       // Sleep
                float X         = (float) Getline(lLine,1);
                float Y         = (float) Getline(lLine,2);
                float Z         = (float) Getline(lLine,3);
                
                string Msg = llList2String(lLine,4);
                string sCommand = llList2String(lLine,5);

                TempLocation.x = X;
                TempLocation.y = Y;
                TempLocation.z = Z;
                
                lTimeouts += Timeout;
                lCoordinate += TempLocation;
                lDescriptions += Msg;
                lCommands += sCommand;


                integer locationLength = (llGetListLength(lCoordinate));
                integer     InitPerCent = (integer) llRound(((float) locationLength / (float) iIndexLines) * 100);
                llSetText("Initialising... \n" + (string) InitPerCent + "%" , <1,1,1>, 1.0);
                if (InitPerCent == 100)
                    state Paused;
                i++;
            }
            kGetIndexLines = llGetNotecardLine(NOTECARD,i);
        }
    }


    touch_start(integer total_number)
    {
        integer check = llGetListLength(lCoordinate);
        if (_debug)
            llOwnerSay("List is " + (string) check + " destinations long");

        if (check >= iIndexLines)
            state Paused;

        if (check < iIndexLines)
            llSay(0, "Hang on a sec, still initialising...");
    }

    state_exit()
    {
        llSetText("", <1,1,1>, 1.0);
        TargetLocation = (vector) llList2String(lCoordinate, 0);  // Look at 0th
    }
}


state Paused
{
    state_entry()
    {
        TargetLocation = (vector) llList2String(lCoordinate, count);
        llSetStatus(STATUS_PHYSICS, TRUE);
        state moving;
    }
}

state moving
{

    state_entry()
    {
        if (_debug) llOwnerSay("Mooving to " + (string) TargetLocation);
        llSetTimerEvent(INTERVAL);
        priorpos = llGetPos();
        llSetStatus(STATUS_PHYSICS, FALSE);
    }

    on_rez(integer param)
    {
        llResetScript();
    }


    timer()
    {  
        vector myPos = llGetPos();
        if (_debug) 
        {
            float dist = llVecDist(myPos, priorpos);
            float velocity = dist / DAMPING;
            if (_debug) llOwnerSay("Velocity:" + (string) velocity);
        }

        if (llVecMag(myPos - TargetLocation) >  DAMPING)
        {   
            llLookAt(TargetLocation, .4, .2);
            llSetPos((llVecNorm(TargetLocation- myPos) * DAMPING) + myPos);
        }  
        else
        {
            SpeakThis =  llList2String(lDescriptions, count);
    
            if (llStringLength(SpeakThis) > 0)
                llSay(CommandChannel,SpeakThis);
                
            SpeakThis =  llList2String(lCommands, count);
        
            string CmdName = left(SpeakThis,":");
            string VarName = right(SpeakThis,":");

            if (_debug) llOwnerSay("Cmd:" + (string) CmdName);
            if (_debug) llOwnerSay("Val:" + (string) VarName);    
            
            if (CmdName == "Speed")
            {
               //llSay(0,"New Speed:" + (string) VarName);
                DAMPING = (float) VarName;
            }
        
                
            float Timeout =  llList2Float(lTimeouts, count);
            
            if (Timeout)
            {
                if (_debug) llOwnerSay("Pauseing:" + (string) Timeout);
                llSleep(Timeout);
            }
  
            count ++;
    
            if (count > (iIndexLines - 1))
                state end;
    
            if (count <= (iIndexLines - 1))
            {
                //Say(0,"At " + (string) TargetLocation);
                TargetLocation = (vector) llList2String(lCoordinate, count);
                if (_debug) llOwnerSay("New Target: " + (string) TargetLocation);
            }
        }
    }

    state_exit()
    {
        llSetTimerEvent(0);
    }
}

state GetCoordinate
{
    state_entry()
    {
        if (_debug) llOwnerSay("state GetCoordinate");
        count ++;

        if (count > (iIndexLines - 1))
            state end;

        if (count <= (iIndexLines - 1))
        {
            TargetLocation = (vector) llList2String(lCoordinate, count);
            if (_debug) llOwnerSay("New Target: " + (string) TargetLocation);
            state moving;
        }
    }

}

state end
{
    state_entry()
    {
        //llSay(0, "Tour end. " );
        count = 0;
        TargetLocation = (vector) llList2String(lCoordinate, 0); // Start over
        state moving;   // start over
    }


}

