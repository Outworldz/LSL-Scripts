// :CATEGORY:Games
// :NAME:Domino
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:51
// :ID:246
// :NUM:337
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Domino.lsl
// :CODE:



//This domino script uses an llApplyImpulse fuction call to make it fall forward. If you decide that you want to resize the domino, you will need to adjust the amount of impulse applied.






vector base_pos;
rotation base_rot;
integer bump = 0;

move_back()
{
    llSetPos(base_pos);
    llSetRot(base_rot);
    llSetPos(base_pos);
    llSetRot(base_rot);
    llSetPos(base_pos);
    llSetRot(base_rot);
}

default
{
    state_entry()
    {
        llSetStatus(STATUS_PHYSICS, FALSE);
        state waiting;
    }
    on_rez(integer sparam)
    {
        llSetStatus(STATUS_PHYSICS, FALSE);
        state waiting;
    }

}

state waiting
{
    collision_start(integer tnum)
    {
        if (llDetectedType(0) & (ACTIVE | AGENT))
        {
            llTriggerSound("fall", 1.0);
            base_pos = llGetPos();
            base_rot = llGetRot();
            llSetStatus(STATUS_PHYSICS, TRUE);
            vector dir = llGetPos() - llDetectedPos(0);
            dir = llVecNorm(dir);
            llApplyImpulse(dir*1, FALSE);
            llSleep(10.0);
            state fix;
        }
    }
    touch_start(integer sparam)
    {
        bump = 0;
    }
    touch(integer sparam)
    {
        bump++;
    }
    touch_end(integer sparam)
    {
        if (bump< 5)
        {
            llTriggerSound("fall", 1.0);
            base_pos = llGetPos();
            base_rot = llGetRot();
            llSetStatus(STATUS_PHYSICS, TRUE);
            vector dir = llGetPos() - llDetectedPos(0);
            dir = llVecNorm(dir);
            llApplyImpulse(dir*1,FALSE);
            llSleep(10.0);
            state fix;
        }
        else
        {
            llSetStatus(STATUS_PHYSICS, FALSE);
        }
    }
}

state fix
{
    state_entry()
    {
        llSetStatus(STATUS_PHYSICS, FALSE);
        llSetStatus(STATUS_PHANTOM, TRUE);
        llSleep(10.0);     //how long before the domino resets itself
        move_back();
        llSleep(5.0);
        llSetStatus(STATUS_PHANTOM, FALSE);
        state default;
    }
    collision_start(integer tnum)
    {
    }
}// END //
