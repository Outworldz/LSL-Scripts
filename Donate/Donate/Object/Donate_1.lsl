// :CATEGORY:Money
// :NAME:Donate
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:51
// :ID:247
// :NUM:338
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Donate.lsl
// :CODE:

//Variables
integer randomDialogChannel;
integer donationAmount;
integer listenID;
key theirkey;  // place to save the guy that touched us's key

//Options

//  you need to add your key!!
key recepient = "93ffa6cc-e2c6-431c-b67c-54cdb7882265"; //Key for Fox, please add it here using the Key Prim script

default
{
    state_entry()
    {
        //Select a random dialog channel so we don't conflict with other scripts
        randomDialogChannel = -(integer)llFrand(2147483647);
    }
    on_rez(integer start_param)
    {
        //Always reset on rez
        llResetScript();
    }
    run_time_permissions(integer permissions)
    {
        if (permissions & PERMISSION_DEBIT)
        {
            //If we have received permissions to debit account, send money
            llGiveMoney(recepient, donationAmount);
            llSay(0,"Thank you very much for your donation!");
            llInstantMessage(recepient, llKey2Name(llGetOwner()) + " just donated L$" + (string)donationAmount + "  via the built-in donation option");
        }
        llResetScript(); //Reset the script to remove permission to debit account
    }
    
    touch_start(integer total_number)
    {
        theirkey = llDetectedKey(0);
    }

    
    listen(integer channel, string name, key id, string message)
    {
        donationAmount = (integer)message;
        
        //Process amount selected in dialog
        if (donationAmount > 0)
        {
            string gadget = llGetInventoryName(INVENTORY_NOTECARD,0);
            
            llOwnerSay("Requesting Permissions to send donation ...");
            llRequestPermissions(theirkey, PERMISSION_DEBIT);
        }
    }
    link_message(integer sender_num, integer num, string str, key id)
    {
        //Receive message from dialog script
        if (num == 324235353254)
        {
            llListenRemove(listenID);
            listenID = llListen(randomDialogChannel, "", theirkey, "");
            llDialog(theirkey, "Thank you for donating !\nPlease select the amount of L$ you would like to donate below...", ["10", "5", "1", "100", "50","25", "1000", "500", "250"], randomDialogChannel);
        }
    }
 
}
// END //
