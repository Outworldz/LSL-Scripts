// :CATEGORY:Door
// :NAME:Magic Door
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:56
// :ID:499
// :NUM:667
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// teleporting door
// :CODE:

// Fred Beckhusen (Ferd Frederix)


integer debug = 1;


float TIME = 6.0;
integer channel = -44442;      // listener from other prim
integer listener;            // channel handle 
string myName;                // Name of this prim

vector DestPosition = <0,0,0.1>;                // offset to the other door
rotation DestRotation = <0,0,0,1>;    // rotation when we get there

vector MYOFFSET = <1,0,0.1>;                // offset to the other door
rotation MYROT = <0,0,0,1>;    // rotation when we get there

string animation ;

key AvatarKey;                // key of who touched the door


Tell()
{
    string location = (string) llGetPos() + "|" + (string) llGetRot();
    if (! debug)
        llRegionSay(channel,location);  
    else
        llSay(channel,location);  
}

Go()
{   
    if (debug) llOwnerSay("starting animation");
    llStartAnimation(animation);
    llSleep(TIME);
    if (debug) llOwnerSay("starting movement to " + (string )DestPosition);
    warpPos();
    
    if (debug) llOwnerSay("ending  animation");
    llSleep(TIME);
    llStopAnimation(animation);
    llUnSit(AvatarKey);
    
     string location = (string) llGetPos() + "|" + (string) llGetRot();
     if (debug)
        llOwnerSay(location);
    else
        llRegionSay(channel,location);  

}

 warpPos() 
 {   //R&D by Keknehv Psaltery, 05/25/2006
     //with a little poking by Strife, and a bit more
     //some more munging by Talarus Luan
     //Final cleanup by Keknehv Psaltery
     //Changed jump value to 411 (4096 ceiling) by Jesse Barnett
     // Compute the number of jumps necessary
     // rotated by Fred Beckhusen (Ferd Frederix)
     //llSitTarget(destpos, ROT);//Set the sit target
     integer jumps = (integer)(llVecDist(DestPosition, llGetPos()) / 10.0) + 1;
     // Try and avoid stack/heap collisions
     if (jumps > 411)
         jumps = 411;
     list rules = [ PRIM_POSITION, DestPosition ];  //The start for the rules list
     integer count = 1;
     while ( ( count = count << 1 ) < jumps)
         rules = (rules=[]) + rules + rules;   //should tighten memory use.
     llSetPrimitiveParams( rules + llList2List( rules, (count - jumps) << 1, count) );
     if ( llVecDist( llGetPos(), DestPosition ) > .001 ) //Failsafe
         while ( --jumps ) 
             llSetPos( DestPosition );
    if (debug)
        llOwnerSay("open");
    else
        llWhisper(channel,"open");
    llSetRot(DestRotation);          // set dest rotation
    if (! debug)
        llDie();
 }


default
{
    state_entry()
    {
        if (debug)
            channel = 0;
            
        animation = llGetInventoryName(INVENTORY_ANIMATION,0);
        llSetSitText("Enter");
        llSitTarget( MYOFFSET, MYROT);
        myName = llGetObjectName();
        listener = llListen(channel,myName,NULL_KEY,"");
        if (debug)
            llSay(channel,"reset");  
        else
            llRegionSay(channel,"reset");  
        Tell();
    }
    
    changed (integer what)
    {
        if (what & CHANGED_LINK)
        {
            if (debug) llOwnerSay("changed");
            AvatarKey = llAvatarOnSitTarget();
            if (AvatarKey != NULL_KEY) 
            { 
                if (debug) llOwnerSay("request perms");
                llRequestPermissions(AvatarKey,PERMISSION_TRIGGER_ANIMATION );
            }
        }
        else
        {
            animation = llGetInventoryName(INVENTORY_ANIMATION,0);
        }
           
    }

    listen(integer channel,string name, key id, string message)
    {
        if (id == llGetKey())
            return;
        if (message == "reset")
        {
            Tell();
            return;
        }
        if (message == "open")
            return;
        
        if(debug) llOwnerSay("Heard:" + message);
        if (id != llGetKey())
        {
            list params = llParseString2List(message,["|"],[""]);
            DestPosition = (vector) llList2String(params,0);
            DestRotation = (rotation) llList2String(params,1);
            if (debug) llOwnerSay("Set Pos:" + (string) DestPosition + " rot:" + (string) DestRotation);
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
        llResetScript();
    }

}

