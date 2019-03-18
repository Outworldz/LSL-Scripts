// :CATEGORY:Updater
// :NAME:Product_Updater
// :AUTHOR:Mulligan Silversmith
// :KEYWORDS:
// :CREATED:2011-07-05 15:50:25.133
// :EDITED:2014-02-24
// :ID:660
// :NUM:900
// :REV:1.1
// :WORLD:Second Life
// :DESCRIPTION:
// Client: Check for update when rezzed. 
// :CODE:

// mods by Fred Beckhusen (Ferd Frederix) to make it work.
// wrong params passed by caller, did not match server
// version should be a <, not a != and be floats, not strings


string server = "Server Key";// The Server ID Key... Get it from the server! 
float version = 1.0;  // The version of the object at the time! Don't forget to change when you update! 
string password = "Your Password"; //Same password seen in the server script! 

Checkupdate() {     
	
    llOwnerSay("Looking for update..");

    // Subject is the Owner Key to give the update to
    // Body is the password ^ Version strings.
	llEmail((string)server+"@lsl.secondlife.com", (string) llGetOwner(),password + "," + (string) version); 
} 

default {     
	state_entry()     
	{         
	    Checkupdate();     
    }

    on_rez(integer p)
    {
        Checkupdate();                 
    }
 }
