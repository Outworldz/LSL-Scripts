// :CATEGORY:Sphere World
// :NAME:Sphere_World__Walk_and_live_on_a_sphere
// :AUTHOR:Ferd Frederix
// :CREATED:2012-09-19 19:01:45.217
// :EDITED:2013-12-13 14:01:06
// :ID:824
// :NUM:1557
// :REV:1.1
// :WORLD:Second Life
// :DESCRIPTION:
// Controlled Walk Pose ball - put this in  a small sphere and set it at ground level.
// Add a walk animation named "Walk: Power Slow"  to the prim, and an animation named "avatar_stand_1".
// You can rename these to match or rename them in the sceript. 
// When you click it, it will let you walk on your sphere world


// :CODE:
// As of 03-13-2014,  the LICENSE for this script is now CC - NC BY SA 3.0
// See http://digigrids.free.fr/wiki/index.php?title=CC_BY-NC-SA_3.0
// original function is http://digigrids.free.fr/wiki/index.php?title=LlLookAt

// Mods:
// 03-13-2014
//   Unrolled uSteppedLookAt for Opensim to use
//   State change to running in function Fetch is illegal, moved to main code with True/False return value


string Text = "Live on the Moon";           // the hovertext when no one is stting
string WALK = "Walk: Power Slow";
string STAND = "avatar_stand_1";

// Requires there to be one walk animation in the inventory of the pose ball.


integer debug = FALSE;
DEBUG(string msg)
{
    if (debug)
        llOwnerSay(llGetScriptName() + ":" + msg);
        
}

// global listeners

integer To_Pose_CHANNEL = 98798771;
integer To_Planet_CHANNEL = 65835861;

//  walk on a sphere


string ANIMATION ;  // change to a walk animation


vector gSphereLocation;   // location of the walkable sphere
vector Home;            // pose ball home
rotation gOrient;
list gSilly_walks;

rotation sphereRot;


vector priorpos; 
key avatarKey;
float x ;
float y ;
float z ;
float gRADIUS = 0.0;
float aRADIUS;  
string controls ;


spin()
{
    llTargetOmega(<0.5,0.0,0.0>*llGetRot(),0.1,0.01);    // start spin
}

stopSpin()
{
    llTargetOmega(<0.0,0.0,0.0>*llGetRot(),0.1,0.01);    // start spin
}

//-- rotate objects x axis toward vPosTarget (local offset), at vFltRate (in radians per second)
//-- vFltRate < ~0.00000003rad/sec, (~0.00002deg/sec) will result in errors (and is just too slow anyway)
//-- vFltRate >= (PI * 5.0)rad/sec, (900deg/sec) will result in a single snap move to vRotTarget
uSteppedLookAt( vector vPosTarget, float vFltRate ){
    rotation vRotTarget = llRotBetween( <1.0, 0.0, 0.0>,  vPosTarget );
    vFltRate = llAcos( (llVecNorm( vPosTarget )) *(<1.0, 0.0, 0.0> * llGetLocalRot()) ) / (vFltRate / 5.0);
	if ((integer)vFltRate){
		rotation vRotStep = llAxisAngle2Rot( llRot2Axis( vRotTarget / llGetLocalRot() ),
		                    (1.0 / vFltRate) * llRot2Angle( vRotTarget / llGetLocalRot() ) );
		vFltRate = (integer)vFltRate;
		do{
			llSetLocalRot( vRotStep * llGetLocalRot() );
		}while( --vFltRate );
	}
	llSetLocalRot( vRotTarget );
} //-- for fixed time on any rotation try llKeyframeMotion

face_target(vector lookat) {
    
    rotation rot = llGetRot() * llRotBetween(<0.0 ,0.0 ,1.0 > * llGetRot(), gSphereLocation - llGetPos());
    llSetRot(rot);   
}

key avatar;


 warpPos( vector destpos ) 
 {  
    llOwnerSay("tp to: " + (string) destpos);
 
     llSetRegionPos(destpos);
 
 }

integer Fetch(key id, string message)
{
    if (llGetOwnerKey(id) == llGetOwner()) 
    {
        DEBUG("walk script Heard " + message);
    
        list data = llParseString2List(message, ["^"], []);
        
        if (llList2String(data, 0) == "SPHERE") 
        {
            gSphereLocation = (vector) llList2String(data, 1);
            float dia = llList2Float(data, 2);
            gRADIUS = dia/2;
            llOwnerSay("Sphere located at " + (string)  gSphereLocation); 
            Home = llGetPos();   
            return TRUE ;                                                     
        }
}
return FALSE;
}

