// :CATEGORY:Donation Box
// :NAME:DONATION_BOX__Original_Version
// :AUTHOR:Nada Epoch
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:52
// :ID:248
// :NUM:339
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// DONATION BOX - Original Version by Nada Epoch and Friends.lsl
// :CODE:

//Keknehv Psaltery Updated Version of DONATION BOX By jean cook, ama omega, and nada epoch Debugged by YadNi Monde (LoL) Yea, that s a Bunch O Peeps =)

//Summary: The following script will make an object accept donations on your behalf.
//Usage: stick it on any object you own(my favorite is a top hat), and it will promptly display:
//"<your name>'s donation hat.
//Donate if you are so inclined."
//at which point anyone can right click on it and give you a tip. also, the script tells the donator thanks, and then tells you who donated how much
//also shows the total amount donated



integer totaldonated;
string owner;

default
{
    on_rez( integer sparam )
    {
        llResetScript();
    }
    state_entry()
    {
        owner = llKey2Name( llGetOwner() );
        llSetText( owner + "'s donation hat.\nDonate if you are so inclined!\n$0 Donated so far",<1,1,1>,1);
    }

    money(key id, integer amount)
    {
        totaldonated+=amount;
        llSetText( owner + "'s donation hat.\nDonate if you are so inclined!\n$" + (string)amount + " Donated so far",<1,1,1>,1);
        llInstantMessage(id,"Thanks for the tip!");
        llInstantMessage(owner,llKey2Name(id)+" donated $" + (string)amount);
    }
} // END //
