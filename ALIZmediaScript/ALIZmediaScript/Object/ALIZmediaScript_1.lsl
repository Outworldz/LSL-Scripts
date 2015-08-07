// :CATEGORY:Tip Jar
// :NAME:ALIZmediaScript
// :AUTHOR:Ali Virgo
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:47
// :ID:26
// :NUM:36
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// ALIZmediaScript.lsl
// :CODE:

list amounts = [    10,20,25,30,40,50,100,200]; // Up to 12 amounts - must be integer, no commas or periods.
string d_msg = "This is donation If you can, please donate to  Ali Virgo                                                                                                                                                                                               "; // Dialog message.
key payee = "34ad4985-bcc7-4f93-a65e-6ecd87c935cd"; // Insert your key here. (I will have provided a script that gives you your key.)

// =======================================================
// == Don't worry about here down if you don't want to. ==
// =======================================================

// Other globals
list amt_string = [];
string owner = "";
integer lhan;

integer don_amt = 0;

list stringify(list amt)
{
    integer n = llGetListLength(amt);
    integer i;
    list temp = [];
    for(i=0; i<n; i++)
    {
        temp += "L$" + (string)llList2Integer(amt,i);
    }
    return temp;
}

default
{
    state_entry()
    {
        owner = llKey2Name(llGetOwner());
        amt_string = stringify(amounts);
        lhan = llListen(990099, "", llGetOwner(), "");
        llDialog(llGetOwner(), d_msg, amt_string, 990099);
        llSetTimerEvent(300);
    }
    
    on_rez(integer n)
    {
        llResetScript();
    }
    
    listen(integer chan, string name, key id, string msg)
    {
        llListenRemove(lhan);
        integer index = llListFindList(amt_string, [msg]);
        if ( index > -1 ) // valid
        {
            don_amt = llList2Integer(amounts, index);
            llRequestPermissions(llGetOwner(), PERMISSION_DEBIT);
        }
    }
    
    run_time_permissions(integer perm)
    {
        if( perm & PERMISSION_DEBIT )
        {
            llOwnerSay("Processing donation... please wait!");
            llGiveMoney(payee, don_amt);
            llInstantMessage(payee, owner + " has donated L$" + (string)don_amt + ".");
            llOwnerSay("Thank you for your donation!");
        }
        else
        {
            llOwnerSay("Thanks for considering a donation!");
        }
    }
    
    timer()
    {
        llListenRemove(lhan);
        llOwnerSay("Thanks for considering a donation!");
    }
}
// END //
