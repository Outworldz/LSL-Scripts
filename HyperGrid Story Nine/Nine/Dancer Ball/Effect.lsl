// :SHOW:1
// :CATEGORY:NPC
// :NAME:HyperGrid Story Nine
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:NPC, controller, cyber helmet
// :CREATED:2015-11-24 20:25:33
// :EDITED:2015-11-24  19:25:33
// :ID:1087
// :NUM:1836
// :REV:1.0
// :WORLD:OpenSim
// :DESCRIPTION:
// NPC helmet controller
// Accepts a single link message to make the cyber being helmet flash for a second or two.
// worn by the NPC

// :CODE:

// TUNABLES
integer debug = 0;




// GLOBALS
integer counter = 0;


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
    llSetLinkPrimitiveParamsFast(llGetLinkNumber(),[PRIM_GLOW,ALL_SIDES,.2, PRIM_SIZE, <2,2,2>,PRIM_COLOR,ALL_SIDES,<1,1,1>,0.5  ]);
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
        
        llSetTextureAnim(ANIM_ON | SMOOTH | LOOP , ALL_SIDES, 1, 1, 1.0, 1.0, 1.0);
    }

    link_message(integer total_number, integer Num, string text, key id)
    {
        if ( text =="BOOM")
            Go();
    }
    
    
    timer()
    {
        llSetLinkPrimitiveParamsFast(llGetLinkNumber(),[PRIM_GLOW,ALL_SIDES,0.2, PRIM_SIZE, <1.5,1.5,1> ] );
        llSleep(0.25);
        llSetLinkPrimitiveParamsFast(llGetLinkNumber(),[PRIM_GLOW,ALL_SIDES,0.2, PRIM_SIZE, <1.2,1.2,1> ] );
        
        llSetLinkPrimitiveParamsFast(llGetLinkNumber(),[PRIM_GLOW,ALL_SIDES,0, PRIM_SIZE, <1,1,1> ] );
        llSleep(0.25);
        llSetLinkPrimitiveParamsFast(llGetLinkNumber(),[PRIM_GLOW,ALL_SIDES,0, PRIM_SIZE, <1,1,1>,PRIM_COLOR,ALL_SIDES,<1,1,1>,0 ] );
        llSetTimerEvent(0);
        
    }
        
}
