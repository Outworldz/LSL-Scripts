// :CATEGORY:Animation
// :NAME:SurprizingFreezer
// :AUTHOR:Seagel Neville
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:05
// :ID:850
// :NUM:1180
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// SurprizingFreezer.lsl
// :CODE:

// Seagel Neville wrote this.
// I'm not familiar with any difficult things. You can do anything. ;)

key agent;

default 
{ 
    state_entry() 
    { 
        llSetSitText("Freeze");
        llSitTarget(<0.8, 0, -0.5>, ZERO_ROTATION);
        llSetCameraEyeOffset(<5, 0, 0.3>);
        llSetCameraAtOffset(<-5, 0, 0.2>);
    }      
    changed(integer change) 
    { 
        if(change & CHANGED_LINK) 
        { 
            agent = llAvatarOnSitTarget();             
            if(agent != NULL_KEY) 
            { 
                llRequestPermissions(agent, PERMISSION_TRIGGER_ANIMATION); 
            } 
        } 
    } 
    run_time_permissions(integer perm) 
    {
        if(perm & PERMISSION_TRIGGER_ANIMATION) 
        {
            llMessageLinked(LINK_SET,0, "OPEN", "");
            llPlaySound("door_open", 1);
            llStopAnimation("sit_generic"); 
            llStopAnimation("sit");
            llStartAnimation("falling");
            llMessageLinked(LINK_SET,0, "CLOSE", "");
            llPlaySound("door_latch", 1);
            llSleep(0.5);
            llStopAnimation("falling");
            llMessageLinked(LINK_SET,0, "ICE ON", "");
            llStartAnimation("up-up-and-away");
            llSleep(1);
            
            llMessageLinked(LINK_SET,0, "OPEN", "");    //You can copy, modfy, and insert this block
            llPlaySound("door_open", 1);                //to add new animations.
            llSleep(1);                                 //
            llMessageLinked(LINK_SET,0, "CLOSE", "");   //
            llPlaySound("door_latch", 1);               //
            llSleep(0.5);                               //
            llStopAnimation("up-up-and-away");          //
            llStartAnimation("igor");                   //
            llSleep(1);                                 //
            
            llMessageLinked(LINK_SET,0, "OPEN", "");
            llPlaySound("door_open", 1);
            llSleep(1);
            llMessageLinked(LINK_SET,0, "CLOSE", "");
            llPlaySound("door_latch", 1);
            llSleep(0.5);
            llStopAnimation("igor");
            llStartAnimation("MEATBALL");
            llSleep(1);
            
            llMessageLinked(LINK_SET,0, "OPEN", "");
            llPlaySound("door_open", 1);
            llSleep(1);
            llMessageLinked(LINK_SET,0, "CLOSE", "");
            llPlaySound("door_latch", 1);
            llSleep(0.5);
            llStopAnimation("MEATBALL");
            llStartAnimation("pull your head out");
            llSleep(1);
            
            llMessageLinked(LINK_SET,0, "OPEN", "");
            llPlaySound("door_open", 1);
            llSleep(1);
            llMessageLinked(LINK_SET,0, "CLOSE", "");
            llPlaySound("door_latch", 1);
            llSleep(0.5);
            llStopAnimation("pull your head out");
            llStartAnimation("long-kiss-femanine");
            llSleep(1);
            
            llMessageLinked(LINK_SET,0, "OPEN", "");
            llPlaySound("door_open", 1);
            llSleep(1);
            llMessageLinked(LINK_SET,0, "CLOSE", "");
            llPlaySound("door_latch", 1);
            llSleep(0.5);
            llStopAnimation("long-kiss-femanine");
            llStartAnimation("birth-of-venus");
            llSleep(1);
            
            llMessageLinked(LINK_SET,0, "OPEN", "");
            llPlaySound("door_open", 1);
            llMessageLinked(LINK_SET,0, "ICE OFF", "");
            llSleep(1);
            llSetStatus(STATUS_PHANTOM, TRUE);
            llUnSit(agent);
            llPushObject(agent, (<10, 0, 7> * llGetRot()), ZERO_VECTOR, FALSE);
            llStopSound();
            llSleep(1);
            llSetStatus(STATUS_PHANTOM, FALSE);
            llMessageLinked(LINK_SET,0, "CLOSE", "");
            llPlaySound("door_latch", 1);
        }            
    } 
    on_rez(integer start_param) 
    { 
        llResetScript(); 
    } 
} // END //
