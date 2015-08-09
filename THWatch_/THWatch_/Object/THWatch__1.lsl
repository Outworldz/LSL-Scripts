// :CATEGORY:Clock
// :NAME:THWatch_
// :AUTHOR:Trimming Hedges
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:07
// :ID:890
// :NUM:1266
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// THWatch 0.lsl
// :CODE:


// THWatch, version 0.32, written 12/30/03 by Trimming Hedges.  You're welcome to use this code as you wish.  If you find it
// useful, I'd appreciate a donation.  I stole a couple of code snippets, primarily the argument-parsing stuff 
// (search for 'preamble') from another watch script.  There's no record of the author or I would credit them.   I'm not really
// a programmer (as will probably be obvious from the code :) ), and this is my first real script, so if you find bugs or have 
// suggestions, I'm eager to hear them. 

// This code is released under the Attribution-ShareAlike Creative Commons license.  A summary is at:
// http://creativecommons.org/licenses/by-sa/1.0/.  Basically: if you incorporate my code, you must credit me and you must
// release that code freely.  If you make a super-cool watch and put this code in it, you are welcome to sell it for any 
// amount you can get for it, but you cannot lock the user's ability to see, modify, or copy this code.  
// If you want to lock your object and can do so while still leaving this code free, that's fine.  

// WARNING: this script is VERY close to the heap limit, which seems to be about 8k.  There's probably about 10 BYTES left. 
// If you want to add ANYTHING to this, you're going to have to take something else out. 

// revision history:  0.30 released 12/31/2003.  Most recent change:  Attempt to avoid double listens by checking to see if listentrack
// variable is set before starting a listen, and clearning listentrack variable when clearing a listen.  Should avoid an occasional bug 
// I've seen. 


// DEFAULTS SECTION:
// User-settable defaults: you can change all of these with 'say' commands, but if you get tired of that, change the defaults here.


integer hour24 = 0;  // 0 is 12-hour (AM/PM), 1 is 24-hour. 
integer offset = 0;  // 3 = eastern, 8 = roughly UTC (depends on Daylight Savings), Sydney=18, Hawaii=-2
integer alarmwarnmax = 3; // how many times the alarm should alert you before shutting off
integer output = 1;  // 0=tell via dialog, 1=instant message, 2=whisper, 2=say, 3=shout
integer playsound = 1; // whether or not to make sound
integer updatefrequency = 1; // how often, in seconds, the watch checks the alarm and timer.  If you use the timer, you probably want 1

// Other global variables, computed by the watch.  If you change these without understanding how the watch works internally,
// you will probably break it. 

integer alarmset = 0;
integer alarmmintime = 0;
integer alarmmaxtime = 0; 
integer alarmwarnings = 0;
integer timerstop = 0;
integer timerset = 0;
integer stopwatchstart=0;
integer stopwatchon=0;
integer listentrack=0;
string version = "0.32";
key owner;

integer secondsin24hours = 86400;

// Code starts

telluser (string outmessage)
{
    if (output == 0)
        llDialog (owner, outmessage, [], 23882102 ); 
    if (output == 1)
        llInstantMessage(owner, outmessage);
    if (output == 2)
        llWhisper (0,outmessage);
    if (output == 3)
        llSay (0,outmessage);
    if (output == 4)
        llShout (0,outmessage);
}

do_help (key id)
{
    llGiveInventory (id,"THWatchbasichelp");
}

do_morehelp(key id)
{
    llGiveInventory (id,"THWatchadvancedhelp");
}

integer localseconds (integer lindenseconds)
{
    integer localseconds = lindenseconds + (offset * 3600);  // add or subtract 3600 seconds per hour of offset
    
    if ( localseconds < 0)
         localseconds = localseconds + secondsin24hours;
    localseconds = localseconds % secondsin24hours;  // masks times greater than 1 day; modulo result can't exceed 86399, 1 second before midnight
    return localseconds;
}
integer lindenseconds (integer localseconds)
{
    integer lindenseconds = localseconds - (offset * 3600); //subtract or add 3600 seconds per hour of offset
    if (lindenseconds < 0)
        lindenseconds = lindenseconds + secondsin24hours;
    lindenseconds = lindenseconds % secondsin24hours; // modulo division prevents values greater than secondsin24hours
    return lindenseconds;    
}

