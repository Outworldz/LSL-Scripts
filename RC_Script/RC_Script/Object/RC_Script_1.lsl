// :CATEGORY:Vehicles
// :NAME:RC_Script
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:00
// :ID:684
// :NUM:927
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// RC Script.lsl
// :CODE:

key pilot = NULL_KEY;
string pilot_name = "";
integer controls_taken = FALSE;

set_pilot(key id, string name)
{
    pilot = id;
    pilot_name = name;
    llRequestPermissions(id, PERMISSION_TAKE_CONTROLS);
}

release_controls()
{
    if (controls_taken) {
        pilot = NULL_KEY;
        controls_taken = FALSE;
        llReleaseControls();
    }
}

move_by(vector offset)
{
    llSetPos(llGetPos() + offset*llGetRot());
}

rotate_by(vector angular_offset)
{
    llSetRot(llEuler2Rot(llRot2Euler(llGetRot()) + angular_offset * DEG_TO_RAD));
}

default
{
    touch(integer num_touched)
    {
        //if (llDetectedKey(0) == llGetOwner()) {
            set_pilot(llDetectedKey(0), llDetectedName(0));
        //}
    }
    
    control(key name, integer level, integer edge)
    {
        if (level & CONTROL_FWD) {
            move_by(<0,.5,0>);
        }
        if (level & CONTROL_BACK) {
            move_by(<0,-.5,0>);
        }
        if (level & CONTROL_LEFT || level & CONTROL_ROT_LEFT) {
            rotate_by(<0,0,1.5>);
        }
        if (level & CONTROL_RIGHT || level & CONTROL_ROT_RIGHT) {
            rotate_by(<0,0,-1.5>);
        }
        if (level & CONTROL_UP) {
            move_by(<0,0,.5>);
        }
        if (level & CONTROL_DOWN) {
            move_by(<0,0,-.5>);
        }
    }
    
    run_time_permissions(integer perms)
    {
        if (perms & PERMISSION_TAKE_CONTROLS) {
            llTakeControls(CONTROL_FWD | CONTROL_BACK | CONTROL_LEFT | CONTROL_RIGHT | CONTROL_ROT_LEFT | CONTROL_ROT_RIGHT | CONTROL_UP | CONTROL_DOWN, TRUE, FALSE);
            controls_taken = TRUE;
        } else {
            release_controls();
        }
    }
}
// END //
