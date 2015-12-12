// :SHOW:1
// :CATEGORY:Gaming
// :NAME:Falling walkway script
// :AUTHOR:Ferd Frederix
// :KEYWORDS:Game, Bridge
// :REV:2.0
// :WORLD:OpenSim
// :DESCRIPTION:
// A part of a bridge or walkway that falls when walked on.
// Put in a walkway and reset it.  When an avatar walks on it, it will move downward 2 meters for one minute, then restore.
// Place Hypergate water below the prim for them to fall into.
// :CODE:


Reset()
{
    llSetStatus(STATUS_PHANTOM, FALSE);
    llVolumeDetect(FALSE);
    llSleep(0.1);
    llVolumeDetect(TRUE);
}

vector initPos;
default
{
    state_entry()
    {
        initPos = llGetPos();
        Reset();
    }
    
    collision_start(integer num) {
        if (osIsNpc(llDetectedKey(0)))
            return;
        vector newPos = initPos;
        newPos.z -= 2;
        llSetPos(newPos);
        llSetTimerEvent(60);
    }
    
    timer()
    {
        Reset();
        llSetPos(initPos);
        llSetTimerEvent(0);
    }
    
    
    changed(integer what) {
        if (what & CHANGED_REGION_START)
            llResetScript();
    }
}