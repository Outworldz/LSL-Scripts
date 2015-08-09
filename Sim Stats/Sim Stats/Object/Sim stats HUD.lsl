// :CATEGORY:Sim Feedback
// :NAME:Sim Stats
// :AUTHOR:Ariane Brodie
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-11-27 13:33:07
// :ID:57
// :NUM:84
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Reports sim stats as a HUD
// :CODE:
//

string TitleName = ""; //default title
integer TitleMode = 1; //default mode
string alist;

float tz = -7;
integer mil = 0;


integer Count; // counter for averaging FPS
integer FPS_Total; // total fps for averaging

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
    string time = "real time: " + shours + ":" + sminutes + ":" + sseconds + ampm;
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
    time = time+"\nsim time: "+shours + ":" + sminutes + ":" + sseconds + "\n" + suntime;
    return time;
}

string positionData()
{
    vector pos = llGetPos();
    float currentSpeed = llVecMag(llGetVel()) * 3.6;
        
    return "You are at: " + llGetRegionName() + " (" + (string)((integer)pos.x) + ", " + (string)((integer)pos.y) + ") \nHeight: " + (string)((integer)pos.z) + " \nSpeed: " + (string)((integer)currentSpeed) +"km/h";
}
integer CommandIs(string msg,string cmd)
{
    return llSubStringIndex(msg,cmd) == 0;
}
ParseAndIssueCommand(string cmd)
{

    if (CommandIs(cmd,"title"))
    {
        TitleMode = 1;
        string name = llGetSubString(cmd,6,-1);
        TitleName = name;
        if (name == "title")
            llSetText("",<0,1,0>,1.0);
        else
            llSetText(name,<0,1,0>,1.0);   
    }
    
    if (cmd == "scan")
        TitleMode = 2;
    if (cmd == "time")
        TitleMode = 3;
    if (cmd == "pos")
        TitleMode = 4;
    if (cmd == "ani")
        TitleMode = 5;
    if (cmd == "lag")
        TitleMode = 6;
    if (cmd == "to" || cmd == "toff") {
        TitleMode = 1;
        llSetText("",<0,1,0>,1.0);
    }
    if (cmd == "ton"){
        TitleMode = 1;
        llSetText(TitleName,<0,1,0>,1.0);
    }
}

default
{
    state_entry()
    {
         llListen(2,"",llGetOwner(),"");
         llSensorRepeat("","",AGENT,96,PI,1);
         llSetTimerEvent(1.0);
    }
    on_rez(integer start_param)
    {
        llResetScript();
    }  
    listen(integer channel, string name, key id, string msg)
    {
        ParseAndIssueCommand(msg);
    }
        
    sensor(integer n) 
    { 
    //TitleMode 1 = Title
    //TitleMode 2 = Scan
    if (TitleMode == 2) {
        integer i; 
        vector pos; 
        vector targetPos = llGetPos();
        integer dist; 
        string iSee = ""; 
        for(i=0; i<n; i++) { 
            if(llDetectedKey(i) != llGetOwner()){
            pos = llDetectedPos(i); 
            dist = (integer)llVecDist(pos, targetPos); 
            iSee += "[1:"+llDetectedName(i)+" @ "+(string)dist+"M]\n";
            }
        } 
        llSetText(iSee,<1,1,1>,1.0);
    } 
    }
    
    no_sensor()
    {
        if (TitleMode == 2) 
            llSetText("",<1,1,1>,1.0);
    }
    
    timer()
    {
    //TitleMode 3 = Time
    if (TitleMode == 3) 
        llSetText(clock(tz,mil),<0,0,1>,1.0);
    //TitleMode 4 = Position
    if (TitleMode == 4)
        llSetText(positionData(),<1,0,0>,1.0);
    //TitleMode 5 = Animation View
    if (TitleMode == 5){
        alist = llGetAnimation(llGetOwner()); // get the current animation state
        llSetText(alist, <0, 1, 1>, 1.0); // display it as floating text
    }
    //TitleMode 6 = Lag
    if (TitleMode == 6) {
        Count += 1;
        integer RegFPS = llFloor(llGetRegionFPS());
        FPS_Total += RegFPS;
        integer avgFPS = FPS_Total / Count;
        string avg = (string)avgFPS;
        string fps_condition;
        string dil_cond;
        if (RegFPS >= 1000)
        {
            fps_condition = "(Incredible!)";
        }
        else if (RegFPS >= 500)
        {
            fps_condition = "(Great!)";
        }
        else if (RegFPS > 400)
        {
            fps_condition = "(Good!)";
        }
        else if (RegFPS > 300)
        {
            fps_condition = "(Fair)";
        }
        else if (RegFPS > 200)
        {
            fps_condition = "(Could be better)";
        }
        else if (RegFPS > 100)
        {
            fps_condition = "(Sucky)";
        }
        else if (RegFPS > 50)
        {
            fps_condition = "(Start Praying)";
        }
        else
        {
            fps_condition = "(OMG this Server BLOWS)";
        }
        string RegName = llGetRegionName();
        float TimeDil = llGetRegionTimeDilation();
        if (TimeDil >= 0.96)
        {
            dil_cond = "(Sim is Stable)";
        }
        else if (TimeDil >= 0.90)
        {
            dil_cond = "(Sim is Hiccuping)";
        }
        else if (TimeDil >= 0.80)
        {
            dil_cond = "(Sim is Lagging)";
        }
        else if (TimeDil >= 0.60)
        {
            dil_cond = "(Potential Sim Crash!)";
        }
        else
        {
            dil_cond = "(Sim is DOOMED!)";
        }
        string s_count = (string)Count;
        llSetText("Sim = "+RegName+"\nFPS = "+(string)RegFPS+" "+fps_condition+" (Avg: "+avg+")\nDil = "+(string)TimeDil+" "+dil_cond+"\nPolls: "+s_count,<1,1,0>,1.0);
    }
    }
}
