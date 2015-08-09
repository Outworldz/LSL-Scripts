// :CATEGORY:Train
// :NAME:Train_car_follower
// :AUTHOR:Barney Boomslang
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:08
// :ID:913
// :NUM:1311
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Train_car_follower
// :CODE:
// copyright 2007 Barney Boomslang
//
// this is under the CC GNU GPL
// http://creativecommons.org/licenses/GPL/2.0/
//
// prim-based builds that just use this code are not seen as derivative
// work and so are free to be under whatever license pleases the builder.
//
// Still this script will be under GPL, so if you build commercial works
// based on this script, keep this script open!

// This script is the simple follower that is used to make a car follow the
// train or follow another car. It uses a simple inchannel and outchannel
// mechanism - each position on inchannel is handed over to one of several
// movement scripts and then announced on the outchannel. A car has to handle
// it's queue length itself - the length of the queue is based on the engine
// speed and the car and engine sizes.

// channels to communicate on - inchannel receives, outchannel sends
integer inchannel = -65432;
integer outchannel = -65433;

// queue for incoming requests. The length is based on speed and size of the car.
list queue = [];
integer qlen = 7;

// timeout for position updates - if we go over this time for updates, die
float timeout = 300.0;

// number of motors in the car and current motor to use
integer nummotors = 4;
integer currentmotor = 0;

// for keeping track of the train on sim crossing
key train = NULL_KEY;

// just the listener to make sure we can close it on multiple rezzes
integer listener = 0;

default
{
    state_entry()
    {
        queue = [];
        llSetTimerEvent(timeout);
    }
    
    on_rez(integer start_param)
    {
        inchannel = start_param;
        outchannel = start_param - 1;
        train = NULL_KEY;
        queue = [];
        if (listener) llListenRemove(listener);
        listener = llListen(inchannel, "", NULL_KEY, "");
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if ((id == train) || (llGetOwnerKey(id) == llGetOwner()))
        {
            // check for the trains die command
            if (message == "!DIE!")
            {
                llShout(outchannel, "!DIE!");
                llDie();
            }
            llSetTimerEvent(timeout);
            if (message != "!NOP!")
            {
                if (llGetListLength(queue) > qlen)
                {
                    train = id;
                    string m = llList2String(queue, 0);
                    queue = llList2List(queue, 1, -1);
                    llMessageLinked(LINK_THIS, currentmotor, m, NULL_KEY);
                    llShout(outchannel, m);
                    currentmotor += 1;
                    if (currentmotor >= nummotors)
                    {
                        currentmotor = 0;
                    }
                }
                queue += [message];
            }
        }
    }
    
    timer()
    {
        // if there is no update for a given time, we assume the train is dead
        llDie();
    }
}
