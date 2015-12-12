// :SHOW:1
// :CATEGORY:Gaming
// :NAME:HyperGrid Story Nine
// :AUTHOR:Ferd Frederix
// :KEYWORDS:Game, Collider
// :CREATED:2015-11-24 20:25:33
// :EDITED:2015-11-24  19:25:33
// :ID:1087
// :NUM:1834
// :REV:2.0
// :WORLD:OpenSim
// :DESCRIPTION:
// Triggers the NPC controller to play the Greet notecard when collided.
// :CODE:

string message = "@notecard=Greet";

Reset() {
    llSetStatus(STATUS_PHANTOM, FALSE);    // rev 2.0
    llVolumeDetect(FALSE);
    llSleep(0.1);
    llVolumeDetect(TRUE);
}

default{
    state_entry(){
        Reset();
    }
    collision_start(integer n){
        if (osIsNpc(llDetectedKey(0))){
            return;
        }
        llMessageLinked(2,0,message,"");
                 
        llSetTimerEvent(10);
    }
    timer() 
    {
        Reset();
        llSetTimerEvent(0);
    }
    on_rez(integer p){
        llResetScript();
    }
    changed(integer what){
        if (what & CHANGED_REGION_START){
            llResetScript();
        }
    }
}
