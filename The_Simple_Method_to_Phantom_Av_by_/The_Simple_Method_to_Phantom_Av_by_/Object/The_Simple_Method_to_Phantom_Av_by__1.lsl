// :CATEGORY:Phantom AV
// :NAME:The_Simple_Method_to_Phantom_Av_by_
// :AUTHOR:Beatfox Xevious
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:07
// :ID:886
// :NUM:1255
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// The Simple Method to Phantom Av by Beatfox Xevious-STEP TWO.lsl
// :CODE:

//The Simple Method to Phantom Av by Beatfox Xevious-STEP TWO


//After saving the script, unlink the prims and delete the one you put the script in. The remaining prim should now act like a phantom prim, even though it's not set to phantom. Next, place the following script in it:



default { state_entry() { llListen(1, "", llGetOwner(), ""); } listen(integer channel, string name, key id, string message) { if (message == "phantom on") { llSetScale(<.4, .4, .4>); llSetScale(<.5, .5, .5>); } else if (message == "phantom off") { llResetScript(); } } }



//Finally, attach the prim. Type "/1 phantom on" to turn on phantom mode, and "/1 phantom off" to turn it off. That's all there is to it! Note that this is intended for flying only; it can do some pretty funky stuff in walk mode. // END //
