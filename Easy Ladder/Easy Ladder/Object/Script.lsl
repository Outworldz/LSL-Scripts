// :SHOW:
// :CATEGORY:Animation
// :NAME:Easy Ladder
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2015-07-15 10:04:12
// :EDITED:2015-07-15  09:04:12
// :ID:1081
// :NUM:1800
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Easy ladder script
// :CODE:
/* Climb ladder
 http://community.secondlife.com/t5/Scripting/Ladder-Climb/td-p/256433
 Edited for opensimulator w/ugly hack to unsit user at top via offset vector
 fixme: would be nicer to have a llRotLookAt for dismounting ladder
 BVH: 13_33   climb ladder

Ferd Frederixz - removed cruft, added offsets and removed ugly hacks. 

*/
 

float LADDERHEIGHT= 7.0;    // how far to move up
float STEPHEIGHT = 0.25;    // how far to move each step
float OFFSET = 3;           // tilt of the ladder;
float Extra  = 1;           // extra move onto the roof or in the door before unsit

climbup()
{
  
     llSetAlpha(0,ALL_SIDES);
    llStopAnimation("sit");
    llStartAnimation(llGetInventoryName(INVENTORY_ANIMATION,0));
     
    
    integer i;
    vector original;
    float steps = LADDERHEIGHT / STEPHEIGHT;
    float offset = OFFSET / steps;  // to one side
    
    original = llGetPos();
    do    
    {
        i++;  
        vector newPos = llGetPos() + <offset,0, STEPHEIGHT> * llGetRot();
        llSetPos(newPos);
    } while (i <= (steps));

    llSetPos(llGetPos() + <Extra, 0, 0> * llGetRot()); // extra, then unsit
    
    llStopAnimation(llGetInventoryName(INVENTORY_ANIMATION,0));

    if (llAvatarOnSitTarget() != NULL_KEY)
    { // somebody is sitting on me
        llUnSit(llAvatarOnSitTarget()); // unsit him or her
    }
      
    llSetPos(original); 
    llSetAlpha(1,ALL_SIDES);
}  // end climbup

default
{
  
  state_entry() {
     llSitTarget(<0.0, 0.0, 0.1>, ZERO_ROTATION);
  }

  changed(integer change)
  { 
  
  
    if(change == CHANGED_LINK)
    {
      key avatar = llAvatarOnSitTarget();
     
      if(avatar != NULL_KEY)
      {
         llRequestPermissions(avatar,PERMISSION_TRIGGER_ANIMATION);
            //hide poseball
         
         climbup();
      } 
    }
  } //end changed
} //end default
