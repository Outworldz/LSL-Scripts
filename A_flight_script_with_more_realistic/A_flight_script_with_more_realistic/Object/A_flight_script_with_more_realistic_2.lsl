// :CATEGORY:Vehicles
// :NAME:A_flight_script_with_more_realistic
// :AUTHOR:Fritz Kakapo
// :CREATED:2010-12-28 21:16:02.003
// :EDITED:2013-09-18 15:38:47
// :ID:8
// :NUM:13
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// To fly, this also requires the pilot seat script, also in the root prim.
// :CODE:
//string sit_anim = "vseat";   This sit annimation didn't work.  The pilot scrapes on the ground too badly.
key pilot;
//
default
{
//  Vario-position Pilot Seat for Pietenpol Air Camper
// Ezekiel Bailly
// CopyLeft
// Current Limitation is that Pilot needs to standup and then re-sit to effect change
//
    state_entry()
    {
        pilot = NULL_KEY;       
        llListen( 0, "", llGetOwner(), "" );
        llSitTarget(  < 0.3, 0.0, 0.40 >, llEuler2Rot(<0,0,0>) );   // Start in up position.
    }
    //
    changed(integer change)
    {
        key sitting = llAvatarOnSitTarget();
        if ( change & CHANGED_LINK )
        {
            if ( sitting != NULL_KEY && pilot == NULL_KEY )
            {
                if ( sitting = llGetOwner() )
                {
                    pilot = sitting;
                    //llMessageLinked( 1, 0, "llWhisper", "/me pilotr " + llKey2Name(sitting) );
                    //if (sit_anim != "")
                    //{
                    llRequestPermissions(pilot, PERMISSION_TRIGGER_ANIMATION);
                    //}
                }
            }
            else if ( sitting == NULL_KEY && pilot != NULL_KEY )
            {
                if ( (llGetPermissions() & PERMISSION_TRIGGER_ANIMATION) == PERMISSION_TRIGGER_ANIMATION && llGetPermissionsKey() == pilot )
                {
                    llSetStatus(STATUS_PHYSICS, FALSE);
                    llSetStatus(STATUS_PHANTOM, TRUE);
                    //llStopAnimation(sit_anim);
                    llSleep(2.0);
                    llSetStatus(STATUS_PHANTOM, FALSE);
                }
                pilot = NULL_KEY;
                llMessageLinked(  LINK_SET, 0, "pilot", NULL_KEY );
            } 
        } 
    }
    //
    on_rez(integer n)
    {
        llResetScript();
    }
    //                   
    listen(integer chan, string name, key id, string msg)
    {
        if (msg == "seatdown")
        {
            llSitTarget( < 0.3,0.0,0.35 >, llEuler2Rot(<0,0,0>) );
            llSay(0, "Seat Position: Down");
        }
              else if ( msg == "seatup" )
        {
            llSitTarget( < 0.3, 0.0, 0.40 >, llEuler2Rot(<0,0,0>) );
            llSay(0, "Seat Position: Up");
        }
         else if (msg == "help")
        {
            llGiveInventory( id, "Pietenpol manual" );
        }
    }
    //        This annimation puts the avatar too high, so the sit position has to be too low,
    //      so the airplane is pushed off the ground.
    //
    //run_time_permissions(integer perms)
    //{
    //    if ((perms & PERMISSION_TRIGGER_ANIMATION) == PERMISSION_TRIGGER_ANIMATION) {
    //        llStartAnimation(sit_anim);
    //    }                    
    //}       
}
//============================================================================================================
//
