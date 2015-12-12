//:Name: HYPERGRID STORY NINE
//:Author: Shin Ingen
//:REV:1.0
//:DESCRIPTION:
// Timer controller
//:CODE:
// lots of mods by Ferd
//


integer debug = 2;

// Link Numbers of the NPC controller 
integer namaka      =2;
integer dylan       =3;
integer npc1        =4;
integer npc2        =5;
integer npc3        =6;
integer npc4        =7;
integer npc5        =8;
integer npc6        =9;

// List of NPC Listener channels

integer gFireworksChannel =20;
integer gTeleportChannel = 21;
integer CommandChannel = 23;
integer gSimpleMenuChannel = 999; // The channel used for the menu

integer        MaxTicks = 60;     // Show length
// The repeat the show timer

list kDance1     = ["Dance1",1];          // Dance
list kDance2     = ["Dance2",10];          // Dance
list kDance3     = ["Dance3",20];          // Dance
list kDance4     = ["Dance4",30];          // Dance
list kDance5     = ["Dance5",40];          // Dance
list kDance6     = ["Dance6",50];          // Dance

list kFireworksRepRate = ["Shoot", 2];      // rep rate for finale

// the following are calculated based on the current timer tick
list kFireworksStartsAt = ["StartFireworks", 99999];  // rep rate for finale
list kRaiseTeleport = ["BeamMeUp",99999];      // raise the teleports
list kStopAutoFire = ["EndFireworks",99999];   // and stops here

SendMessageLinked(integer npc,  string cmd)
{
    llRegionSay(CommandChannel,(string) npc + "|" + cmd);
}
DoCmd(string message, integer channel)
{
    if (channel == CommandChannel) {
        Process(message);
    }

    if (message == "ShowTime") {
        
        DEBUG("Running");
        ShowTime();
    }
    else if (message == "Finale!")
    {
        kFireworksStartsAt = ["StartFireworks", gTimeElapsed+1];  // rep rate for finale
        kRaiseTeleport = ["BeamMeUp",gTimeElapsed+25];      // raise the teleports
        kStopAutoFire = ["EndFireworks",gTimeElapsed+30];   // and stops here

        settimeout(kFireworksStartsAt);
        settimeout(kStopAutoFire);
        settimeout(kRaiseTeleport);
    }
    else if (message == "Stop")
    {
        llSay(0,"You selected option Stop");
        gTimeoutList = [];
    }

}
// this is a list of all the cycling show bits
ShowTime()
{
    DEBUG("Starting Countdown");
    gTimeElapsed=0;

    settimeout(kDance1);
    settimeout(kDance2);
    settimeout(kDance3);
    settimeout(kDance4);
    settimeout(kDance5);
    settimeout(kDance6);

    DEBUG(llDumpList2String(gTimeoutList,":"));
}

