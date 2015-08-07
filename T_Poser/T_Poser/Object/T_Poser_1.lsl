// :CATEGORY:Pose Balls
// :NAME:T_Poser
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:06
// :ID:865
// :NUM:1202
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// T Poser.lsl
// :CODE:

key sitter = NULL_KEY;
integer perms = FALSE;

default
{
    state_entry()
    {
        vector posoffset = <0.00, 0.00, 2.00>;
        
        rotation rX;
        rotation rY;
        rotation rZ;
        rotation r;
        
        rX = llAxisAngle2Rot( <0.04,0,0>, 0 * DEG_TO_RAD);
        rY = llAxisAngle2Rot( <0,0.04,0>, 0 * DEG_TO_RAD);
        rZ = llAxisAngle2Rot( <0,0,0.04>, 0 * DEG_TO_RAD);
        
        r = rX * rY * rZ;
        
        llSetSitText( "Stand" );
        
        llSitTarget( posoffset, r );
    }
    
    changed(integer change) 
    {
        if (change & CHANGED_LINK)
        {
            key agent = llAvatarOnSitTarget();
            if ( sitter == NULL_KEY && agent != NULL_KEY ) 
            {
                sitter = agent;
                llRequestPermissions(sitter,PERMISSION_TRIGGER_ANIMATION);
            }
            
            else if ( sitter != NULL_KEY && agent == NULL_KEY) 
            {
                if ( perms ) 
                {
                    llStopAnimation("T Pose");
                }
                
                llResetScript();
            }
        }        
    }
    
    run_time_permissions(integer parm) 
    {
        if(parm == PERMISSION_TRIGGER_ANIMATION) 
        {
            perms = TRUE;
            llStopAnimation("sit");
            llStartAnimation("T Pose");
        }
    }    
}// END //
