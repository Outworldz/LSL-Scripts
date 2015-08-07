// :CATEGORY:Clock
// :NAME:Clock_Radio
// :AUTHOR:Ariane Brodie
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:50
// :ID:182
// :NUM:253
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
//  found a routine in Wiki to make a digital clock, so I turned it into a clock-radio-motion detector device. It is a simple script that left alone displays the time in any time zone you want, or you can click it to toggle on and off your radio. Or the third function is that of a motion detector that IMs you if someone is near the detector. Update: script now cycles through 4 different channels, and also displays your server time and how long till the next sunrise/sunset.
// :CODE:
string oldSee = "";
//  http://64.236.34.67:80/stream/1040 - Club 977  the 80's channel
//  http://216.218.254.98:8310 - Twister Radio  SL Radio
//  http://vruk.sc.llnwd.net:12265 - Virgin Radio- classic rock
//  http://64.236.34.196:80/stream/1005 - Smooth Jazz
//  http://195.140.143.76:8000 - Frequency 3 (French pop)
//  http://69.28.128.148:80/stream/vruk_vr_hi - Virgin Radio ( UK )
//  http://64.236.34.67:80/stream/1038 - Hitz Radio - Pop Music
//  http://64.236.34.196:80/stream/1006 - Mostly Classical
//  http://64.236.34.196:80/stream/1018 - Nicely Chilled
//  http://64.236.34.196:80/stream/1011 - Todays Dance Music
//  http://hifi.kcsm.org:8002 - Jazz - KCSM
//  http://66.230.159.66:8765 - Hip Hop
//  http://64.236.34.196:80/stream/1003 - Trance
//  http://64.202.98.51:7150 - NewAge
//  http://64.236.34.97:80/stream/2004 - NewAge / Chill
//  http://64.236.34.97:80/stream/1048 - Radio Paradise
string radioURL = "http://64.236.34.97:80/stream/1048";
float tz = -7;
integer mil = 0;

string clock(float timezone, integer military)
{
    integer raw = (integer)(llGetGMTclock() + (timezone * 3600));
    integer shiftraw = raw;
    if((timezone * 3600) + raw > 86400)
    {
        shiftraw = raw - 86400;
    }
    else if((timezone * 3600) + raw < 0)
    {
        shiftraw = raw + 86400;
    }
    integer hours = shiftraw / 3600;
    integer minutes = (shiftraw % 3600) / 60;
    integer seconds = shiftraw % 60;
    string ampm;
    //non-military time adjustments
    if(!military)
    {
        if(shiftraw < 43200)
        {
            ampm = " AM";
        }
        else
        {
            ampm = " PM";
            hours -= 12;
        }
    }
    string shours = (string)hours;
    string sminutes = (string)minutes;
    string sseconds = (string)seconds;
    
    //add zeros to single digit minutes/seconds
    if(llStringLength(sminutes) == 1)
    {
        sminutes = "0" + sminutes;
    }
    if(llStringLength(sseconds) == 1)
    {
        sseconds = "0" + sseconds;
    }   
    string time = shours + ":" + sminutes + ":" + sseconds + ampm + "(PST)";
        //the following will time stamp the data sent using SL time.
    raw = (integer)llGetTimeOfDay();
    minutes = raw/60;
    integer mintill;
    string suntime = "";
    if (minutes < 30) {
        mintill = 30 - minutes;
        suntime = (string)mintill + " min till Sunrise";
    }
    if (minutes == 30)
        suntime = "Sunrise";
    if (minutes > 30) {
        mintill = 210 - minutes;
        suntime = (string)mintill + " min till Sunset";
    }
    if (minutes == 210)
        suntime = "Sunset";
    if (minutes > 210){
        mintill = 270 - minutes;
        suntime = (string)mintill + " min till Sunrise";
    }
    shours = "0"+(string)((raw/3600)%4);
    integer len = llStringLength(shours);
    shours = llGetSubString(shours, len - 2, len - 1);
    sminutes = "0"+(string)((raw%3600)/60);
    len = llStringLength(sminutes);
    sminutes = llGetSubString(sminutes, len - 2, len - 1);
    sseconds = "0"+(string)(raw%60);
    len = llStringLength(sseconds);
    sseconds = llGetSubString(sseconds, len - 2, len - 1);
    time = time+"\n"+shours + ":" + sminutes + ":" + sseconds + "(SLT)\n" + suntime;
    return time;
}

