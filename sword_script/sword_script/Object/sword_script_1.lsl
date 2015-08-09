// :CATEGORY:Weapons
// :NAME:sword_script
// :AUTHOR:John Linden
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:06
// :ID:863
// :NUM:1200
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// sword script.lsl
// :CODE:

// Gun script
// John Linden

// where the gun attaches itself if you click on it
// switch this to ATTACH_LHAND if you are left-handed
integer gAttachPart = ATTACH_RHAND;
vector rez_pos = <1.5, 0.0, 0.02>;
float height_offset;


integer gDesiredPerm;
//  Indicates whether wearer has yet given permission 
integer gHavePermissions;

// Bullet travel speed
float   gBulletSpeed = 15.0;

// when we last fired a shot
float   gLastFireTime = 0.01;
// how long it takes to reload when tapping 
float   gTapReloadTime = 0.01;
// how long it takes to reload when holding
float   gHoldReloadTime = 0.01;
//the sword animation being used
integer swings;
string anim = "sword";
vector  gEyeOffset = <0.0, 0.0, 0.75>;
key owner;




// the gun has only one state

default
{
    on_rez(integer start_param)
    {
         swings = 0;
         anim = "sword";
        vector size = llGetAgentSize(llGetOwner());
        gEyeOffset.z = gEyeOffset.z * (size.z / 2.0);
        // llStopAnimation("sword pose");
        
        
        
        
    }

    state_entry()
    {
      
        gHavePermissions = FALSE;
        // this should be initialized directly with the variable 
        // but I can't do that due to a bug
        gDesiredPerm = (PERMISSION_TAKE_CONTROLS
                        | PERMISSION_TRIGGER_ANIMATION);
                         llStartAnimation("sword pose"); 
        // Start with a full clip
       
        llResetTime();
    }

    // the player has touched us (left-clicked)    
    // give directions
    touch_start(integer tnum)
    {
        
        
        // Guns only work for their owner
        if ( llDetectedKey(0) == llGetOwner() )
        {
            if ( gHavePermissions )
            {
                
            } else
            {
                
            }
        } else
        {
            // Not the owner
           
        }
    }
    
    // Player attaches us, either by dragging onto self or from pie menu
    attach(key av_key)
    {
        

        if (av_key != NULL_KEY)
        {
            // Can't attach if we don't own it
            if ( av_key != llGetOwner() )
            {
               
                return;
            }
            
            //
            //  Always request permissions on attach, as we may be re-rezzing on login
            llRequestPermissions(av_key, gDesiredPerm);
             llStartAnimation("sword pose"); 
            
            // run_time_permissions() is executed after this call
        } else
        {
           
            
            if ( gHavePermissions )
            {
                // we are being detached
                 llStopAnimation("swordb");
                 llStopAnimation("swordcr");
                 llStopAnimation("sword pose");
                llReleaseControls();
                llSetRot(<0.0, 0.0, 0.0, 1.0>);
                gHavePermissions = FALSE;
            }
        }
    }

    // this is called whenever llRequestPermissions() returns
    // i.e. the user has responded or dismissed the dialog
    // perm is the permissions we now have
    run_time_permissions(integer perm)
    {
     
        
        // see if we now have the permissions we need
        if ( (perm & gDesiredPerm) == gDesiredPerm )
        {
           
    
            // we got the permissions we asked for
            gHavePermissions = TRUE;
            llTakeControls(CONTROL_ML_LBUTTON, TRUE, FALSE);
           
        } else
        {
            
            
            // we didn't get them, kill ourselves
            //llDie();
        }
    }


    // the player has used the controls, process them
    control(key owner, integer level, integer edge)
    {
       
        
        // has our gun reloaded?
        float time = llGetTime();

        // see if av has fired
        // (edge & level) == down edges, (edge & !level) == up edges
        // repeat rate is faster for tapping than holding
        if ( ( ((edge & level) & CONTROL_ML_LBUTTON) 
                && (time > gTapReloadTime) )
           || ( (time > gHoldReloadTime) 
               && (level & CONTROL_ML_LBUTTON) ) )
        {
            // if player is out of ammo, must wait for reload
           
                if(swings = 0)
                {
                 anim = "swordb";   
                }
                if(swings = 1)
                {
                 anim = "swordb";   
                }
                if(swings = 2)
                {
                 anim = "swordb";   
                }
                if(swings = 3)
                {
                 anim = "swordb";
                 swings = 0;   
                }
                
                llTriggerSound("e19b1802-9dab-f9b0-5cbd-b3530e578908", 1.2);
                 llStartAnimation(anim);
                llResetTime();  // we fired, set timer back to 0

                
                vector      my_pos = llGetPos() + gEyeOffset;
              
                
                 rotation    my_rot = llGetRot();
                vector      my_fwd = llRot2Fwd(my_rot);

                 llRezObject("meele", 
                    my_pos, 
                    my_fwd * gBulletSpeed,
                    my_rot,
                    1);
                    llRezObject("meele", 
                    my_pos + <0,0,0.15>, 
                    my_fwd * gBulletSpeed,
                    my_rot,
                    1);
                    llRezObject("meele", 
                    my_pos + <0,0,-0.15>, 
                    my_fwd * gBulletSpeed,
                    my_rot,
                    1);
               

                
                
          swings = swings + 1; 
       llStopAnimation(anim);
      // llSleep(3.0);
       // llStartAnimation("sword pose");  
    } // control
}
} // default state
// END //
