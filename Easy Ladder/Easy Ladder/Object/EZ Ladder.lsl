// :SHOW:
// :CATEGORY:Animation
// :NAME:Easy Ladder
// :AUTHOR:Ferd Frederix
// :KEYWORDS:Ladder
// :CREATED:2015-07-15 10:04:12
// :ID:1081
// :NUM:1800
// :REV:2
// :WORLD:Second Life, Opensim
// :DESCRIPTION:
// Easy ladder script
// :CODE:

// Rev 2:  12-18-2015 added region pos for return

/* Climb ladder
 http://community.secondlife.com/t5/Scripting/Ladder-Climb/td-p/256433
 Edited for opensimulator to unsit user at top via offset vector

 BVH: climb-rope

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
      
    llSetRegionPos(original); 
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
         climbup();
      } 
    }
  } //end changed
} //end default
