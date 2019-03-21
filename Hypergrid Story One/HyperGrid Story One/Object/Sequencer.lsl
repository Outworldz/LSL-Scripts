// :SHOW:1
// :CATEGORY:NPC
// :NAME:Hypergrid Story One
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:Game, Collider
// :CREATED:2015-11-24 20:36:34
// :EDITED:2015-11-24  19:36:34
// :ID:1089
// :NUM:1856
// :REV:3.0
// :WORLD:Opensim
// :DESCRIPTION:
// Sample sequencer script for NPC animator.  It sequences multiple NPCs in order thru a scenarios
// each 'things' entry is the NPC number, a (float) time to take between sending commands ( 0 is not allowed, but a small number is()
///and a @command that is sent to the NPC.

// :CODE:

// Rev: 2 fixes the Linux bug for collisions.
//
// Rev: 3 Neo Cortex: modified to become a standalone sequencer for Scene one
//
// Rev: 4 Aine Caoimhe: added support for custom appearance change slave scripts for finale sequence with 2 new commands:
//      @dumpkeys   must be called when all NPCs have been rezzed (ie when npcList has been populated with their keys)
//                  this relays the key data to the slave scripts which are numbered from 01 to 12
//      @slaveap=target|appearance_notecard_name where:
//                  target   1 = namaka (for final one)
//                  target   2 = mirror namakas (for final one)
//                  target   3 = all namaka (for all the other ones for her)
//                  target  -1 = dylan (for the final one)
//                  target  -2 = mirror dylans (for the final one)
//                  target  -3 = all dylans (for all the ones for him)
//      in both of the above commands you can use any non-zero npc number but it's ignored so I'd just use 1 each time
//      it will respect a time delay value if you set one
// example: 
// after all NPCs have been rezzed you need to call (but you only need to do it once):
//      things += [1,0,"@dumpkeys"];
// then to have all of the dylans change to appearance notecard "dylan scene 2" with no delay after it you would do:
//      things += [1,0,"@slaveap=-3|dylan scene 2"];

string myStoryNotecard = "!Story";

integer debug = FALSE;
integer LSLEditor = FALSE;        // set to to TRUE to working in  LSLEditor, FALSE for in-world.
integer iTitleText = TRUE;    // set to TRUE to see debug info in text above the controller

integer SENSE = FALSE;    // sensor for an avatar
float RATE = 5;          // every 5 seconds
float RANGE = 2;        // a very short range as this goes into a ring around the avatar
integer COLLIDE = TRUE;  // if they collide, trigger the sequence

integer isRunning = FALSE; // used to stop collision from firing twice

list npcList = [ (key) "00000000-0000-0000-0000-000000000000", "empty npc0",    // this one is ignored
                 (key) "00000000-0000-0000-0000-000000000000", "empty npc1",
                 (key) "00000000-0000-0000-0000-000000000000", "empty npc2",
                 (key) "00000000-0000-0000-0000-000000000000", "empty npc3",
                 (key) "00000000-0000-0000-0000-000000000000", "empty npc4",
                 (key) "00000000-0000-0000-0000-000000000000", "empty npc5",
                 (key) "00000000-0000-0000-0000-000000000000", "empty npc6",
                 (key) "00000000-0000-0000-0000-000000000000", "empty npc7",
                 (key) "00000000-0000-0000-0000-000000000000", "empty npc8",
                 (key) "00000000-0000-0000-0000-000000000000", "empty npc9",
                 (key) "00000000-0000-0000-0000-000000000000", "empty npc10",
                 (key) "00000000-0000-0000-0000-000000000000", "empty npc11",
                 (key) "00000000-0000-0000-0000-000000000000", "empty npc12"];

list myObjects = [];
list myObjectKeys = [];
integer myObjectsInitialized = FALSE;


string npcAction = "";
string npcParams = "";
key npcKey = "";
integer  NPCOptions = OS_NPC_CREATOR_OWNED;    // only the owner of this box can control this NPC.

