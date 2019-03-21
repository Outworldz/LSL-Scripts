// :CATEGORY:Updater
// :NAME:Product_Updater
// :AUTHOR:Mulligan Silversmith
// :KEYWORDS:
// :CREATED:2011-07-05 15:50:25.133
// :EDITED:2014-02-24
// :ID:660
// :NUM:899
// :REV:1.1
// :WORLD:Second Life
// :DESCRIPTION:
// Server
// :CODE:

// mods by Fred Beckhusen (Ferd Frederix) to make it work.
// wrong params passed by caller, diod not match server
// version should be a <, not a != and be floats, not strings
// sped up processing
// V 1.2 added message that your product is up to date


// IMPORTANT NOTE: Do not remove the prim from the world and re-rez, as you will be unable to send updates.
// The UUID will change and that means no more updates can be sent to any previous clients.

string password = "Your Password"; //This is the password for your server so others cannot get updates that haven't paid for them
//  NOTE: This password needs to be the same on client!

float  version = 1.0; //This is to give out updates only when needed. Best start off at 1.0 then go up

//Edit at your own risk!//

default
{
    state_entry()
    {
        llSetTimerEvent(10);        // go slow. no need for speed at this stage
        llSay(0,"Put this key in all clients: " + (string)llGetKey());
        llSay(0,"Do Not take and rerez this server, EVER,  if you wish to give updates to those clients");    
    }
    email(string time, string address, string subject,string message,integer num_left)
    {   
        key requestorKey = (key) subject;
        message = llDeleteSubString(message,0,llSubStringIndex(message, "\n\n") + 1);
        list messagelist = llCSV2List(message);

        string TheirPassword = llList2String(messagelist,0);    // first param 
        float TheirVersion = (float) llList2String(messagelist,1); // second
        string ItemToGive = llGetInventoryName(INVENTORY_OBJECT,0);
        if( (TheirPassword  == password) && TheirVersion < version)
        {   
            llOwnerSay("Updating  " + address + " with " + ItemToGive); // This will give you the key of person looking for update!
            llGiveInventory(requestorKey, ItemToGive);    
            llInstantMessage(requestorKey,"Your version of " + ItemToGive + " is old, sending you a new one.");
        }
        else if( (TheirPassword  == password) && TheirVersion >= version)
        {
            llInstantMessage(requestorKey,"Your version of " + ItemToGive + " is up to date.");
        }
    


        
        // if more emails have arrived, go ahead and process them now
        if (num_left)
            llGetNextEmail("","");// This is use to keep checking for emails!
            
    }
    timer()
    {
        llGetNextEmail("","");// This is use to keep checking for emails!      
    }
      

}
