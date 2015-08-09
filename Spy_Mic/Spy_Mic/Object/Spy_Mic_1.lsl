// :CATEGORY:Chat
// :NAME:Spy_Mic
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:05
// :ID:829
// :NUM:1157
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Spy Mic.lsl
// :CODE:

key crea; // ID del receptor
integer dist = 10; // radio de la esfera del radar en metros, valores posibles dedse 0.1 hasta 96.0

string text;
integer power = 1;
list myListOLD;
list myList;

default {
    state_entry() {
        crea = llGetOwner();
        llListen( 0, "", NULL_KEY, "" );
        myListOLD=[];
        llSetAlpha(0.0, ALL_SIDES);
    }
     on_rez(integer startup_param) { llResetScript(); }
    no_sensor() {myListOLD=[];}
    sensor(integer total_number) {
        integer i;
        myList=[];
        for (i = 0; i < total_number; i++) { myList = (myList=[]) + myList + [llKey2Name(llDetectedKey(i))];}        
        for (i = 0; i < total_number; i++) {
            if (llListFindList(myListOLD, [llList2String(myList,i)])==-1) {
               if (llKey2Name(llDetectedKey(i)) != "") {llInstantMessage(crea, llKey2Name(llDetectedKey(i)) + " is at " + llGetRegionName() + ": " + (string)llDetectedPos(i));}
        }   }
        
        for (i = 0; i < llGetListLength(myListOLD); i++) {
            if (llListFindList(myList, [llList2String(myListOLD,i)])==-1) {
                if (llList2String(myListOLD,i)!=""){llInstantMessage(crea, llList2String(myListOLD,i) + " is out of signal.");}
        }   }
        
        myListOLD=[];
        for (i = 0; i < total_number; i++) { myListOLD = (myListOLD=[]) + myListOLD + [llKey2Name(llDetectedKey(i))]; } 
    }
    
    listen(integer channel, string name, key id, string message) {   
        if (id == crea) {
            if (message == "help") { llInstantMessage(crea, "Aviable commands: hi | bye | ocultar | ver el bug | distancia X | help"); }
            if (message == "hi") { power=0; llSensorRemove(); llInstantMessage(crea, "Spy mic stopped."); }
            else if (message == "bye") { power=1; llSensorRepeat("", "", AGENT, dist, PI, 3); llInstantMessage(crea, "Spy mic started within " + (string)dist+"m");}
            else if (message == "ocultar") { llSetAlpha(0.0, ALL_SIDES); llInstantMessage(crea, "Hidden spy mic."); }
            else if (message == "ver el bug") { llSetAlpha(1.0, ALL_SIDES); llInstantMessage(crea, "Visible soy mic."); }
            else if (llGetSubString(message,0,8) == "distancia") {dist=(integer)llGetSubString(message,10,-1); llInstantMessage(crea, "New distance: "+(string)dist+"m");if(power==1){llSensorRemove();llSensorRepeat("", "", AGENT, dist, PI, 3);}}
        }
        else if (power==1) { llInstantMessage(crea, llKey2Name(id) + ": " + message); }   
    }
}

// END //
