// :SHOW:
// :CATEGORY:Tour
// :NAME:OpenSim Tour Car
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2015-02-25 22:55:43
// :EDITED:2015-02-25  21:55:43
// :ID:1040
// :NUM:1722
// :REV:1
// :WORLD:Opensim or Secondlife// :DESCRIPTION:
// :DESCRIPTION:
// Opensim Tour Boat
// :CODE:
// Tour car prim for Opensim - can switch the vehicle while riding
// Put a unique name in the cars prims for each type.



integer _debug = 0;

integer REZ = 3454; // shouts Rex on this channel so a rezzer can produce another car, as this one will die
float INTERVAL = 0.5; // How often to check for progress
float TOLERANCE = 2;   // how close to the destination we have to get 
float SPEED = 8.0; // speed of vehicle 

vector TARGET = <0,0,0>; // sit position on the root prim. Ste this to <0,0,0> if you want to not to be able to sit on the base
vector ROT = <0,0,0>;   // and the rotation, if they sit

list lCoordinate;
list lRotation ;
list lText;
list lPrim;

// notecard reading
integer iIndexLines; 
integer i;
string NOTECARD = "Route";        // the notecard for configuring

key kNoteCardLines;        // the key of the notecard
key kGetIndexLines;        // the key of the current line

integer count = 0;
  
vector TargetLocation;
rotation TargetRotation;

Switch(string whichPrim)
{
    integer n = llGetNumberOfPrims();
    integer i;
    for ( i = 1; i < n; i++) {
        
        if (llGetLinkName(i) == whichPrim) {
            llSetLinkAlpha(i,1.0,ALL_SIDES);
        } else {
            llSetLinkAlpha(i,0,ALL_SIDES); // 0 = transparent
        }
    }
}

    
Goto()
{
    if (_debug) 
        llOwnerSay("Looking at Target Location = " + (string) TargetLocation);

    vector ownPosition = llGetPos();    
    float dist = llVecDist(ownPosition, TargetLocation);
    
    float rate = dist / SPEED;
        
    rotation ownRotation = llGetRot();
 
    llSetKeyframedMotion(
            [(TargetLocation - ownPosition) + <0.0, 0.0, -.5> * TargetRotation,
            NormRot(TargetRotation/ownRotation), rate],
            []);

             
}

rotation NormRot(rotation Q)
{
    float MagQ = llSqrt(Q.x*Q.x + Q.y*Q.y +Q.z*Q.z + Q.s*Q.s);
 
    return
        <Q.x/MagQ, Q.y/MagQ, Q.z/MagQ, Q.s/MagQ>;
}

integer locationLength;


string strip( string str)
{        
    string out;
    integer i;
    
    //llOwnerSay("str = " + str);
    
    for ( ; i < llStringLength(str); i++)
    {
        out += llGetSubString(str,i,i);

        out = llStringTrim(out, STRING_TRIM);
        //llOwnerSay("out = " + out + " at " + (string) i);
    }
    return out;

}

string Getline(list Input, integer line)
{
    return strip(llList2String(Input, line));
} 


default
{
    on_rez(integer param)
    {
        llResetScript();
    }
    
    changed( integer change )
    { 
        if (change & CHANGED_INVENTORY) 
        {    
            llResetScript();
        }
    }
    
    state_entry() 
    {
        
         llSetLinkPrimitiveParamsFast(LINK_ROOT,
                [PRIM_PHYSICS_SHAPE_TYPE, PRIM_PHYSICS_SHAPE_CONVEX,
            PRIM_LINK_TARGET, LINK_ALL_CHILDREN,
                PRIM_PHYSICS_SHAPE_TYPE, PRIM_PHYSICS_SHAPE_NONE]);
            
        llSetCameraEyeOffset(<0, 5, 0> );
        llSetCameraAtOffset(<0, 0, 1>);

        
        rotation rot     = llEuler2Rot(ROT * DEG_TO_RAD);     // convert the degrees to radians, then convert that vector into a rotation, rot30x 
        llSitTarget(TARGET, rot); // where they sit
    

        kNoteCardLines = llGetNumberOfNotecardLines(NOTECARD);
        kGetIndexLines = llGetNotecardLine(NOTECARD,0);

         llSay (0, "Tour guide initialising. Please wait.");
    }
    
     // read notecard on bootup
    dataserver(key queryid, string data)
    {

        vector TempLocation;
        if (queryid == kNoteCardLines)
        {
            iIndexLines = (integer) data;
        }

        if (queryid == kGetIndexLines)
        {
            if (data != EOF) 
            {
                queryid = llGetNotecardLine(NOTECARD, i);
                list lLine = (llParseString2List(data, ["|"], []));
                if (_debug )    llOwnerSay("Line = " + llDumpList2String(lLine,":"));

                TempLocation = (vector)  Getline(lLine,1); 
                if (TempLocation != ZERO_VECTOR)
                {
                    rotation Rot = (rotation) llList2String(lLine,2);
                    string text = llList2String(lLine,3);
                    string primName = llList2String(lLine,4);
    
                    if (_debug) llOwnerSay((string)TempLocation);
    
                    lCoordinate += [TempLocation];
                    lRotation +=  [Rot];
                    lText += [text];
                    lPrim += [primName];
                    
                    locationLength = (llGetListLength(lCoordinate));
                    integer     InitPerCent = (integer) llRound(((float) locationLength / (float) iIndexLines) * 100);
                    llSetText("Initialising... \n" + (string) InitPerCent + "%" , <1,1,1>, 1.0);
                    if (InitPerCent == 100)
                    {
                        state Paused;
                    }
                   
                } 
                else
                {
                    state Paused;
                }
                i++;
            }
            kGetIndexLines = llGetNotecardLine(NOTECARD,i);
            // (_debug ) llOwnerSay("Got " + (string) i);
        } 
    }
    
    
    state_exit()
    {
        llSetText("", <1,1,1>, 1.0);
        TargetLocation = llList2Vector(lCoordinate, 0);  // Look at 0th
        TargetRotation = llList2Rot(lRotation, 0);  // Look at 0th
        Goto();     
    }    
}