Process(string timereventid) {

    if (llList2String(kDance1,0) == timereventid) 
    {       
        DEBUG("Dance1");
;
        SendMessageLinked(dylan,"@appearance=Dylan");
        SendMessageLinked(namaka,"@appearance=Namaka");

        SendMessageLinked(npc1,"@appearance=Crispen Enpeacee");
        SendMessageLinked(npc2,"@appearance=Alessandra Enpeacee");
        SendMessageLinked(npc3,"@appearance=Sammy Enpeacee");
        SendMessageLinked(npc4,"@appearance=Jolinda Enpeacee");
        SendMessageLinked(npc5,"@appearance=Claire Enpeacee");
        SendMessageLinked(npc6,"@appearance=Marianne Enpeacee");
        
        SendMessageLinked(LINK_SET,"@notecard=Dance1");
    }
    else if (llList2String(kDance2,0) == timereventid) 
    {       
        DEBUG("Dance2");
        SendMessageLinked(LINK_SET,"@appearance=Alessandra Enpeacee");
        SendMessageLinked(LINK_SET,"@notecard=Dance2");
    }
    else if (llList2String(kDance3,0) == timereventid) 
    {       
        DEBUG("Dance3");
        SendMessageLinked(LINK_SET,"@appearance=Sammy Enpeacee");
        SendMessageLinked(LINK_SET,"@notecard=Dance3");
    }
    else if (llList2String(kDance4,0)== timereventid) 
    {       
        DEBUG("Dance4");
        SendMessageLinked(LINK_SET,"@appearance=Jolinda Enpeacee");
        SendMessageLinked(LINK_SET,"@notecard=Dance4");
    }
    else if (llList2String(kDance5,0)== timereventid) 
    {       
        DEBUG("Dance5");
        SendMessageLinked(LINK_SET,"@appearance=Claire Enpeacee");
        SendMessageLinked(LINK_SET,"@notecard=Dance5");
    }
    else if (llList2String(kDance6,0)== timereventid) 
    {       
        DEBUG("Dance6");
        SendMessageLinked(LINK_SET,"@appearance=MarianneEnpeacee");
        SendMessageLinked(LINK_SET,"@notecard=Dance6");
    }
    else if (llList2String(kFireworksStartsAt,0) == timereventid) 
    {       
        DEBUG("Shoot!");
        SendMessageLinked(LINK_SET,"@appearance=Dragon");
        SendMessageLinked(LINK_SET,"@notecard=Fireworks");
        llRegionSay(gFireworksChannel,"Go");
        settimeout(kFireworksRepRate);
    }
    else if (llList2String(kFireworksRepRate,0) == timereventid) 
    {       
        DEBUG("Fireworks Start");
        llRegionSay(gFireworksChannel,"Go");
        
        SendMessageLinked(npc1,"@appearance=Crispen Enpeacee");
        SendMessageLinked(npc2,"@appearance=Alessandra Enpeacee");
        SendMessageLinked(npc3,"@appearance=Sammy Enpeacee");
        SendMessageLinked(npc4,"@appearance=Jolinda Enpeacee");
        SendMessageLinked(npc5,"@appearance=Claire Enpeacee");
        SendMessageLinked(npc6,"@appearance=Marianne Enpeacee");

        SendMessageLinked(dylan,"@appearance=Dylan");
        SendMessageLinked(namaka,"@appearance=Namaka");
        
        SendMessageLinked(LINK_SET,"@notecard=Final");   
        
        settimeout(kFireworksRepRate);
    }
    else if (llList2String(kStopAutoFire,0) == timereventid) 
    {
        
        DEBUG("Fireworks End");
        deletetimeout(kFireworksRepRate);
        settimeout(kRaiseTeleport);
    }
    else if (llList2String(kRaiseTeleport,0) == timereventid) 
    {
        SendMessageLinked(LINK_SET,"@notecard=Teleport");   
        DEBUG("Teleports Up");
        llRegionSay(gTeleportChannel,"Up");
    }
}

integer        busy;
integer        gListener;  // Listener for handling different channels
list           gTimeoutList;
float          gTimeElapsed=0;

//============================================================================
vector          gFacecolor=<1.0,0.0,0.0>; //RED


DEBUG(string msg)
{
    if (debug ==1)
        llSay(0,llGetScriptName() + ":" + msg);   
    if (debug ==2)
        llSetText(msg, <1,0,0>,1.0);   
}





menu(key id, integer channel, string title, list buttons) {
    llListenRemove(gListener);
    gListener = llListen(channel,"",id,"");
    llDialog(id,title,buttons,channel);
}

simplemenu(key id) {
    menu(id,gSimpleMenuChannel,"Select an option",["ShowTime","Finale","Stop"]);
}

deletetimeout(list events) {

    string timereventid = llList2String(events,0);

    DEBUG("Deleteing timer event " + timereventid);
    integer identifyerIndex = llListFindList(gTimeoutList, [timereventid]);
    if (identifyerIndex != -1)
        gTimeoutList = llDeleteSubList(gTimeoutList, identifyerIndex - 1, identifyerIndex);
}

settimeout(list events)
{
    // unpack the list
    string timereventid = llList2String(events,0);
    integer time = llList2Integer(events,1);

    DEBUG("Adding " + timereventid);
    integer identifyerIndex = llListFindList(gTimeoutList, [timereventid]);
    if (identifyerIndex != -1)
        gTimeoutList = llDeleteSubList(gTimeoutList, identifyerIndex - 1, identifyerIndex);
    if (time != 0) {
        gTimeoutList += time;
        gTimeoutList += timereventid;
    }
    
    llSetTimerEvent(1.0);
    
}

