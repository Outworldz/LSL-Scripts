// :CATEGORY:Games
// :NAME:A_speedclick_game
// :AUTHOR:Nitsuj Kidd
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:47
// :ID:10
// :NUM:15
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Speed Click Game
// :CODE:
//A simple clicking game.
//By TSL Resident: Nitsuj Kidd
txt(string what)
{
    llSetText(what,<1,1,1>,1);
}
integer minus(integer one,integer two)
{
    return one - two;
}
key bist;
string playur;
key winner;
integer clicks;
key player;
integer time;
//////////////////////////////////////////////////////CLICKS///////////////////////////////////////////////////////////////////////////////
integer high = 50;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
string best = "Mr. Nobody";
default
{
    state_entry()
    {
        txt("Requesting permissions...");
        llSetPayPrice(PAY_HIDE, [1, PAY_HIDE, PAY_HIDE, PAY_HIDE]);
        llRequestPermissions(llGetOwner(),PERMISSION_DEBIT);
    }
    changed(integer c)
    {
        if(c && CHANGED_OWNER)
        {
            llResetScript();
        }
    }
    on_rez(integer p)
    {
        llResetScript();
    }
    run_time_permissions(integer p)
    {
        if(p && PERMISSION_DEBIT)
        {
            state active;
        }
        else
        {
            llRequestPermissions(llGetOwner(),PERMISSION_DEBIT);
        }
    }
}
state active
{
    state_entry()
    {
        llSetTouchText("Click!");
        txt("The clicking game\n Pay me 1L$ to play\nBest: "+best+" - Clicks: "+(string)high);
    }
    money(key giver, integer ammount)
    {
        
        if(ammount == 1)
        {
            time = 0;
            txt("The clicking game\n Current player: " + llKey2Name(giver));
            player = giver;
            llSetTimerEvent(10);
            clicks = 0;
        }
        if(ammount > 1)
        {
            integer change = minus(ammount,1);
            llGiveMoney(giver,change);
        }
    }
    touch_start(integer total_number)
    {
        if(llDetectedKey(0) == player)
        {
            playur = llKey2Name(player);
            clicks++;
            txt("The clicking game\n\n Current player: " + llKey2Name(player) + "\n Clicks: " + (string)clicks);
        }
    }
    timer()
    {
        {
            state check;
        }
    }
}
state check
{
    state_entry()
    {
        txt("Game over!\n " + playur + " had " + (string)clicks + " clicks!");
        player = NULL_KEY;
        llSleep(2);
        llSetTimerEvent(0);
        if(clicks>high)
        {
            txt("You got the best score!");
            llSleep(2);
            high = clicks;
            best = playur;
            bist = player;
            player = "";
            state active;
        }
        else
        {
            txt("You didn't get the high score!");
            llSleep(2);
            state active;
        }
        player = "";
        clicks = 0;
    }
}
