// :CATEGORY:Helicopter
// :NAME:Helicopter scripts
// :AUTHOR:Anonymous
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:54
// :ID:377
// :NUM:522
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// link message for seat
// :CODE:

integer sit;
key  pilot;

integer listenState( integer listener){ return 1;}
    
default
{
    state_entry()
    {
        llSay(0, "Hello, Avatar!");
    }
    // DETECT AV SITTING/UNSITTING AND GIVE PERMISSIONS
    link_message(integer sender_number, integer number, string message, key id)
    {
        
        if (message == "pilot" & id == NULL_KEY)  // no id, means they unsat
        {
           llSetStatus(STATUS_PHYSICS, FALSE);
           llStopAnimation("recline sit");
           llMessageLinked(LINK_SET, 0, "unseated", "");
           llStopSound();
           llReleaseControls();
           sit = FALSE;
           listenState(FALSE);
    
          }

        else if (message == "pilot" & id != NULL_KEY)  // id, means they sat
        {
            // Avatar gets on vehicle
               
               pilot = id ;
           sit = TRUE;
           llRequestPermissions(pilot, PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION);
           listenState(TRUE);
           llWhisper(0,"Comanche Pilot, "+llKey2Name(pilot)+", with your HUD attached, Select Start Engine to begin Flight, type help for additional assistance.");           
           llMessageLinked(LINK_SET, 0, "seated", "");        
         }

        // more ifs and code can go here to detect other link message
        
       }

    
    
    }
