// Rideable Elevator Engine v1.0
// Created by Tech Guy (Island Oasis) 2014

// CONFIGURATION AREA
list floorlist = [1, 23.71295, 30.63740, 38.13171, 45.60405, 53.14041, 60.63789, 68.13129, 75.63333, 83.11023, 90.61882, 98.16618, 105.64812, 113.15546, 120.65170, 128.13916, 135.65147  ]; // List of Floor Z-Vectors associated with floors
list seats = [25,26,27,28,29,30]; // Seat Link Numbers

key MainComputer = "a50c545c-2472-4e8c-a82d-6fbb7598c418";

integer currentfloor = 1; // Stores Current Floor Number (Starts with it being on Floor 1)
integer dest_floor; // Holds Destination Floor
vector currentPos; // Stored Current Position of Car
vector destPos; // Stores Destination Vector
integer MainListener; // Main Listener Handle
float sitTimer = 1.0; // Timer Event Loop Freqency
integer sitCounter; // Sit Counter Down Integer->String
string runstate = "ready"; // Stores Running State of Elevator (ready vs preparing vs moving)
float SpeedT = 5.0; // Travel Speed (Multipled by Travel Distance to get Key Framed Animation Time)
float travelTime; // Will Contain Travel Time for Requested Floor Call
string direction; // Hold Direction Indicator String
vector nextfloor; // Hold Vector of Next Floor
float DiM; // Travel Distance in Meters
integer JR = TRUE; // J

SetSitTargets(){ // Sets Set Targets on 
    integer ListLength = llGetListLength(seats);
    integer i;
    while (i < ListLength){
        llLinkSitTarget(llList2Integer(seats,i),<0.0,0.0,1.0>, ZERO_ROTATION);
        ++i;
    }
}

OpenDoors(){
    llWhisper(420, currentfloor+"O");
    llMessageLinked(LINK_SET, 0, "OFF", NULL_KEY);
    llWhisper(420, "OFF");
}

default
{
    state_entry()
    { 
        
        llListenRemove(MainListener);
        llSetMemoryLimit(0x4000);
        SetSitTargets();
        llOwnerSay("Ready...");
        MainListener = llListen(604, "", "", "" );
    }
    
     on_rez(integer num)
    {
        llResetScript();
    }

    listen(integer number, string name, key id, string message)
    {
        if(message!=""){
            if((integer)message<currentfloor){ // If Destination Floor is Lower than Current Floor
                llOwnerSay("Going to Floor"+message);
                dest_floor = (integer)message;
                integer travel_distance = currentfloor - (integer)message; // Number of Floors to Travel
                travelTime = travel_distance * SpeedT; // TravelTime
                DiM = llList2Float(floorlist, currentfloor) - llList2Float(floorlist, (integer)message); // Determine Distance in Meters
                DiM = DiM * -1;
                destPos = llGetPos();
                destPos.z = llList2Float(floorlist, dest_floor);
                nextfloor = llGetPos();
                nextfloor.z = llList2Float(floorlist, currentfloor-1);
                llOwnerSay("Next Floor: "+(string)nextfloor.z);
                state movedown;
            }else if((integer)message>currentfloor){ // If Destination Floor is Higher than Current Floor
                llOwnerSay("Going to Floor"+message);
                dest_floor = (integer)message;
                integer travel_distance = (integer)message - currentfloor; // Number of Floors to Travel
                travelTime = travel_distance * SpeedT; // TravelTime
                DiM = llList2Float(floorlist, (integer)message) - llList2Float(floorlist, currentfloor); // Travel Distance in Meters
                destPos = llGetPos();
                destPos.z = llList2Float(floorlist, dest_floor);
                nextfloor = llGetPos();
                nextfloor.z = llList2Float(floorlist, currentfloor+1);
                llOwnerSay("Next Floor: "+(string)nextfloor.z);
                state moveup;
            }else{
                OpenDoors();
            }
        }
    }
}

state moveup{
    state_entry(){
        llListenRemove(MainListener);
        llSetStatus(STATUS_ROTATE_X| STATUS_ROTATE_Y| STATUS_ROTATE_Z, FALSE); // Restrict Rotation
        sitCounter = 3;
        integer numSeconds = (integer)sitTimer * sitCounter;
        llSay(0,"You have "+(string)numSeconds+" seconds to sit down or be left behind. Thank You.\n Going to Floor");
        runstate = "preparing";
        llSetTimerEvent(sitTimer);
    }
    
    timer(){
        if(runstate=="preparing"){
            if(sitCounter!=0){
                llSay(0,sitCounter+" second remaining...");
                sitCounter = sitCounter - 1;
            }
            if(sitCounter==0){
                llSay(0,"Going to Floor "+(string)destPos.z);
                llSetKeyframedMotion(
                    [<0.0,0.0,DiM>, travelTime],
                [KFM_DATA, KFM_TRANSLATION, KFM_MODE, KFM_FORWARD]);
                runstate = "moving";
                llSetTimerEvent(0.25);
            }
        }
        if(runstate=="moving"){
            currentPos = llGetPos();
            if(llRound(currentPos.z)==llRound(destPos.z)){
                currentfloor = dest_floor;
                OpenDoors();
                state default;
            }
            if(llRound(currentPos.z)==llRound(nextfloor.z)){
                currentfloor = currentfloor + 1;
                nextfloor.z = llList2Float(floorlist, currentfloor+1);
                llRegionSayTo(MainComputer, 421, (string)currentfloor);
            }
        }
        
    }
}

state movedown{
    state_entry(){
        llListenRemove(MainListener);
        llSetStatus(STATUS_ROTATE_X| STATUS_ROTATE_Y| STATUS_ROTATE_Z, FALSE); // Restrict Rotation
        sitCounter = 3;
        integer numSeconds = (integer)sitTimer * sitCounter;
        llSay(0,"You have "+(string)numSeconds+" seconds to sit down or be left behind. Thank You.\n Going to Floor");
        runstate = "preparing";
        llSetTimerEvent(sitTimer);
    }
    
    timer(){
        if(runstate=="preparing"){
            if(sitCounter!=0){
                llSay(0,sitCounter+" second remaining...");
                sitCounter = sitCounter - 1;
            }
            if(sitCounter==0){
                llSay(0,"Going to Floor "+(string)destPos.z);
                llSetKeyframedMotion(
                    [<0.0,0.0,DiM>, travelTime],
                [KFM_DATA, KFM_TRANSLATION, KFM_MODE, KFM_FORWARD]);
                runstate = "moving";
                llSetTimerEvent(1.0);
            }
        }
        if(runstate=="moving"){
            currentPos = llGetPos();
            if(llRound(currentPos.z)==llRound(destPos.z)){
                llSay(420, (currentfloor-1)+"O");
                llMessageLinked(LINK_SET, 0, "OFF", NULL_KEY);
                llSay(420, "OFF");
                currentfloor = dest_floor;
                state default;
            }
            if(llRound(currentPos.z)==llRound(nextfloor.z)){
                currentfloor = currentfloor - 1;
                nextfloor.z = llList2Float(floorlist, currentfloor-1);
                llRegionSayTo(MainComputer, 421, (string)currentfloor);
            }
        }
        
    }
}