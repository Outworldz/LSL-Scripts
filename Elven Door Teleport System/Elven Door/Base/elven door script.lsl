// :CATEGORY:Teleport
// :NAME:Elven Door Teleport System
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2014-12-04 12:10:29
// :EDITED:2014-12-04
// :ID:1056
// :NUM:1676
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Elven Door teleport System
// :CODE:
////----------------------------------------
//
//
// Q: What do I need to know right away?
//   
//   Use two or more doors to make a sim-wide teleport network.  
//   
//   Click a door to open or close.  Click the spiral to get a menu for teleport.
//   
// Installation:
//   
//         Rename each door as you place it. This name appears in the menu.  Use 12 characters or fewer for each name
//   
// For more door networks, or to prevent interference, change the number in the Objects Description  field to a new channel.  
//   
// The teleport will sync up automatically to a maximum of 16 doors.
//



integer debug = 0;


integer isopen ; // TRUE sf the door is open

// position it in front  and up from the base
vector relativePosOffset = <0, -.80, 0.4>; // "Forward" of this prim
vector startROT = <0,0,90> ;                 // initial rotation


rotation MYROT ;         

string moover;
integer channel = -44442;       // listener from other prim
integer listener;               // channel handle 
string myName;                  // Name of this prim

integer startParam = 30;    // seconds to poof, then door closes

Tell()
{
    string location = (string) llGetPos() + "|" + (string) llGetRot();
    if (! debug)
        llRegionSay(channel,location);  
    else
        llSay(channel,location);  
}


default
{
    state_entry()
    {   
        channel = (integer) llGetObjectDesc();
        if (debug) llOwnerSay("Channel=" + (string) channel);
        listener = llListen(channel,"","","");  
    }
        
    on_rez(integer p)
    {
        llResetScript();
    }
    
    link_message(integer sender_num,integer num, string str, key id)
    {
          
        channel = (integer) llGetObjectDesc();
        if (debug) llOwnerSay("Channel=" + (string) channel);
        listener = llListen(channel,"","","");   
        
        
        if (str =="rez")
        {
            moover = llGetInventoryName(INVENTORY_OBJECT,0);
            string myname = llGetObjectName();
            
            rotation myRot = llGetRot();
            rotation relativeRot =  myRot * llEuler2Rot (startROT * DEG_TO_RAD)   ;
            
            vector myPos = llGetPos();
            
            vector rezPos = myPos+relativePosOffset*myRot;
            vector rezVel = <0,0,0>;
    

            //llOwnerSay("Rezzing " + moover);
            llRezObject(moover,rezPos, rezVel, relativeRot, channel);
        }
    }
    
    listen(integer channel,string name, key id, string message)
    {
        if (debug) llOwnerSay("Heard " + message);
      
        // ignore what I say to myself
        if (id == llGetKey())
            return;
        
        // announce our location
        if (message == "reset")
        {
            Tell();
            return;
        }
        
        // If the person is coming, open the door
        if (message == "open"  && isopen == FALSE)
        {
            isopen = TRUE;
            llMessageLinked(LINK_ALL_OTHERS, 0,"open","");
            llSetTimerEvent(10);
            return;
        }
    
    }
    
    timer()
    {
        llMessageLinked(LINK_ALL_OTHERS, 0,"close","");
        llSetTimerEvent(0);
        isopen = FALSE;
    }
    
}
