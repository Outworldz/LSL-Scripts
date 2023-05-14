// Smooth Swinging Door Script v1.0 by Tech Guy


// Configuration
string SwingDirection = ""; // Inward vs Outward
string SwingMessage = "I do not know which way to swing.\nPlease enter either Inward or Outward (Case-Sensitive) into my description, Thanks";

// Variables
float MoveTimer = 2.5;
vector test; // Input Vector to Convert to Rotation
rotation rot; // Rotation Amount to Move
integer TotalTouched = 0; // Amount of Times Touched

// Switches
integer IsOpen = FALSE;

// Configuration Values Placeholders
float DoorCloseTimeOut = 0;
key nrofnamesoncard;
integer nrofnames;
list names;
list keynameoncard;
string nameoncard;
string storedname;

Initialize(){
    SwingDirection = llGetObjectDesc();
    if(SwingDirection==""){
        llOwnerSay(SwingMessage);
    }else if(SwingDirection=="Inward"){ 
        test.x = 0;
        test.y = 0;
        test.z = 0.5 * PI;
    }else if(SwingDirection=="Outward"){
        test.x = 0;
        test.y = 0;
        test.z = -0.5 * PI;
    }else{
        llOwnerSay(SwingMessage);
    }
    llOwnerSay("Startup state reading whitelist notecard");
    nrofnamesoncard = llGetNumberOfNotecardLines("whitelist");
}

OpenDoor(){
    rot = llEuler2Rot(test);
    llSetKeyframedMotion([rot, 2.5],[KFM_DATA, KFM_ROTATION, KFM_MODE, KFM_FORWARD]);
}

CloseDoor(){
    rot = llEuler2Rot(test);
    llSetKeyframedMotion([rot, 2.5],[KFM_DATA, KFM_ROTATION, KFM_MODE, KFM_REVERSE]);
}

default{
    
    on_rez(integer params){
        llResetScript();
    }
 
    state_entry(){
        Initialize();
    }
    
    touch(integer num){
        TotalTouched = TotalTouched + num;
        if(TotalTouched>1){
            return;
        }else if(llList2String(names, 0)!="" && llListFindList(names, [llDetectedName(0)])==-1){
            llSay(0, "You are not allowed in!");
        }else{
            if(IsOpen){
                llSetTimerEvent(0);
                CloseDoor();
            }else{
                OpenDoor();
                llSetTimerEvent(DoorCloseTimeOut);
            }
            IsOpen = !IsOpen;
        }
    }
    
    touch_end(integer num){
        TotalTouched = 0;
    }
    
    timer(){
        llSetTimerEvent(0);
        IsOpen = FALSE;
        CloseDoor();
    }
    
    dataserver (key queryid, string data){
        
        if (queryid == nrofnamesoncard) 
        {
            nrofnames = (integer) data;
            integer i;
            for (i=0;i < nrofnames;i++){
               keynameoncard += llGetNotecardLine("whitelist", i);
            }    
        } else 
        {
            integer listlength;
            listlength = llGetListLength(keynameoncard);
            integer j;
            for(j=0;j<listlength;j++) {
                if (queryid == (key) llList2String(keynameoncard,j))
                {
                    if(data!=""){
                        llOwnerSay("Name added to whitelist: "+data);
                        names += data;
                    }else{
                        llOwnerSay("Security Turned Off.");
                    }
                }
            }
        }
    }
    
    changed(integer change){
        if(change & CHANGED_INVENTORY){
            llResetScript();
        }
    }
    
}