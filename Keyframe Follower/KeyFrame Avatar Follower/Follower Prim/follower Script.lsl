// :CATEGORY:Follower
// :NAME:Keyframe Follower
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2014-12-04 12:13:47
// :EDITED:2014-12-04
// :ID:1058
// :NUM:1684
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// A avatar folloer thaty works in Opensim 
// :CODE:



float minspeed = 0.5;  
float maxspeed = 2;  
float maxtimer =  10.0;  // when no one is around, slow way down.

float maxrange = 96;    
float minrange = 20;    
float oldZ;

integer isSensorRepeatOn = FALSE;
integer land;

float random_float(float min, float max)
{
    return min + llFrand(max - min + 1);
}


rotation NormRot(rotation Q)
{
    float MagQ = llSqrt(Q.x*Q.x + Q.y*Q.y +Q.z*Q.z + Q.s*Q.s);
    return  <Q.x/MagQ, Q.y/MagQ, Q.z/MagQ, Q.s/MagQ>;
}
  
default 
{
    state_entry()
    {
        llSetLinkPrimitiveParamsFast(LINK_ROOT,
                [PRIM_PHYSICS_SHAPE_TYPE, PRIM_PHYSICS_SHAPE_CONVEX,
            PRIM_LINK_TARGET, LINK_ALL_CHILDREN,
                PRIM_PHYSICS_SHAPE_TYPE, PRIM_PHYSICS_SHAPE_NONE]);
                
        llSensorRepeat("", "", AGENT, 20.0, PI, maxtimer);
    }
 
  

    no_sensor()
    {
        llSensorRepeat("", "", AGENT, maxrange, PI, maxtimer);
    }
  
    sensor(integer num_detected)
    {   
        float speed = random_float(minspeed,maxspeed);
        vector ownPosition = llGetPos();
        rotation ownRotation = llGetRot();
        vector detectedPosition = llDetectedPos(0);
        rotation detectedRotation = llDetectedRot(0);
        vector size = llGetAgentSize(llDetectedKey(0));
        
        float Z = random_float(0, size.z/2);
        if (llFrand(10) < 1) {
            Z = -size.z/2;
            llMessageLinked(LINK_SET,1,"land","");
            land = TRUE;
            speed = 0.5;
        } else {
            land = FALSE;
            if (llFrand(10) < 1)
            {
                llMessageLinked(LINK_SET,1,"flames","");
            }
            
        }
        
       
        float Y = random_float(0, 1); 
        if (llFrand(2) < 1)  {
            llMessageLinked(LINK_SET,1,"r","");
            Y *= -1;
        } else {
            llMessageLinked(LINK_SET,1,"l","");
        }
        
        
        if (Z - oldZ > 0.2)
            llMessageLinked(LINK_SET,1,"up","");
        if (Z - oldZ > -0.2)
            llMessageLinked(LINK_SET,1,"down","");
            
        oldZ = Z;
        
 
        llSetKeyframedMotion(
            [(detectedPosition - ownPosition) + <-1, Y, Z>*detectedRotation,
            NormRot(detectedRotation/ownRotation), speed],
            []);
            
        if (land)
            llSensorRepeat("", "", AGENT, maxrange, PI, 10);
        else
            llSensorRepeat("", "", AGENT, minrange, PI, maxspeed);
    }
} 
