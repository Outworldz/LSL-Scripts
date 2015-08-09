// :SHOW:1
// :CATEGORY:Flying Bee 
// :NAME:Flying Bee and Hive
// :AUTHOR:Ferd Frederix 
// :KEYWORDS:
// :CREATED:2013-09-08 12:59:45 
// :EDITED:2015-03-17  09:26:22
// :ID:995
// :NUM:1725
// :REV:4
// :WORLD:Opensim, SecondLife
// :DESCRIPTION:
// A free flying bee that gathers pollen and takes it to his hive for either OpenSim or Second Life
// :CODE:
// Simple Bee script to locate and gather pollen from all prims named "Flower" then returns to the "Beehive" 
// Requires 2 sounds buzz1 and buzz2
// !!!!!!!!!!!!!!
// Mods by Donjr Spiegelblatt for Opensim to remove chance of thread locking on 3/7/2015
// Thank YOU very much, DonJr !
// 03-17-2015 fixed up a problem reported by DonJr where the bees visited to flowers in the wrong sequence.

// Note: For Opensim, make sure to set the prim to PHYSICS type = NONE manually

// Tunable items

integer debug = FALSE;    // enablefor chattiness
integer PHYSICAL = TRUE;  // for smooth movemenents enable physical.
                          // For less lag, set this to false, but the motion willl be very quick and jerky.

string FLOWER_NAME = "Flower";   // the name of the thing we seek 
string HIVE_NAME = "Beehive";
float DIST = 15.0;                // gow far to fly, max
float SPEED = 1;                  // move in this number of seconds from place to place

// code bits
vector vInitROT = <90,0,0> ;       // due to the sculpted body, this bee gets rotated 90 degrees.
vector vFlowerOffset = <0,.10,0.1>;// due to the rotation on the sculpted body, this is back and up a bit.
vector vHiveOffset = <0,.5,0>; 
rotation r90;                      //  a calculated 90 degree rotation ends up here
integer iCount = 0;                // hive counter
string sLocatedName;               // located name of item
list lGlist;                       //  This is used as a first in first out stack with 2 entries per element 

DEBUG(string str)
{
    if (debug) llOwnerSay(llGetScriptName() + ":" + str);
}


// pop the top entry off the stack 
poplGlist() { 
   lGlist = llDeleteSubList(lGlist,0,1); 
} 

//  Get the top Position 
vector Gpos() { 
   return llList2Vector(lGlist,0); 
} 

//  Get the top Rotation 
rotation Grot() { 
   return llList2Rot(lGlist,1); 
} 

SetRotPos(rotation rot, vector dest)
{
    DEBUG("moveto:" + (string) dest);
    if (PHYSICAL) {
        llMoveToTarget(dest,SPEED);
        llLookAt(dest+ <1,0,0>,SPEED,1);    //  0.1 is a good compromise for SPEED > 1
    } else {
        llSetRegionPos(dest);
        llSetRot(rot);
    }
}

default
{ 
    state_entry()
    {       
        sLocatedName = "";
        llSetLinkPrimitiveParamsFast(LINK_ALL_CHILDREN, [PRIM_PHYSICS_SHAPE_TYPE, PRIM_PHYSICS_SHAPE_NONE]);
        // set rotation for this sculpted bee - remove this if yiou use a base prim
         vector new = vInitROT * DEG_TO_RAD; 
        r90 = llEuler2Rot(new);
        
        llSetTimerEvent(.1); // let's go!
        
        if (PHYSICAL)
            llSetStatus(STATUS_PHYSICS,TRUE);
        else
            llSetStatus(STATUS_PHYSICS,FALSE);          
    } 

    on_rez(integer p) 
    { 
        llResetScript();
    } 

    timer() 
    { 
        llSetTimerEvent(0); 
        if (sLocatedName == FLOWER_NAME) 
        { 
            if ( lGlist != [] ) 
            { 
                llPlaySound("buzz1",1.0); 

                SetRotPos(Grot() * r90 , Gpos() + vFlowerOffset);  // orient to it 
                llSetTimerEvent(4); 
                poplGlist();                     // pop the top entry off the stack 
            } 
            else 
            { 
                DEBUG("Look for Hive");
                llSensor(HIVE_NAME,NULL_KEY,ACTIVE|PASSIVE,DIST,PI); // Hive can be scripted, or not
            } 
        } 
        else if (sLocatedName == HIVE_NAME) 
        { 
            if ( iCount == 0 ) 
            { 
                SetRotPos(llGetRot(), Gpos());    // move in 
                llSetTimerEvent(10); 
            } 
            else if ( iCount == 1 ) 
            { 
                llSetTimerEvent(2);
                SetRotPos(llGetRot(),Gpos() + vHiveOffset);     // move out 
            } 
            else {
                sLocatedName = "";     // fall into llSensor FLOWER_NAME 
                llSetTimerEvent(1);  // adjust pause here
            }
            iCount++; 
        } else {                // fixed here
                 // as you don't want to "fall" into here until after a 1 second pause 

            DEBUG("Look for Flower");
            llSensor(FLOWER_NAME, NULL_KEY, ACTIVE|PASSIVE, DIST,PI); // flowers can be scripted, or not
        }
    }


    sensor(integer numDetected) 
    { 
        DEBUG("detected:" + (string) numDetected); 
        sLocatedName = llDetectedName(0); 
        // Clear the stack and place the first entry on it 
        lGlist = [ llDetectedPos(0), llDetectedRot(0) ]; 
        if (sLocatedName == FLOWER_NAME) 
        { 
            // Append any additional Flowers entries onto the stack 
            integer i; 
            for (i = 1; i < numDetected; i++) 
            { 
                lGlist += [ llDetectedPos(i), llDetectedRot(i) ]; 
            } 
        } else { 
            iCount = 0; 
            llPlaySound("buzz1",1.0); 
            // start moving towards the Hive 
            SetRotPos(Grot()  * r90,Gpos() + vHiveOffset);    // orient to it        
        } 
        // next step is always timer event 
        llSetTimerEvent(1); 
    } 

    no_sensor() 
    { 
        sLocatedName = ""; 
        llSetTimerEvent(15); // try again
    }

    changed(integer change)
    {
        if (change & CHANGED_REGION_START)
            llResetScript();        
    }
} 
// end of code 