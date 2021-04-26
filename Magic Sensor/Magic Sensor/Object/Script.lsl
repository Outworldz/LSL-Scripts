// :CATEGORY:Sensor
// :NAME:Mafic Sensor
// :AUTHOR:CyberGlo Cyberstar
// :REV:1.0
// :WORLD:Second Life, Opensim
// :DESCRIPTION:
// Finds various scripted, unscripted and other objects and marks them, much like the More-Beacons menu
// :CODE:

vector offset = < 2, 0, 1.25>;  
vector pos;
vector vecNewPos;

key gKyOID;
key gKySensedObject;
key gKyOrb;

float fltDistApart;

list lstObjectNameList;
list lstObjectKeyList;

string strDisplayString;
string strObjectPos;
string strButtonResponse;

integer gListener;
integer gListener2;
integer intSearchState;
integer gIntTimedCount;
integer gIntSearchIndex;

fnWarpPos(vector pos)
{
 	llSetRegionPos(pos);
}


fnBeamParticles(key gKySensedObject)
{
        llParticleSystem([ PSYS_PART_FLAGS, 0 | PSYS_PART_EMISSIVE_MASK | 
         PSYS_PART_INTERP_COLOR_MASK | PSYS_PART_INTERP_SCALE_MASK | 
         PSYS_PART_FOLLOW_SRC_MASK | PSYS_PART_FOLLOW_VELOCITY_MASK |PSYS_PART_TARGET_POS_MASK ,
         PSYS_SRC_PATTERN,PSYS_SRC_PATTERN_EXPLODE,
         PSYS_PART_MAX_AGE, 1.0,
         PSYS_PART_START_COLOR,<1,0,0>,
         PSYS_PART_END_COLOR,<1,0,0>,
         PSYS_PART_START_SCALE,<0.1, 0.4, 0.1>,
         PSYS_PART_END_SCALE,<0.1, 0.2, 0.1>,
         PSYS_PART_START_GLOW, 0.3,
         PSYS_SRC_BURST_RATE,0.01,
         PSYS_SRC_ACCEL,<0.0, 0.0, 0.0>,
         PSYS_SRC_BURST_PART_COUNT,1,
         PSYS_SRC_BURST_RADIUS,0.03,
         PSYS_SRC_BURST_SPEED_MIN,0.10,
         PSYS_SRC_BURST_SPEED_MAX,0.50,
         PSYS_SRC_TARGET_KEY,gKySensedObject,
         PSYS_SRC_INNERANGLE,1.55,
         PSYS_SRC_OUTERANGLE,1.54,
         PSYS_SRC_OMEGA,<0.0, 0.0, 5.0>,
         PSYS_SRC_MAX_AGE,0.00,
         PSYS_PART_START_ALPHA,0.50,
         PSYS_PART_END_ALPHA,0.10
         ]);   
}

updateParticles()
{
    key gKySensor;
    llParticleSystem([  PSYS_PART_MAX_AGE,2,
                        PSYS_PART_FLAGS,PSYS_PART_EMISSIVE_MASK|PSYS_PART_INTERP_SCALE_MASK|PSYS_PART_TARGET_POS_MASK ,
                        PSYS_SRC_TARGET_KEY,gKyOrb,
                        PSYS_PART_START_COLOR,<1,0,0> ,
                        PSYS_PART_END_COLOR, <1,0,0>,
                        PSYS_PART_START_SCALE,<.125,.125,FALSE>,
                        PSYS_PART_END_SCALE,<.01,.01,FALSE>, 
                        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
                        PSYS_SRC_BURST_RATE,.02,
                        PSYS_SRC_ACCEL, <0,0,0>,
                        PSYS_SRC_BURST_PART_COUNT,1,
                        PSYS_SRC_BURST_RADIUS,.0,
                        PSYS_SRC_BURST_SPEED_MIN,.25,
                        PSYS_SRC_BURST_SPEED_MAX,.25,                       
                        PSYS_SRC_ANGLE_BEGIN,(float).5*PI,
                        PSYS_SRC_ANGLE_END,(float).5*PI,                       
                        PSYS_SRC_OMEGA, <0,0,1.0>,
                        PSYS_SRC_MAX_AGE, 0,
                        PSYS_SRC_TEXTURE, "smoke1",
                        PSYS_PART_START_ALPHA, 1,
                        PSYS_PART_END_ALPHA, 1
                            ]);
}
 
