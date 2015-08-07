// :CATEGORY:Environment
// :NAME:day_night_script
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:51
// :ID:223
// :NUM:309
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// day night script that detect and do stuff.lsl
// :CODE:


default {
   state_entry() {
      llSetTimerEvent(600);
   }
   timer() {
      vector sun = llGetSunDirection();
         if(sun.z > 0) {
            llSetPrimitiveParams([PRIM_MATERIAL,PRIM_MATERIAL_GLASS]);
         }
         else {
           llSetPrimitiveParams([PRIM_MATERIAL,PRIM_MATERIAL_LIGHT]);
         }
   }
}// END //
