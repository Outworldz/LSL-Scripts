// :SHOW:1
// :CATEGORY:Gaming
// :NAME:Does not use a Sensor to delete or start a NPC
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:Game, Sensor
// :REV:1.0
// :WORLD:OpenSim
// :DESCRIPTION:
// A part of a controller set for NPC's
// When an avatar (the owner is not counted) gets close to this, it sends a @go command to the controller. This will make it continue from an @stop.
// when no one is around, it sends a @stop to remove the NPC. It sends these once per avatar presence.
// Does not use a laggy sensor. Will not detect  the owner.
// :CODE:


integer debug = FALSE;         // set to TRUE or FALSE for debug chat on various actions
integer iTitleText = FALSE;    // set to TRUE or FALSE for debug hovertext above the prim

float distance = 75;    // keep this distance short - in my case, we are on a broad plain and we need to notice the avatar from a long distance, but not often.
float time = 10;        // keep this big - the smaller, the laggier it gets

// toggle if a person is there or not so we can detect the edge condition
integer isPersonDetected = FALSE;

// send a link message once, when no one  is detected
nobodyHome() {
    if (isPersonDetected) {
        llMessageLinked(LINK_SET,1,"@stop","");
    }
    isPersonDetected = FALSE;
}

// send a link message once, when someone is detected
somebodyHome() {
   if (! isPersonDetected)
        llMessageLinked(LINK_SET,1,"@go","");

   isPersonDetected = TRUE;
}

default {
    state_entry(){
        llSetTimerEvent(time);
    }
    
    timer(){
        list avatarsInRegion = osGetAvatarList();
        // A srided list of the UUID, position, and name of each avatar in the region except the owner.

        integer i;
        integer present;
        for (i = 0; i < llGetListLength(avatarsInRegion)/3;i++)
        {
            key avatarUUID = llList2Key(avatarsInRegion,i);
            if (! osIsNpc(avatarUUID)) {

                vector avatarLoc = llList2Vector(avatarsInRegion,i+1);    // location
                float dist = llVecDist(llGetPos(),avatarLoc);
                if (dist < distance)
                    present++;
            }
        }

        if (present) 
            somebodyHome();
        else
            nobodyHome();
        
    }
        
   on_rez(integer p) {
        llResetScript();
    }
    
    
    changed(integer what){
        if (what & CHANGED_REGION_START){
            llResetScript();
        }
    }
    
}