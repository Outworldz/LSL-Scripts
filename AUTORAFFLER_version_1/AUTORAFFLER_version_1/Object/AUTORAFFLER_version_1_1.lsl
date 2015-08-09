// :CATEGORY:Games
// :NAME:AUTORAFFLER_version_1
// :AUTHOR:Johnson Earls
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:48
// :ID:68
// :NUM:95
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// AUTORAFFLER version 1.lsl
// :CODE:

//  AUTORAFFLER version 1.1
//  by Neo Rebus
//  Copyright (c) 2004 by Johnson Earls, All Rights Reserved
//  See end of file for license information
//
//  This is an automatic raffling system.  Once started, it will
//  periodically conduct a raffle on its own and give the prize to the
//  winner.  The winner must accept the prize within 15 seconds or the
//  autoraffler will choose a different winner.  (This allows the owner
//  of the object or property to decline accepting a prize)
//
//  SETUP:
//
//  Create an object that fills the volume in which the raffle attendees
//  will be standing.  The object can consist of multiple prims.  Once
//  the autoraffle script is put on the object, it will become phantom.
//  The object should be named something descriptive (as it will say
//  things to the world), and should be transparent since people will be
//  standing inside it.
//
//  Put the autoraffle script into the raffler object, then put the
//  objects to be raffled in.  Everything being raffled must be an
//  *object*, not a texture or landmark or anything.  If you want to
//  raffle other types of things off, put them inside their own object
//  and raffle that object.  If you want to raffle money, make an object
//  named "L$### ..." and the winner will be given ### linden dollars
//  rather than the object itself.
//
//  at this point, the autoraffler accepts voice commands to control it:
//
//    autoraffle reset
//      to reset the script
//    autoraffle list
//      to list the people entered in the raffle
//    autoraffle list winners
//      to list people who have won the raffle since it was reset
//    autoraffle stop
//      to stop an ongoing raffle
//    autoraffle start [ <interval> [ <count> ] ]
//      to start a raffle.  <interval> and <count> are optional.  If
//      interval is not given, it will default to about 30 seconds.
//      If count is not given, it will raffle off all the objects in
//      the autoraffler's inventory.
//
//      example:  autoraffle start 20 5
//        this will start the autoraffler with a raffle every 20 minutes
//        (starting 20 minutes from now), raffling off 5 random prizes.
//

integer raffleAcceptTimeout = 15;

integer runningRaffleCount = 0;
integer runningRaffleInterval = 0;

integer runningRaffleListenerChat = 0;
integer runningRaffleListenerPrivate = 0;

list runningRaffleEntrants = [];
list runningRaffleWinners = [];

key thisRafflePrize = NULL_KEY;
string thisRafflePrizeName = "";
key thisRaffleWinner = NULL_KEY;
string thisRaffleWinnerAccepted = "";
list thisRaffleEntrants = [];

integer PRIVATE_CHAT = 1316110706 ;

list remove_from_list(list src, list what)
{
    //  find 'what'
    integer idx = llListFindList(src, what);
    if (idx > -1)
    {
        list pfx;  // the list before 'what'
        list sfx;  // the list after 'what'
        if (idx > 0)
        {
            pfx = llList2List(src, 0, idx - 1);
        } else {
            pfx = [];
        }
        if (idx < llGetListLength(src) - llGetListLength(what))
        {
            sfx = llList2List(src, idx + llGetListLength(what), -1);
        } else {
            sfx = [];
        }
        return pfx + sfx;
    } else {
        return src;
    }
}

raffleWinner(key winner)
{

    //  if the winner is not NULL_KEY, give them the prize.
    //  if the winner *is* NULL_KEY, give the script owner the prize.
    //  remove the prize from the inventory, decrement the raffle count, and call nextRaffle().

    if (winner == NULL_KEY)
    {
        llSay(0, "No one accepted the prize!");
        if (llGetSubString(thisRafflePrizeName, 0, 1) != "L$")
        {
            llGiveInventory(llGetOwner(), thisRafflePrizeName);
        }
    } else {
        if (llGetSubString(thisRafflePrizeName, 0, 1) == "L$")
        {
            llGiveMoney(winner, llList2Integer(llParseString2List(thisRafflePrizeName, [" ", "$"], []), 1));
        } else {
            llGiveInventory(winner, thisRafflePrizeName);
        }
        runningRaffleWinners = runningRaffleWinners + [ winner ];
    }

    llRemoveInventory(thisRafflePrizeName);

    thisRafflePrize = NULL_KEY;
    thisRafflePrizeName = "";
    thisRaffleWinner = NULL_KEY;

    runningRaffleCount -= 1;

    nextRaffle();
}

