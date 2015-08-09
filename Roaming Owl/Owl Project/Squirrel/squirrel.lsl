// :CATEGORY:Bird
// :NAME:Roaming Owl
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:01
// :ID:707
// :NUM:967
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Squirrel scrip gets grabbed by the owl
// :CODE:

// put this in a prim named 'Squirrel and feeder' for the owl to catch.

default
{
    state_entry()
    {
        llListen(2222,"","","fish");
    }

     
     
   listen( integer channel, string name, key id, string message )
   { 
        llDie();
   }
    

     on_rez(integer param)
     {
         llResetScript();
     }
}

