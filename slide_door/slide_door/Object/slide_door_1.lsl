// :CATEGORY:Door
// :NAME:slide_door
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:04
// :ID:794
// :NUM:1103
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// slide door.lsl
// :CODE:

key owner;
// Will be used to retrieve owner's key.

integer iChan     = 1000;
// Channel door will listen on if other doors are touched;
// also the channel this door will broadcast on.

integer iSteps    = 15;
// How many steps the door will open in, used to provide the
// illusion of sliding.  Fewer steps means it opens faster,
// but more steps will make it "slide" smoother.

vector  vOffset   = <0.0, 0.15, 0.0>;
// Indicates how far the door will move with each step.
// Multiply by iSteps to calculate the total distance the
// door will move.

vector  vBase;
// Used to "un-stick" the door if something blocks it.
// Not sure if this is needed since 0.5.1, objects don't
// seem to block the door any more.  Leaving it in just
// in case, though.  I think attempting to edit the door
// while it's moving may make it stick.  This will solve
// that problem as well.

float   fOpenTime = 1.5;
// How long the door stays open

string  sSKeyword = "open1";
// Keyword door broadcasts when it's touched, to make
// other doors open.  You can chain these to make multiple
// doors open when any one is touched.
// NEVER make sSKeyword and sRKeyword the same, or you may
// get some doors stuck in an infinite loop, continuously
// re-triggering each other.

string  sRKeyword = "open2";
// Keyword door listens for from other doors.  Will open
// when it "hears" this keyword.
// Again, NEVER make sSKeyword and sRKeyword the same.

integer bMove     = FALSE;
// Is the door moving?

integer bLock     = FALSE;
// Is the door locked?

integer bVerbose  = FALSE;
// Confirm when owner locks/unlocks the door.

//*********************************************
// open() -- the meat and taters of the code,
//           makes the door actually move.
//*********************************************
open()
{
    bMove = TRUE;
    integer i;
    vector basepos = llGetPos();
    for (i = 0; i < iSteps; i++)
    {
      llSetPos(basepos +  i*vOffset);
    }
    vOffset *= -1;
    llSleep(fOpenTime);
    basepos = llGetPos();
    for (i = 0; i < iSteps; i++)
    {
      llSetPos(basepos + i*vOffset);
    }
    vOffset *= -1;
    if (llGetPos() != vBase) {
        llSetTimerEvent(5);
    } else {
        bMove = FALSE;
    }
}

default
{
    //**************************************************  *
    // state_entry() -- set up our global variables and
    //                  initialize the listen events.
    //**************************************************  *
    state_entry()
    {
        vBase = llGetPos();
        owner = llGetOwner();
        llListen(0,"",owner,"");
        llListen(iChan,"",NULL_KEY,sRKeyword);
    }

    //**************************************************  *
    // listen() -- listen for other doors opening, and
    //             if owner wants to lock/unlock doors.
    //**************************************************  *
    listen(integer chan, string name, key id, string msg)
    {
        if (chan == iChan && msg == sRKeyword) {
            if (!bMove && !bLock) open();
            if (bLock && bVerbose) llSay(0,"Locked!");
        }
        if (chan == 0 && id == owner && msg == "lock") {
            bLock = TRUE;
            if (bVerbose) llWhisper(0,"Locked!");
        }
        if (chan == 0 && id == owner && msg == "unlock") {
            bLock = FALSE;
            if (bVerbose) llWhisper(0,"Unlocked!");
        }
    }
    
    //********************************************
    // touch_start() -- what to do when someone
    //                  touches the door.
    //********************************************
    touch_start(integer count)
    {
        if (bLock) {
            llSay(0,"Locked!");
        } else {
            if (!bMove) {
                llWhisper(iChan,sSKeyword);
                open();
            }
        }
    }

    //**************************************************  **
    // timer() -- this is only used to un-stick the door
    //            (see vBase definition above).
    //**************************************************  **
    timer()
    {
        llSetPos(vBase);
        if(llGetPos() == vBase) {
            llSetTimerEvent(0);
            bMove = FALSE;
        }
    }
}// END //