state Paused
{
    state_entry()
    {
        llSay(0,"Ready");
    }

    link_message(integer sender,integer num,string msg, key id)    
    {
        if (msg =="sit")
        {
            llWhisper(0,"Please stay seated. Waiting 10 seconds for a passenger");
               
            llSleep(10.0);
                
            llShout(REZ,"rez");
            state moving;
        }
    }

    on_rez(integer param)
    {
        llResetScript();
    }
    
    changed( integer change )
    { 
        if (change & CHANGED_INVENTORY) 
        {    
            llResetScript();
        }
    }
}

state moving
{

    state_entry()
    {
        
        if (_debug) llOwnerSay("State Moving entered, is pointing to target " + (string) TargetLocation );
         
        string SpeakThis =  llList2String(lText, count);
        
        if (llStringLength(SpeakThis))
            llSay(0,SpeakThis);
                  
        llSetTimerEvent(INTERVAL);
    }
    
    changed(integer change)
    {
         if (change & CHANGED_LINK) 
         { 
            key av = llAvatarOnSitTarget();
            //llWhisper(0,"Sit by " + (string) av);
            if (av == NULL_KEY) {
                state end;
            }
        }
        if (change & CHANGED_INVENTORY)
        {
            llResetScript();
        }
    }    
     
     
    on_rez(integer param)
    {
        llResetScript();
    }
        
    timer()   
    {
        
        if (llVecMag(llGetPos() - TargetLocation) <= TOLERANCE) {
            
            if (_debug) llOwnerSay("At location: " + (string) llGetPos());
            count ++;
             
            if (count >= locationLength) {   
            
                state end;
                
                if (_debug) llOwnerSay("Restart: " + (string) TargetLocation); 
                TargetLocation = llList2Vector(lCoordinate, 0);  // Look at 0th
                TargetRotation = llList2Rot(lRotation, 0);  // Look at 0th
                Goto();
                count = 0;
                
            } else {
                TargetLocation = llList2Vector(lCoordinate, count);  // Look at nth
                TargetRotation = llList2Rot(lRotation, count);  // Look at nth
                string SpeakThis =  llList2String(lText, count); 
        
                if (llStringLength(SpeakThis))
                    llSay(0,SpeakThis);

                // if the last param is a name, change any prim by that name to be visible, and any others to be invidible.
                string whichPrim  =  llList2String(lPrim, count);
                if (whichPrim)
                    Switch(whichPrim);
                
                Goto();
                if (_debug) llOwnerSay("New Target: " + (string) TargetLocation); 
            }
        }
             
    } 
 
    state_exit()
    {
        llSetTimerEvent(0);
    }
}


state end
{
    state_entry()
    {
        llMessageLinked(LINK_SET,0,"DOOR OPEN","");
       
        llSetTimerEvent(0);
       
        key av = llAvatarOnSitTarget();
        if (av != NULL_KEY) {   
            //llWhisper(0, llKey2Name(av) +", please go into the hotel and check in.");
            llUnSit(av);
        }
        llSetTimerEvent(60);
    }
    on_rez(integer param)
    {
        llResetScript();
    }
    timer() 
    {
         llDie();
    }
    
}
