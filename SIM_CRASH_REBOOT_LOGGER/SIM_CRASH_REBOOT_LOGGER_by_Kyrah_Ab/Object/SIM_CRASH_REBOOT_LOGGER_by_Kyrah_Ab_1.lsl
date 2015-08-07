// :CATEGORY:Reboot Logger
// :NAME:SIM_CRASH_REBOOT_LOGGER
// :AUTHOR:Kyrah Abbatoir
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:02
// :ID:754
// :NUM:1038
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// SIM CRASH_REBOOT LOGGER by Kyrah Abattoir.lsl
// :CODE:

//********************************************************
//This Script was pulled out for you by YadNi Monde from the SL FORUMS at http://forums.secondlife.com/forumdisplay.php?f=15, it is intended to stay FREE by it s author(s) and all the comments here in ORANGE must NOT be deleted. They include notes on how to use it and no help will be provided either by YadNi Monde or it s Author(s). IF YOU DO NOT AGREE WITH THIS JUST DONT USE!!!
//********************************************************





/////////////////////////////////////////
//SIM CRASH/REBOOT LOGGER
//by: Kyrah Abattoir
/////////////////////////////////////////

integer timering = 30;//the polling rate, put the speed you wish, in seconds

//there we go...
integer UNIX;
string _buffer;
list log;
integer span = 0;
float fps;
float dilation;
integer crash = 0;
string date;
//2004-08-27T00:56:21.785886Z

default
{
    state_entry()
    {
        llSetTimerEvent(timering);//starting our timer
    }
    timer()
    {
        string timestamp = llGetTimestamp();
        list temp = llParseString2List(timestamp,["T",":",":","."],[]);
        integer _hour = llList2Integer(temp,1) + 4;
        if(_hour > 24) //getting the hours
            _hour = _hour - 24 ;

        string _date = llList2String(temp,0);
        integer _min = llList2Integer(temp,2);
        integer _sec = llList2Integer(temp,3);
        string buffer;

        if(date == _date) //daily reset of the average fps and dilation
            span++;
        else
        {
            span = 1;
            date = _date;
            fps = 0;
            dilation = 0;
        }

        fps += llGetRegionFPS();
        dilation += llGetRegionTimeDilation();
        integer avg_FPS = (integer)(fps/span);
        string avg_dilation= llGetSubString((string)(dilation/span),0,3);

        buffer += llGetRegionName();
        buffer += "\n FPS:"+(string)avg_FPS;
        buffer += " dil. :"+(string)avg_dilation;
        //buffer += "\n" + llDumpList2String(log,"\n");

        integer _UNIX = _sec + _min * 60 + _hour * 3600;//making our timestamp
        
        if (_UNIX - UNIX > timering + 5 && UNIX != 0)//okay the delay has been waaay too olong, it probably crashed or rebooted
        {
            crash++;
            log += (string)_date + " - " + (string)_hour+ ":"+(string)_min+":"+(string)_sec;
            if(llGetListLength(log) > 9)
                log = llDeleteSubList(log,0,0);
        }
        buffer += "\n sim crashes: " + (string)crash + "\n last crash: \n" + llDumpList2String(log,"\n");
        if(_buffer != buffer); //display
        {
            llSetText(buffer,<1,1,1>,1.0);
            _buffer = buffer;   
        }
        UNIX = _UNIX;
    }
}// END //
