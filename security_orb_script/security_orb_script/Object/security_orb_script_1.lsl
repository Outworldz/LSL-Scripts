// :CATEGORY:Security
// :NAME:security_orb_script
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:02
// :ID:733
// :NUM:1001
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// security orb script.lsl// A better script is at <a href="http://www.outworldz.com/cgi/freescripts.plx?ID=1674">http://www.outworldz.com/cgi/freescripts.plx?ID=1674 </a> by  mangowylder
// :CODE:

key second = NULL_KEY; // fill in a second key if you want

string active = "deactive";
float range = 25.0; // Range we will be scanning for for persons to check if they are on the whitellist

key nrofnamesoncard; // Some variables used to collect all the data from the notecard
integer nrofnames;
list names;
list keynameoncard;




default // We use the default state to read the notecard. 
{
    state_entry()
    {
          llOwnerSay("Startup state reading whitelist notecard");
          nrofnamesoncard = llGetNumberOfNotecardLines("whitelist"); // Triggers the notecard reading by getting the numer of lines in the notecard
    }
    
    on_rez (integer param)
    {
        llResetScript();   
    }
    
    dataserver (key queryid, string data){
        
        if (queryid == nrofnamesoncard) 
        {
            // When we receive the number of lines in the notecard we do llGetNotecardLine for each line to get the contents   
            nrofnames = (integer) data;      
            llOwnerSay("Found "+(string)nrofnames+ " names in whitelist.");
            
            integer i;
            for (i=0;i < nrofnames;i++){
               keynameoncard += llGetNotecardLine("whitelist", i);
            }    
        } else 
        {
            integer listlength;
            listlength = llGetListLength(keynameoncard);
            integer j;
            for(j=0;j<listlength;j++) {
                if (queryid == (key) llList2String(keynameoncard,j))
                { // after checking if this really was an answer to one of our llGetNotecardLines calls (checking the keys we stored earlier)
                  // We add the name to our names list. Which we will use in a later state.
                    llOwnerSay("Name added to whitelist: "+data);
                    names += data;
                }
            }
        }
          
        if (llGetListLength(names) == nrofnames)
        {
            // If we have read all the names (just as many names as there where notecard lines). We switch to our next state "start"
            // This state will do the actual work
            llOwnerSay ("Done with reading notecard. Starting script now");
            state start;
        }    
        

            
    }
    
           
}
state start
{
    state_entry ()
    {
        // This is where we enter our state. We start 2 listeneres. One for our owner and one for our second owner..
        llListen(9, "", llGetOwner(), "");   
        llListen(9, "", second, "");
        llSensorRepeat("", NULL_KEY, AGENT, range, PI, 5.0); // We also start scanning for people in it's vincinity. This scan scans for AGENS (avatars), in a range we determinded above (first few lines). And PI means a full circle around us. In theory you could just scan parts of it.
    }
    
    on_rez(integer param)
    {
        llResetScript();
    }
    
    listen(integer channel, string name, key id, string message) 
    { // This is our listen event. Here we receive all commands to control the orbs behaviour.
        if (message == "activate") // Starts the orb
        {
            active = "active";
            llOwnerSay("Activated");
        }
        if (message == "deactivate") // Stops the orb
        {
            active = "deactive";
            llOwnerSay("Deactivated");
        }
        if (message == "reset") // Resets the script
        {
            llResetScript();
        }
        if (llGetSubString(message,0,4) == "range"){ // If the command was range. We extract the new range from the command. Stop the sensor and start it again with the new range.
            range = (float) llGetSubString(message,6,-1);
            llSensorRemove();
            llSensorRepeat("", NULL_KEY, AGENT, range, PI, 5.0);
            llOwnerSay("Changed range to: "+(string) range);
        }
    }
    
    sensor(integer nr)
    { // Here is where all people found in its vincinity are returned.
        
        if (active == "active") // first we make sure the orb is active before we continue
        {
            integer i;
            for (i = 0; i < nr; i++) //Here we start to loop throug all persons we found. We do this one by one.
            {
                string found = "no";
                
                string nametotest = llDetectedName(i);
                integer j;
                for (j = 0; j < llGetListLength(names); j++) // We scan through the list of names to see if this person is whitelisted
                {
                    if (llList2String(names, j) == nametotest){  
                    found = "yes"; // When found we set found to true.
                    } 
                }  
                if (found == "no" && llOverMyLand(llDetectedKey(i)) && (llDetectedKey(i) != llGetOwner())) // When the person has not been found we start to check if this person is on our land. And on popuar reques we will never kick the owner ;)
                {
                    llSay(0, "You will be ejected from this land in 10 seconds. You are on ground you should not be on."); // Let's notify this user that he has a few seconds to leave
                    llSleep(10); // Wait the time we gave him to leave
                    if (llOverMyLand(llDetectedKey(i))) // Ok let's see if he has left.
                    { // If he is still on lets say BYE to him, and tell the owner and second owner someone is kicked off the land
                        llSay(0, "BYE!");
                        llInstantMessage(llGetOwner(), "Ejecting from our home: "+llDetectedName(i));
                        if (second != NULL_KEY)
                        {
                            llInstantMessage(second      , "Ejecting from our home: "+llDetectedName(i));
                        }
                        llEjectFromLand(llDetectedKey(i)); //And finaly we really kick him off
                    }
                } 
            }
        }
    }
        
}// END //
