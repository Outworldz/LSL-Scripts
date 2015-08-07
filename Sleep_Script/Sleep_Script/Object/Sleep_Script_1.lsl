// :CATEGORY:Animation
// :NAME:Sleep_Script
// :AUTHOR:Francis
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:04
// :ID:792
// :NUM:1101
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Sleep Script.lsl
// :CODE:

// Francis wuz here
integer broadcast = 20;

// A More Neutral Sleeping Position
//vector target = <-1.06585, 0.71774, 0.18293>;
//rotation targetRot = <0.50028, -0.49972, -0.50028, 0.49972>;

// A More relaxed sleeping position
vector target = <-1.15419, 0.56328, -0.25744>;
rotation targetRot = <0.52105, -0.49829, -0.46875, 0.51038>;

integer debugRotation = FALSE;
key sitAgent = NULL_KEY;
integer gotPermission = FALSE;

integer time = 0;
default
{
    state_entry()
    {
        llSetSitText( "Sleep" );
        llSitTarget( target, targetRot );
        if ( debugRotation ) {
            llListen( 1977, "Rotation Broadcaster", NULL_KEY, "" );
            llListen( 1978, "Rotation Broadcaster", NULL_KEY, "" );
        }
    }
    listen(integer channel, string name, key id, string message ) {
        if ( channel == 1977 )
            targetRot = (rotation) message;
        else
            target = (vector) message;
            
        llSitTarget( target, targetRot ); 
        if ( time == 0 )
            llSay(0, (string) targetRot + ", " + (string)target );
        time = (time +1) % 50;
    }
    changed(integer change) {
        if (change & CHANGED_LINK)
        {
            key agent = llAvatarOnSitTarget();
            if ( sitAgent == NULL_KEY && agent != NULL_KEY ) {
                // Someone new sitting down
                sitAgent = agent;
                llRequestPermissions(sitAgent,PERMISSION_TRIGGER_ANIMATION);
            }
            else if ( sitAgent != NULL_KEY && agent == NULL_KEY) {
                // sitting down person got up - wake up :)
                if ( gotPermission )
                    llStopAnimation("sleep");
                // Reset the script because we don't have a way of releasing permissions :)
                llResetScript();
            }
        }        
    }
    run_time_permissions(integer parm) {
        if(parm == PERMISSION_TRIGGER_ANIMATION) {
            gotPermission = TRUE;
            llStartAnimation("sleep");
        }
    }
    
}
// END //
