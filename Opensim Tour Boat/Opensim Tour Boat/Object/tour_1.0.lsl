// :SHOW:
// :CATEGORY:Tour
// :NAME:Opensim Tour Boat
// :AUTHOR:thailow
// :KEYWORDS:
// :CREATED:2015-02-25 22:55:36
// :EDITED:2015-02-25  21:55:36
// :ID:1068
// :NUM:1721
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Opensim Tour Boat
// :CODE:
string  routeNCName = "route.config";
string  paramNCName = "param.config";

// -----------------------------------------------------
//  PARAMETRI
// -----------------------------------------------------
vector startPos = <0,0,0>; 
vector startRot = <0,0,0>;

float  vHoverH = 0.1;               // hover height del veicolo rispetto altezza acqua
vector vSpeed = <2,0,0>;            // spinta del motore  
vector vAxe   = <1,0,0>;            // orientamento (prua) del veicolo

float moveTimer = 0.3;

integer debugOn = 1; 

list    route = [];

// -----------------------------------------------------
//  READ VARIABLES
// -----------------------------------------------------
integer routeNCLine = 0;
key     routeNCKey;
integer paramNCLine = 0;
key     paramNCKey;

// -----------------------------------------------------
//  VARIABILI GLOBALI
// -----------------------------------------------------
float   zWater = 20; 
vector  xyTarget;
integer idTarget;
integer nTarget = 0;
integer nrTargets = 0;
integer runSts = 0;         // run status 
key     ownerKey;

// -----------------------------------------------------
//  MENU BOX
// -----------------------------------------------------
list    dlgCmd  = ["Start","Stop","Load_Route", "Load_Param"];
string  dlgInfo = "\nScegliere un comando";
integer dlgCh   = 5555;

// -----------------------------------------------------
//  sayDebug()
// -----------------------------------------------------
sayDebug(string msg) {
    if (debugOn == 1) llOwnerSay(msg);
}

// -----------------------------------------------------
//  Trim a string
// -----------------------------------------------------
string Trim(string s) {
  list t = llParseString2List(s, [" "], []);
  return  llDumpList2String(t, " ");
}

// -----------------------------------------------------
//  initVehicle  
//  from: OpenSim - Physical Boat Script v2.1
// -----------------------------------------------------
initVehicle() {
    // Vehicle Type
    llSetVehicleType(VEHICLE_TYPE_BOAT);                                         // in use
           
    // Type Vector ------------------------------------------------------   
    // friction
    llSetVehicleVectorParam(VEHICLE_ANGULAR_FRICTION_TIMESCALE, <1.0, 1.0, 1.0>);  // z in use
    llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <0.50, 0.50, 1.0>); // x,y in use
    // motor
    llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, <0, 0, 0>);         // in use
    llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <0, 0, 0>);          // in use
    llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_OFFSET, <0, 0, 0>);             // ???
           
    // Type Float -------------------------------------------------------           
    // hover
    vector posv = llGetPos();                      
    llSetVehicleFloatParam(VEHICLE_HOVER_HEIGHT, posv.z - zWater);         // in use
    llSetVehicleFloatParam(VEHICLE_HOVER_EFFICIENCY, 1.0);               // ???
    llSetVehicleFloatParam(VEHICLE_HOVER_TIMESCALE, 1.0);                // ???
    llSetVehicleFloatParam(VEHICLE_BUOYANCY, 1.0);                       // ???
    // friction
    llSetVehicleFloatParam(VEHICLE_ANGULAR_FRICTION_TIMESCALE, 1.0);     // ???
    // motor
    llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_TIMESCALE, 0.1);         // in use
    llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 50);   // in use
    llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_TIMESCALE, 0.1);        // in use
    llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, 1.0);  // in use
    //deflection
    llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 1.0);   // ???
    llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 1.0);    // ???
    llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 1.0);  // ???
    llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, 1.0);   // ???
    // attraction
    llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, 1.0); // ???
    llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 1.0);  // ???
    // banking
    llSetVehicleFloatParam(VEHICLE_BANKING_EFFICIENCY, 1.0);             // ???
    llSetVehicleFloatParam(VEHICLE_BANKING_MIX, 1.0);                    // ???
    llSetVehicleFloatParam(VEHICLE_BANKING_TIMESCALE, 1.0);              // ???    
}    

// -----------------------------------------------------
//  initRoute 
// -----------------------------------------------------
initRoute() {
    nTarget = 0;
    nrTargets = llGetListLength(route);
}

// -----------------------------------------------------
//  nextTarget 
// -----------------------------------------------------
nextTarget() {
    if (nTarget >= nrTargets) { stopTarget(); return; } 
    
    xyTarget = llList2Vector(route, nTarget++);
    xyTarget.z = startPos.z;                          
    idTarget = llTarget( xyTarget, 1.0 );    
    
    sayDebug("to target: "+ (string)xyTarget);
}                            

// -----------------------------------------------------
//  stopTarget 
// -----------------------------------------------------
stopTarget() {    
    sayDebug("end targetting...");
    runSts = 0;
    llSetTimerEvent((float)FALSE);               
    llSetStatus(STATUS_PHYSICS, FALSE);
    llSetLinkPrimitiveParams(LINK_ALL_OTHERS, [PRIM_PHYSICS, FALSE]);
    llSetVehicleType(VEHICLE_TYPE_NONE);
    llSleep(0.3);
    llSetRegionPos(startPos); 
    llSetRot(llEuler2Rot(startRot*DEG_TO_RAD));       
}

