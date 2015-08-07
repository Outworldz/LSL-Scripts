// :CATEGORY:Physical simulations
// :NAME:SL_Molecule_Builder
// :AUTHOR:Dolyn Foley 
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:03
// :ID:787
// :NUM:1076
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
//     *  Create an object - preferable long and tall like a pole//     * Create a prim to represent each atom and place it in the object//     * Place the script below into the first item//     * Touch the first item and the atoms will build a C-60 structure // // Warning: This is a very prim-intensive activity and may not work on a property already containing buildings. Try the sandboxes to demo it. 
// :CODE:
list points = [
    <-0.265,0.328,-0.695>,
    <-0.164,-0.796,0.000>,
    <0.594,-0.531,0.164>,
    <0.000,0.164,0.796>,
    <-0.164,-0.594,0.531>,
    <-0.796,0.000,0.164>,
    <0.164,-0.594,0.531>,
    <-0.531,0.164,-0.594>,
    <0.164,0.594,-0.531>,
    <0.328,0.695,-0.265>,
    <-0.594,-0.531,0.164>,
    <-0.594,0.531,-0.164>,
    <-0.164,-0.594,-0.531>,
    <-0.265,-0.328,-0.695>,
    <-0.695,-0.265,0.328>,
    <0.695,0.265,0.328>,
    <-0.164,0.796,0.000>,
    <0.695,0.265,-0.328>,
    <-0.328,0.695,0.265>,
    <-0.695,-0.265,-0.328>,
    <0.796,0.000,0.164>,
    <0.265,-0.328,0.695>,
    <0.695,-0.265,-0.328>,
    <0.000,-0.164,-0.796>,
    <0.000,-0.164,0.796>,
    <0.164,0.594,0.531>,
    <-0.695,0.265,-0.328>,
    <-0.328,0.695,-0.265>,
    <0.164,-0.796,0.000>,
    <0.695,-0.265,0.328>,
    <-0.531,-0.164,-0.594>,
    <0.531,0.164,0.594>,
    <0.265,0.328,0.695>,
    <0.594,0.531,-0.164>,
    <-0.594,-0.531,-0.164>,
    <0.265,-0.328,-0.695>,
    <0.328,-0.695,0.265>,
    <0.796,0.000,-0.164>,
    <-0.531,0.164,0.594>,
    <-0.695,0.265,0.328>,
    <-0.265,-0.328,0.695>,
    <0.594,-0.531,-0.164>,
    <-0.164,0.594,0.531>,
    <-0.265,0.328,0.695>,
    <0.164,0.796,0.000>,
    <-0.531,-0.164,0.594>,
    <0.265,0.328,-0.695>,
    <0.164,-0.594,-0.531>,
    <0.531,0.164,-0.594>,
    <0.531,-0.164,0.594>,
    <-0.164,0.594,-0.531>,
    <0.328,0.695,0.265>,
    <0.594,0.531,0.164>,
    <-0.328,-0.695,-0.265>,
    <0.000,0.164,-0.796>,
    <-0.796,0.000,-0.164>,
    <0.531,-0.164,-0.594>,
    <0.328,-0.695,-0.265>,
    <-0.328,-0.695,0.265>,
    <-0.594,0.531,0.164>
    ];

integer totalNumberOfObjects = 0;
integer rezCount = 0;


default {
    on_rez(integer start_param) { llResetScript(); } 
    
    state_entry() {
        llOwnerSay("Touch to Make Ball - Replace BallObject to change point");
    }
    
    
    touch_start(integer total_number) {
        llOwnerSay("Start");
        string rezObjName = llGetInventoryName( INVENTORY_OBJECT, 0 );
        llOwnerSay( "Found: " + rezObjName );
        vector centerPos = llGetPos();

        totalNumberOfObjects = llGetListLength(points);
        integer i;
        for(i=0; i<totalNumberOfObjects; i++) {
            vector pos = llList2Vector(points, i);
            llRezObject( rezObjName, centerPos - pos, ZERO_VECTOR, ZERO_ROTATION, i );
        }
    }

    
    object_rez(key id) {
        rezCount++;
        llOwnerSay("rezed: " + (string)rezCount);
        if (rezCount>=totalNumberOfObjects) {
            string scriptName = llGetScriptName();
            llOwnerSay("Done - Die : " + scriptName);
            llDie();
        }
    }
    
}
