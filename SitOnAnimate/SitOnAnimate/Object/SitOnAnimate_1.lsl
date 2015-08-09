// :CATEGORY:Pose Balls
// :NAME:SitOnAnimate
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:03
// :ID:775
// :NUM:1063
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// SitOnAnimate.lsl
// :CODE:

key owner;
key sitter;

string curanim;

default
{
    on_rez(integer params){llResetScript();}
    state_entry()
    {
    owner=llGetOwner();
     vector eul = <0,0,0>; //45 degrees around the z-axis, in Euler form
            eul *= DEG_TO_RAD; //convert to radians
            rotation quat = llEuler2Rot(eul); //convert to quaternion
            llSitTarget(<0,0,-1>,ZERO_ROTATION);
        }
            
    touch_start(integer total_number){
     
    }
    
     changed(integer change) { // something changed
     curanim=llGetInventoryName(INVENTORY_ANIMATION,0);
        if (change & CHANGED_LINK) { // and it was a link change
            llSleep(0.5); // llUnSit works better with this delay
            if (llAvatarOnSitTarget() != NULL_KEY) { // somebody is sitting on me
            sitter=llAvatarOnSitTarget();            
           llRequestPermissions(sitter, PERMISSION_TRIGGER_ANIMATION);
           llStopAnimation("sit");
           llStartAnimation(curanim);
            llLoopSound("loop-galaxie", 1.0);
            
            }else{llStopAnimation(curanim);sitter=NULL_KEY;}
        }
    }
}
// END //