startTarget() {
    runSts = 1;
    initRoute();
    initVehicle();  
    llSleep(0.3);
    llSetStatus(STATUS_PHANTOM, FALSE);
    llSetLinkPrimitiveParams(LINK_ALL_OTHERS, [PRIM_PHANTOM,FALSE]);
    llSleep(0.3);
    llSetStatus(STATUS_PHYSICS, TRUE);
    llSetLinkPrimitiveParams(LINK_ALL_OTHERS, [PRIM_PHYSICS, TRUE]);
    llSleep(0.3);                          
    nextTarget();                     
    llSetTimerEvent(moveTimer);           
}                                                        

default {
    on_rez(integer start_param) { llResetScript(); }            
    
    state_entry() {        
        if (llGetListLength(route) < 1) { state routeread; return; }
        if (startPos == <0,0,0>) { state paramread; return; }   
                   
        runSts = 0; 
        llSetStatus(STATUS_PHANTOM, FALSE);
        llSetLinkPrimitiveParams(LINK_ALL_OTHERS, [PRIM_PHANTOM,FALSE]);
        llSetStatus(STATUS_PHYSICS, FALSE);
        llSetLinkPrimitiveParams(LINK_ALL_OTHERS, [PRIM_PHYSICS,FALSE]);
            
        zWater = llWater(<0,0,0>);            
        startPos.z = zWater + vHoverH; 
        
        llSetRegionPos(startPos);
        llSetRot(llEuler2Rot(startRot*DEG_TO_RAD));
              
        ownerKey = llGetOwner();
        llListen(dlgCh, "", ownerKey, ""); 
    }
    
    touch_end(integer pp) {
        key agent = llDetectedKey(0);        
        if(agent == ownerKey) {
            llDialog(agent, dlgInfo, dlgCmd, dlgCh);
            return;
        }    
        if (runSts == 0) startTarget();
    }

    listen(integer ch, string name, key id, string msg) {        
        sayDebug("command: " + msg );
        
        msg = llToLower(msg);        
        if ((msg == "start")&&(runSts==0)) { startTarget(); return; }
        if ((msg == "stop")&&(runSts==1)) { stopTarget(); return; }
        if (msg == "load_route") { state routeread; return; }
        if (msg == "load_param") { state paramread; return; }        
    }        
              
    timer()
    {
        if(runSts == 1) {    
            // spinta del motore
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, vSpeed);
                
            // direzione rispetto a quella corrente
            vector pos = llGetPos(); 
            llRotLookAt( 
                llRotBetween( <1.0,0.0,0.0>, llVecNorm( 
                    ((vector)<xyTarget.x, xyTarget.y, pos.z>) - pos)
                ), 
                1, 1 
            );  
        }
    } 
    
    at_target(integer tnum, vector targetpos, vector ourpos) {        
        if (tnum != idTarget) return;

        sayDebug("at target: "+ (string)ourpos);          
        llTargetRemove(tnum); 
        nextTarget();
    }                                    
}

// -----------------------------------------------------
//  READ ROUTE NOTECARD
// -----------------------------------------------------
state routeread {
  state_entry()  { 
            
    if(llGetInventoryType(routeNCName) != INVENTORY_NOTECARD) {
      sayDebug("missing inventory notecard: " + routeNCName);      
      return; 
    }  
        
    routeNCLine = 0;  
    route = [];                
    routeNCKey = llGetNotecardLine(routeNCName, routeNCLine);              
  }

  dataserver(key req_id, string data)  {        
    if(req_id != routeNCKey) return;
    
    if (data == EOF) {       
      sayDebug("end reading "+ (string)routeNCLine +" route lines");  
      state default; 
      return; 
    } 

    if(data != "") {
      if(llSubStringIndex(data, "#") != 0) { route += [(vector)data]; }
    }    
    routeNCKey = llGetNotecardLine(routeNCName, ++routeNCLine);        
  }        
}

// -----------------------------------------------------
//  READ PARAM NOTECARD
// -----------------------------------------------------
state paramread {
  state_entry()  { 
            
    if(llGetInventoryType(paramNCName) != INVENTORY_NOTECARD) {
      sayDebug("missing parameter notecard: " + paramNCName);      
      return; 
    }  
        
    paramNCLine = 0;      
    paramNCKey = llGetNotecardLine(paramNCName, paramNCLine);              
  }
  
  dataserver(key req_id, string data)  {        
    if(req_id != paramNCKey) return;
    
    if (data == EOF) { 
      if (startPos == <0,0,0>) {
        sayDebug("parameters missing");        
        return;
      }                
      sayDebug("end reading parameters");  
      state default; 
      return; 
    } 

    if(data != "") {      
      
      if(llSubStringIndex(data, "#") != 0) {
        integer i = llSubStringIndex(data, "=");        
        
        if(i != -1) {
          string name = llToLower(Trim(llGetSubString(data, 0, i - 1)));            
          string value = Trim(llGetSubString(data, i + 1, -1));      
          
          if (name == "startpos") startPos = (vector)value;    
          if (name == "startrot") startRot = (vector)value;          
          if (name == "hoverwater") vHoverH = (float)value;          
          if (name == "speed") vSpeed.x = (float)value;          
          if (name == "pushtime") moveTimer = (float)value;          
          if (name == "debug") debugOn = (integer)value;                    
        }
      }      
    }    
    paramNCKey = llGetNotecardLine(paramNCName, ++paramNCLine);        
  }        
}
