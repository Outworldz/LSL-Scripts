// :SHOW:
// :CATEGORY:Teleport
// :NAME:Elven Door Teleport System
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2014-12-04 12:11:30
// :EDITED:2015-04-14  11:57:46
// :ID:1056
// :NUM:1679
// :REV:2
// :WORLD:Second Life
// :DESCRIPTION:
// DESCRIPTION: []::Elven Door teleport System invisible prim - put inside the main system
// :CODE:
// Ferd Frederix


integer debug = 0;
    
float TIME = 6.0;       // animation play time
integer channelin;      // listener from other prim
integer menuchannel;    // a random channel for hearing the Dialog box
integer chathandle;     // handle for the menu, we destroy it to kill lag
integer listener;       // channel handle 

float oldDist;      

vector StartSeatedRotation = <0, 0, 0>;      // animation start rotation
vector StopSeatedRotation = <0, 0, -90>;      // animation stop rotation 

vector StartSeatedOffset = <0, 0, 0.5>;     // where we sit to start    
vector StopSeatedOffset = <0, .5, 0.2>;     // where we end up after teleport

vector DestPosition;            // calculated offset to the other door
rotation DestRotation;          // calculated rotation when we get there
string animation ;              // calculated animation name

key AvatarKey;                // key of who touched the door

list menu;                  // storage for all the remoted doors
 
Menu() 
{
    
    menuchannel = llCeil(llFrand(1000000) + 99999);     // large random #
    chathandle = llListen(menuchannel,"","","");        // listen for Dialog
    integer i = llGetListLength(menu);
    list buttons;
    integer j;
    // make a menu from what we have heard   
    for (j = 0; j < i; j+=3)
        buttons += llList2String(menu,j);

    if (debug) llOwnerSay("button channel = " + (string)menuchannel +":" + llDumpList2String(buttons,"=="));
    
    llDialog(AvatarKey,"Pick a destination",buttons,menuchannel);
}
 
BootUp(integer newchannel)
{
    oldDist = 0;
    channelin = newchannel;
    
    if (debug) llOwnerSay("Channel=" + (string) channelin);
    listener = llListen(channelin,"","","");
    
    rotation SeatedRotation = llEuler2Rot( StartSeatedRotation * DEG_TO_RAD) * llGetRot();
    //llOwnerSay("bootup=" + (string) StartSeatedOffset+ "..." + (string) SeatedRotation);
    llSitTarget(StartSeatedOffset, <0,0,0,1>);
    
    animation = llGetInventoryName(INVENTORY_ANIMATION,0);
    llSetSitText("Enter");
    llRegionSay(channelin,"reset");  
    llSetTimerEvent(30);     // die when the door shuts
}


MovePrim(float dir)
{
    
    vector   vPosOffset     = <dir, 0.0, 0.0>; //-- creates an offset one tick  in the positive X direction.
    integer i = 0;
    for (i = 0; i < 20; i++)
    {
        vector   vPosRotOffset  = vPosOffset * llGetRot(); //-- rotate the offset to be relative to objects rotation
        vector   vPosOffsetIsAt = llGetPos() + vPosRotOffset; //-- get the region position of the rotated offset
        llSetPos(vPosOffsetIsAt);
    }
}


 
Go()
{   
    if (debug) llOwnerSay("starting animation");
    llStartAnimation(animation);
    MovePrim(.1);

    if (debug) llOwnerSay("starting movement to " + (string )DestPosition);
    warpPos();
    
    MovePrim(.1);
    if (debug) llOwnerSay("ending  animation");

    llStopAnimation(animation);
    llUnSit(AvatarKey);
     
    if (! debug)
        llDie();

}

 warpPos() 
 {   
     llSetRegionPos( DestPosition );
             
             
     DestRotation = llEuler2Rot( StopSeatedRotation * DEG_TO_RAD) * DestRotation  ;    // maybe rotate
     //DestRotation = llGetRot()  * DestRotation  ;    // maybe rotate
                     
     llSetRot(DestRotation);          // set dest rotation

     llWhisper(channelin,"open");
     llSleep(1.0);
    
 }



default
{
    state_entry()
    {
                
        if (((integer) llGetObjectDesc()) == 0)
            llSetObjectDesc("22221");
         

        BootUp((integer) llGetObjectDesc());
    }
    
    changed (integer what)
    { 
        if (what & CHANGED_LINK)
        {
            if (debug) llOwnerSay("changed");
            
            
            AvatarKey = llAvatarOnSitTarget();
            if (AvatarKey != NULL_KEY) 
            {             
                integer i = llGetListLength(menu);
                if (debug) llOwnerSay("Menu L= " + (string) i);
                if (i > 0)
                    Menu();
            }
        }
        else
        {
            animation = llGetInventoryName(INVENTORY_ANIMATION,0);
        }
           
    }

    

    run_time_permissions(integer perm)
    {
        if(PERMISSION_TRIGGER_ANIMATION & perm)
        {
            if (debug) llOwnerSay("perms granted");
            Go();
        }
    }
    
    on_rez(integer p)
    {
        if (p ==0)
            p = (integer) llGetObjectDesc();
            
        BootUp(p);  
    }

    timer()
    {
        llSetTimerEvent(0);
        if (! debug)
            llDie();
        
        
    }
    
    listen(integer channels,string name, key id, string message)
    {
        if(debug) llOwnerSay("Heard:" + message);
        
        if (channels == channelin)
        {
        
            if (id == llGetKey())
                return;
            if (message == "reset")
                return;
            if (message == "open")
                return;
            
            list params = llParseString2List(message,["|"],[""]);
            vector DestPositionproto = (vector) llList2String(params,0);
            
            rotation DestRotationproto = (rotation) llList2String(params,1);
            
            // remember the furthest prim that responds
            float dist = llVecDist(DestPositionproto,llGetPos());            
            menu += name;
            menu += DestPositionproto;
            menu += DestRotationproto;

            if (debug) llOwnerSay("Set Pos:" + (string) DestPosition + " rot:" + (string) DestRotation);
        }
        else if (channels == menuchannel)
        {
            llListenRemove(chathandle);
            integer i = llGetListLength(menu);
            integer j;
            
            for (j = 0; j < i; j+=3)
            {
                if ( llList2String(menu,j) == message)  // they want to go somewhere
                {
                    DestPosition = llList2Vector(menu,j+1);
                    DestRotation = llList2Rot(menu,j+2);

                    // convert position to lsl rotated form
                    if (debug) llOwnerSay("Located:" + (string) DestPosition + " rot:" + (string) DestRotation);
            
                    vector   vPosRotOffset  = StopSeatedOffset * DestRotation; //-- rotate the offset to be relative to objects rotation
                    
                    DestPosition = DestPosition + vPosRotOffset; //-- get the region position of the rotated offset
                    
                    
                    if (DestPosition != <0,0,0>)
                    {
                        if (debug) llOwnerSay("request perms");
                        llRequestPermissions(AvatarKey,PERMISSION_TRIGGER_ANIMATION );
                    }
        
            
                }
            }
        }
    }
    
    
    
}
