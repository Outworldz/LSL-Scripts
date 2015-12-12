// :SHOW:1
// :CATEGORY:NPC
// :NAME:HyperGrid Story Nine
// :AUTHOR:Ferd Frederix
// :KEYWORDS:NPC, controller, console
// :CREATED:2015-11-24 20:25:33
// :EDITED:2015-11-24  19:25:33
// :ID:1087
// :NUM:1838
// :REV:1.0
// :WORLD:OpenSim
// :DESCRIPTION:
// NPC console controller
// Accepts button input from 8 buttons in a compass rose configuration
// Controls a pait of NPCS to xap 6 other NPCs.
// :CODE:

//vector osNpcGetPos(key id) { return <128,128,20>; }

// TUNABLES

 
integer debug = 0;
integer CommandChannel = 23;
integer BUSY;

string errorbeep = "back-in-time";
string footsteps = "footstepmuffled";
string click = "coins_bag_2_3";
string sex="Sex";
string effect="magic-string-spell-2";

integer gFireworksChannel =20;
integer STATE = 0;

float LASTDIST = 1;
integer counter = 0;
list FarAway = ["She is too far away","Move her closer to the dancers", "Move her near the dancers and press the center button.","What button did you just push?","Is she stuck?", "I hope this is working"];

integer counter1 = 0;
list Instructions = ["She is moving","Move her next to the dancers", "Try the center button.","Try the other direction","I think you have to get near a dancer", "Move her close to the dancers and press the center button", "Keep going", " This looks good"];


float MAXDIST = 15; 
float MaxBeam = 3.0;    // how far the helmet beam happens

vector centerPoint = <213.89366, 129.07689, 39.56485>;

// first three are root, namaka, and dylan
list avatarDancePos= [ZERO_VECTOR,ZERO_VECTOR,ZERO_VECTOR,ZERO_VECTOR,ZERO_VECTOR,ZERO_VECTOR,ZERO_VECTOR,ZERO_VECTOR,ZERO_VECTOR,ZERO_VECTOR];

list avatars;

// Link Numbers of the NPC controller 
integer namaka      =2;
integer dylan       =3;
integer npc1        =4;
integer npc2        =5;
integer npc3        =6;
integer npc4        =7;
integer npc5        =8;
integer npc6        =9; // MaryAnne

// GLOBALS
integer busy ;

key NamakaKey;
key DylanKey ;

// npc counters
integer FIRST = 0;    
integer LAST = 6;
integer currNpcNum;

// FUNCTIONS

DEBUG(string msg)
{
    if (debug ==1 || debug ==3)
        llOwnerSay(llGetScriptName() + ":" + msg);   
    if (debug ==2 || debug ==3) {
        llSetText(msg, <1,0,0>,1.0);   
        llSleep(0.25);
    }
}

string NpcSayInstructions()
{    
    if (counter1 ++ >= llGetListLength(Instructions))
        counter1 = 0;
    
    return llList2String(Instructions,counter1);
}


string NpcSayTooFar()
{    
    if (counter++ >= llGetListLength(FarAway))
        counter = 0;
    
    return llList2String(FarAway,counter);
}


Command(integer Npc,string msg)
{
    //DEBUG("Command:" +(string) Npc +":" + msg);
    llMessageLinked(Npc,0,msg,"");
}

ChangeNpcToDemon(integer npc)
{
    DEBUG("Change to demon " + (string) npc);
    llMessageLinked(npc,100,"BOOM",""); // tell the effect to play
    llMessageLinked(LINK_SET,200,"BANG",""); // tell the spiral effect to play
    Command(npc,"@notecard=!Changed");
    
}

Win()
{
    DEBUG("Win");
    
    llRegionSay(gFireworksChannel,"Go");
    STATE=1;
    
    DEBUG("FIREWORKS");
    llSetTimerEvent(1);
}


InitAllNpc()
{
    DEBUG("Init all Npc");
    currNpcNum = FIRST;
    llMessageLinked(LINK_SET,99,"reset","");
    busy = FALSE;
    STATE = 0;
    avatars = [0,0,0,0,1,1,1,1,1,1];    // 0 is skipped, 1 = root, 2 - namaka
    llShout(CommandChannel,"0006");
    BUSY = FALSE;
}
 
