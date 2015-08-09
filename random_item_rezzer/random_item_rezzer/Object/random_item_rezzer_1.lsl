// :CATEGORY:Rezzers
// :NAME:random_item_rezzer
// :AUTHOR:Martin
// :CREATED:2010-06-27 20:04:44.170
// :EDITED:2013-09-18 15:39:00
// :ID:677
// :NUM:920
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// you can have tons of fun with this if you fool with it
// :CODE:
string object = "ball"; // Name of object in inventory
string object1 = "square";
string object2 = "triangle";
string object3 = "cylinder";

vector relativePosOffset = <0.5, 0., 2.0>; // "Forward" and a little "above" this prim
vector relativeVel = <0.0, 0.0, 0.0>; // Traveling in this prim's "forward" direction at 1m/s
rotation relativeRot = <0.0, 0.0, 0.0, 0.0>; // Rotated 90 degrees on the x-axis compared to this prim
integer startParam = 10;
 

default
{
    state_entry()
    {
       
    }

    touch_start(integer total_number)
    {
        float   FloatValue;
        integer IntValue;
        string  StringValue;
        
        FloatValue  = llFrand(3);
        IntValue    = llRound(FloatValue);
        StringValue = (string)IntValue;
        
          if (StringValue == "0")
         {
                 vector myPos = llGetPos();
        rotation myRot = llGetRot();
 
        vector rezPos = myPos+relativePosOffset*myRot;
        vector rezVel = relativeVel*myRot;
        rotation rezRot = relativeRot*myRot;
 
        llRezObject(object, rezPos, rezVel, rezRot, startParam);
}


        if (StringValue == "1")
         {
                 vector myPos = llGetPos();
        rotation myRot = llGetRot();
 
        vector rezPos = myPos+relativePosOffset*myRot;
        vector rezVel = relativeVel*myRot;
        rotation rezRot = relativeRot*myRot;
 
        llRezObject(object1, rezPos, rezVel, rezRot, startParam);}

if (StringValue == "2")
         {
                 vector myPos = llGetPos();
        rotation myRot = llGetRot();
 
        vector rezPos = myPos+relativePosOffset*myRot;
        vector rezVel = relativeVel*myRot;
        rotation rezRot = relativeRot*myRot;
 
        llRezObject(object2, rezPos, rezVel, rezRot, startParam);

}

if (StringValue == "3")
         {
                 vector myPos = llGetPos();
        rotation myRot = llGetRot();
 
        vector rezPos = myPos+relativePosOffset*myRot;
        vector rezVel = relativeVel*myRot;
        rotation rezRot = relativeRot*myRot;
 
        llRezObject(object3, rezPos, rezVel, rezRot, startParam);

}}
}
