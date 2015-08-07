// :CATEGORY:Weapons
// :NAME:Bow_and_Arrow
// :AUTHOR:Eric Linden
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:49
// :ID:113
// :NUM:154
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// There are two scripts, one for each prim.  The forst is for the bow, the second goes in the arrow.   Attach the arrow to your right hand
// :CODE:

vector fwd;
vector pos;
rotation rot;  

key holder;             //  Key of avatar holding gun 
integer on = TRUE;

integer attached = FALSE;  
integer permissions = FALSE;
integer armed = TRUE;
key owner;

fire()
{
    if(armed)
    {
    //  
    //  Actually fires the ball 
    //  
    armed = FALSE;
    integer shot = llRound(llFrand(1.0));
    rot = llGetRot();
    fwd = llRot2Fwd(rot);
    pos = llGetPos();
    pos = pos + fwd;
    pos.z += 0.75;                  //  Correct to eye point
    fwd = fwd * 30.0;
    llSay(57, (string)owner + "shoot");
    llStartAnimation("shoot_L_bow");
    llTriggerSound(llGetInventoryName(INVENTORY_SOUND, shot), 0.8);
    llRezObject("arrow", pos, fwd, rot, 0); 
    llSetTimerEvent(2.0);
    }

    
}

default
{
    
    run_time_permissions(integer permissions)
    {
        if (permissions > 0)
        {
            llWhisper(0, "Enter Mouselook to shoot me, Say 'pickup' to pickup arrows, say 'id' to identify yours.");
            llTakeControls(CONTROL_ML_LBUTTON, TRUE, FALSE);
            llStartAnimation("hold_L_bow");
            attached = TRUE;
            permissions = TRUE;
            owner = llGetOwner();
        }
    }

    attach(key attachedAgent)
    {
        //
        //  If attached/detached from agent, change behavior 
        // 
        if (attachedAgent != NULL_KEY)
        {
            string name = llKey2Name(llGetOwner());
            
            on = TRUE;
            attached = TRUE;
            if (!permissions)
            {
                llRequestPermissions(llGetOwner(),  PERMISSION_TRIGGER_ANIMATION| PERMISSION_TAKE_CONTROLS | PERMISSION_ATTACH);   
            }
            
        }
        else
        {
           
            attached = FALSE;
            llStopAnimation("hold_L_bow");
            llReleaseControls();
           

        }
    }

    control(key name, integer levels, integer edges) 
    {
        if (  ((edges & CONTROL_ML_LBUTTON) == CONTROL_ML_LBUTTON)
            &&((levels & CONTROL_ML_LBUTTON) == CONTROL_ML_LBUTTON) )
        {
            fire();
        }
    }
    
    timer()
    {
        llSetTimerEvent(0.0);
        armed = TRUE;
    }
    
        
  
}
 

// add the following scripr to the arrow prim

list textlist;
integer i;
integer cb;

default
{
    state_entry()
    {
        integer faces = llGetNumberOfSides();
        for(i=0; i<faces; i++)
        {
            string texture = llGetTexture(i);
            textlist = texture + textlist;
        }
        
        
            
    }
    
    attach(key id)
    {
        if(id == llGetOwner())
        {
            llListenRemove(-1);
            llSay(0,"armed");
            cb = llListen(57,"","",(string)id + "shoot");
        }
        else
        {
            llListenRemove(cb);
        }
    }

    listen(integer chan, string name, key id, string message)
    {
        //llSay(0, "arrow");
        llMessageLinked(LINK_SET, 1,"","");
        llSetTexture("clear", ALL_SIDES);
        llSetTimerEvent(0.3);
    }
    
    timer()
    {
        llSetTimerEvent(0.0);
        
        integer faces = llGetNumberOfSides();
        for(i=0; i<faces; i++)
        {
            string texture = llList2String(textlist,i);
            llSetTexture(texture, i);
        }
    }
}
