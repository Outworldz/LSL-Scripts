// :CATEGORY:Flight Assist
// :NAME:Flight
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:53
// :ID:318
// :NUM:426
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Flight.lsl
// :CODE:

integer moving = FALSE;
key passer;
key owner;
integer speed=10000;

default

{
    state_entry()
    {
        owner=llGetOwner();
        llListen(0,"",owner,"");
       // owner=llGetOwner();
    }
 
    attach(key on)
    {
        if (on != NULL_KEY)
        {
            moving = TRUE;
            passer=on;
            integer perm = llGetPermissions();
            if (perm != (PERMISSION_TAKE_CONTROLS))
            {
                llRequestPermissions(on, PERMISSION_TAKE_CONTROLS);
            }
            else
            {
                llTakeControls(CONTROL_FWD , TRUE, TRUE);
            }
        }
        else
        {
            moving = FALSE;
        }
    }
    
    listen(integer channel, string name, key id, string message)
    {
       //if(id==owner)
        //{
            if(message=="Stop")
            {
                llReleaseControls();
                llWhisper(0,"What, you don't like the SPEED?");
            }
            if(message=="Fly")
            {
                llWhisper(0,"WOOWHOOO!");
                speed=10000;
                key on=passer;
                if (on != NULL_KEY)
                {
                    moving = TRUE;
                    integer perm = llGetPermissions();
                if (perm != (PERMISSION_TAKE_CONTROLS))
                    {
                    llRequestPermissions(on, PERMISSION_TAKE_CONTROLS);
                    }
                else
                    {
                    llTakeControls(CONTROL_FWD | CONTROL_ML_LBUTTON, TRUE, TRUE);
                    }
                }
            }
                if (message=="Walk!")
                {
                    speed=1;
                    llWhisper(0, "A casual walk?");
                }
                if (message=="Trot!")
                {
                    speed=100;
                    llWhisper(0, "Moving to a brisk pace??");
                }
                if (message=="Sprint!")
                {
                    speed=10000;
                    llWhisper(0, "oooo, a run!");
                }
                if (message=="Plaid!")
                {
                    speed=75000;
                    llWhisper(0, "Ludicris Speed.");
                }
      
        //}     
    }
    

    run_time_permissions(integer perm)
    {
        if (perm)
        {
            llTakeControls(CONTROL_FWD | CONTROL_ML_LBUTTON, TRUE, TRUE);
        }
    }
    
    control(key owner, integer level, integer edge)
    {
        // Look for the jump key going down for the first time.
        if (!(level & CONTROL_FWD))
        {
            llSetForce(<0,0,0>, FALSE);
        }
        else
        {
            vector fwd;
            fwd = llRot2Fwd(llGetRot());
            fwd = llVecNorm(fwd);
            fwd *= speed;
            llSetForce(fwd, FALSE);
        }
    }
    
}
// END //
