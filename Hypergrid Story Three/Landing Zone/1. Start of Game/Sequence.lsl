// :SHOW:1
// :CATEGORY:Gaming
// :NAME:Hypergrid Story Three
// :AUTHOR:Ferd Frederix
// :KEYWORDS:Game, Collider
// :CREATED:2015-11-24 20:36:34
// :EDITED:2015-11-24  19:36:34
// :ID:1090
// :NUM:1857
// :REV:2.0
// :WORLD:Opensim
// :DESCRIPTION:
// Sample sequencer script for NPC animator.  It sequeunces multiple NPCs in order thru a scenarios
// each 'things' entry is the NPC number, a (float) time to take between sending commands ( 0 is not allowed, but a small number is()
///and a @command that is sent to the NPC.

// :CODE:
// Notes: Link messages arte as follows 
// 1 = Racoon
// 2 = Namaka
// 3 = Dylan

// Rev: 2 fixes the Linux bug for collisions.

integer busy = FALSE;

integer debug = FALSE;
integer SENSE = TRUE;
float RATE = 5;
integer COLLIDE = TRUE;
float RANGE = 2;

 
list things ;
RezIn()
{ 
    things = [1,5,"@stop"];    
    things += [2,5,"@stop"];    
    things += [3,10,"@stop"];   
    Speak(); 
}

DoIt() 
{ 
  things =  [-1,1,"@pause=1"];    
    
    things += [1,1,"@animate=avatar_jumpforjoy|1"];
    things += [1,1,"@say=Hello! What happened to you two?"];
    things += [1,1,"@run=<123.70119, 124.20567, 37.52779>"];
    things += [1,1,"@walk=<124.75295, 125.30030, 37.52779>"];
    
    

    // rezpoint
    things += [2,1,"@walk=<125.02877, 121.68277, 37.39204>"];
    things += [2,1,"@animate=SwayInBreeze|2"];
    things += [2,2,"@animate=avatar_type|2"];
    things += [2,2,"@say=We are cyber beings that were transformed into these appearances."];
    
    things += [3,1,"@walk=<122.39304, 121.43833, 37.50384>"];

    things += [3,1,"@animate=SwayInBreeze|2"];

    things += [3,2,"@animate=avatar_type|3"];
    things += [3,1,"@say=Fire and wood do not mix.  I cannot be with you, my love, while in this form."];
    
    things += [2,2,"@animate=avatar_type|2"];
    things += [2,2,"@say=We must seek help to transform ourselves. I cannot live without you"];
    
    things += [2,2,"@pause=2"];
    
    
    things += [2,3,"@animate=avatar_type|3"];
    things += [2,1,"@say=Now we are on a journey to find our home, and find ourselves again"];
    things += [2,2,"@pause=2"];
    
    things += [1,3,"@animate=avatar_type|3"];
    things += [1,1,"@say=I see your friends have been changed by magic."];
    things += [1,2,"@pause=2"];
    
    
    things += [1,3,"@animate=avatar_type|3"];
    things += [1,1,"@stand"];
    things += [1,2,"@say=I can show a place that has potions to cure that."];
    
    things += [1,2,"@animate=avatar_type|2"];
    things += [1,2,"@say=But you need be careful here, the swamp is a dangerous place "];
    things += [1,1,"@stand"];
    
    things += [1,2,"@animate=avatar_type|2"];
    things += [1,1,"@say=I can show you the way. Follow me"];
    things += [1,1,"@walk=<119.90541, 124.44883, 37.51564>"];
    things += [1,1,"@walk=<121.84517, 124.44883, 37.51564>"];
    
    things += [3,1,"@animate=avatar_type|3"];
    things += [3,1,"@whisper=I do not trust this racoon. He has a mask and could mislead us. "];
    

    
    things += [2,1,"@animate=avatar_type|3"];
    things += [2,1,"@say=We must stay here, my love, where we do not burn the woods down."];

    
    things += [2,1,"@animate=avatar_type|2"];
    things += [2,1,"@say=Be careful, friend!"];
    
    things += [3,1,"@animate=avatar_type|3"];
    things += [3,1,"@say=Thank you for helping us"];

    things += [1,1,"@shout=Follow me!"];

    
    Speak();
}

Speak() {
    
    integer prim = llList2Integer(things,0);
    float time = llList2Float(things,1);
    string msg = llList2String(things,2);
    if (debug) llOwnerSay("Prim:" + (string) prim + " time:" + (string) time + " Msg:" + msg);    
    if (prim) {
        things = llDeleteSubList(things,0,2);
        llMessageLinked(prim,0, msg,"");
        if (time > 0) {
            llSetTimerEvent(time);
    } else {
            llOwnerSay("Whooops, time = 0!");
            if (debug) llOwnerSay("Prim:" + (string) prim + " time:" + (string) time + " Msg:" + msg);    
            llSetTimerEvent(0);
            Reset();
            busy = FALSE;
        }
    } else {
        if (debug) llOwnerSay("Done");
        busy = FALSE;
        Reset();
        llSetTimerEvent(0);
        if (SENSE)
            llSensorRepeat("","",AGENT,RANGE,PI,RATE);
    }
}

Reset()
{
    llSetStatus(STATUS_PHANTOM, FALSE);
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
        llSetTimerEvent(0);
        if (SENSE)
             llSensorRepeat("","",AGENT,RANGE,PI,RATE);
    }
    
    sensor(integer n) {
        if (debug) llOwnerSay("Bumped");
        if (! osIsNpc(llDetectedKey(0))) {
            if (debug) llOwnerSay("Sensed avatar");
            llSensorRemove();
            RezIn();
        }
    }
    
    timer()
    {
        Speak();
    }
    
    collision_start(integer n) {
        if (debug) llOwnerSay("Collided with " + llKey2Name(llDetectedKey(0)));
        if (busy) 
            return;
        if (! osIsNpc(llDetectedKey(0)))
        {  
            DoIt();
        }
            
    }
 
    on_rez(integer p)
    {
         llResetScript();
    }
    
    changed(integer what)
    {
        if (what & CHANGED_REGION_START)
        {
            llResetScript();
        }
    }
}
