// :CATEGORY:Rezzers
// :NAME:multi_item_rezer
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:57
// :ID:529
// :NUM:714
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// multi item rezer.lsl
// :CODE:

// THE AMAZING
// TERRA(tm) FISH-O-MATIC(tm) FISH GENERATOR!!


integer RADIUS_MAX = 9; 
integer HEIGHT_MAX = 18; 
float FREQ = 5; // how often to change target location

integer chanDlg;
integer chanFish = 10; // fish listen on this channel

integer numFish;
integer radius = 2; // radius around rezzer
integer height = 10; // max height of fish target -- meters relative to rezzer
integer lstn;

vector myPos;
vector target;


list fishTypes;

key owner;



vector chooseTarget()
{
    myPos = llGetPos();
    vector offset;
    vector thisTarget;
    offset.x = llFrand(2 * radius) - radius; // x/y offset can be negative
    offset.y = llFrand(2 * radius) - radius;
    offset.z = llFrand(height) + 0.5;
    thisTarget = myPos + offset;
    return thisTarget;
}


getFishTypes()
{
    fishTypes = [];
    integer i;
    numFish = llGetInventoryNumber(INVENTORY_OBJECT);
    for (i = 0; i < numFish; i++)
    {
        fishTypes += [llGetInventoryName(INVENTORY_OBJECT,i)];
    }
}

init()
{
    chanDlg = (integer)(llFrand(10000)+1000); // random chat channel to avoid interference
    owner = llGetOwner();
    if (lstn)
    {
        llListenRemove(lstn);
        lstn = 0;
    }
    lstn = llListen(chanDlg,"", owner, "");
    myPos = llGetPos();
    llOwnerSay("Click me to set the options.");
}

menu()
{
    string txt = "SET UP THE FISHIES!\n\tMax height: "+(string)height+"m above rezzer\n\tHorizontal radius: "+(string)radius+"m";
    
    list buttons = ["Radius -","Height -","DELETE","Radius +", "Height +"] + fishTypes;
    
    llDialog(owner,txt,buttons,chanDlg);
}

rezFish(string name)
{
    llOwnerSay("Rezzing 1 "+name+".");
    llRezObject(name, chooseTarget(), ZERO_VECTOR, ZERO_ROTATION, 0);
    llSetTimerEvent(FREQ);
}

killFish()
{
    llOwnerSay("Deleting all nearby fish.");
    llSay(chanFish,"die");
    llSetTimerEvent(0);
}



default
{
    state_entry()
    {
        init();
    }
    
    on_rez(integer num)
    {
        llResetScript();
    }
    
    touch_start(integer num)
    {
        getFishTypes();
        integer i;
        key agent = llDetectedKey(i);
        if (agent == owner)
        {
            menu();
        }
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (message == "DELETE")
        {
            killFish();
        }
        else if (message == "Radius +") 
        {
            if (radius < RADIUS_MAX)
            {
                radius++;
            }
            else llOwnerSay("Radius is already at the maximum of "+(string)RADIUS_MAX+" meters.");
            menu();
            
        }
        else if (message == "Radius -")
        {
            if (radius > 0)
            {
                radius--;
            }
            menu();
        }
        else if (message == "Height +")
        {
            if (height < HEIGHT_MAX)
            {
                height++;
            }
            else llOwnerSay("Height is already at the maximum of "+(string)HEIGHT_MAX+" meters.");
            menu();
        }
        else if (message == "Height -")
        {
            if (height > 0)
            {
                height--;
            }
            menu();
        }
        else if (llGetInventoryType(message) >= INVENTORY_OBJECT) // returns -1 if object of that name doesn't exist
        {
            rezFish(message);
            menu();
        }
    }
    
    timer()
    {
        integer i;
        for (i = 0; i < numFish; i++)
        {
            vector t = chooseTarget();
            //target,<fish name>,<x>,<y>,<z>
            llSay(chanFish,"target,"+llList2String(fishTypes,i)+","+(string)t.x+","+(string)t.y+","+(string)t.z); // tell fish where to swarm
        }
        
    }
    
    
}// END //
