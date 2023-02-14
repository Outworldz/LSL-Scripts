key ActiveDancer = NULL_KEY;
string ActiveDance;
string PrevDance;
integer Random = FALSE; // Do we Dance Cycle?
string TimerMode;
string EMPTY = "";
list Dances;

Dancer(string CMD){
    if(CMD=="Start"){
        osAvatarStopAnimation(ActiveDancer, "stand");
        osAvatarPlayAnimation(ActiveDancer, ActiveDance);
    }else if(CMD=="Stop"){
        osAvatarStopAnimation(ActiveDancer, ActiveDance);
        osAvatarPlayAnimation(ActiveDancer, "stand");
        ActiveDancer = NULL_KEY;
        llSetScriptState(llGetScriptName(), FALSE);
    }else if(CMD=="Change"){
        osAvatarStopAnimation(ActiveDancer, PrevDance);
        osAvatarPlayAnimation(ActiveDancer, ActiveDance);
    }
}

integer GetDances(){
    integer i;
    for(i=0;i<llGetInventoryNumber(INVENTORY_ANIMATION);i++){
        Dances = Dances + [llGetInventoryName(INVENTORY_ANIMATION, i)];
    }
    integer DanceListLength = llGetListLength(Dances);
    return DanceListLength;
}

 
default{
    state_entry(){
        llResetScript();
        GetDances();
    }
    
    link_message(integer sendinglink, integer I, string msg, key id){
        list InputData = llParseString2List(msg, ["||"], []);
        string CMD = llList2String(InputData, 0);
        key UserKey = id;
        string PARAM = llList2String(InputData, 1);
        if(ActiveDancer==NULL_KEY){
            if(CMD=="START"){
                ActiveDance = PARAM; 
                ActiveDancer = UserKey;
                llRegionSayTo(id, 0, "Please Accept Animate Permissions...");
                llRequestPermissions(UserKey, PERMISSION_TRIGGER_ANIMATION);
                TimerMode = "Perms";
                llSetTimerEvent(30);
            }
        }else if(ActiveDancer==UserKey){
            if(CMD=="STOP"){
                Random = FALSE;
                llSetTimerEvent(0);
                Dancer("Stop");
            }else if(CMD=="CHANGE"){
                Random = FALSE;
                llSetTimerEvent(0);
                PrevDance = ActiveDance;
                ActiveDance = PARAM;
                Dancer("Change");
            }else if(CMD=="<<"){
                if(llGetListLength(Dances)==0){
                    if(GetDances()>=2){
                        integer DanceIndex = llListFindList(Dances, [ActiveDance]);
                        PrevDance = ActiveDance;
                        if(DanceIndex==0){
                            ActiveDance = llList2String(Dances, -1);
                        }else{
                            ActiveDance = llList2String(Dances, (DanceIndex - 1));
                        }
                        Dancer("Change");
                    }
                }
            }else if(CMD==">>"){
                if(llGetListLength(Dances)==0){
                    if(GetDances()>=2){
                        integer DanceIndex = llListFindList(Dances, [ActiveDance]);
                        PrevDance = ActiveDance;
                        if(DanceIndex==(llGetListLength(Dances) - 1)){
                            ActiveDance = llList2String(Dances, 0);
                        }else{
                            ActiveDance = llList2String(Dances, (DanceIndex + 1));
                        }
                        Dancer("Change");
                    }
                }
            }
        }
    } 
    
    run_time_permissions(integer perms){
        if(perms & PERMISSION_TRIGGER_ANIMATION){
            llSetTimerEvent(0);
            TimerMode = EMPTY;
            Dancer("Start");
        }else{
            llRequestPermissions(ActiveDancer, PERMISSION_TRIGGER_ANIMATION);
        }
    }
    
    timer(){
        if(TimerMode=="Perms"){
            llMessageLinked(LINK_THIS, 0, "FAIL||"+llGetScriptName(), ActiveDancer);
            llSleep(0.1);
            llSetScriptState(llGetScriptName(), FALSE);
        }
    }
}