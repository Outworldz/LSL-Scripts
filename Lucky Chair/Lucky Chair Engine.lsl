key Sitter = NULL_KEY;
list Prizes;
string TimerMode;
integer TimerRoundCount;
integer TimerCountDown = 10;
list Players;
string SittingAnim = "Sit 1";

// Init Function
Init(){
    integer NumPrizes = llGetInventoryNumber(INVENTORY_OBJECT);
    integer i;
    for(i=0;i<NumPrizes;i++){
        Prizes = Prizes + [llGetInventoryName(INVENTORY_OBJECT, i)];
        llOwnerSay("Prize: "+llList2String(Prizes, -1)+" Added!");
    }
    TimerRoundCount = TimerCountDown;
    if(llGetListLength(Prizes)>0){
        llLinkSitTarget(1, <0,0,0.1>, ZERO_ROTATION);
        llOwnerSay("System Ready!");
    }
}

PickWinner(){
    float Num = llFrand(10.0);
    if((integer)Num > 5){
        integer NumPrizes = llGetListLength(Prizes);
        string Prize = llList2String(Prizes, (integer)llFrand((NumPrizes - 1)));
        llShout(0, "We have a WINNER! Prize Won: "+Prize);
        llRegionSayTo(Sitter, 0, "You are a WINNER! You have won the "+Prize);
        llGiveInventory(Sitter, Prize);
        Players = Players + [Sitter];
        llUnSit(Sitter);
        Sitter = NULL_KEY;
    }else{
        Players = Players + [Sitter];
        llRegionSayTo(Sitter, 0, "Better Luck Next Time!");
        llUnSit(Sitter);
        Sitter = NULL_KEY;
    }
}

default{
    on_rez(integer params){
        llResetScript();
    }
    
    state_entry(){
        Init();
    }
    
    changed(integer change){
        if(change & CHANGED_INVENTORY){
            llResetScript();
        }
        
        if(change & CHANGED_LINK){
            key sitterKey=llAvatarOnLinkSitTarget(1);
            if (Sitter==NULL_KEY && sitterKey!=NULL_KEY) // someone sitting down
            {
                Sitter=sitterKey;
                llRegionSayTo(Sitter, 0, "Please Accept Animation Permissions to start the Lucky Chair!");
                TimerMode = "Sitting";
                llSetTimerEvent(15.0);
                llRequestPermissions(Sitter,PERMISSION_TRIGGER_ANIMATION);
            }else if (Sitter!=NULL_KEY && sitterKey==NULL_KEY){
                Sitter = NULL_KEY;
                llSetTimerEvent(0);
            }else if (Sitter!=NULL_KEY && sitterKey!=Sitter) // someone sitting but object already occupied by someone else
            {
                llUnSit(sitterKey);
                llRegionSayTo(sitterKey,0,"Sorry, someone else is already sitting here, Please wait...");
            }
            return;
        }
    }
    
    run_time_permissions(integer perms){
        if(perms & PERMISSION_TRIGGER_ANIMATION){
            TimerMode = "CountDown";
            llStopAnimation("stand");
            llStartAnimation(SittingAnim);
            llShout(0, "We have a player for the lucky chair!\n Counting Down...");
            llSetTimerEvent(1.0);
        }
    }
    
    timer(){
        if(TimerMode=="Sitting"){
            llStopAnimation(SittingAnim);
            llStartAnimation("stand");
            llUnSit(Sitter);
            llSleep(1.0);
            llResetScript();
        }else if(TimerMode=="CountDown"){
            if(TimerRoundCount==0){
                TimerRoundCount = TimerCountDown;
                llSetTimerEvent(0);
                PickWinner();
            }else{
                llShout(0, "Picking a Winner in "+(string)TimerRoundCount+" seconds...");
                TimerRoundCount--;
            }
        }
    }
}