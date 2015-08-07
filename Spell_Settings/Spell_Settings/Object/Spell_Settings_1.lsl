// :CATEGORY:Spells
// :NAME:Spell_Settings
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:05
// :ID:822
// :NUM:1132
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Spell Settings.lsl
// :CODE:

default
{
    state_entry()
    {
        llSetBuoyancy(1); // so gravity doesn't pull our physical spells down
    }

   //Event if you hit a person or object
    collision_start(integer i){
        
        llDie();    // Delete object
    }
    
    //Event if you hit the ground
    land_collision_start(vector pos) {
    
        llDie(); //Delete object
    }
    
    //Event that happens when the spell is rezzed from the wand
    on_rez(integer param){
      
    }
}
// END //
