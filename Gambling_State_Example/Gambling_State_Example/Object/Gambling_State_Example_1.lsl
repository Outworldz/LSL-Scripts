// :CATEGORY:Gambling
// :NAME:Gambling_State_Example
// :AUTHOR:Hank Ramos
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:53
// :ID:343
// :NUM:461
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Gambling State Example.lsl
// :CODE:

1//============================================================================
//Gambling Machine
//State Example
//by Hank Ramos
//============================================================================
//Copyright 2006 by Hank Ramos, All Rights Reserved
//You may use this script freely in your projects, but you are not licensed to
//distribute or redistribute this script in a free or sold pack of example LSL
//scripts or on it's own. This script is "open source" in that you are able to
//view and learn from it.  It is still copyrighted and is not in the public
//domain, therefore it may not be redistributed in it's current form.  Use it 
//as a learning example or as a template for your own scripting project.
//I sell these example scripts as a business, so please do not give these
//scripts away or sell them.
//============================================================================

//Variables
key playerID;
integer amountPaid;
integer winningAmount;

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
        if (permissions & PERMISSION_DEBIT)
        {
            llSay(0, "Initailized Successfully...");
            state waiting;
        }
    }
}

state waiting
{
    state_entry()
    {
        llSay(0, "Idle...");
    }
    money(key id, integer amount)
    {
        playerID = id;
        amountPaid = amount;
        state playing;        
    }
}

state playing
{
    state_entry()
    {
        //Do the gambling bit in this state
        
        //Determine if they are a winner or a loser
        //Half the time pay twice the bet
        //The other half, pay nothing.
        if (llFrand(1) >= 0.5)
        {
            winningAmount = amountPaid * 2;
            state winner;
        }
        else
        {
            state loser;
        }
    }
}

state winner
{
    state_entry()
    {
        
        llSay(0, "You won L$" + (string)winningAmount + "!");
        llGiveMoney(playerID, winningAmount);
        state waiting;
    }
}

state loser
{
    state_entry()
    {
        llSay(0, "Sorry, you lose.");
        state waiting;
    }
}
// END //
