// :CATEGORY:Teleport
// :NAME:WarpPos_Teleporter
// :AUTHOR:Davy Maltz
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:09
// :ID:964
// :NUM:1386
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// WarpPos_Teleporter
// :CODE:
WarpPos() 
{
    integer jumps = (integer)(llVecDist(destpos, llGetPos()) / 30.0) + 1;
    
    if (jumps > 200 )
        jumps = 200;
    list rules = [ PRIM_POSITION, destpos ];
    integer count = 1;
    while ( ( count = count << 1 ) < jumps)
        rules = (rules=[]) + rules + rules;
    llSetPrimitiveParams( rules + llList2List( rules, (count - jumps) << 1, count) );
while(llGetPos() != destpos)
    WarpPos();
}
vector destpos;
default
{
    on_rez(integer start_param)
    {
        llSay(0,"Say '.pos <position>' To Set The Destination To The Specified Position, And '.warp' To Warp The Object To The Defined Position.(You Must Be Sitting On The Object If You Want To Warp Yourself With The Object.)");
llResetScript();
    }
    state_entry()
    {
        llSetTimerEvent(0.1);
        llListen(0,"",llGetOwner(),"");
    }
    timer()
    {
        if(destpos != ZERO_VECTOR)
        {
            
            llSetText("WarpPos Warper: Ready. Destination Set To " + (string)destpos + ".",<0,1,0>,1.0);
        }
        else
        {
            llSetText("WarpPos Warper: Not Ready. No Destination Set.",<1,0,0>,1.0);
        }           
    }
    listen(integer channel, string name, key id, string message)
    {
        if(llToLower(message) == ".warp")
        {
            if(destpos == ZERO_VECTOR)
            {
                llSay(0,"No Destination Defined. Say '.pos <position>' To Set The Destination To The Specified Position.");
            }
            else
            {
                WarpPos();
            }
        }
        else if(llSubStringIndex(llToLower(message),".pos ") != -1)
        {
            if(llSubStringIndex(message,"<") == -1)
            {
            destpos = (vector)("<" + llGetSubString(llToLower(message),5,llStringLength(message)) + ">");
            }
            else if(llSubStringIndex(message,"<") != -1)
            {
            destpos = (vector)llGetSubString(llToLower(message),5,llStringLength(message));
            }
        }
    }
}
