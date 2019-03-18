// :SHOW:1
// :CATEGORY:NPC
// :NAME:HyperGrid Story Nine
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:NPC, controller, cyber helmet
// :CREATED:2015-11-24 20:25:33
// :EDITED:2015-11-24  19:25:33
// :ID:1087
// :NUM:1843
// :REV:1.0
// :WORLD:OpenSim
// :DESCRIPTION:
// NPC helmet controller
// Accepts a single chatted command to msake the cyber being helmet flash for a second or two.
// rezzed in world and not worn
// :CODE:

// TUNABLES
integer debug = 0;


// GLOBALS
integer counter = 0;
integer listener;

// FUNCTIONS
DEBUG(string msg)
{
    if (debug & 1)
        llSay(0,llGetScriptName() + ":" + msg);   
    if (debug & 2)
        llSetText(msg, <1,0,0>,1.0);   
}
NpcSaySomething(){

    list sayings = ["The helmet begins to glow","A beam of light appears","The helmet begins to hum","The cyberbeing helmet is activated", "bzzz", "Zap","KaPow!"];
    key NpcKey = llGetOwner();
    DEBUG("Owner Key = " + (string) NpcKey);
    
    llSay(0, llList2String(sayings,counter++));
    if (counter > llGetListLength(sayings)) {
        counter = 0;
    }   
}

Go()
{
    NpcSaySomething();
    llSetLinkPrimitiveParamsFast(0,[PRIM_GLOW,ALL_SIDES,.2, PRIM_SIZE, <2,2,2>,PRIM_COLOR,ALL_SIDES,<1,1,1>,0.5  ]);
    llSetTimerEvent(2);

}

integer Helmet_Channel = 576;

default
{
    on_rez(integer p)
    {
        llResetScript();
    }

    changed(integer what)
    {
        if (what & CHANGED_REGION_START)
        {
            llResetScript();
        }                
    }
    

    state_entry()
    {    
        llSetText("", <1,0,0>,1.0);   
        llListenRemove(listener);
        listener= llListen(Helmet_Channel, "","","BOOM"); // listen for boom command
        
        llSetTextureAnim(ANIM_ON | SMOOTH | LOOP , ALL_SIDES, 1, 1, 1.0, 1.0, 1.0);
        
        llSensorRepeat("Namaka ♥", NULL_KEY, AGENT, 25.0, PI,5);
    }

    listen(integer channel, string name, key id, string msg)
    {
         Go();   
    }
        
    touch_start(integer total_number)
    {
        Go();
    }
    
    sensor(integer n)
    {
        llSetRegionPos(llDetectedPos(0) + <0,0,1>);
    }
    
    no_sensor()
    {
        llSetRegionPos(<200, 128, 48>); // sop we can find this blasted thing
    }
    
    timer()
    {
        llSetLinkPrimitiveParamsFast(0,[PRIM_GLOW,ALL_SIDES,0.2, PRIM_SIZE, <1.5,1.5,1> ] );
        llSleep(0.25);
        llSetLinkPrimitiveParamsFast(0,[PRIM_GLOW,ALL_SIDES,0.2, PRIM_SIZE, <1.2,1.2,1> ] );
        
        llSetLinkPrimitiveParamsFast(0,[PRIM_GLOW,ALL_SIDES,0, PRIM_SIZE, <1,1,1> ] );
        llSleep(0.25);
        llSetLinkPrimitiveParamsFast(0,[PRIM_GLOW,ALL_SIDES,0, PRIM_SIZE, <1,1,1>,PRIM_COLOR,ALL_SIDES,<1,1,1>,0 ] );
        llSetTimerEvent(0);
        
    }
        
}