key oldCollider; //remember who collided last
key newCollider;

// CODE follows

// For rezzing in
RezIn()
{
    things = [1,5,"@stop"];
    things += [2,5,"@stop"];
    things += [3,10,"@stop"];
    Speak();
}

DoIt()
{
    things = myStory;
    isRunning = TRUE;
    llVolumeDetect(FALSE);
    llSleep(0.1);
}


list things ;
list myStory;

// DEBUG(string) will chat a string or display it as hovertext if debug == TRUE
DEBUG(string str) {
    if (debug && ! LSLEditor)
        llOwnerSay( str);                    // Send the owner debug info 
    if (debug &&  LSLEditor)
        llSay(0, str);                    // Send to the Console in LSLEDitor 
    if (iTitleText) {
        llSetText(str,<1.0,1.0,1.0>,1.0);    // show hovertext
    
    }
}

list ListStridedUpdate(list dest, list src, integer start, integer end, integer stride) {
    return llListReplaceList(dest, src, start * stride, ((end + 1) * stride) - 1 );
}

spawn(integer who,string msg) {
    DEBUG("spawning " + msg);
    list data  = llParseString2List(msg, ["|"], []);
    //DEBUG((string) data);
    list npcName = llParseString2List(llList2String(data,0), [" "], []);
    npcKey =  osNpcCreate(llList2String(npcName, 0), llList2String(npcName, 1), llList2Vector(data,1),  llList2String(data, 2), NPCOptions);
    npcList=ListStridedUpdate(npcList,[npcKey,npcName],who,who,2);
    //DEBUG("npcList " + (string) npcList);
}

delete(integer who) {
    DEBUG(llList2String(npcList,who*2+1) + " is removed");
    osNpcRemove (llList2Key(npcList,who*2));
    npcList=ListStridedUpdate(npcList,[(key) "00000000-0000-0000-0000-000000000000","removed NPC"],who,who,2);
    //llSay(0, "npcList " + (string) npcList);
}

say(integer who,string msg) {
    DEBUG(llList2String(npcList,who*2+1) + " says " + msg);
    osNpcSay(llList2Key(npcList,who*2),0, msg);
}

sit(integer who,string msg) {
    DEBUG(llList2String(npcList,who*2+1) + " sits on " + (string) msg);
    // look up object named "msg" in myObjects, get key from myObjectsKeys, make "who" NPC sit on it
    osNpcSit(llList2Key(npcList,who*2), llList2Key(myObjectKeys,llListFindList(myObjects,[msg])), OS_NPC_SIT_NOW);
}

touchit(integer who,string msg) {
    DEBUG(llList2String(npcList,who*2+1) + " touches " + (string) msg);
    // look up object named "msg" in myObjects, get key from myObjectsKeys, make "who" NPC touch it
     osNpcTouch(llList2Key(npcList,who*2),llList2Key(myObjectKeys,llListFindList(myObjects,[msg])), LINK_THIS);
}

stand(integer who) {
    DEBUG(llList2String(npcList,who*2+1) + " stands");
    osNpcStand(llList2Key(npcList,who*2));
    list anToStop=llGetAnimationList(llList2Key(npcList,who*2));
    integer stop=llGetListLength(anToStop);
    while (--stop>-1) { osAvatarStopAnimation(llList2Key(npcList,who*2),llList2Key(anToStop,stop)); }
    osNpcPlayAnimation(llList2Key(npcList,who*2),"Stand");
}

walk(integer who,vector pos) {
    DEBUG(llList2String(npcList,who*2+1) + " walks to " + (string) pos);
    osNpcMoveToTarget(llList2Key(npcList,who*2),pos,OS_NPC_NO_FLY);
    osNpcPlayAnimation(llList2Key(npcList,who*2),"Walk");
}

animate(integer who, string ani) {
    DEBUG(llList2String(npcList,who*2+1) + " plays " + (string) ani);
    osNpcPlayAnimation(llList2Key(npcList,who*2),ani);
}

