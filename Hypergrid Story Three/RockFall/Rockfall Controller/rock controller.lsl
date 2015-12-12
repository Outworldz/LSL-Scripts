// :SHOW:
// :CATEGORY:NPC
// :NAME:All-In one example Sequencer
// :AUTHOR:Ferd Frederix
/// :REV:1
// :WORLD:Opensim
// :DESCRIPTION:
// Sample collision script for NPC sequence for the rock fall game

// :CODE:
list things ;

DoIt()
{ 
    things =       [ -1,1,"@pause=1"];
    things =       [ -1,8,"@sound=tremor"];
    
    things +=      [ 2,4,"@say=Oooooh a Human fell down and went boom!"];
    things +=      [ 2,0.1,"@rotate=180"];
    things +=      [ 4,4,"@say=No one said rocks would be safe hahahaha!"];
    things +=      [ 2,5,"@say=Anyone want to bet this silly  human will never figure out  how to get to the end of this?"];
                    
    things +=      [ 3,2,"@say=Not me!"];
    things +=      [ 3,0.1,"@rotate=90"];
    things +=      [ 2,1,"@say=Not me!"];
    things +=      [ 2,0.1,"@rotate=90"];
    things +=      [ 3,2,"@fly=<81.33295, 53.93847, 34.28074>"];
    things +=      [ 3,2,"@fly=<83.37263, 66.61314, 33.87567>"];
                    
    things +=      [ 2,2,"@fly=<81.33295, 53.93847, 34.28074>"];
    things +=      [ 2,2,"@fly=<90.31698, 65.18839, 32.46637>"];

    things +=      [ 4,1,"@say=No way ! Goodbye!"];
    things +=      [ 4,1,"@rotate=270"];
    things +=      [ 4,1,"@rotate=90"];
    things +=      [ 4,2,"@fly=<81.33295, 53.93847, 34.28074>"];
    things +=      [ 4,2,"@fly=<90.31698, 65.18839, 32.46637>"];

    things +=      [ 5,1,"@rotate=270"];
    things +=      [ 5,2,"@rotate=90"];    
    things +=      [ 5,2,"@say=I bet this human thinks everything here is worth their trust."];
    things +=      [ 5,2,"@fly=<81.33295, 53.93847, 34.28074>"];
    things +=      [ 5,0.1,"@fly=<90.49598, 68.05671, 35.85766>"];
    
    things +=      [ 5,4,"@say=Good luck!"];
    things +=      [ -1,0.1,"@delete"];

    Speak();
}

Speak() {
    
    integer prim = llList2Integer(things,0);
    float time = llList2Float(things,1);
    string msg = llList2String(things,2);
    //llOwnerSay("Prim:" + (string) prim + " time:" + (string) time + " Msg:" + msg);    
    if (prim) {
        things = llDeleteSubList(things,0,2);
        llMessageLinked(prim,0, msg,"");
        if (time > 0) {
            llSetTimerEvent(time);
    } else {
            llOwnerSay("Whooops, time = 0!");
            llOwnerSay("Prim:" + (string) prim + " time:" + (string) time + " Msg:" + msg);    
            llSetTimerEvent(0);
        }
    } else {
        llOwnerSay("Done");
        Reset();
        llSetTimerEvent(0);
    }
}
    
Reset()
{
    llSetStatus(STATUS_PHANTOM, FALSE); // Rev 2.
    llVolumeDetect(FALSE);
    llSleep(0.1);
    llVolumeDetect(TRUE);
}

default
{
    state_entry()
    {
        llSetText("",<1,1,1>,1.0);
        Reset();
    }
    
    timer()
    {
        Speak();
    }
    
    collision_start(integer n) {
        //llOwnerSay("Collided with " + llKey2Name(llDetectedKey(0)));

        if (! osIsNpc(llDetectedKey(0)))
        {
            llOwnerSay("Rock fall!");
            llTriggerSound("tremor",1.0);
            DoIt();
        }
            
    }
    
    touch_start(integer p)
    {
        DoIt();    
    }   
    
    changed(integer what)
    {
        if (what & CHANGED_REGION_START)
        {
            llResetScript();
        }
    }
}