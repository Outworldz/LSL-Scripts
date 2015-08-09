// :CATEGORY:Dance
// :NAME:DanceScript_v1
// :AUTHOR:Cailyn Miller
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:51
// :ID:215
// :NUM:290
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// DanceScript v1.lsl
// :CODE:

// avatar dance script v1.1
// say "/1 on" or "/1 off"
//
// v1.1 
// 30/3/04
// clear up llListen when leaving each state, and redo them entering each
// state (fixes what SL v1.3 broke)
//
// v1.0
// written by Cailyn Miller
// 25/3/04
// for Matheyus Gallant

// this list is the dance sequence.
// the first part of each line is the name of the movement, the second
// is the amount of time before the next movement begins.
// so for longer pauses between moves, make the value higher, to make moves
// flow together, reduce the values.
list lstDanceAnims  = [ 
"backflip", 1, 
"fist_pump", 2,
"dance1",  3,
"dance2",  3,
"dance3",  1,
"dance4",  2,
"dance5",  1,
"dance6",  3,
"dance7",  3,
"dance8", 3,
"kick_roundhouse_R", 2,
"musclebeach", 4,
"punch_L",  1,
"punch_onetwo",  2,
"punch_R",  1,
"sword_strike_R", 2   
// don't put a comma at the end of the last line!
];

string strCurAnim;
integer iCurMove;

// variable for the listen number
integer iListenVar;

default
{
    state_entry()
    {
        // request permission to animate the avatar
        llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
        
        // change state
        state off;
    }

    on_rez(integer num)
    {
        llResetScript();
    }
}

state off
{
    state_entry()
    {
        iListenVar = llListen(1, "", "", "on");
    }
    
    listen(integer channel, string name, key id, string message)
    {
        // should only be triggered by the owner, but check anyway
        if ( id == llGetOwner() )
        {
            if (message == "on")
            {
                // change state
                state on;
            }
        }
    }
    
    on_rez(integer num)
    {
        llResetScript();
    }

    attach(key id) 
    {
        llResetScript();
    }
    
    state_exit()
    {
        llListenRemove(iListenVar);
    }
}

state on
{
    state_entry()
    {
        iListenVar = llListen(1, "", "", "off");
        
        // initialise a count
        iCurMove = 0;
        
        // extracts the list at the current index
        list lMove = llList2List(lstDanceAnims, iCurMove, iCurMove + 1);
        
        // extract the anim name and sleep time
        string strMoveName = llList2String(lMove, 0);
        integer iMoveTime = llList2Integer(lMove, 1);
        
        // start the first dance move
        //llWhisper(0, strMoveName + " " + (string)iMoveTime);
        llStartAnimation(strMoveName);
        
        // increment count
        iCurMove+=2;
        
        // save dance move name
        strCurAnim = strMoveName;
        
        // start a timer for the correct amount of time
        llSetTimerEvent(iMoveTime);
    }
    
    listen(integer channel, string name, key id, string message)
    {
        // should only be triggered by the owner, but check anyway
        if ( id == llGetOwner() )
        {
            if (message == "off")
            {
                // stop the current dance move
                
                // cancel the timer
                llSetTimerEvent(0);
                
                // change state
                state off;
            }
        }
    }
    
    on_rez(integer num)
    {
        llResetScript();
    }
    
    attach(key id) 
    {
        llResetScript();
    }

    timer()
    {
        // stop timer
        llSetTimerEvent(0.0);
        
        // stop the current dance move
        llStopAnimation(strCurAnim);
        
        // extracts the list at the current index
        list lMove = llList2List(lstDanceAnims, iCurMove, iCurMove + 1);
        
        // extract the anim name and sleep time
        string strMoveName = llList2String(lMove, 0);
        integer iMoveTime = llList2Integer(lMove, 1);
        
        // start the first dance move
        //llWhisper(0, strMoveName + " " + (string)iMoveTime);
        llStartAnimation(strMoveName);
        
        // save dance move name
        strCurAnim = strMoveName;
        
        // start a timer for the correct amount of time
        llSetTimerEvent(iMoveTime);
        
        // increment move count (if drops of the end of the list restart at 0)
        iCurMove+=2;
        if (iCurMove >= llGetListLength(lstDanceAnims))
            iCurMove = 0;
    }

        state_exit()
    {
        llListenRemove(iListenVar);
    }
}// END //