appearance(integer who, string app) {
    DEBUG(llList2String(npcList,who*2+1) + " changes appearance to " + (string) app);
    osNpcLoadAppearance(llList2Key(npcList,who*2),app);
}

rotate(integer who,float rot) {
    DEBUG(llList2String(npcList,who*2+1) + " rotates " + (string) rot);
    osNpcSetRot(llList2Key(npcList,who*2),llEuler2Rot(<0,0,rot> * DEG_TO_RAD));
}

// <<<< Added by Aine
dumpKeys() {
    llMessageLinked(LINK_THIS,0,"NPC_UUID_LIST",llDumpList2String(llList2ListStrided(npcList,0,-1,2),"|"));
}
slaveap(string com) {
    list parse=llParseString2List(com,["|"],[]);
    llMessageLinked(LINK_THIS,llList2Integer(parse,0),"NPC_CHANGE_APPEARANCE",llList2String(parse,1));
}
// <<<< End added by Aine
Speak() {

    integer npc = llList2Integer(things,0);
    float time = llList2Float(things,1);
    string msg = llList2String(things,2);
    DEBUG("npc:" + (string) npc + " time:" + (string) time + " Msg:" + msg);
    if (npc) {
        things = llDeleteSubList(things,0,2);
//        llMessageLinked(npc,0, msg,"");           // <<<<< Aine: I don't see any need for having this here still since this script is handling it
        list data  = llParseString2List(msg, ["="], []);
        npcAction = llToLower(llStringTrim(llList2String(data, 0), STRING_TRIM));
        DEBUG("Action:" + npcAction);
        npcParams = llStringTrim(llList2String(data, 1), STRING_TRIM);
        DEBUG("Params:" + npcParams);
        if (npcAction == "@say") {
            say(npc,npcParams);
        } else if (npcAction == "@spawn") {
            spawn(npc,npcParams);
        } else if (npcAction == "@delete") {
            delete(npc);
        } else if (npcAction == "@sit") {
            sit(npc,npcParams);
        } else if (npcAction == "@touch") {
            touchit(npc,npcParams);
        } else if (npcAction == "@stand") {
            stand(npc);
        } else if (npcAction == "@walk") {
            walk(npc,npcParams);
        } else if (npcAction == "@animate") {
            animate(npc,npcParams);
        } else if (npcAction == "@appearance") {
            appearance(npc,npcParams);
        } else if (npcAction == "@rotate") {
            rotate(npc,npcParams);
        // >>>> Added by Aine
        } else if (npcAction == "@dumpkeys") {
            dumpKeys();
        } else if (npcAction == "@slaveap") {
            slaveap(npcParams);
        } // >>>> end of add by Aine
        if (time > 0) {
            llSetTimerEvent(time);
        } else {
                llOwnerSay("Whooops, time = 0!");
            DEBUG("npc:" + (string) npc + " time:" + (string) time + " Msg:" + msg);
            llSetTimerEvent(0);
        }
    } else {
        DEBUG("Done");
        isRunning = FALSE;
        Reset();
        llSetTimerEvent(0);
        if (SENSE)
            llSensorRepeat("","",AGENT,RANGE,PI,RATE);
    }
}

Reset()
{
    llSetStatus(STATUS_PHANTOM, FALSE);        // Rev 2
    llVolumeDetect(FALSE);
    llSleep(0.1);
    llVolumeDetect(TRUE);
}

