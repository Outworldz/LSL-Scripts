// :CATEGORY:Sphere World
// :NAME:Sphere_World__Walk_and_live_on_a_sphere
// :AUTHOR:Ferd Frederix
// :CREATED:2012-09-19 19:01:45.217
// :EDITED:2013-12-13 14:01:06
// :ID:824
// :NUM:1555
// :REV:1.1
// :WORLD:Second Life
// :DESCRIPTION:
// Pose ball - put this in  a small sphere and set it at ground level.
// When you click it, it will let you walk on your sphere world
// Also Add a walk animation named "walk"  to the prim, too
// Thanks to Shameena Short for reporting bugs!
// :CODE:

// walk on a moon pose ball
// Put this script into a pose ball and set it near your Sphere world.
//  This allows the person to actually welk on your world using the arrow ketys

// Requires there to be one Walk animation in the inventory of the pose ball.


integer debug = FALSE;
DEBUG(string msg)
{
    if (debug)
        llOwnerSay(llGetScriptName() + ":" + msg);
        
}

integer To_Pose_CHANNEL = 98798771;
integer To_Planet_CHANNEL = 65835861;

string Copyright = " (c) 2012 by Ferd Frederix";    // You cannot change this line. See License agreements above. Attribution is required, and these files are copyrighted. 

vector home_location;
vector destination;
integer rest;

 
//  walk on a sphere

rotation gOrient;

integer gCounter;

string ANIMATION;

key avatarKey;
float x ;
float y ;
float z ;
float gRADIUS;
float aRADIUS;


face_target(vector lookat) {
    rotation rot = llGetRot() * llRotBetween(<1.0 ,0.0 ,0.0 > * llGetRot(), lookat - llGetPos());

    llSetRot(rot);

    rot = llGetRot() * llRotBetween(<0.0 ,0.0 ,1.0 > * llGetRot(), home_location - llGetPos());
    llSetRot(rot);
}

key avatar;


vector Home;

default
{

    on_rez(integer p)
    {
        llResetScript();
    }

    state_entry()
    {

        Home = llGetPos();

        llSetAlpha(1,ALL_SIDES);
        llSetText("Walk on the moon",<1,1,1>,1);
        vector rot = <0,180,180>;
        rotation sitrot = llEuler2Rot(rot * DEG_TO_RAD);
        llSitTarget(<0,0,0.01>,sitrot);

        llListen(To_Pose_CHANNEL, "", "", "");
        llShout(To_Planet_CHANNEL, "PING_WORLD");
    }


    listen(integer channel, string name, key id, string message)
    {
        list data = llParseString2List(message, ["^"], []);
        
        DEBUG(llDumpList2String(data,","));
        
        if (llList2String(data, 0) == "SPHERE")
        {
            DEBUG("SPHERE");

            vector n_home_loc = (vector) llList2String(data, 1);
            vector my_loc = llGetPos();

            DEBUG("dist:" + (string)llVecDist(n_home_loc, my_loc) + " Home:" + (string)n_home_loc  + " Name:" + llList2String(data, 4));

            if (llGetOwnerKey(id) == llGetOwner()) 
            {
                home_location = n_home_loc;
                DEBUG("Home loc:" + (string) home_location);
            
                float dia = llList2Float(data, 2);

                if (llGetOwnerKey(id) == llGetOwner())
                {
                    gRADIUS = dia/2;

                    //home_location.y -= dia/2;

                    DEBUG("Home Radius:" + (string) gRADIUS);
                    
                    DEBUG("Orbit Set");
                
                    state running;
                }
            }
        }
    }
}


state running
{
    state_entry()
    {
        llOwnerSay("running");
        gOrient = ZERO_ROTATION;
        destination = <0,0,0>;
        vector current_loc = llGetPos();

        llListen(To_Planet_CHANNEL, "", "", "");
    }

    run_time_permissions(integer perm)
    {
        if(perm & PERMISSION_TRIGGER_ANIMATION)
        {
            vector height = llGetAgentSize(avatarKey);

            aRADIUS = gRADIUS  + height.z * .85 ;         // adjust for the agent size

            llStopAnimation("sit");
            llStartAnimation("walk");
            ANIMATION = "walk";
            llSetTimerEvent(.5);
            llSetText("",<1,0,0>,1);
            llSetAlpha(0,ALL_SIDES);
        }
    }




    changed(integer change)
    {
        if(change & CHANGED_LINK)
        {
            avatar = llAvatarOnSitTarget();
            if(avatar != NULL_KEY){
                //SOMEONE SAT DOWN
                avatarKey = avatar;
                llRequestPermissions(avatar,PERMISSION_TRIGGER_ANIMATION);

            }else{
                //SOMEONE STOOD UP
                if (llGetPermissionsKey() != NULL_KEY)
                {
                    llSetTimerEvent(0);
                    llStopAnimation(ANIMATION);
                    llSetText("Walk on the Moon",<1,1,1>,1);
                    llSetAlpha(1,ALL_SIDES);
                    llSetRegionPos(Home);
                }
            }
        }
    }



    timer()
    {
        if (rest)
        {
            //llSetText((string) rest,<1,0,0>,1);
            rest--;

            rotation delta = llEuler2Rot(<x,y,z> * DEG_TO_RAD);

            vector unitpos = llRot2Fwd( gOrient );
            vector pos = home_location + unitpos * aRADIUS;

            DEBUG((string) llVecDist(home_location,llGetPos()));

            gCounter++;
            face_target(pos);
            llSetRegionPos(pos);

            gOrient = gOrient * delta;

        }
        else
        {
            x = llFrand(5) + 5;
            y = llFrand(5) + 5;
            z = llFrand(5) + 5;

            if (llFrand(2) > 1)
                x = 1-x;
            if (llFrand(2) > 1)
                y = 1-z;
            if (llFrand(2) > 1)
                z = 1-z;

            rest = (integer)llFrand(12.0) + 1;

        }

    }



}



