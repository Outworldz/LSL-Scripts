// :SHOW:1
// :CATEGORY:NPC
// :NAME:HyperGrid Story Nine
// :AUTHOR:Ferd Frederix
// :KEYWORDS:NPC, controller, cyber helmet
// :CREATED:2015-11-24 20:25:33
// :EDITED:2015-11-24  19:25:33
// :ID:1087
// :NUM:1842
// :REV:1.0
// :WORLD:OpenSim
// :DESCRIPTION:
// NPC helmet controller
// Accepts a single chatted command to msake the cyber being helmet flash for a second or two.
// worn by the NPC
// :CODE:

// TUNABLES
integer debug = 1;




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

Go()
{
        llSetLinkPrimitiveParamsFast(llGetLinkNumber(),[PRIM_GLOW,ALL_SIDES,.2, PRIM_SIZE,  <0.5,0.5,2>,PRIM_COLOR,ALL_SIDES,<1,1,1>,0.5  ]);
    llSetTimerEvent(2);

}



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
        if ( text =="BANG")
            Go();
    }
    
    
    timer()
    {
        llSetLinkPrimitiveParamsFast(llGetLinkNumber(),[PRIM_GLOW,ALL_SIDES,0.2, PRIM_SIZE, <0.5,0.5,2> ] );
        llSleep(0.25);
        llSetLinkPrimitiveParamsFast(llGetLinkNumber(),[PRIM_GLOW,ALL_SIDES,0.2, PRIM_SIZE, <0.4,0.4,2> ] );
        
        llSetLinkPrimitiveParamsFast(llGetLinkNumber(),[PRIM_GLOW,ALL_SIDES,0, PRIM_SIZE, <0.2,0.2,2> ] );
        llSleep(0.25);
        llSetLinkPrimitiveParamsFast(llGetLinkNumber(),[PRIM_GLOW,ALL_SIDES,0, PRIM_SIZE, <0.1,0.1,2>,PRIM_COLOR,ALL_SIDES,<1,1,1>,0 ] );
        llSetTimerEvent(0);
        
    }
        
}
