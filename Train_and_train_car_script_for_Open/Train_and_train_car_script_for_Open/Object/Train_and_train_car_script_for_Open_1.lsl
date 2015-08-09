// :CATEGORY:Vehicles
// :NAME:Train_and_train_car_script_for_Open
// :AUTHOR:Charles Allen
// :CREATED:2010-11-18 20:44:15.230
// :EDITED:2013-09-18 15:39:08
// :ID:911
// :NUM:1308
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// First the readme:// // Train Engine/Car v1.1// ~~~~~~~~~~~~~~~~~~~~// Note: The checkpoints are already setup for MonopolyMall.
// 
// Version History
// --------------------
// - v1.1
// * Ability for Start, Stop, Running, and Idle sounds added.
// - v1.0
// * Initial Release
// 
// 
// Multiple Cars
// --------------------
// Find "carnumber = 1;" in the Car script and change it to the next number from the previous car. For instance.... The engine would be considered 0, the number of the first car after the engine would be 1, the second car after the engine would be 2 and so on.... So in the first car the 'carnumber' would be 1 ("carnumber = 1;"), second car would be 2 ("carnumber = 2;"), and so on...
// 
// Train Offset
// --------------------
// Find "cpoffset = <0.0, 0.0, -1.199>;" in both the Engine and Car script and modify them as needed. This offset allows you to change the position of all of the checkpoints... This will allow you to make modifications on the positioning of the train on the track without having to change all of the checkpoints. So, if the train is 1 meter above the track you would change "<0.0, 0.0, -1.199>" to "<0.0, 0.0, -1.0>". If it is 1 meter below the track, you would change it to "<0.0, 0.0, 1.0>". (Note: There is the possibility to change the position of the "direction prim" instead of using this offset. For more information on the "direction prim" see 'Advanced Information - Train/Car Prim Setup')
// 
// Speed
// --------------------
// Find "speed = 10.0;" in both the Engine and Car script and change the "10.0" number to your wanted speed. (They must match in each script). Slower = Higher number. Faster = Lower number. (Note: The faster it is the more jumpy it will look.)
// 
// Multiple Trains
// --------------------
// Find "enginechannel = -549816546;" in both the Engine and Car script and change them to something different. (They must match in each script)
// It is suggested to only use negative numbers. (Any number from -1 to -2147483648). Make sure that this number is different for each train.
// 
// Checkpoints
// --------------------
// There isn't any 'automated' way to add, remove, or modify the location of a checkpoint... Open the Engine script and find the line that says "list checkpoints = " all of the stuff behind the equal sign is what makes up the track of the train. Between the quote marks are the cordinates, the time to wait for, the current station name, and the next station name. e.g. "<108.21135, 63.93224, 63.44129>:20:Reading Railroad:Pennsylvania Railroad" - "<108.21135, 63.93224, 63.44129>" are the cordinates, "20" is the number of seconds to wait for, "Reading Railroad" is the name of the station, and "Pennsylvania Railroad" is the name of the next station. (If you change the 'checkpoints' in the Engine script, make sure to also change it in the Car scripts)
// Update: If there is an s after the time to wait for, the stopping sound will be played when the train arrives at that checkpoint.
// 
// Train/Car Prim Setup
// --------------------
// The easiest thing to do is to make a small prim (0.1x0.1x0.1) and make it the root prim and center it on the train or car, then rotate the prim you just made so the +Z axis is facing in the direction you want the train to face when it is moving. It may take awhile to get the rotation for the direction correct. (*Warning*: I have hard coded the start rotation of the train into the code for MonopolyMall, so then the rotation wouldn't become 'strange' after making several rounds on the track. So if this is used somewhere else you will need to change the hardcoded rotation.)
// 
// Usage
// --------------------
// After making any needed changes to the script/train. Put the car script in each car of the train and change the 'carnumber' as needed. When finished doing the cars, put the Engine Script into the engine of the train.
// 
// Sound
// --------------------
// Open the Train Engine script and modify the stop, stopvolume, running, runningvolume, start, startvolume, and stopsoundlength variables.
// * stop - The name or UUID of the sound to play when stopping at a station.
// - e.g. 'string stop = "train_stop";' or 'string stop = "0bbda905-2797-5522-1eb5-7057937c7830";'.
// * stopvolume - The volume to play the stopping sound.
// - e.g. 'float stopvolume = 1.0;'.
// * running - The name or UUID of the sound to play when moving on the track.
// - e.g. 'string running = "train_running";' or 'string running = "38a3de37-8250-f77c-9d68-57fb0ce3e82b";'.
// * runningvolume - The volume to play the running sound.
// - e.g. 'float runningvolume = 1.0;'.
// * idle - The name or UUID of the sound to play when moving on the track.
// - e.g. 'string idle = "train_idle";' or 'string idle = "38a3de37-8250-f77c-9d68-57fb0ce3e82b";'.
// * idlevolume - The volume to play the idle sound.
// - e.g. 'float idlevolume = 1.0;'.
// * start - The name or UUID of the sound to play when leaving a station.
// - e.g. 'string start = "train_start";' or 'string start = "c55b672b-4054-0725-ac7b-ab71eda7ddfb";'.
// * startvolume - The volume to play the starting sound.
// - e.g. 'float startvolume = 1.0;'.
// * startsoundlength - The time that the starting sound plays for, in seconds. (Needed so then the script will know when to start playing the running sound)
// - e.g. 'float startsoundlength = 0.5;'.
// Note (stop, running, idle, start): If your going to use the name of the sound, the sound file must be in the same prim as the script. To not play a sound during start, running, or stop leave the variable empty. e.g. 'string stop = "";'
// 
// Next the Train Engine:
// :CODE:
// vvv Configuration/Settings vvv
    // Sounds
        // Arrive at Station
            string stop = "";
            float stopvolume = 1.0;
        // Running
            string running = "";
            float runningvolume = 1.0;
        // Idle
            string idle = "";
            float idlevolume = 1.0;
        // Leave Station
            string start = "";
            float startvolume = 1.0;
            float startsoundlength = 0.5;
    // Multiple Trains
        integer enginechannel = -549816546;
    // Speed
        float speed = 10.0;
    // Train Offset
        vector cpoffset = <0.0, 0.0, -1.199>;
    // Train Checkpoints
        list checkpoints = ["<128.21408, 64.01570, 63.43275>", "<118.21558, 64.01607, 63.44098>:0s:", "<108.21135, 63.93224, 63.44129>:20:Reading Railroad:Pennsylvania Railroad", "<98.64242, 64.58298, 63.43275>", "<89.63821, 66.57278, 63.44098>", "<82.54501, 70.11105, 63.44129>", "<76.58730, 75.55882, 63.43275>", "<71.72843, 81.54896, 63.44098>", "<68.27763, 88.99255, 63.44129>", "<66.32258, 98.22130, 63.43275>", "<65.64206, 107.66950, 63.44098>", "<65.64206, 117.63175, 63.44129>", "<65.64170, 127.63023, 63.43275>", "<65.64206, 137.62869, 63.44098>:0s:", "<65.64206, 147.61710, 63.44098>:20:Pennsylvania Railroad:B. & O. Railroad", "<66.35152, 157.35495, 63.43275>", "<68.34132, 166.35918, 63.44098>", "<71.87959, 173.45236, 63.44129>", "<77.32736, 179.41008, 63.43275>", "<83.31750, 184.26895, 63.44098>", "<90.76109, 187.71974, 63.44129>", "<99.98985, 189.67482, 63.43275>", "<109.43803, 190.35532, 63.44098>", "<119.40030, 190.35532, 63.44129>", "<129.39877, 190.35568, 63.43275>", "<139.39725, 190.35532, 63.44098>:0s:", "<149.22479, 190.33736, 63.44098>:20:B. & O. Railroad:Short Line", "<158.96265, 189.62785, 63.43275>", "<167.96687, 187.63806, 63.44098>", "<175.06004, 184.09982, 63.44128>", "<181.01776, 178.65202, 63.43275>", "<185.87663, 172.66190, 63.44098>", "<189.32744, 165.21828, 63.44129>", "<191.28250, 155.98955, 63.43275>", "<191.96301, 146.54137, 63.44098>", "<191.96301, 136.57907, 63.44129>", "<191.96336, 126.58061, 63.43275>", "<191.96300, 116.58212, 63.44098>:0s:", "<191.97081, 106.75428, 63.44098>:20:Short Line:Reading Railroad", "<191.26131, 97.01643, 63.43275>", "<189.27151, 88.01220, 63.44098>", "<185.73326, 80.91902, 63.44129>", "<180.28548, 74.96130, 63.43275>", "<174.29536, 70.10243, 63.44098>", "<166.85175, 66.65163, 63.44129>", "<157.62302, 64.69656, 63.43275>", "<148.17484, 64.01606, 63.44098>", "<138.21254, 64.01606, 63.44129>"];