timertick() {
    gTimeElapsed ++;
    //DEBUG((string) gTimeElapsed );
    
    integer i;
    integer numTimers = llGetListLength(gTimeoutList);

    //DEBUG((string) (numTimers/2) + " timers");
    // scan over all queued timers
    for (i = 0; i < numTimers; i += 2) 
    {
        integer triggerTime = llList2Integer(gTimeoutList, i);

        //DEBUG("TriggerTime = " + (string)triggerTime); 
        if (triggerTime == gTimeElapsed) {
            
            string timereventid = llList2String(gTimeoutList, i + 1);
            //DEBUG("matched " + timereventid);
            
            gTimeoutList = llDeleteSubList(gTimeoutList, i, i + 1);    // they are one-shots, so delete the event that just happened.

            Process(timereventid);    // process the callback

            
            if (gTimeoutList == []) {
                DEBUG("Show over! Starting back up");
                ShowTime();
            }
        } 
    }
}

displaydigit(integer n, string d){
    list Facelist; //list depends on your mesh digital readout face number.
    integer i;       
    if(n==0) Facelist=[ 1,1,1,1,0,1,1 ]; //index @0 | 7 faces per digit
    if(n==1) Facelist=[ 0,0,1,0,0,1,0 ];
    if(n==2) Facelist=[ 1,1,0,1,1,1,0 ];
    if(n==3) Facelist=[ 1,1,1,0,1,1,0 ];
    if(n==4) Facelist=[ 0,0,1,0,1,1,1 ];
    if(n==5) Facelist=[ 1,1,1,0,1,0,1 ];
    if(n==6) Facelist=[ 0,1,1,1,1,0,1 ];
    if(n==7) Facelist=[ 1,0,1,0,0,1,0 ];
    if(n==8) Facelist=[ 1,1,1,1,1,1,1 ];
    if(n==9) Facelist=[ 1,0,1,0,1,1,1 ];
    
    integer l = llGetLinkNumber() != 0;   
    integer x = llGetNumberOfPrims() + l; 

    for (; l < x; ++l){
        if (llGetLinkName(l) == d){
            for (i=0;i<7;i++){
                llSetLinkPrimitiveParamsFast(l,[PRIM_COLOR,i,gFacecolor,llList2Float(Facelist,i)]);
            }
        }
    }
}

getdigit(integer time){
    string dOne;
    string dTen;
    string dHundred;
    string dThousand;
    
    if (time<10){
        dOne=(string)time;
        dTen="0";
        dHundred="0";
        dThousand="0"; // add your digits here
    }else if(time<100){
        dOne=llGetSubString((string)time,-1,-1);
        dTen=llGetSubString((string)time,0,0);
        dHundred="0";
        dThousand="0";
    }else if(time<1000){
        dOne=llGetSubString((string)time,-1,-1);
        dTen=llGetSubString((string)time,1,1);
        dHundred=llGetSubString((string)time,0,0);
        dThousand="0";
    }else if(time<10000){
        dOne=llGetSubString((string)time,-1,-1);
        dTen=llGetSubString((string)time,2,2);
        dHundred=llGetSubString((string)time,1,1);
        dThousand=llGetSubString((string)time,0,0);
    }
    displaydigit((integer)dOne, "one");
    displaydigit((integer)dTen, "ten");
    displaydigit((integer)dHundred, "hundred");
    displaydigit((integer)dThousand, "thousand");

    //DEBUG(dThousand + dHundred + ":" + dTen + dOne);
}

StopAll()
{
    DEBUG("Stopped");
    llSetTimerEvent(0);
    
}
           
default
{
    state_entry()
    {
         llListen(CommandChannel,"","","");
         getdigit(0);
    }
    
    touch_start(integer num)
    {
        if ( llGetOwner() == llDetectedKey(0)) {
            if (! busy) {
                simplemenu(llDetectedKey(0));
                busy++;
            } else {
                busy = FALSE;
                StopAll();
            }
        }
    }
    
    link_message(integer sender_number, integer number, string message, key id)
    {
        DEBUG("LINK MESSAGE\n" + message);
        DoCmd(message, number);        
    }

    listen (integer channel, string name, key id, string message) 
    {
        // !!! add parser for killing the NPC
        DEBUG("LISTEN\n" + message);
        DoCmd(message, channel);
    }

    timer() 
    {
        timertick();
        
        //limit the ticker to maximum ticks
        if(gTimeElapsed >= MaxTicks){
            gTimeElapsed=0;
        }
        integer CountDown = MaxTicks - (integer)gTimeElapsed;
        integer mm = (CountDown / 60) * 100;
        integer ss = (CountDown % 60);
        integer cc = mm + ss;
        
        getdigit((integer)cc);
    }

}