// :CATEGORY:Weapons
// :NAME:Revolver_Script
// :AUTHOR:John Linden
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:01
// :ID:704
// :NUM:960
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Revolver Script.lsl
// :CODE:

// Gun script
// John Linden

// where the gun attaches itself if you click on it
// switch this to ATTACH_LHAND if you are left-handed
integer gAttachPart = ATTACH_RHAND;

string  INSTR_HELD_1 = "";
string  INSTR_HELD_2 = "";

string  INSTR_NOT_HELD_1 = "";
string  INSTR_NOT_HELD_2 = "";

string  INSTR_NOT_OWNER_1 = "";
string  INSTR_NOT_OWNER_2 = "";

// this is a permission combination we check for many times
// I define it here so we don't have to keep typing it
// guns need to take controls, attach themselves, and possibly 
// trigger animations
// NOTE: since I can't initialize to an expression (even if it is 
// all constants), this moved to default { state_entry() }
integer gDesiredPerm;
//  Indicates whether wearer has yet given permission 
integer gHavePermissions;

// Bullet travel speed
float   gBulletSpeed = 30.0;

// when we last fired a shot
float   gLastFireTime = 0;
// how long it takes to reload when tapping 
float   gTapReloadTime = 0.05;
// how long it takes to reload when holding
float   gHoldReloadTime = 1.0;
// how long it takes when we're out of ammo
float   gOutOfAmmoReloadTime = 1.4;
// how many shots before reload is necessary
integer gAmmoClipSize = 6;
// how much ammo we have right now
integer gAmmo;

// HACK: how far away the eye is from the avatar's center (approximately)
vector  gEyeOffset = <0.0, 0.0, 0.84>;


say(string msg)
{
 
}
debug(string msg)
{
//    llSay(0, msg);
}
func_debug(string msg)
{
//    llSay(0, msg);
}


// the gun has only one state

default
{
    on_rez(integer start_param)
    {
       
        // HACK: try to compensate for height of avatar
        // by changing firing position appropriately
        vector size = llGetAgentSize(llGetOwner());
        gEyeOffset.z = gEyeOffset.z * (size.z / 2.0);
        
  
        
        // NOTE: can't do this if we want to attach by dragging from
        // inventory onto the av, because the llResetScript(); clears
        // all the callbacks, including attach()
//        llResetScript();

        // NOTE 2: This can be uncommented in 1.1 because you won't have
        // to ask for permissions, you can just take them.  But for now
        // it pops up two dialog boxes if you drag onto the av, so I'll
        // leave it out.
        // Try to attach to the rezzer
//        if ( !gHavePermissions ) 
//        {
//            llRequestPermissions(llGetOwner(), gDesiredPerm);
//        }
    }

    state_entry()
    {
        func_debug("default state_entry");
        gHavePermissions = FALSE;
        // this should be initialized directly with the variable 
        // but I can't do that due to a bug
        gDesiredPerm = (PERMISSION_TAKE_CONTROLS
                        | PERMISSION_TRIGGER_ANIMATION);
        // Start with a full clip
        gAmmo = gAmmoClipSize;
        llResetTime();
    }

    // the player has touched us (left-clicked)    
    // give directions
    touch_start(integer tnum)
    {
        func_debug("touch_start");
        
        // Guns only work for their owner
        if ( llDetectedKey(0) == llGetOwner() )
        {
            if ( gHavePermissions )
            {
                llWhisper(0, INSTR_HELD_1);
                llWhisper(0, INSTR_HELD_2);
            } else
            {
                llWhisper(0, INSTR_NOT_HELD_1);
                llWhisper(0, INSTR_NOT_HELD_2);
            }
        } else
        {
            // Not the owner
            llWhisper(0, INSTR_NOT_OWNER_1);
            llWhisper(0, INSTR_NOT_OWNER_2);
        }
    }
    
    // Player attaches us, either by dragging onto self or from pie menu
    attach(key av_key)
    {
        func_debug("attach");

        if (av_key != NULL_KEY)
        {
            // Can't attach if we don't own it
            if ( av_key != llGetOwner() )
            {
                llWhisper(0, INSTR_NOT_OWNER_1);
                llWhisper(0, INSTR_NOT_OWNER_2);
                return;
            }
            
            //
            //  Always request permissions on attach, as we may be re-rezzing on login
            llRequestPermissions(av_key, gDesiredPerm);
            
            // run_time_permissions() is executed after this call
        } else
        {
            func_debug("  detach");
            
            if ( gHavePermissions )
            {
                // we are being detached
                llStopAnimation("hold_R_handgun");
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
        func_debug("run_time_permissions");
        
        // see if we now have the permissions we need
        if ( (perm & gDesiredPerm) == gDesiredPerm )
        {
            func_debug("  got perms");
    
            // we got the permissions we asked for
            gHavePermissions = TRUE;
            llTakeControls(CONTROL_ML_LBUTTON, TRUE, FALSE);
            llStartAnimation("hold_R_handgun");
        } else
        {
            func_debug("  didn't get perms");
            
            // we didn't get them, kill ourselves
            llDie();
        }
    }


    // the player has used the controls, process them
    control(key owner, integer level, integer edge)
    {
        func_debug("control");
        
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
            if ( (gAmmo >= 1) || (time > gOutOfAmmoReloadTime) )
            {
                // bang!
                
                llResetTime();  // we fired, set timer back to 0

                // HACK: gun shoots from gun pos, mouselook looks 
                // from player's eye, so we try to move the gun 
                // up to the eye.  but we really don't 
                // know where it is, so we guess (see gEyeOffset)
                vector      my_pos = llGetPos() + gEyeOffset;
                rotation    my_rot = llGetRot();
                vector      my_fwd = llRot2Fwd(my_rot);

                // Rez a bullet!
                llRezObject("Shuriken", 
                    my_pos, 
                    my_fwd * gBulletSpeed,
                    my_rot,
                    1);
                
                // decrease ammo count
                --gAmmo;
                if ( gAmmo > 0 )
                {
                    // still bullets left
                }
                else if ( gAmmo == 0 )
                {
                    // we just ran out of shots
                    // play reload sound here after a delay
                    
                }
                else // gAmmo < 0
                {
                    // we've just fired first round of new clip
                    gAmmo = gAmmoClipSize - 1;
                }
            } else
            {
                debug("Can't shoot, reloading...");
            }
        }
        
    } // control

} // default state
// END //