// ^^^ Configuration/Settings ^^^

integer checkpoint = 0;
integer numcheckpoints = 0;
vector next_pos;
string cpdata;
string spause;
float pause;
string csname;
string nsname;
integer cpdataloc;
rotation rot;
vector increment;
integer i;
integer soundstart = 0;

next_checkpoint()
{
    if (checkpoint >= numcheckpoints)
    {
        checkpoint = 0;
        llSetRot(<0.70711, 0.00000, -0.70711, 0.00000>);
        if (llGetFreeMemory() <= 2000) llResetScript();
    }
    next_pos = ZERO_VECTOR;
    cpdata = llList2String(checkpoints, checkpoint);
    spause = "";
    pause = 0.0;
    csname = "";
    nsname = "";
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
        spause = llGetSubString(cpdata, 0, cpdataloc - 1);
        if (llGetSubString(spause, -1, -1) == "s" && stop != "")
        {
            llStopSound();
            llPlaySound(stop, stopvolume);
            pause = (float)llGetSubString(cpdata, 0, cpdataloc - 2);
        }
        else
        {
            pause = (float)llGetSubString(cpdata, 0, cpdataloc - 1);
        }
        cpdata = llDeleteSubString(cpdata, 0, cpdataloc);
        cpdataloc = llSubStringIndex(cpdata, ":");
        if (cpdataloc != -1)
        {
            if (idle != "")
            {
                llLoopSound(idle, idlevolume);
            }
            csname = llGetSubString(cpdata, 0, cpdataloc - 1);
            cpdata = llDeleteSubString(cpdata, 0, cpdataloc);
            nsname = llGetSubString(cpdata, 0, -1);
            if (llStringLength(csname) > 0) llWhisper(0, "Arrived at " + csname + ".");
        }
        if (pause > 0.0)
        {
            llSleep(pause);
            if (start != "")
            {
                llStopSound();
                llPlaySound(start, startvolume);
                llResetTime();
                soundstart = 1;
            }
        }
        if (llStringLength(nsname) > 0) llWhisper(0, "Next stop " + nsname + ".");
    }
    if (soundstart == 1)
    {
        if (llGetTime() >= startsoundlength)
        {
            soundstart = 0;
            llLoopSound(running, runningvolume);
        }
    }
    llShout(enginechannel, "nextpos");
    rot = llGetRot() * llRotBetween(<0,0,1> * llGetRot(), next_pos - llGetPos());
    increment = (next_pos - llGetPos()) / speed;
    for(i=0;i<speed;++i)
    {
        llSetPrimitiveParams([PRIM_POSITION, (llGetPos() + increment), PRIM_ROTATION, rot]);
    }
    checkpoint++;
    next_checkpoint();
}

default
{
    state_entry()
    {
        numcheckpoints = llGetListLength(checkpoints);
        checkpoint = 0;
        llSetRot(<0.70711, 0.00000, -0.70711, 0.00000>);
        next_checkpoint();
    }

    on_rez(integer start_param)
    {
        llResetScript();
    }
}
