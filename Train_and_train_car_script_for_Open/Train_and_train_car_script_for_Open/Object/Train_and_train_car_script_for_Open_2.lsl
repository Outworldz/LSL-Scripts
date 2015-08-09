// :CATEGORY:Vehicles
// :NAME:Train_and_train_car_script_for_Open
// :AUTHOR:Charles Allen
// :CREATED:2010-11-18 20:44:15.230
// :EDITED:2013-09-18 15:39:08
// :ID:911
// :NUM:1309
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Lastly the Train car
// :CODE:
// vvv Configuration/Settings vvv
    // Multiple Cars
        integer carnumber = 1;
    // Multiple Trains
        integer enginechannel = -549816546;
    // Speed
        float speed = 10.0; // Higher = Slower, but will look smoother.
    // Train Offset
        vector cpoffset = <0.0, 0.0, -1.884>;
    // Train Checkpoints
        list checkpoints = ["<128.21408, 64.01570, 63.43275>", "<118.21558, 64.01607, 63.44098>:0s:", "<108.21135, 63.93224, 63.44129>:20:Reading Railroad:Pennsylvania Railroad", "<98.64242, 64.58298, 63.43275>", "<89.63821, 66.57278, 63.44098>", "<82.54501, 70.11105, 63.44129>", "<76.58730, 75.55882, 63.43275>", "<71.72843, 81.54896, 63.44098>", "<68.27763, 88.99255, 63.44129>", "<66.32258, 98.22130, 63.43275>", "<65.64206, 107.66950, 63.44098>", "<65.64206, 117.63175, 63.44129>", "<65.64170, 127.63023, 63.43275>", "<65.64206, 137.62869, 63.44098>:0s:", "<65.64206, 147.61710, 63.44098>:20:Pennsylvania Railroad:B. & O. Railroad", "<66.35152, 157.35495, 63.43275>", "<68.34132, 166.35918, 63.44098>", "<71.87959, 173.45236, 63.44129>", "<77.32736, 179.41008, 63.43275>", "<83.31750, 184.26895, 63.44098>", "<90.76109, 187.71974, 63.44129>", "<99.98985, 189.67482, 63.43275>", "<109.43803, 190.35532, 63.44098>", "<119.40030, 190.35532, 63.44129>", "<129.39877, 190.35568, 63.43275>", "<139.39725, 190.35532, 63.44098>:0s:", "<149.22479, 190.33736, 63.44098>:20:B. & O. Railroad:Short Line", "<158.96265, 189.62785, 63.43275>", "<167.96687, 187.63806, 63.44098>", "<175.06004, 184.09982, 63.44128>", "<181.01776, 178.65202, 63.43275>", "<185.87663, 172.66190, 63.44098>", "<189.32744, 165.21828, 63.44129>", "<191.28250, 155.98955, 63.43275>", "<191.96301, 146.54137, 63.44098>", "<191.96301, 136.57907, 63.44129>", "<191.96336, 126.58061, 63.43275>", "<191.96300, 116.58212, 63.44098>:0s:", "<191.97081, 106.75428, 63.44098>:20:Short Line:Reading Railroad", "<191.26131, 97.01643, 63.43275>", "<189.27151, 88.01220, 63.44098>", "<185.73326, 80.91902, 63.44129>", "<180.28548, 74.96130, 63.43275>", "<174.29536, 70.10243, 63.44098>", "<166.85175, 66.65163, 63.44129>", "<157.62302, 64.69656, 63.43275>", "<148.17484, 64.01606, 63.44098>", "<138.21254, 64.01606, 63.44129>"];
// ^^^ Configuration/Settings ^^^

key owner;
integer checkpoint = 0;
integer numcheckpoints = 0;
vector next_pos;
string cpdata;
integer cpdataloc;
rotation rot;
vector increment;
integer i;

next_checkpoint()
{
    if (checkpoint >= numcheckpoints)
    {
        checkpoint = 0;
        llSetRot(<0.70711, 0.00000, -0.70711, 0.00000>);
    }
    else if (checkpoint == (numcheckpoints - 1) - carnumber && llGetFreeMemory() <= 2000)
    {
        llResetScript();
    }
    next_pos = ZERO_VECTOR;
    cpdata = llList2String(checkpoints, checkpoint);
    cpdataloc = llSubStringIndex(cpdata, ":");
    if (cpdataloc == -1)
    {
        next_pos = ((vector)cpdata + cpoffset);
    }
    else
    {
        next_pos = ((vector)llGetSubString(cpdata, 0, cpdataloc - 1) + cpoffset);
        cpdata = llDeleteSubString(cpdata, 0, cpdataloc);
        cpdataloc = llSubStringIndex(cpdata, ":");
    }
    rot = llGetRot() * llRotBetween(<0,0,1> * llGetRot(), next_pos - llGetPos());
    increment = (next_pos - llGetPos()) / speed;
    for(i=0;i<speed;++i)
    {
        llSetPrimitiveParams([PRIM_POSITION, (llGetPos() + increment), PRIM_ROTATION, rot]);
    }
    checkpoint++;
}

default
{
    state_entry()
    {
        owner = llGetOwner();
        llListen(enginechannel, "", NULL_KEY, "nextpos");
        numcheckpoints = llGetListLength(checkpoints);
        checkpoint = (numcheckpoints - 1) - carnumber;
        next_checkpoint();
        llSetRot(<0.70711, 0.00000, -0.70711, 0.00000>);
    }

    on_rez(integer start_param)
    {
        llResetScript();
    }

    listen(integer channel, string name, key id, string message)
    {
        if (llGetOwnerKey(id) == owner)
        {
            next_checkpoint();
        }
    }
}