integer stringtoseconds (string timestring)
{
    list hoursminutes = llParseString2List(timestring, [ ":" ], [] );
    integer hour = llList2Integer(hoursminutes,0);
    integer minutes = llList2Integer(hoursminutes,1);
    return ( (hour * 3600) + (minutes * 60) );
}

string secondstostring (integer time)
// this function takes a number of seconds and converts it into a human-readable string.  
// It returns a null string if it gets greater than 24 hours' worth of seconds, or if it gets less than zero.  
// It reads the global veriable hour24 to know how to format the string

{
    integer hours = 0;
    integer minutes = 0;
    integer seconds = 0;
    string hourstring = "";
    string minutestring = "";
    string secondstring="";
    string ampm="";
   
    if ( (time > secondsin24hours) || (time < 0) )  // invalid value, return empty string
        return "";
        
    hours = time / 3600;        // 3600 seconds in an hour
    time = time % 3600;         // get remainder, anything less than 3600

    minutes = time / 60;        // 60 seconds in a minute
    time = time % 60;           // get remainder, anything less than 60

    seconds = time;             // all we have left are seconds


    if (minutes < 10)           // pad output string for readability
        minutestring = "0"+(string)minutes;
    else 
        minutestring = (string)minutes;
    
    if (seconds < 10)
        secondstring = "0"+(string)seconds;
    else
        secondstring = (string)seconds;
    
// determine whether we're in 24-hour mode 

    if (hour24 != 1)  
    {   
        if (hours < 12)
            ampm = " AM";
        else 
            ampm = " PM";
        
        if (hours > 12)   // can't combine these into 1 if statement, because hours=12 is PM but shouldn't have 12 subtracted
        {
            hours = hours - 12;
        } else if (hours == 0)  // it's 12AM
        {
            hours = 12;
        }        
    } else {  // it is a 24 hour clock, skip all that crap
        ampm = "";
    }

    hourstring = (string)hours;  // doesn't need padding, 9:03 looks better than 09:03
  
    return hourstring + ":"+minutestring+":"+secondstring + ampm;
}

showtime()
{
    integer time = (integer)llGetWallclock();
   
    time = localseconds (time); 
    
    if (offset == 0) 
    { 
        telluser ("Linden time is " + secondstostring(time) + ".");
    } else {
        telluser ("Your local time is " + secondstostring(time) + ".");
    }
}

