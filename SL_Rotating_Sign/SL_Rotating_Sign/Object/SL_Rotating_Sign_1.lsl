// :CATEGORY:Presentations
// :NAME:SL_Rotating_Sign
// :AUTHOR:Bill Freese
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:03
// :ID:789
// :NUM:1078
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// the Script
// :CODE:
// rotations in quaternions
rotation rot1 = <0.00000, 0.00000, 0.00000, 1.00000>;
rotation rot2 = <0.00000, 0.00000, -0.70711, 0.70711>;
rotation rot3 = <-0.00000, 0.00000, -1.00000, 0.00000>;
rotation rot4 = <0.00000, 0.00000, 0.70711, 0.70711>;


default // rotation_one
{
    state_entry()
    {
        llSetRot(rot1);
    }

    touch_start(integer total_number)
    {
        state rotation_two;
    }
}


state rotation_two
{
    state_entry()
    {
        llSetRot(rot2);
    }

    touch_start(integer total_number)
    {
        state rotation_three;
    }
}

state rotation_three
{
    state_entry()
    {
        llSetRot(rot3);
    }

    touch_start(integer total_number)
    {
        state rotation_four;
    }
}

state rotation_four
{
    state_entry()
    {
        llSetRot(rot4);
    }

    touch_start(integer total_number)
    {
        state default;
    }
}