default
{
    
    on_rez(integer p)
    {
        llResetScript();
    }

    state_entry()
    {
     
        
        ANIMATION = llGetInventoryName(INVENTORY_ANIMATION,0);  // get the first animation we can find
        
        llSetAlpha(1,ALL_SIDES);    // visible
        llSetText(Text,<1,1,1>,1);  // set hover text
        
        // sitting
        vector rot = <0,90,180>;  // 0, 90, 180 for avatar position
        rotation sitrot = llEuler2Rot(rot * DEG_TO_RAD);
        llSitTarget(<0,0,0.01>,sitrot);        

        // position
        vector arot = <270,0,270>;  // 0, 90, 180 for avatar position
        sphereRot = llEuler2Rot(arot * DEG_TO_RAD);
        llSetRot(sphereRot);
                        
        spin();
        
        // listen for world position and size
        llListen(To_Pose_CHANNEL, "", "", "");
        llRegionSay(To_Planet_CHANNEL, "PING");

        // camera
        llSetCameraEyeOffset(<-4, 0, 3> * sitrot);
        llSetCameraAtOffset(<2, 0, 1> * sitrot);
    }


    listen(integer channel, string name, key id, string message)
    {
        if(Fetch(id,message))
            state running;    
    }


}

state running
{
    state_entry()
    {   
        gOrient = ZERO_ROTATION;
        Home = llGetPos();        
        llListen(To_Pose_CHANNEL, "", "", "");
    } 

    listen(integer channel, string name, key id, string message)
    {
        Fetch(id,message);
    }
    
    changed(integer change) 
    {
        if (change & CHANGED_LINK) 
        {
            avatar = llAvatarOnSitTarget();
            if(avatar != NULL_KEY){
                
                if (gSphereLocation == <0,0,0>) {
                    llOwnerSay("World not located yet, please click the sphere world and make sure it is within 100 meters");
                    return;
                }
                
                //SOMEONE SAT DOWN
                avatarKey = avatar;
                llRequestPermissions(avatar,PERMISSION_TRIGGER_ANIMATION |PERMISSION_TAKE_CONTROLS);

            }else{
                //SOMEONE STOOD UP
                if (llGetPermissionsKey() != NULL_KEY)
                { 
                    llStopAnimation(ANIMATION); 
                }
                
                llSetTimerEvent(0);
                llSetText(Text,<1,1,1>,1);
                llSetAlpha(1,ALL_SIDES);
                warpPos(Home);               
                llSetRot(sphereRot);
                spin();
            }
        }
    }
    
    run_time_permissions(integer perm) 
    {
        if(perm & PERMISSION_TRIGGER_ANIMATION) 
        {
            
            vector height = llGetAgentSize(avatarKey);
            aRADIUS = gRADIUS  + height.z * 0.50 ;         // adjust for the agent size
            
             vector unitpos = llRot2Fwd( gOrient );
            vector pos = gSphereLocation + unitpos * aRADIUS;
            
            warpPos(pos);
            
            llStartAnimation(STAND);
            llStopAnimation("sit");
            
            llSetTimerEvent(.5);        // look for walking
            llSetText("",<1,0,0>,1);    // no text
            llSetAlpha(0,ALL_SIDES);    // invisible
            stopSpin();
        }
        if(PERMISSION_TAKE_CONTROLS & perm)
        {
            //llOwnerSay("Controls Ready");
            llTakeControls( CONTROL_FWD |
                            CONTROL_BACK |
                            CONTROL_ROT_LEFT |
                            CONTROL_ROT_RIGHT , TRUE, TRUE);
            controls = "U";
        }
    }

    timer()
    { 

        if(llStringLength(controls) == 0)      
        {
            llStartAnimation(STAND);
            llStopAnimation(WALK);  
            return;
        }

        //llOwnerSay(controls);
        controls = "";
        llStartAnimation(WALK);
        llStopAnimation(STAND);
        
        rotation delta = llEuler2Rot(<x,y,z> * DEG_TO_RAD);

        vector unitpos = llRot2Fwd( gOrient );
        vector pos = gSphereLocation + unitpos * aRADIUS;
    
        //llOwnerSay((string) llVecDist(gSphereLocation,llGetPos()));
        
      // face_target(pos);
        
        //llLookAt( pos, 1.0, 0.1);
        
       // if (pos != priorpos)
       // {
       //     llOwnerSay("rotating");
       //     uSteppedLookAt(pos,2.0);
       //     priorpos = pos;
       // }
        llSetRot(gOrient);
        
        //llRezObject("Pointer",pos,<0,0,0>,gOrient,1);
        //llOwnerSay("Pos:" + ( string) pos);
        
        llSetPos(pos);

        gOrient = gOrient * delta;
    }
    

    control(key driver, integer levels, integer edge)
    {
        
       // integer start = levels & edge;
       // integer end = ~levels & edge;
       // integer held = levels & ~edge;
        //integer untouched = ~(levels | edge);
        //llOwnerSay(llList2CSV([levels, edge, start, end, held, untouched]));
        
        //z = L/R
        //y = U/d
        x = 0;
        y = 0;
        z = 0;
        
        float bump = 10;
        
        if (levels & CONTROL_FWD)
        {
            y = -bump;
            controls = "U";
        }
        if (levels & CONTROL_BACK)
        {
            y = bump;
            controls = "D";
        }
        if (levels & CONTROL_ROT_LEFT)
        {
            z = bump ;  
            controls = "L";          
        }
        if (levels & CONTROL_ROT_RIGHT)
        {
           z = -bump;
           controls = "R";
        }
        


        
    }

    on_rez(integer p)
    {
        llResetScript();
    }


}