default
{
    state_entry()
    {
        llSensorRepeat("","",AGENT,5,PI,1);
        llSetTouchText("Radio On");
        llListen( 5, "", NULL_KEY, "" );
    }
    
    touch_end(integer n)
    {
        llSetParcelMusicURL(radioURL);
        state radio_on;    
    }  
    
    sensor(integer n) 
    { 
    integer i; 
    string currenttime = clock(tz,mil);
    llSetText(currenttime, <1, 1, 1>, 1.0);
    string iSee = ""; 
    for(i=0; i<n; i++) { 
        if(llDetectedKey(i) != llGetOwner()){
        iSee += llDetectedName(i);
    } 
    } 
    if(iSee != "" && iSee != oldSee) {
       llInstantMessage(llGetOwner(), iSee + " is in your lab.");
       oldSee = iSee;
       }
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (message == "hide"){
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <0.5, 0, 0>, 0.0]);
        }
        if (message == "show"){
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <0.5, 0, 0>, 1.0]);
        }
    }
}

state radio_on
{
    state_entry()
    {
        llSensorRepeat("","",AGENT,5,PI,1);
        llSetTouchText("Rock");
        llListen( 5, "", NULL_KEY, "" );
    }
    
    touch_end(integer n)
    {
        llSetParcelMusicURL("http://vruk.sc.llnwd.net:12265");
        state radio_on1;   
    }  
    
    sensor(integer n) 
    { 
    integer i; 
    string currenttime = clock(tz,mil);
    llSetText(currenttime, <1, 1, 1>, 1.0);
    string iSee = ""; 
    for(i=0; i<n; i++) { 
        if(llDetectedKey(i) != llGetOwner()){
        iSee += llDetectedName(i);
    } 
    } 
    if(iSee != "" && iSee != oldSee) {
       llInstantMessage(llGetOwner(), iSee + " is in your lab.");
       oldSee = iSee;
       }
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (message == "hide"){
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <0.5, 0, 0>, 0.0]);
        }
        if (message == "show"){
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <0.5, 0, 0>, 1.0]);
        }
    }
}

state radio_on1
{
    state_entry()
    {
        llSensorRepeat("","",AGENT,5,PI,1);
        llSetTouchText("80s");
        llListen( 5, "", NULL_KEY, "" );
    }
    
    touch_end(integer n)
    {
        llSetParcelMusicURL("http://64.236.34.67:80/stream/1040");
        state radio_on2;   
    }  
    
    sensor(integer n) 
    { 
    integer i; 
    string currenttime = clock(tz,mil);
    llSetText(currenttime, <1, 1, 1>, 1.0);
    string iSee = ""; 
    for(i=0; i<n; i++) { 
        if(llDetectedKey(i) != llGetOwner()){
        iSee += llDetectedName(i);
    } 
    } 
    if(iSee != "" && iSee != oldSee) {
       llInstantMessage(llGetOwner(), iSee + " is in your lab.");
       oldSee = iSee;
       }
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (message == "hide"){
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <0.5, 0, 0>, 0.0]);
        }
        if (message == "show"){
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <0.5, 0, 0>, 1.0]);
        }
    }
}

state radio_on2
{
    state_entry()
    {
        llSensorRepeat("","",AGENT,5,PI,1);
        llSetTouchText("Jazz");
        llListen( 5, "", NULL_KEY, "" );
    }
    
    touch_end(integer n)
    {
        llSetParcelMusicURL("http://64.236.34.196:80/stream/1019");
        state radio_on3;   
    }  
    
    sensor(integer n) 
    { 
    integer i; 
    string currenttime = clock(tz,mil);
    llSetText(currenttime, <1, 1, 1>, 1.0);
    string iSee = ""; 
    for(i=0; i<n; i++) { 
        if(llDetectedKey(i) != llGetOwner()){
        iSee += llDetectedName(i);
    } 
    } 
    if(iSee != "" && iSee != oldSee) {
       llInstantMessage(llGetOwner(), iSee + " is in your lab.");
       oldSee = iSee;
       }
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (message == "hide"){
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <0.5, 0, 0>, 0.0]);
        }
        if (message == "show"){
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <0.5, 0, 0>, 1.0]);
        }
    }
}

state radio_on3
{
    state_entry()
    {
        llSensorRepeat("","",AGENT,5,PI,1);
        llSetTouchText("Radio Off");
        llListen( 5, "", NULL_KEY, "" );
    }
    
    touch_end(integer n)
    {
        llSetParcelMusicURL("");
        llResetScript();   
    }  
    
    sensor(integer n) 
    { 
    integer i; 
    string currenttime = clock(tz,mil);
    llSetText(currenttime, <1, 1, 1>, 1.0);
    string iSee = ""; 
    for(i=0; i<n; i++) { 
        if(llDetectedKey(i) != llGetOwner()){
        iSee += llDetectedName(i);
    } 
    } 
    if(iSee != "" && iSee != oldSee) {
       llInstantMessage(llGetOwner(), iSee + " is in your lab.");
       oldSee = iSee;
       }
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (message == "hide"){
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <0.5, 0, 0>, 0.0]);
        }
        if (message == "show"){
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <0.5, 0, 0>, 1.0]);
        }
    }
}