nextRaffle()
{
    llSetTimerEvent(0.0); // just in case

    //  if the raffle count is 0, announce the end of the raffle and reset running variables.
    if (runningRaffleCount == 0)
    {

        runningRaffleInterval = 0;
        thisRafflePrize = NULL_KEY;
        thisRafflePrizeName = "";
        thisRaffleWinner = NULL_KEY;
        thisRaffleWinnerAccepted = "";
        thisRaffleEntrants = [];
        llSay(0, "The raffle is over!  Thank you for attending!");

    } else {

        //  compute the timer value.  if < 5, set it to 5.
        float timer_value = runningRaffleInterval - llGetTime();
        if (timer_value < 30.0)
        {
            timer_value = 30.0;
        }
        llSetTimerEvent(timer_value);

        //  initialize raffle params.
        thisRaffleWinner = NULL_KEY;
        thisRafflePrize = NULL_KEY;
        thisRafflePrizeName = "";

        //  announce the raffle.
        if (timer_value < 120)
        {
            llSay(0, "The next raffle is coming up!");
        } else {
            llSay(0, "The next raffle will be in " + (string)(llFloor(timer_value / 60.0)) + " minutes.");
        }

    }
}

chooseWinner()
{

    integer nument = llGetListLength(thisRaffleEntrants);

    //  if no valid entrants, call raffleWinner(NULL_KEY) to give item back to owner.
    if (nument == 0)
    {
        raffleWinner(NULL_KEY);
    } else {

        //  pick a random person from the entrants.  Announce that they won.
        //  give them a dialog to allow them to decline the prize, and set a
        //  timer for the timeout.

        integer winner = llCeil(llFrand(nument)) - 1;

        thisRaffleWinner = llList2Key(thisRaffleEntrants, winner);
        llSay(0, "The winner is " + llKey2Name(thisRaffleWinner) + "!");
        llSetTimerEvent(raffleAcceptTimeout);
        llDialog(thisRaffleWinner, "Do you wish to accept the raffle prize " + thisRafflePrizeName + "?", [ "Yes", "No" ], PRIVATE_CHAT);

    }

}

