// :SHOW:1
// :CATEGORY:Gaming
// :NAME:Sequencer and Collider for All in One NPC Controller
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:Game, Collider
// :REV:1.0
// :WORLD:Opensim
// :DESCRIPTION:
// Sequencer script for NPC animator for HyperGrid Story nine sim.  It sequences multiple NPCs in order thru a scenarios
// each 'things' entry is the NPC number, a (float) time to take between sending commands ( 0 is not allowed, but a small number is()
///and a @command that is sent to the NPC.

// :CODE:
// Notes: Link messages arte as follows 


// Rev: 2 fixes the Linux bug for collisions.
//
integer debug = 1;         // set to TRUE or FALSE for debug chat on various actions

// list of NPCs and their linked prim numbers
list npcName = ["namaka",2,"dylan",3,"npc1",4,"npc2",5,"npc3",6,"npc4",7,"npc5",8,"npc6",9];

integer CommandChannel = 23;

// DEBUG(string) will chat a string or display it as hovertext if debug == TRUE

DEBUG(string str) {
    if (debug ==1 )
        llSay(0, llGetScriptName() + ":" + str);
    if (debug ==2 )
        llSetText(str,<1,1,1>,1.0);
}

integer osIsNpc(key id){
    return FALSE;
}

string osGetNotecard(string name) {
    // sample notecard for testing
    string str = "NPC #| seconds | Command\n"
    +"npc1|0|@pause=1\n"
    +"sylan|0|@animate=avatar_jumpforjoy|5\n"
    +"namaka|0|@say=Hello! What happened to you two?\n"
    +"Derf|0|@say=error\n"
    +"dylan|2|@animate=avatar_type|2\n"
    +"dylan|8|@say=I think we can transform back to our original selves, at last.\n";

    return str;
}


integer SENSE = FALSE;    // sensor for an avatar
float RATE = 5;          // every 5 seconds
integer COLLIDE = TRUE;  // if they collide, trigger the sequence
float RANGE = 96;        // a very short range as this goes into a ring around the avatar
integer Rezzed;

list things ;
// CODE follows


Send(string who, string cmd)
{
    DEBUG("Sending to " + who + "(" + (string) lookup(who) + ") the command " + cmd);
    llMessageLinked(lookup(who),0,cmd,"");
} 

integer lookup(string Name)
{
    integer i = llListFindList(npcName,[Name]);
    if (i != -1)
        return llList2Integer(npcName,i+1);
    return 0;
}

// For rezzing in
RezIn()
{
    DEBUG("Rezz In = @reset");
    llMessageLinked(LINK_SET,0,"@reset","");
}


DoIt() 
{

    string note = osGetNotecard("Sequence");
    list stuff=     llParseString2List(note,["\n"],[]);

    DEBUG("stuff:" + llDumpList2String(stuff,":"));
    integer i;
    integer j = llGetListLength(stuff);
    for (i=0; i < j; i++)
    {
        string noteline =  llList2String(stuff,i);
        DEBUG("noteline:" + noteline);
        
        list line =     llParseString2List(noteline,["|"],[]);
        string primName = llList2String(line,0);
        float sleepTime = llList2Integer(line,1);
        string atCmd = llList2String(line,2);
        string param1= llList2String(line,3);
        string param2= llList2String(line,4);

        DEBUG("prim:"      + primName);
        DEBUG("num:"       + (string) lookup(primName));
        DEBUG("time:"     + (string) sleepTime);   
        DEBUG("atCmd:"     +atCmd);   
        if (lookup(primName) && llSubStringIndex(atCmd,"@") == 0)
        {
            things += lookup(primName);
            things += sleepTime;
            things += atCmd+"|" + param1 + "|" + param2;
        }
    }
    DEBUG("Things:" + llDumpList2String(things,":"));
}




Speak() {
    
    integer prim = llList2Integer(things,0);
    float time = llList2Float(things,1);
    string msg = llList2String(things,2);
    DEBUG("Prim:" + (string) prim + " time:" + (string) time + " Msg:" + msg);    
    if (llStringLength(msg)) {
        things = llDeleteSubList(things,0,2);
        DEBUG("LINK:" +(string) prim + ":" + msg);
        llMessageLinked(prim,0, msg,"");
        if (time > 0) {
            llSetTimerEvent(time);
        } else {
            llSetTimerEvent(0.1);
        }
    } else {
        DEBUG("Done");
        
        Rezzed = 0;

        llSetTimerEvent(0);
        if (SENSE)
            llSensorRepeat("","",AGENT,RANGE,PI,RATE);
    }
}


 
default
{
    state_entry()
    {
        llSetText("",<1,1,1>,1.0);
        
        RezIn();
        
        llSetTimerEvent(0);
        if (SENSE)
            llSensorRepeat("","",AGENT,RANGE,PI,RATE);

        llListen(CommandChannel,"","","");
    }

    touch_start(integer p) {
        DEBUG("touched");
        if (llGetOwner() == llDetectedKey(0))
        {
            Send("Claire","@say=touched");
        } 
    }

    listen(integer channel, string name, key id, string message)
    {
        DEBUG(message);
        list vars = llParseString2List(message,["|"],[]);
        string num = llList2String(vars,0);
        string cmd = llList2String(vars,1);
        
        Send(num, cmd);
        
    }
    
    sensor(integer n) {
        DEBUG("Sensed");
        
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
        DEBUG("Collided with " + llKey2Name(llDetectedKey(0)));

        if (! osIsNpc(llDetectedKey(0)))
        {  
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
        if (what & CHANGED_REGION_START)
        {
            llResetScript();
        }
    }
}