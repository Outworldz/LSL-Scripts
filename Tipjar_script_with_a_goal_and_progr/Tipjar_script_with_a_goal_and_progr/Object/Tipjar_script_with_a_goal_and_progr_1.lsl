// :CATEGORY:Tip Jar
// :NAME:Tipjar_script_with_a_goal_and_progr
// :AUTHOR:Angel Fluffy
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:07
// :ID:897
// :NUM:1273
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Tipjar script with a 'goal' and progress meter by Angel Fluffy.lsl
// :CODE:

//********************************************************
//This Script was pulled out for you by YadNi Monde from the SL FORUMS at http://forums.secondlife.com/forumdisplay.php?f=15, it is intended to stay FREE by it s author(s) and all the comments here in ORANGE must NOT be deleted. They include notes on how to use it and no help will be provided either by YadNi Monde or it s Author(s). IF YOU DO NOT AGREE WITH THIS JUST DONT USE!!!
//********************************************************







// CARP Donation box script. Written by Angel Fluffy, with credit to :
// Keknehv Psaltery, jean cook, ama omega, nada epoch, YadNi Monde
// for their work on the "DONATION box" script upon which it was based.
//
//Donation / Tipjar script with a 'goal' and progress meter (ideal for tracking tier)
//What it is : a donation box / tip jar script, that uses the concept of 'goals' and a progress meter to encourage people to donate (as people donate more when they can see the progress being made towards a set goal).
//
//Edit the config settings, drop in a prim, and pay it some money to find out how it works.
//
//In future, I intend to add a 'biggest donors' field to it which people can use to recieve a list of the top 5 donors when the prim is clicked on.
//
//
//CODE
string imtext = "I'm the __________ Donation Box! Please right click and pay me to donate, as this supports the __________ project and helps keep the place open for you!";
// this is the text sent to someone who clicks on the prim containing this script and who isn't the owner.

// first line of hover text above box (always constant)
string floaty = "__________ Donation Box\n";

// when total donated this month is less than monthlyneeded, display whatfunding_1 as the funding target,
// when it is more, display whatfunding_2. This allows you to show your donors when you have switched
// from funding your essential running costs to funding expansion. 
string whatfunding_1 = "Funding : __________ \n";
string whatfunding_2 = "Funding : __________ \n"; 

// name of the current month
// we *could* get this automatically, but changing the month automatically isn't as easy as it seems.
// This is a change I might make in a future version.
string thismonth = "October"; 

// How much are we trying to raise per month?
// The script displays a countdown in SETTEXT above the prim its in, counting down until this target is reached.
// After this target is reached, the countdown disappears, being replaced with a tally.
// The goal of this is to encourage people to donate by setting a clear goal they feel they can help achieve by donating.
integer monthlyneeded = 30000;


// These two variables define the starting numbers for how much has been donated across all time, and how much this month.
// These starting numbers will have the donations the script recieves in between each reset/save added to it,
// and the result displayed in float text over the top of the script.
// The first time you start accepting donations, you should set both of the numbers below to zero.
// When saving this script, you (the object owner) should touch the donation box object,
// which will then tell you how much has been donated in total and how much has been donated this month.
// Entering this information here before saving will allow you to preserve the 'state' of the script across edits/restarts.
integer totaldonated = 0;
integer monthdonated = 0;

// these settings are like the above, but save the 'last donor' information. You can set them to "" and 0 to clear saved info.
string lastdonor = "Taffy Tinlegs";
integer lastdonated = 0;

// this interval defines how long we wait between each reminder to donate broadcast to SAY (range=20m)
integer timer_interval = 3600;

// these settings determine what the 'default' donation amounts are.
// the buttons are the 'fast pay' buttons, the 'payfield' is the default amount in the text box.
list paybuttons = [50,200,400,800];
integer payfield = 100;


// these variables should be left undefined.
string owner; 
string otext;
integer mpercent;

integer updatemath() {
        float mpercentfloat = ((monthdonated * 100) / monthlyneeded);
        mpercent = (integer)mpercentfloat; 

 return 1;   
}

integer updatetext() {
        otext = floaty;

        if (mpercent >= 100) { 
            otext += whatfunding_2;
        } else {
            otext += whatfunding_1;
        }
        if (lastdonated > 0) {
            otext += "Last donation : L$" + (string)lastdonated + " by " + lastdonor +"\n";
        }
        if (mpercent >= 100) {
            otext += "We have raised L$"+(string)(monthdonated - monthlyneeded)+" for this, beyond our basic running costs of L$"+(string)monthlyneeded+" for "+thismonth+". \n";
            //otext += "The excess will go towards giving prizes and running special events!";
        } else {
            otext += "Our donors have contributed "+(string)mpercent+"% of our basic running costs ("+(string)monthdonated+"/"+(string)monthlyneeded+") for "+thismonth+".\n";
        }
        llSetText(otext,<1,1,1>,1);
 return 1;   
}
default
{
    on_rez( integer sparam )
    {
        llResetScript();
    }
    state_entry()
    {
        updatemath();
        updatetext();
        owner = llKey2Name( llGetOwner() );
        llSetPayPrice(payfield,paybuttons);
        llSetTimerEvent(timer_interval);
        llSay(0,"Script updated. Usually this is caused by the donation box owner updating the script.");
    }

    money(key id, integer amount)
    {
        totaldonated += amount;
        monthdonated += amount;
        lastdonor = llKey2Name(id);
        lastdonated = amount;
        updatemath();
        updatetext();
        llInstantMessage(id,"On behalf of everyone who uses this place, thank you for the donation!");
        llSay(0,(string)llKey2Name(id)+" donated L$" + (string)amount + ". Thank you very much for supporting us, it is much appreciated!" );
    }
    touch_start(integer num_detected){
        if (llDetectedKey(0) == llGetOwner()) {
            llOwnerSay("Reporting script status, because you are recognised as the owner of this donation box.");
            llOwnerSay("Current TOTAL donations across all time: L$"+(string)totaldonated);    
            llOwnerSay("Current TOTAL donations for this month: L$"+(string)monthdonated); 
        }  else {
            llInstantMessage(llDetectedKey(0),imtext); 
        }
    }
    timer() {
        integer premainder = 100 - mpercent;
        integer aremainder = monthlyneeded - monthdonated;
        if (mpercent < 100) {
            llSay(0,"We still need to meet the last "+(string)premainder+"% of our basic costs (L$"+(string)aremainder+") this month, to pay for land tier etc. Please consider donating to help us out!");
        }
        llSetTimerEvent(timer_interval);
    }
} // END //