default
{
    state_entry()
    {
        DEBUG("entering state default");

    if (! myObjectsInitialized){
         state initial;
        }
    
        llSetText("",<1,1,1>,1.0);
        Reset();
        llSetTimerEvent(0);
        if (SENSE)
            llSensorRepeat("","",AGENT,RANGE,PI,RATE);
    }

    sensor(integer n) {
        DEBUG("Bumped");
        if (! osIsNpc(llDetectedKey(0))) {
            DEBUG("Sensed avatar");
            llSensorRemove();
            RezIn();
        }
    }
    
    timer()
    {
        Speak();
    }

    collision_start(integer n) {
        newCollider = llKey2Name(llDetectedKey(0));
        DEBUG("Collided with " + llKey2Name(llDetectedKey(0)));

        if (! osIsNpc(llDetectedKey(0)))
        {
            if ( newCollider != oldCollider) {
                DoIt();
                oldCollider = llKey2Name(llDetectedKey(0));
                Speak();
            }
        }
    }

    collision_end(integer num_detected) {
        DEBUG(llDetectedName(0) + " has stopped colliding with me!");
        if (! isRunning && (newCollider == oldCollider) ) {
            oldCollider = NULL_KEY;
        }
    }

    touch_start(integer n) {
        DEBUG("Touched by " + llKey2Name(llDetectedKey(0)));
        if (isRunning) {
            //insert restart code here
        }
        if (! osIsNpc(llDetectedKey(0))) {
            DoIt();
            Speak();
        }
    }



    on_rez(integer p)
    {
        llResetScript();
    }

    changed(integer what)
    {
        if (what & CHANGED_REGION_START|CHANGED_INVENTORY)
        {
            llResetScript();
        }
    }
}

state initial
{
    state_entry()
    {
        DEBUG("entering state initial");
        myStory = [];
        list myStoryLines = llParseString2List(osGetNotecard(myStoryNotecard), ["\n"], []);
        DEBUG("text = " + (string) myStoryLines);
        DEBUG("lines = " + (string) llGetListLength(myStoryLines));
        integer i;
        for (i=0; i<llGetListLength(myStoryLines); i++) {
            string myStoryLine = llList2String(myStoryLines,i);
            integer npc = (integer) llGetSubString(myStoryLine,0,llSubStringIndex(myStoryLine,","));
            string rest =  llGetSubString(myStoryLine,llSubStringIndex(myStoryLine,",")+1,-1);
            float time =  llGetSubString(rest,0,llSubStringIndex(rest,","));
            string msg = llGetSubString(rest,llSubStringIndex(rest,",")+2,-2);
            //now parse for sit and touch events to find the names of the objects needed
            list data  = llParseString2List(msg, ["="], []);
            npcAction = llToLower(llStringTrim(llList2String(data, 0), STRING_TRIM));
            DEBUG("Action:" + npcAction);
            npcParams = llStringTrim(llList2String(data, 1), STRING_TRIM);
            DEBUG("Params:" + npcParams);
            if (npcAction == "@sit") {
                myObjects += npcParams;
            } else if (npcAction == "@touch") {
                myObjects += npcParams;
            }
            DEBUG("npc: " + (string) npc + " time: " + (string) time + " msg: " + msg);
            myStory += [npc, time, msg];
        }
            DEBUG("Story read, initializing objects: " +  llDumpList2String(myObjects," "));
        
        if (llGetListLength(myObjects) == 0) {
            DEBUG("myObjects is empty upon entering state initial");
            myObjectsInitialized = TRUE;
            state default;
        }
        llSensor(llList2String(myObjects,0),"",ACTIVE|PASSIVE,96,PI);
        DEBUG("initially looking for: " + llList2String(myObjects,0));
    }

    //sensor is used to scan surrounding for named prims
    sensor(integer num) {
        myObjectKeys = myObjectKeys +  llDetectedKey(0);
        DEBUG("myObjectKeys: " + llDumpList2String(myObjectKeys," "));
        
        myObjects = llDeleteSubList(myObjects,0,0);
        if (llGetListLength(myObjects) == 0) {
            myObjectsInitialized = TRUE;
            state default;
        } else {
            llSensor(llList2String(myObjects,0),"",ACTIVE|PASSIVE,96,PI);
            DEBUG("now looking for: " + llList2String(myObjects,0));
        }
    }
    no_sensor(){
        DEBUG ("no target prim located");
    }
}
