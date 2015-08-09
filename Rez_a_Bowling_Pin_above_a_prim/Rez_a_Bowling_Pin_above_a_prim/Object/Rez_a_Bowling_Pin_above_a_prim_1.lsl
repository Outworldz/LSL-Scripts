// :CATEGORY:Rezzers
// :NAME:Rez_a_Bowling_Pin_above_a_prim
// :AUTHOR:Martin
// :CREATED:2010-06-21 11:42:40.877
// :EDITED:2013-09-18 15:39:01
// :ID:705
// :NUM:961
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Rez_a_Bowling_Pin_above_a_prim
// :CODE:
string object = "bowling_pins"; // Name of object in inventory
vector relativePosOffset = <-0.5, 0.0, .0>; // "Forward" and a little "above" this prim
vector relativeVel = <0.0, 0.0, 0.0>; // Traveling in this prim's "forward" direction at 1m/s
rotation relativeRot = <0.0, 0.0, 0.0, 0.0>; // Rotated 90 degrees on the x-axis compared to this prim
integer startParam = 10;
 
default
{
   state_entry()
   {
      llListen(0,"","","");
   }
   listen(integer channel,string name,key id,string message)
   { 
           if(id == llGetOwner())
           {
            if(message == "")
            {
                llGiveInventory(llDetectedKey(0), "");
            }
            else if(message == "reset")
            {
                llSetTimerEvent(3);
            }
            
        }}timer()
            {
            
            {
                 vector myPos = llGetPos();
        rotation myRot = llGetRot();
 
        vector rezPos = myPos+relativePosOffset*myRot;
        vector rezVel = relativeVel*myRot;
        rotation rezRot = relativeRot*myRot;
 
        llRezObject(object, rezPos, rezVel, rezRot, startParam);
        llResetScript();
    
        }
        }}
