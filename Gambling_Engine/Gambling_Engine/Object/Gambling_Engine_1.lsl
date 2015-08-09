// :CATEGORY:Gambling
// :NAME:Gambling_Engine
// :AUTHOR:Hank Ramos
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:53
// :ID:342
// :NUM:460
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Gambling Engine.lsl
// :CODE:

1//Gambling Machine
//State Example
//by Hank Ramos
key playerID;
string lastWinner = "None";
integer potValue = 50;
float odds = 0.905; //Valid values are 0.50 to 0.99.  
integer moneyIn;
integer moneyOut;
integer counter;
integer maxLosses = 250;

display(string text)
{
    llSetText(text, <1,1,1>, 1);
}

default
{
    state_entry()
    {
        //Do some initialization here
        llRequestPermissions(llGetOwner(), PERMISSION_DEBIT);
    }
    run_time_permissions(integer permissions)
    {
        //Only wait for payment if the owner agreed to pay out money
        if (permissions)
        {
            llSay(0, "Initailized Successfully...");
            state waiting;
        }
    }
}
state broken
{
    state_entry()
    {
        display("Machine Malfunction.  Please Contact Owner");
    }
    touch_start(integer num_detected)
    {
        if (llDetectedKey(0) == llGetOwner())
        {
            llSay(0, "Resuming...");
            maxLosses += 50;
            state waiting;
        }
    }
}
state waiting
{
    state_entry()
    {
        string oddsString;
        
        oddsString = "1:" + (string)llRound(1/(1-odds));
        
        llSetColor(<0,0,1>, ALL_SIDES);
        display("Current Pot: L$" + (string)potValue + "\nPay L$10 to Play!\nOdds " + oddsString + "\nLast Winner: " + lastWinner);
        
        if ((moneyOut - moneyIn) > maxLosses)
        {
            state broken;
        }
        //llSetTimerEvent(300);
    }
    money(key id, integer amount)
    {
        if (amount == 10)
        {
            playerID = id;
            moneyIn += amount;
            state playing;        
        }
        else
        {
            llSay(0, "You must pay L$10 to play.  Refunding Money...");
            llGiveMoney(id, amount);
        }
    }
    touch_start(integer num_detected)
    {
        if (llDetectedKey(0) == llGetOwner())
        {
            llSay(0, "L$ Collected: " + (string)moneyIn);
            llSay(0, "L$ Dispensed: " + (string)moneyOut);
        }
    }
    timer()
    {
        //llSay(0, "Play to Win!  Only L$10 per play!  Current Pot is L$" + (string)potValue + "!");
    }
}

state playing
{
    state_entry()
    {
        counter = 0;
        display("Randomizing...");
        llLoopSound("Cosmic", 1);
        llSetTimerEvent(0.1);
    }
    timer()
    {
        counter += 1;
        llSetColor(<llFrand(1), llFrand(1), llFrand(1)>, ALL_SIDES);
        if (counter >= 80)
        {
            llSetTimerEvent(0);
            llStopSound();
            if (llFrand(1) >= odds)
            {
                state winner;
            }
            else
            {
                state loser;
            }
        }
    }
}

state winner
{
    state_entry()
    {      
        display("You won L$" + (string)potValue + "!");
        lastWinner = llKey2Name(playerID) + " L$" + (string)potValue;
        llSetColor(<0,1,0>, ALL_SIDES);
        llGiveMoney(playerID, potValue);
        moneyOut += potValue;
        potValue = 50;
        llSleep(5);
        state waiting;
    }
}

state loser
{
    state_entry()
    {
        display("Sorry, better luck next time...");
        llSetColor(<1,0,0>, ALL_SIDES);
        potValue += 4;
        llSleep(5);
        state waiting;
    }
}
// END //