alarmfunctions (list parsed)  // I use braces around single statement blocks here for readability, since they're fairly long commands.
{
    string alarmcommand = llList2String(parsed,2);
    if (alarmcommand == "")
    {
        if (alarmset == 0)
        {
            telluser ("Alarm isn't set.");
            return;
        }
        if (offset != 0)
        {
            telluser ("Alarm set for " + secondstostring(localseconds(alarmmintime)) + ", your local time.");
        } else 
        {
            telluser ("Alarm set for " + secondstostring(alarmmintime) + ", Linden Standard Time.");
        }
    } else if ( (alarmcommand == "warning") || (alarmcommand == "warnings") )
    {
        string alarmwarnings = llList2String(parsed,3);
        if ( (integer)alarmwarnings == 0) // if they pass in something non-numeric or blank
        {
            telluser ("Alarm warnings now " + (string)alarmwarnmax);
            return;
        } 
        if ( ( (integer)alarmwarnings < 1 ) || ( (integer)alarmwarnings > 60 ) )
        {
            telluser ("Warnings must be between 1 and 60, inclusive");
            return;
        } else
        {
            alarmwarnmax = (integer)alarmwarnings;
            telluser ("Warnings now set to " + alarmwarnings);
        }
    }        
    else if (alarmcommand == "off")
    {
        alarmset = 0; // alarm turns off!
        alarmmintime = 0; 
        alarmmaxtime = 0;
        telluser ("Alarm disabled.");
    }
    else   // we assume user is setting time... original code used 'set' but everyone including me kept getting confused.
           // this is the single most complex function, as it has to deal with many different input and output possibilities
    {
            // old syntax was alarm time set, new syntax is alarm time XX:YY, move arguments down by one if arg2 is 'set'
        string alarmtimestring = llList2String(parsed,2); // this is the same argument as timecommand, so they're identical values
        string argument3 = llList2String(parsed,3);  // this is a bit tough; user could say 5:00 pm lst, or 5:00 pm, or 5:00 lst
        string argument4 = llList2String(parsed,4);
        string argument5 = llList2String(parsed,5);
        if (alarmtimestring == "set")  // old syntax was alarm time set XX:YY, new one is alarm time XX:YY... if there is a set,
                                       // slide all variables down by one
        {
            alarmtimestring = argument3;
            argument3 = argument4;
            argument4 = argument5;
        }
        list alarmtimeparsed = llParseString2List(alarmtimestring, [ ":" ],[]);
        integer alarmhour = llList2Integer(alarmtimeparsed,0);
        integer alarmminute = llList2Integer(alarmtimeparsed,1);

        if (alarmhour > 12)
        {
             telluser ("Hour greater than 12.  Ignoring AM or PM.");
        } else
        {
            if (argument3 == "pm")
            {
                if (alarmhour < 12)  // fortunately, 12 pm is just 12, it's only 1-11 pm we need to worry about
                {
                    alarmhour = alarmhour + 12;
                } 
            }
            if (argument3 == "am") // have to check for 12 am
            {    
                if (alarmhour == 12)
                {
                    alarmhour = 0;  // 12 am is 0 hours
                }
            }
        }
                     
        integer alarmtimeseconds = (alarmhour * 3600 ) + (alarmminute * 60);                          
        if (alarmtimeseconds < 0) // user is being stupid
        {
            telluser ("Can't set alarms for negative time values.");
            return;
        }
        alarmtimeseconds = alarmtimeseconds % secondsin24hours; // just in case user is being an idiot, prevent >24 hour times
                                                
        if ((argument3 == "lst") || (argument4 == "lst") || (offset == 0)) // user said 'lst', or offset is 0, so the time was specified as lindentime
        {
            alarmmintime = alarmtimeseconds;
            alarmmaxtime = alarmtimeseconds + 60; // 1 minute later
            alarmset = 1;  // alarm turns on!
            telluser ("Alarm set for " + secondstostring(alarmtimeseconds) + " Linden Standard Time.");
        } else  // user didn't say 'lst' and offset is nonzero, so he/she is specifying local time
        {           
            alarmmintime = lindenseconds (alarmtimeseconds); // we set the actual alarm in lindenseconds, even though we display localtime
            alarmmaxtime = alarmmintime + 60;
            alarmset = 1; // alarm turns on!
            telluser ("Alarm set for " + secondstostring(alarmtimeseconds) + ", your local time.");
        }
    }
}

outputfunctions (list parsed)
{
    string outputsetting = llList2String(parsed,2);

    if (outputsetting == "dialog")
    {    
        output = 0;
    } else if (outputsetting == "message")
    {
        output = 1;
    } else if (outputsetting == "whisper")
    {
        output = 2;
    } else if (outputsetting == "say")
    {
        output = 3;
    } else if (outputsetting == "shout")
    {
        output = 4;
    } else {
        telluser ("Has to be dialog, message, whisper, say, or shout.");
    }
    telluser ("Watch output is like this.");
    return;
}

modefunctions (list parsed)
{
    string newmode = llList2String(parsed,2);
    
    if (newmode == "12")
    {
        hour24 = 0;
        telluser ("Watch set to 12-hour mode.");
    } else if (newmode == "24")
    {
        hour24 = 1;
        telluser ("Watch set to 24-hour mode.");
    } else if (newmode =="")
    {
        if (hour24 == 1)
        {
            telluser ("Watch is in 24-hour mode.");
        } else {
            telluser ("Watch is in 12-hour mode.");
        }
    } else {
        telluser ("You can only set 12- or 24-hour mode.");
    }
    return;
}

zonefunctions (list parsed)
{

    if (llList2String(parsed, 2) != "") // any argument given
    {
        integer newzone = (integer)llList2String(parsed,2);
        if ((newzone < -24) || (newzone > 24))
        {
            telluser ("Zone has to be between -24 and +24, inclusive.");
            return;
        }
        offset = newzone;
        telluser ("Time zone offset changed to " + (string)offset);
    } else  // no argument given, just tell current setting
    {
        telluser ("Current time zone is " + (string)offset);
    }
}