default
{

    state_entry()
    {
        // turn off the timer
        llSetTimerEvent(0.0);

        // get permission to give money
        llRequestPermissions(llGetOwner(),PERMISSION_DEBIT    );

        // reset the running raffle parameters
        runningRaffleCount = 0;
        runningRaffleInterval = 0;
        runningRaffleEntrants = [];
        runningRaffleWinners = [];

        thisRafflePrize = NULL_KEY;
        thisRafflePrizeName = "";
        thisRaffleWinner = NULL_KEY;

        // turn volume detect off, then back on, to force collision_start events
        llVolumeDetect(FALSE);
        llSleep(0.1);
        llVolumeDetect(TRUE);

        // remove listeners and re-add them
        llListenRemove(runningRaffleListenerChat);
        llListenRemove(runningRaffleListenerPrivate);
        runningRaffleListenerChat = llListen(0, "", NULL_KEY, "");
        runningRaffleListenerPrivate = llListen(PRIVATE_CHAT, "", NULL_KEY, "");
    }

    on_rez(integer start_code)
    {
        // reset script
        llResetScript();
    }

    collision_start(integer total_number)
    {
        integer i;
        for (i=0; i<total_number; i++)
        {
            //  in order to be an avatar, the detected item's key must = the item's owner.
            if (llDetectedKey(i) == llDetectedOwner(i))
            {
                //  check if the detected person is already in Entrants.  if not, add them.
                if (llListFindList(runningRaffleEntrants, [ llDetectedKey(i) ]) == -1)
                {
                    runningRaffleEntrants = runningRaffleEntrants + [ llDetectedKey(i) ];
                }
            }
        }
    }

    collision_end(integer total_number)
    {
        integer i;
        for (i=0; i<total_number; i++)
        {
            //  remove the person from Entrants
            runningRaffleEntrants = remove_from_list(runningRaffleEntrants, [ llDetectedKey(i) ]);
        }
    }

    listen(integer channel, string name, key id, string msg)
    {

        // convert msg to lowercase
        msg = llToLower(msg);

        // on chat channel, listen for "autoraffle" commands.
        if ((channel == 0) && (id == llGetOwner()) && (llGetSubString(msg, 0, 10) == "autoraffle "))
        {

            if (msg == "autoraffle stop")
            {

                //  turn autoraffle off by setting the runningRaffleCount to 0 and calling nextRaffle()
                runningRaffleCount = 0;
                nextRaffle();

            } else if (msg == "autoraffle list")
            {

                //  generate comma-separated list of entrants with 'and' between last two
                integer i;
                integer num;
                string entrants = "";
                num = llGetListLength(runningRaffleEntrants);
                for (i=0; i<num; i++)
                {
                    string name = llKey2Name(llList2Key(runningRaffleEntrants, i));
                    if (i == 0)
                    {
                        entrants = name;
                    } else if (i == num - 1)
                    {
                        if (i > 1)
                        {
                            entrants = entrants + ",";
                        }
                        entrants = entrants + " and " + name;
                    } else {
                        entrants = entrants + ", " + name;
                    }
                }
                llSay(0, "The current raffle entrants are " + entrants);

            } else if (msg == "autoraffle list winners")
            {

                //  generate comma-separated list of entrants with 'and' between last two
                integer i;
                integer num;
                string winners = "";
                num = llGetListLength(runningRaffleWinners);
                for (i=0; i<num; i++)
                {
                    string name = llKey2Name(llList2Key(runningRaffleWinners, i));
                    if (i == 0)
                    {
                        winners = name;
                    } else if (i == num - 1)
                    {
                        if (i > 1)
                        {
                            winners = winners + ",";
                        }
                        winners = winners + " and " + name;
                    } else {
                        winners = winners + ", " + name;
                    }
                }
                llSay(0, "The raffle winners so far have been " + winners);

            } else if (msg == "autoraffle reset")
            {

                //  reset script
                llResetScript();

            } else if ((msg == "autoraffle start") ||
                       (llGetSubString(msg, 0, 16) == "autoraffle start "))
            {

                // split message into params, set interval and count,
                // and call nextRaffle()
                list params = llParseString2List(msg, [" "], []);
                integer npar = llGetListLength(params);
                if (npar > 2)
                {
                    runningRaffleInterval = llList2Integer(params, 2);
                } else {
                    runningRaffleInterval = 0;
                }
                if (npar > 3)
                {
                    runningRaffleCount = llList2Integer(params, 2);
                } else {
                    runningRaffleCount = llGetInventoryNumber(INVENTORY_OBJECT);
                }
                llResetTime();
                nextRaffle();

            }
        }

        if ((channel == PRIVATE_CHAT) && (id == thisRaffleWinner))
        {

            // on the private chat, set the Accepted string and reset
            // the timer to go off as quickly as possible
            thisRaffleWinnerAccepted = msg;
            llSetTimerEvent(0.1);

        }

    }

    timer()
    {

        // unset the timer
        llSetTimerEvent(0.0);

        // if we don't have a winner, then we're still selecting one.
        if (thisRaffleWinner == NULL_KEY)
        {

            // if we don't have a prize key, then we need to announce it.
            if (thisRafflePrize == NULL_KEY)
            {
                // reset the time so the next raffle is based on this time.
                llResetTime();

                // if we don't have any entrants, then skip this raffle attempt
                if (llGetListLength(thisRaffleEntrants) == 0)
                {

                    nextRaffle();

                } else {

                    // if we have no items, let the raffle owner know via IM
                    integer n = llGetInventoryNumber(INVENTORY_OBJECT);
                    if (n == 0)
                    {

                        llInstantMessage(llGetOwner(), llGetObjectName() +
                            ": No items left to raffle!");
                        nextRaffle();

                    } else {

                        n = llCeil(llFrand(n)) - 1;
                        thisRafflePrizeName = llGetInventoryName(INVENTORY_OBJECT, n);
                        thisRafflePrize = llGetInventoryKey(thisRafflePrizeName);
                        llSetTimerEvent(10.0);
                        llSay(0, "Now raffling: " + thisRafflePrizeName);

                    }
                }

            } else {

                // we have a prize key, find a winner.
                thisRaffleEntrants = runningRaffleEntrants;
                chooseWinner();
            
            }
        } else {

            //  we have a winner.  therefore they've already been offered
            //  the win dialog.  if they accept, call raffleWinner(); otherwise,
            //  remove them from thisRaffleEntrants and call chooseWinner() again.
            if (thisRaffleWinnerAccepted == "yes")
            {
                raffleWinner(thisRaffleWinner);
            } else {
                llSay(0, llKey2Name(thisRaffleWinner) + " did not accept the raffle prize.");
                thisRaffleEntrants = remove_from_list(thisRaffleEntrants, [ thisRaffleWinner ]);
                chooseWinner();
            }
        }

    }

}


////////////////////////////////////////////////////////////////////////
//
//  Auto-Raffler version 1.0
//  by Neo Rebus
//  Copyright (c) 2004 by Johnson Earls
//  All Rights Reserved
//
//  Permission to Use and Redistribute
//
//  Permission to use and redistribute the Auto-Raffler code, with or
//  without modifications, is granted under the following conditions:
//
//  + All redistributions must include this copyright notice and license.
//  + All redistributions must give credit to the author, by real name
//    (Johnson Earls) and by SL name (Neo Rebus).  If distributed in a
//    modified form, credit must still be given to Neo Rebus (Johnson
//    Earls) as the original author.
//  + All redistributions *should* include the setup information at the
//    beginning of the script.
//
////////////////////////////////////////////////////////////////////////// END //
