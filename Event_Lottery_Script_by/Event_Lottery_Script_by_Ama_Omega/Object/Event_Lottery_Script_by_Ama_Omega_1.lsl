// :CATEGORY:Lottery
// :NAME:Event_Lottery_Script_by
// :AUTHOR:Ama Omega
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:52
// :ID:287
// :NUM:385
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Event Lottery Script by Ama Omega.lsl
// :CODE:

// Event Lottery Script by Ama Omega
//This is a simple script for randomly awarding money to event attendies. Everyone who wishes to enter simply clicks the object the script is on. To find a winner the owner of the object says 'Find Winner'. This can be repeated as often as needed to find as many winners as possible. After a name has 'won' it is removed from the pool. This is a simple script.


list names;
integer i;
integer j;
integer count;
string name;

integer find(string name)
{
    for (i=0;i<count;i++)
        if (llList2String(names,i) == name)
            return i;        
    return -1;
}

default
{
    state_entry()
    {
        llListen(0,"",llGetOwner(),"Find Winner");
        count = 0;
    }

    touch_start(integer total_number)
    {
        for (j=0;j<total_number;j++)
        {
            if (find(llDetectedName(j)) == -1)
            {
                name = llDetectedName(j);
                names += name;
                llSay(0,name + " has been entered.");
                count++;
            }
        }
    }
    
    listen(integer chan, string name, key id, string mes)
    {
        names = llListRandomize(names,1);
        i = llFloor(llFrand(llGetListLength(names)));
        llWhisper(0,"And the Winner is " + llList2String(names,i) + 
            "! There were " + (string)count + " participants.");
        llDeleteSubList(names,i,i);
    }
}// END //
