// :CATEGORY:Map
// :NAME:Hunt HUD
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:55
// :ID:396
// :NUM:552
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// main program
// :CODE:

// Map HUD root prim script
// exposes a child prim when over that place

integer debug = TRUE;    // set to TRUE to debug

integer up = FALSE;

DEBUG(string msg)
{
    if (debug) llOwnerSay(msg);
}

setChild(vector myPos)
{
    vector rootScale = llGetScale();
    //DEBUG("scale: " + (string) rootScale);

    float x = myPos.x / 256 * rootScale.x;    // some percentage of the size of the prim
    float A = -rootScale.x/2 ;
    float up = A + (rootScale.x * x *2 );
    //up = -.25;

    float y = myPos.y / 256 * rootScale.y;    // some percentage of the size of the prim
    float B = -rootScale.y/2 ;
    float left_right = B + (rootScale.y * y * 2);

    
    string msg = (string) left_right+ "|" + (string) up +"|"+ (string) llGetRot();
   // DEBUG(msg);

    
            
  // up = 0;
  // left_right =0;

    
//    msg = (string) left_right+ "|" + (string) up;
    
    llMessageLinked(LINK_ALL_CHILDREN,0,msg, "");
    //llMessageLinked(LINK_ALL_CHILDREN,0,msg, "");
}
init()
{
    llMessageLinked(LINK_ALL_CHILDREN,2,(string) llGetScale(),"");
    llMessageLinked(LINK_ALL_CHILDREN,4,"","");     // Darken them all
    llSetTimerEvent(.20);
}

default
{
    state_entry()
    {
        init();
    }

    touch_start(integer total_number)
    {
        if (up)
        {
            llMessageLinked(LINK_ALL_CHILDREN,1,"Down","");
            up = TRUE;
        } 
        else
        {
            llMessageLinked(LINK_ALL_CHILDREN,1,"Up","");
            up = FALSE;
        }
    }

    changed(integer change)
    {
        if (change & CHANGED_OWNER)
        {
            llResetScript();
        }
    }


    attach(integer where)
    {
        init();
    }
    
    
    timer()
    {
        if ( llGetRegionName() != llGetObjectDesc())
            return;


        vector myPos = llGetPos();
        setChild(myPos);

    }


}