default
{
    on_rez(integer parm)
    {
        llResetScript();
    }
    state_entry()
    {
       // llSetPrimitiveParams([PRIM_TYPE,PRIM_TYPE_SPHERE,PRIM_SIZE,<0.2,0.2,0.2>,PRIM_PHYSICS,1,PRIM_FULLBRIGHT,1,PRIM_POINT_LIGHT,1,<1,0,0>,1,10,5,PRIM_GLOW,0.3,PRIM_TEXTURE,0,"CLOUDS",<1,1,1>,<1,1,1>,0.0]);
        updateParticles();
        llSetStatus(STATUS_PHYSICS, TRUE);
        llSleep(0.1);
        llSetTimerEvent(0.5);
        gKyOID=llGetOwner();
        gKyOrb = llGetKey();
    }
    
    touch_start(integer c)
    {
        llListenRemove(gListener);
        llListenRemove(gListener2);
        gListener = llListen(-99, "", gKyOID, "");
        llDialog(gKyOID, "\nPlease select Scan Type:", ["Active", "Passive", "Scripted","Legacy", "Display","Select", "Beam Off" ] , -99);
        llSensorRepeat("", "", intSearchState, 30, PI, 2);
        //CAN BE ACTIVE,PASSIVE,SCRIPTED,AGENT
    }
    
    listen(integer chan, string name, key id, string msg)
    {
        lstObjectNameList = llList2List(lstObjectNameList,0,11);
        if (chan == -99)
        {
            if (msg == "Active")
            {
                intSearchState=2;
                llSensorRepeat("", "", intSearchState, 30, PI, 2);
            }
            if (msg == "Passive")
            {
                intSearchState=4;
                 llSensorRepeat("", "", intSearchState, 30, PI, 2);
            }
            if (msg == "Legacy")
            {
                intSearchState=1;
                 llSensorRepeat("", "", intSearchState, 30, PI, 2);
            }
            if (msg == "Display")
            {
                intSearchState =10;
                 llSensorRepeat("", "", intSearchState, 30, PI, 2);
            }
            if (msg == "Scripted")
            {   
                intSearchState =8;
                 llSensorRepeat("", "", intSearchState, 30, PI, 2);
            }
            if (msg == "Select")
            {
                
            llDialog(gKyOID, "\nPlease select Object:", lstObjectNameList , -98);
            gListener2 = llListen(-98, "", gKyOID, "");
            }
            if (msg == "Beam Off")
            {
                updateParticles();
            
            }
        } 
        if (chan == -98)
        {
            gIntSearchIndex = llListFindList(lstObjectNameList,msg);
            gKySensedObject = llList2Key(lstObjectKeyList,gIntSearchIndex);  
            fnBeamParticles(gKySensedObject);             
        }
     }
    sensor(integer number_detected)
    {
        strDisplayString = "";
        lstObjectNameList = [];
        lstObjectKeyList = [];
        integer intObjectNumber;
        for (; intObjectNumber < number_detected; intObjectNumber++)
        {
            string  strObjectName = llDetectedName(intObjectNumber);
            key     gKySensedObject  = llDetectedKey(intObjectNumber);
            if (intObjectNumber< 12)
            {
                if (llListFindList(lstObjectNameList, [strObjectName]) == -1)
                {
                    lstObjectNameList =(lstObjectNameList=[])+lstObjectNameList+[strObjectName]; 
                    lstObjectKeyList = (lstObjectKeyList=[])+lstObjectKeyList+[gKySensedObject];
                    // llOwnerSay(strObjectName);
               
                    list lstObjectNow = llGetObjectDetails(gKySensedObject, OBJECT_POS);
                    vector vecObjectNow = llList2Vector (lstObjectNow,0);
                    integer intVecX = (integer)vecObjectNow.x;
                    integer intVecY = (integer)vecObjectNow.y;
                    integer intVecZ = (integer)vecObjectNow.z;
                    string strObjPosVec = "<"+(string)intVecX+" "+(string)intVecY+ " " + (string)intVecZ+">";
                    strObjectPos = strObjPosVec;
                    strDisplayString = strDisplayString +strObjectName + " \n";
                    strObjectPos = "";
                 //lstObjectNameList = [];   
                 //lstObjectKeyList = [];
                 }
            }
        }
        llSetText(strDisplayString,<1,1,1>,1.0);
        //strDisplayString = "";
        //lstObjectNameList = [];
    }
    changed(integer c)
    {
        if (c & CHANGED_OWNER)
        {
            llResetScript();
        }
    }
    
    timer()
    {
      //  gIntTimedCount++;
      //  if (gIntTimedCount == 1)
       // {
       //     lstObjectNameList=[];
       //     lstObjectKeyList=[];
       //     strDisplayString="";
       //     gIntTimedCount = 0;
       // }
        if (llGetAgentSize(gKyOID) == ZERO_VECTOR)
        {
            pos = <128,128,25>;
            llMoveToTarget(pos,0.4);
        }
        else
        {
            list det = llGetObjectDetails(gKyOID,[OBJECT_POS,OBJECT_ROT]);
            pos   = llList2Vector(det,0);
            vecNewPos = llGetPos();
            fltDistApart =llVecDist(pos,vecNewPos);
            if (fltDistApart > 8)
            { 
                llSetText((string)fltDistApart, <1,1,1>,1.0);
                pos += <2,0,1>;
                fnWarpPos(pos);
                
                llSetText("",<0.1,0.1,0.1>,0.1);            
            }
            rotation rot = (rotation)llList2String(det,1);
            vector worldOffset = offset;
            vector avOffset = offset * rot;
            pos += avOffset;
            if (pos.x < 0 ) { pos.x =1; }
            if (pos.x > 256 ) { pos.x = 256;}
            if (pos.y < 0 ) { pos.y = 1;}
            if (pos.y > 256 ) { pos.y = 256; }
            llMoveToTarget(pos,0.4);
        } 
    }
}