stopwatchfunctions (list parsed)
{
    integer elapsed;
    if (stopwatchon == 0)
    {
        telluser ("Starting stopwatch.");
        stopwatchstart = (integer)llGetWallclock();
        stopwatchon = 1;
    } else 
    {
        telluser ("Stopping stopwatch.");
        elapsed = (integer)llGetWallclock() - stopwatchstart;
        if (elapsed < 0)
        {
            elapsed = secondsin24hours - elapsed;
        }
        telluser ("Stopwatch stopped after " + (string)elapsed + " seconds.");
        stopwatchon = 0;
        stopwatchstart = 0;
    }
}
timerfunctions (list parsed)
{
     integer timercount = (integer)llList2String(parsed,2);
    if (timercount == 0)
    {
        telluser ("Disabling timer");
        timerset = 0;
        timerstop = 0;
    }
    if (timercount > 0)
    {
        timerstop = (integer)llGetWallclock() + timercount;
        if ( timerstop < secondsin24hours)
        {
            timerset = 1;
            telluser ("Timer set!  Counting " + (string)timercount + " seconds.");
        } else
        {
            telluser ("Can't set timer across midnight boundary LST.");
        }
    }        
   return;
}

soundfunctions (list parsed)
{
    string onoroff = llList2String (parsed,2);
    if (onoroff == "on")
    {
        playsound = 1;
    } else if (onoroff == "off")
    {
        playsound = 0;
    }
    if (playsound)
    {
        telluser ("Sound output is on.");
    } else {
        telluser ("Sound output is off.");
    }
}
do_alarm()
{
    if (playsound)
        llPlaySound("alarmbeep",0.50);
    telluser ("Alarm going off!  It was set for " + secondstostring(localseconds(alarmmintime)));
    alarmwarnings = alarmwarnings + 1; 
    if (alarmwarnings >= alarmwarnmax)
    { 
        alarmset = 0;
        alarmwarnings = 0;
    }
}   


do_timerexpire()
{
    timerset = 0;
    timerstop = 0;
    if (playsound)
        llPlaySound("timerbeep",1.0);
    telluser ("Time's up!");
}

init ()
{
    owner = llGetOwner();
    telluser("THWatch " + version+".  Say 'time help' or 'time morehelp' for basic or advanced help.");
    if (listentrack == 0)
    {
        llSetTimerEvent(updatefrequency);
        listentrack=llListen(0, "", owner, "");   
    }
}
die ()
{
    llSetTimerEvent (0.0);
    llListenRemove (listentrack); 
    listentrack = 0;
}


default
{
    state_entry()
    {
   
    }
    attach (key attached)
    {
        if (attached != NULL_KEY) //object has been attached
            init();
        else //object is being detached
            die();
    }
    
    timer ()  // because this code runs constantly, it needs to be VERY lightweight.  This code does almost nothing unless an alarm or timer is set.
    
    {    
        if ((alarmset == 0) && (timerset == 0))
            return;

            // ok, either alarm or timer is set
        integer now = (integer)llGetWallclock();
        if ((alarmset != 0) && (now >= alarmmintime) && (now <= alarmmaxtime))
        {
            do_alarm();
        }
        if ((timerset != 0) && (now >= timerstop))
        {
            do_timerexpire();
        }
    }
    
    listen (integer channel, string name, key id, string message)
    {
        message = llToLower(message);
        string preamble = llGetSubString(message,0,3);
        if (preamble != "time")
            return;
        list parsed = llParseString2List(message, [ " " ], []);  
        string command = llList2String(parsed,1);
 
        if (command == "")
        {    
            showtime();
        } 
        else if (command == "help")
        {
            do_help(id);
        } 
        else if (command == "morehelp")
        {
            do_morehelp(id);
        }
        else if (command == "alarm")
        {
            alarmfunctions(parsed);
        }
        else if (command == "output")
        {
            outputfunctions(parsed);
        }
        else if (command == "mode")
        {
            modefunctions(parsed);
        }
        else if (command == "zone")
        {
            zonefunctions(parsed);
        }
        else if (command == "stopwatch")
        {
            stopwatchfunctions(parsed);
        }
        else if (command == "timer")
        {
            timerfunctions(parsed);
        }
        else if (command == "sound")
        {
            soundfunctions (parsed);
        }
    }
}
// END //
