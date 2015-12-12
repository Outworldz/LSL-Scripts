//HYPERGRID STORY NINE
// List NPC Listener channels
//sara=11 sammy=12 claire=13 jolinda=14 tiny=15 tiny2=16 fireworks=20

integer        gListener;  // Listener for handling different channels
integer        gSimpleMenuChannel; // The channel used for the menu
float          gTimerInterval = 1; // Keep this at 1 for your sanity.
list           gTimeoutList;
float          gTimeElapsed=0;
integer        gAutofire=FALSE;
//============================================================================
vector          gFacecolor=<1.0,0.0,0.0>; //RED
integer         gNewTime;
integer         gOldTime;
//==Function that returns a random number for our menu handler channel
integer randomchannel() {
    return((integer)(llFrand(99999.0)*-1));
    }

menu(key id, integer channel, string title, list buttons) {
    llListenRemove(gListener);
    gListener = llListen(channel,"",id,"");
    llDialog(id,title,buttons,channel);
    // TimerEvent for killing the menu listener
    settimeout("untouched", 30); //call untouched timeout 
    }

simplemenu(key id) {
    gSimpleMenuChannel = randomchannel();
    menu(id,gSimpleMenuChannel,"Select an option",["FIREWORKS","SARA","SAMMY","CLAIRE","JOLINDA","TINY","TINY2","LeadNPC","Finale!","CeaseFire"]);
    }

settimeout(string timereventid, float time) {
    if(gTimeoutList == [])
        llSetTimerEvent(gTimerInterval);
    integer identifyerIndex = llListFindList(gTimeoutList, [timereventid]);
    if (identifyerIndex != -1)
        gTimeoutList = llDeleteSubList(gTimeoutList, identifyerIndex - 1, identifyerIndex);
    if (time != 0) {
        gTimeoutList += time + gTimeElapsed;
        gTimeoutList += timereventid;
        }
    gTimeoutList = llListSort(gTimeoutList, 2, TRUE);
    }

timeout(string timereventid) 
{
    if (timereventid == "untouched") 
    {
        llSay(0, "I have been untouched for 30 seconds, killing menu listener!");
        llListenRemove(gListener); // kill the listener after 30 seconds inactivity
    } 
    else if (timereventid == "countdown2execute") 
    {
        float seconds2count = 1800;
        llSay(0, "I have counted down " + (string)seconds2count + " seconds, repeat countdown and start the show");
        settimeout("countdown2execute", seconds2count); //call it again to loop.
    }
    else if (timereventid == "autofire") 
    {
    if(gAutofire)
    {
    llSay(0,"should fire every 5 seconds.");
    llRegionSay(20,"Go");
    settimeout("autofire", 5);
    }
    }
    if (timereventid == "stopautofire") 
    {
    gAutofire=FALSE;
    } 
}
timertick() 
{
    gTimeElapsed += gTimerInterval;
    integer i;
    integer numTimers = llGetListLength(gTimeoutList);
    for (i = 0; i < numTimers; i += 2) 
    {
        float triggerTime = llList2Float(gTimeoutList, i);
        if (triggerTime <= gTimeElapsed) 
        {
            string timereventid = llList2String(gTimeoutList, i + 1);
            gTimeoutList = llDeleteSubList(gTimeoutList, i, i + 1);
            timeout(timereventid);
        if (timereventid=="countdown2execute")
        {
        displaycountdowntext((integer)gTimeElapsed);
        getdigit((integer)gTimeElapsed);
        }
            if (gTimeoutList == [])
                llSetTimerEvent(0);
        } 
        else 
        {
            return;
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

integer i;

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
}

displaycountdowntext(integer time){
 gNewTime = time;
 if (gOldTime < gNewTime){
     llSetText("Elapsed Ticker: " + (string)gNewTime + " ticks",<1,1,.6>,1.0);
     gOldTime = gNewTime;
    }   
}
    
default
{
    state_entry()
    {
    float seconds2count = 3600;
    settimeout("countdown2execute", seconds2count);
    
    }
    touch_start(integer num)
    {
        simplemenu(llDetectedKey(0));
    }

    listen (integer channel, string name, key id, string message) 
    {
        if (message == "FIREWORKS") {
            llSay(0,"You selected option FIREWORKS");
            llRegionSay(20,"Go");
            //do something else here
        }
        else if (message == "SARA") 
        {
            llSay(0,"You selected option SARA");
            llRegionSay(11,"@go");
                //do something else here
        }
        else if (message == "SAMMY") 
        {
            llSay(0,"You selected option SAMMY");
             llRegionSay(12,"@go");
                //do something else here
        }
        else if (message == "CLAIRE") 
        {
            llSay(0,"You selected option CLAIRE");
             llRegionSay(13,"@go");
                //do something else here
        }
        else if (message == "JOLINDA") 
        {
            llSay(0,"You selected option JOLINDA");
             llRegionSay(14,"@go");
                //do something else here
        }
        else if (message == "TINY") 
        {
            llSay(0,"You selected option TINY");
             llRegionSay(15,"@go");
                //do something else here
        }
        else if (message == "TINY2") 
        {
            llSay(0,"You selected option TINY2");
             llRegionSay(16,"@go");
                //do something else here
        }
        else if (message == "LeadNPC")
        {
            llSay(0,"You selected option LeadNPC");
             llRegionSay(10,"@go");
                //do something else here
        }
        else if (message == "Finale!")
        {
            llSay(0,"You selected option Finale!");
            gAutofire=TRUE;
            settimeout("autofire", 1);
            settimeout("stopautofire", 90);            
            //do something else here
        }
        else if (message == "CeaseFire")
        {
            llSay(0,"You selected option CeaseFire");
            gAutofire=FALSE;
            //do something else here
        }
        simplemenu(id); // refresh menu
    }

    timer() 
    {
        timertick();
        integer MaxTicks = 1800; //Ticks to countdown from
        //limit the ticker to maximum ticks
        if(gTimeElapsed >= MaxTicks){
            gTimeElapsed=0;
        }
        integer CountDown = MaxTicks - (integer)gTimeElapsed;
        integer mm = (CountDown / 60) * 100;
        integer ss = (CountDown % 60);
        integer cc = mm + ss;
        displaycountdowntext((integer)gTimeElapsed);
        getdigit((integer)cc);

    }
}