default
{
    state_entry()
    {
        DEBUG("Reset");
        busy = FALSE;
        llSetText("",<1,1,1>,1.0);
        InitAllNpc();  
    } 
     
    timer()
    {
        llShout(CommandChannel,(string) (180 - STATE));
        llSetTimerEvent(1);
        
        if (STATE == 15  || STATE== 20 || STATE == 25) {
            llRegionSay(gFireworksChannel,"Go");
            
        } 
        
        if (STATE==30)
        {
            Command(namaka,"@notecard=dragon");
            Command(dylan,"@notecard=dragon");    
        }
        if (STATE == 180)
        {   
            InitAllNpc();
            llSetTimerEvent(0);
        }
        STATE++;
    }
    
    
    link_message(integer sender_number, integer number, string message, key id)
    {
        if (BUSY)
            return;
       // DEBUG("Num:" + (string) number  + " str:" + message);
        // --10 is the link num and pos of the dancer
        // -2 is dylans key
        // -1 is Namakas key
        // 4 is for NPC direction commands
        // 1 is for doorway
        // 2 is the helmet beam channel
        
        if (number == -10) {
            list x = llParseString2List(message,["|"],[]);
            integer linknum = (integer) llList2String( x,0);
            vector v = (vector) llList2String( x,1);
            
            avatarDancePos = llListReplaceList(avatarDancePos,[v],linknum,linknum);
            //DEBUG("Npc Count = " + (string) llGetListLength(avatarDancePos));
        }
        else if (number == -2){ // -2 is Dylans key fromt the modified NPC controller script
            DylanKey = id;
            //DEBUG("Dylan Key set to " + (string) id);
            
        } else if (number == -1){ // -1 is Namakas key
            NamakaKey = id;
            //DEBUG("Namaka Key set to " + (string) id);
            
        } else if (number == 4){  // 4 is for NPC direction commands
        
            llMessageLinked(LINK_SET,0," ",""); // stimulate back a NPC key message
            
            vector direction =  (vector) message;
            direction *= 2.5;
            DEBUG((string) direction);

            llTriggerSound(click,1.0);
            
            //DEBUG("Key: " + (string) NamakaKey);
            list stuff = llGetObjectDetails(NamakaKey, [OBJECT_POS]);
             
            vector namakaPos = llList2Vector(stuff,0);
            //vector namakaPos = osNpcGetPos(NamakaKey);
//            DEBUG("NPC at " + (string) namakaPos); 
              
            vector newNpcPos = namakaPos;
            newNpcPos.z = 0;
            centerPoint.z = 0;

            //DEBUG("Roam dist:" + (string) llVecDist(newNpcPos, centerPoint));
            llTriggerSound(footsteps,1.0);
            
             // Move the npc some direction
            
            if (llVecDist(newNpcPos, centerPoint) > MAXDIST)  {
                DEBUG("Went too far");
                llTriggerSound(errorbeep,1.0);
                
                string toSay = NpcSayTooFar();
                Command(dylan,"@animate=avatar_type|3");
                Command(dylan,"@say=" + toSay);
                
 //               string newPos2 = (string) (namakaPos + (direction *-2));
//                DEBUG("Reversing to @walk=" + newPos2);

                Command(namaka,"@teleport=<207, 126, 41>" );
                Command(dylan,"@teleport=<198.4, 130, 41.5>" );
                return;
            }

           
            string newPos = (string) (namakaPos + direction + <0,0,0.2>);
            //DEBUG("Moving to @walk=" + newPos);
            
            Command(namaka,"@walk=" + newPos);
                
        } else if (number == 1) { // 1 is for doorway
        
            if (busy) {
                DEBUG("Busy");
                return;
            }

            InitAllNpc();
            busy++;
            
        } else if (number == 2){ // 2 is the helmet beam channel
            
            DEBUG(llDumpList2String(avatars,":"));
        
            llTriggerSound(effect,1.0);
            llMessageLinked(LINK_SET,0," ",""); // stimulate back a NPC key message

            LASTDIST = 99;
            integer i;
            integer j = llGetListLength(avatarDancePos);
            for (i = 0; i < j; i++)        
            {
                if (llList2Integer(avatars,i) != 0)
                {

                    //DEBUG("I:" + (string) i);
                    // get Namakas position and compare it to all the npcs
                    vector npcPos = llList2Vector(avatarDancePos,i);
                    npcPos.z = 0;
                    list stuff = llGetObjectDetails(NamakaKey, [OBJECT_POS]);
                    vector namakaPos = llList2Vector(stuff,0);
                    
                    if (namakaPos == ZERO_VECTOR)
                    {
                        DEBUG("Oops");
                        return;
                    } 
        
                    namakaPos.z = 0;
                    
                    //DEBUG("namakaPos:" + (string) namakaPos);
                    //DEBUG("npcPos:" + (string) npcPos);
                    
                    float dist = llVecDist(npcPos,namakaPos);
                    //DEBUG("dist:" + (string) dist);
                    
                    if (dist < LASTDIST)
                    {
                        LASTDIST = dist;
                    }
                        
                    if (dist < MaxBeam)
                    {
                        llSetText("Distance\n" + (string) dist,<0,1,0>,1.0);
                        Command(dylan,"@say=Something is happening!" );
                        
                        ChangeNpcToDemon(i);   //1 = root, 2 = namake, 3 = dylan
                        
                        avatars= llListReplaceList(avatars,[0],i,i);
                        integer k;
                        integer l = llGetListLength(avatars);
                        integer count;
                        for (k=0; k < l; k++)
                        {
                            count += llList2Integer(avatars,k);
                        }
                        DEBUG("count:" + (string) count);
                        llShout(CommandChannel,(string) count);
                         
                        if (count <2) {
                            
                            llTriggerSound(sex,1.0);
                            Win();
                            BUSY++;
                            return;
                        }
                        llTriggerSound(effect,1.0);
                        return;
                    } 
                    
                }
            }
            llSetText("Distance\n" + (string) LASTDIST,<0,1,0>,1.0);
           
            string toSay2 = NpcSayInstructions();
            Command(dylan,"@animate=avatar_type|3");
            Command(dylan,"@say=" + toSay2);
                
            integer d = (integer) LASTDIST;
            Command(dylan,"@say=The closest dancer is about " + d + " meters away from her");
                
        } 
    }
}
