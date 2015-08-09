// :CATEGORY:Building
// :NAME:Geodesic_Dome_Builder
// :AUTHOR:Shine Renoir
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:54
// :ID:345
// :NUM:466
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// LINE// // // Put this scale script into a rod object called 'Line' and put that inside the builder, alongside the script above.// // The rod object is a Cylinder with size <0.1,0.1,1.0>.
// :CODE:


// One time scale script
// 2007 Copyright by Shine Renoir (fb@frank-buss.de)
// Use it for whatever you want, but keep this copyright notice
// and credit my name in notecards etc., if you use it in
// closed source objects

integer handle;

default
{
    state_entry()
    {
        handle = llListen(-42, "", NULL_KEY, "" );
    }
    
    listen(integer channel, string name, key id, string message)
    {
        llSetScale((vector) message);
        llListenRemove(handle);
    }
    
    on_rez(integer param) {
        llResetScript();
    }
}
