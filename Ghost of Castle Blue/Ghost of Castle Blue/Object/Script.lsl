// :CATEGORY:Pose Ball
// :NAME:Ghost of Castle Blue
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:54
// :ID:347
// :NUM:470
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// A pose ball to scare people
// :CODE:


// setup variables
integer degrees = 0;
string sHoverText = "Click to see the\nGhost\nof\nCastle Blue\n \n \n \n";


//constants

rotation sitRot ;


ShowHover()
{
    //llOwnerSay( "Showing" );
    llSetText( sHoverText, <1.0,1.0,1.0>, 1.0);
    //add a slight delay to avoid sending too many messages to the prim
    llSleep( 0.5 );
}

HideHover()
{
    //llOwnerSay( "Hiding" );
    llSetText( "", <1.0,1.0,1.0>, 0.0 );
    //llSleep( 0.5 );
}


// Sit the avatar looking at an arbitrary direction
// Look over the avatar's shoulders from behind once it sits down
 
back_view(float degrees)
{
    
    llSetCameraEyeOffset(<-2, 0, 1> * sitRot);
    llSetCameraAtOffset(<2, 0, 1> * sitRot);
}
 


default
{
    state_entry()
    {
        // setup sit target
        sitRot = llAxisAngle2Rot(<0, 0, 1>, degrees * DEG_TO_RAD);
        llSitTarget(<0, 0, 0.1>, ZERO_ROTATION);
        ShowHover();
    }
    
    changed( integer iChange )
    {
        if( iChange & CHANGED_LINK )
        {
            key kAgent = llAvatarOnSitTarget();
            
            //llOwnerSay( "kAgent=" + (string)kAgent ); 
            if( kAgent == NULL_KEY )
            {
                ShowHover();
            }
            else
            {
                llPlaySound("sound",0.11);
                HideHover();
                back_view( degrees );
            }
        }
    }
}
