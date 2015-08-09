// :CATEGORY:Crate
// :NAME:Breakable_Crate
// :AUTHOR:Davy Maltz
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:49
// :ID:114
// :NUM:155
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// After the success of the breakable crate, I also decided to make some modified copies--A breakable wooden pallet, barrel, and explodable barrel...The main difference being the sounds that were used for collisions and destructions. For the sake of not uploading duplicate scripts, the sounds for the other versions of this script can be found in our list of Sound Keys. 
// :CODE:
list breaksound = ["1ceaa00b-95a4-9b37-5c76-dbd711128fe5","22f44b4c-e9e7-9070-074c-2979813768b1","7c2b0c79-4cb5-51f4-90f5-ec3adce56f03","a9f429ec-6cca-777d-1517-7cd79df88043"];
list collisionsound = ["2d968abb-4c3d-61f9-572a-b380969d9327","20d17901-8e0c-d3cf-4390-2db00524f59e","305e1068-1650-38d6-ee80-0f2dd7d7c95d"];
default
{
    state_entry()
    {
        llCollisionSound("",0.0);
    }
    touch_start(integer num_detected)
    {
       llSensor(llKey2Name(llDetectedKey(0)),llDetectedKey(0),AGENT,30,PI);
    }
    sensor(integer num_detected)
    {
      llTriggerSound("1d7b6b0f-df02-d797-3b32-75076af654f1",1.0);
      llApplyImpulse(6 * (llRot2Up(llAxes2Rot(ZERO_VECTOR, ZERO_VECTOR, llVecNorm(llDetectedPos(0) - llGetPos()))) * -1),FALSE);  
    }
    collision_start(integer num_detected)
    {
        llPlaySound(llList2String(collisionsound,(integer)llFrand(llGetListLength(collisionsound))),llVecMag(llGetVel()) / 3);
        if(llVecMag(llDetectedVel(0)) > 10)
        {
            llPassCollisions(TRUE);
            llRezObject("Broken Crate",llGetPos(),llGetVel(),llGetRot(),0);
llStopSound();
llTriggerSound(llList2String(breaksound,(integer)llFrand(llGetListLength(breaksound))),1.0);
            llDie();
        }
        else if(llVecMag(llGetVel()) > 7)
        {
            llPassCollisions(TRUE);\
            llRezObject("Broken Crate",llGetPos(),llGetVel(),llGetRot(),0);
llStopSound();
llTriggerSound(llList2String(breaksound,(integer)llFrand(llGetListLength(breaksound))),1.0);
            llDie();
        }
    }
        land_collision_start(vector pos)
        {
           llPlaySound(llList2String(collisionsound,(integer)llFrand(llGetListLength(collisionsound))),llVecMag(llGetVel()) / 4);
          if(llVecMag(llGetVel()) > 7)
        {
            llPassCollisions(TRUE);
            llRezObject("Broken Crate",llGetPos(),llGetVel(),llGetRot(),0);
llTriggerSound(llList2String(breaksound,(integer)llFrand(llGetListLength(breaksound))),1.0);
            llDie();  
        }
    }
}
