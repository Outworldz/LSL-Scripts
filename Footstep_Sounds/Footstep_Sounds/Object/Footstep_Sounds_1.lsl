// :CATEGORY:AO
// :NAME:Footstep_Sounds
// :AUTHOR:RvA Hax
// :CREATED:2010-07-01 15:44:12.797
// :EDITED:2013-09-18 15:38:53
// :ID:332
// :NUM:445
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Footstep_Sounds
// :CODE:
key owner;
string sound;
integer walking0;
 
default {
   state_entry() 
   {
      owner = llGetOwner();
      sound = llGetInventoryName(INVENTORY_SOUND, 0);
      llSetTimerEvent(0.4);
  }

   timer() 
   {
      integer walking = llGetAgentInfo(owner) & AGENT_WALKING;

      if (walking && !walking0)
         llLoopSound(sound, 0.4);

       else if (!walking && walking0)
          llStopSound();
 
       walking0 = walking;
 
     }

   attach(key id) {
        if (id)
        llPreloadSound(sound);
    }

    changed(integer c) {
        if ((c & CHANGED_OWNER) || (c & CHANGED_INVENTORY))
            llResetScript();
    }
}
