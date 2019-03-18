// :SHOW:1
// :CATEGORY:Tour
// :NAME:OpenSim Tour Car
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2014-09-07 10:50:19
// :EDITED:2015-05-29  11:26:03
// :ID:1040
// :NUM:1626
// :REV:2
// :WORLD:Opensim or Secondlife
// :DESCRIPTION:
// Tour car prim for Opensim
// :CODE:


integer _debug = 0;

integer REZ = 3454; // shouts Rex on this channel so a rezzer can produce another car, as this one will die
float INTERVAL = 0.5; // How often to check for progress
float TOLERANCE = 2;   // how close to the destination we have to get 
float SPEED = 5.0; // speed of vehicle 
integer DieAtEnd = FALSE;  // set to FALSE for endless loop, ser to TRUE to poof

vector TARGET = <0.0, -0.6,0.6>;  // sit position on the root prim. Set this to <0,0,0> if you want to not to be able to sit on the base
vector ROT = <0, 0, 180>;       // and the rotation, if they sit

list lCoordinate;
list lRotation ;
list lText;

// notecard reading
integer iIndexLines; 
integer i;
string NOTECARD = "Route";        // the notecard for configuring

key kNoteCardLines;        // the key of the notecard
key kGetIndexLines;        // the key of the current line

integer count = 0;
vector startPos; 
rotation startRot;  

vector TargetLocation;
rotation TargetRotation;

 
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
            
        llSetCameraEyeOffset(<2, 5, 2> );
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
    
                    if (_debug) llOwnerSay((string)TempLocation);
    
                    lCoordinate += [TempLocation];
                    lRotation +=  [Rot];
                    lText += [text];
                    
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
        startPos = TargetLocation;
        startRot= TargetRotation;
        llSetRegionPos(TargetLocation);
        llSetRot(TargetRotation);     
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
            llSay(0,"Please stay seated. Waiting 10 seconds for a passenger");
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
        if (change & CHANGED_LINK) 
         { 
            key av = llAvatarOnSitTarget();
            //llWhisper(0,"Sit by " + (string) av);
            if (av) //evaluated as true if not NULL_KEY or invalid
            {       
                llSay(0,"Please stay seated. Waiting 10 seconds for a passenger");
                 llSleep(10.0);
                
                llShout(REZ,"rez");

                state moving;
            } else {
                state end;
            }
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
            if (av) //evaluated as true if not NULL_KEY or invalid
            {       
                //tate moving;
            }
            else
            {
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
            } else {
                TargetLocation = llList2Vector(lCoordinate, count);  // Look at nth
                TargetRotation = llList2Rot(lRotation, count);  // Look at nth
                string SpeakThis =  llList2String(lText, count); 
        
                if (llStringLength(SpeakThis))
                    llSay(0,SpeakThis);
                
                Goto();
                 
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
        if (av) {//evaluated as true if not NULL_KEY or invalid
            llWhisper(0, llKey2Name(av) +", please go into the hotel and check in.");
            llUnSit(av);
        }
        llMessageLinked(LINK_SET,0,"unsit","");
        llSetTimerEvent(5);
    }
    
    on_rez(integer param)
    {
        llResetScript();
    }

    timer() 
    {
         llSetTimerEvent(0);        
         state Paused;
    }
    
    
     state_exit()
    {
        TargetLocation = startPos;
        TargetRotation = startRot;
        llSetRegionPos(startPos);
        llSetRot(TargetRotation);
        count = 0;
    }     
    
}
