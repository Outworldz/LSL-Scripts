// :CATEGORY:Rental
// :NAME:No_Money_Rental_Script
// :AUTHOR:Ferd Frederix
// :CREATED:2013-04-03 13:53:53.560
// :EDITED:2013-09-18 15:38:58
// :ID:557
// :NUM:761
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// User can touch the sign and claim  land for a set period.//  You can force them to reclaim every so often, set a grace period, and enforce a number of prims.// // You need some textures, "land available", "Land is rented", and so on. See the details in the user configuarble section of the script.
// :CODE:

// No Money Rental (Vendor).lsl

// User configurable variables:

integer debug = FALSE;    // set to TRUE to see debug info

// Put this in the Description of the sign prim or you will get these by default
// 1,7,100,1,3,1
// These are PERIOD in days, MAXPERIOD in days, PRIMMAX , IS_RENEWABLE, RENTWARNING ,GRACEPERIOD

// PERIOD == 1 day
// MAXPERIOD is set to 7 days, that is as long as they can lease, if IS_RENEWABLE is 0
// PRIMMAX is set to 100 prims, aghain, this is up to you. The script does not enforece prim limits.
// IS_RENEWABLE is set to 1, or TRUE, so they can renew, or set to 0, they cannot renew the same plot.
// RENTWARNING is number of days before this claim expires, when a message is sent via IM to reclaim (if IS_RENEWABLE)
// GRACEPERIOD is number of days allowed to miss claiming before it expires

string  initINFO = "0.5,1,100,0,1,1"; // Default config info if you didn't change the description when this script is first executed
// Debug config info, 5 minutes per claim, 10 minutes max, 100 prims, 2 minute warning, grace period 1 minutes
//string  debugINFO = "0.00347222,0.00694455,100,1,0.00138889, 0.00138889";  //fast timers
string  debugINFO  = "0.041,1,100,1,0.0104,1"; // Default config info if you didn't change the description when this script is first executed


// Uses several textures that need to be made and put in the prims inventory: 
string lease_ex = "lease_ex";          // lease is expired
string lease_large = "lease_large";     // leased signage, large size
string lease_busy = "lease_busy";       // busy signage
string leased = "leased";               // leased  - in use
   
vector FULL_SIZE = <1.5,.375,1.5>;        // the signs size when unrented
vector SMALL_SIZE = <.25,.25,.25>;        // the signs size when rented (it will shrink)
string blank_texture = "5748decc-f629-461c-9a36-a35a221fe21f";  //the UUID of a blank sign, for SL only, change to a blank white texture for OpenSim

//
// don't muck below this, code begins.
//
// The  Description ( config info) of the sign is stored into these variables:

float PERIOD;     // DAYS  lease is claimed
integer PRIMMAX;    // number of prims
float MAXPERIOD;  // maximum length in days
float RENTWARNING ; //Day allowed to renew earlier
float GRACEPERIOD ; // Days allowed to miss payment
   
list my_data;
integer MY_STATE = 0;  // 0 is unleased, 1 = leased
string LEASER = "";    // name of lessor
key LEASERID;          // their UUID
 
integer LEASED_UNTIL; // unix time stamp
integer IS_RENEWABLE = FALSE; // can they renew?
integer DAYSEC = 86400;         // a constant
integer SENT_WARNING = FALSE;    // did they get an im?
integer SENT_PRIMWARNING = FALSE;    // did they get an im about going over prim count?
integer listener;    // ID for active listener
key touchedKey ;     // the key of whoever touched us last (not necessarily the renter)


DEBUG(string data)
{
    if (debug)
        llOwnerSay("DEBUG: " + data);
}

integer dialogActiveFlag ;    // true when we have up a dialog box, used by the timer to clear out the listener if no response is given
dialog()
{
    llListenRemove(listener);
    integer channel = llCeil(llFrand(1000000)) + 100000 * -1; // negative channel # cannot be typed
    listener = llListen(channel,"","","");
    llDialog(touchedKey,"Do you wish to claim this parcel?",["Yes","-","No"],channel);
    llSetTimerEvent(30);
    dialogActiveFlag  = TRUE;
}

string get_rentalbox_info()
{
    return llGetRegionName()  + " @ " + (string)llGetPos() + " (Leaser: \"" + LEASER + "\", Expire: " + timespan(LEASED_UNTIL - llGetUnixTime()) + ")";   
}

string timespan(integer time)
{
    integer days = time / DAYSEC;
    integer curtime = (time / DAYSEC) - (time % DAYSEC);
    integer hours = curtime / 3600;
    integer minutes = (curtime % 3600) / 60;
    integer seconds = curtime % 60;
    
    return (string)llAbs(days) + " days, " + (string)llAbs(hours) + " hours, "
        + (string)llAbs(minutes) + " minutes, " + (string)llAbs(seconds) + " seconds";
    
}

load_data()
{
    integer len;
    my_data = llCSV2List(llGetObjectDesc());

    if (llStringLength(llGetObjectDesc()) < 5) // SL does not allow blank description
    {
        my_data = llCSV2List(initINFO);
    }
    else if (debug)
    {
        my_data = llCSV2List(debugINFO);    // 5 minute fast timers
    }
     
    len = llGetListLength(my_data);
   
    PERIOD = (float) llList2String(my_data,0);
   
    MAXPERIOD = (float) llList2String(my_data,1);
   
    PRIMMAX = (integer) llList2String(my_data,2);
   
    IS_RENEWABLE = (integer) llList2String(my_data, 3);

    RENTWARNING = (float) llList2String(my_data, 4);

    GRACEPERIOD = (float) llList2String(my_data, 5);
   
    MY_STATE = (integer) llList2String(my_data, 6);
   
    LEASER = llList2String(my_data, 7);
   
    LEASERID = (key) llList2String(my_data, 8);
   
    LEASED_UNTIL = (integer) llList2String(my_data, 9);
   
    SENT_WARNING = (integer) llList2String(my_data, 10);

}

save_data()
{
    DEBUG("Data saved in description");
    my_data =  [(string)PERIOD, (string)MAXPERIOD, (string)PRIMMAX, (string)IS_RENEWABLE, (string) RENTWARNING, (string) GRACEPERIOD, (string)MY_STATE, (string)LEASER, (string) LEASERID,  (string)LEASED_UNTIL, (string)SENT_WARNING  ];
    llSetObjectDesc(llList2CSV(my_data));
    initINFO = llList2CSV(my_data);   // for debugging in LSL Editor.
    debugINFO = initINFO;  // for debugging in fast mode
   
    load_data() ;    // to print it in case of debug
}

default
{
    state_entry()
    {
        load_data();  
        llSetScale(SMALL_SIZE);   
        llSetTexture(lease_ex,ALL_SIDES);
        llOwnerSay("Click this rental box to activate after configuring the DESCRIPTION.");  
        llSetText("DISABLED",<0,0,0>, 1.0);
    }
    
    on_rez(integer start_param)
    {
        load_data();
    }
    
    touch_start(integer total_number)
    {
        if (llDetectedKey(0) == llGetOwner())
        {
            load_data();

            llSay(0,"Activating...");
            if (MY_STATE == 0)
                state unleased;
            else if (MY_STATE == 1)
                state leased;
        }
    }
}

state unleased
{
    state_entry()
    {
        DEBUG("state unleased");
        load_data();
        if (MY_STATE !=0 || PERIOD == 0)
        {
            DEBUG("MY_STATE:" + (string) MY_STATE);
            DEBUG("PERIOD:" + (string) PERIOD);
            DEBUG("IS_RENEWABLE:" + (string) IS_RENEWABLE);
            llOwnerSay("Returning to default. Data is not correct.");
            state default;
        }
       
        llSetScale(FULL_SIZE);

        //Blank texture
        llSetTexture(blank_texture,ALL_SIDES);

        llSetTexture(lease_large,1);
        llSetTexture(lease_large,3);
        llOwnerSay("Lease script is unleased");
        llSetText("",<1,0,0>, 1.0);
        
    }
    
    listen(integer channel, string name, key id, string message)
    {
        dialogActiveFlag = FALSE;
        llSetTimerEvent(0);
        llListenRemove(listener);

        load_data();
       
        if (message == "Yes")
        {
            llSay(0,"Thanks for claiming this spot! Please wait a few moments...");
            MY_STATE = 1;
            LEASER = llKey2Name(touchedKey);
            LEASERID = touchedKey;
            LEASED_UNTIL = llGetUnixTime() + (integer) (DAYSEC * PERIOD);
            DEBUG("Remaining time:" +  timespan(llGetUnixTime()-LEASED_UNTIL));
           
            SENT_WARNING = FALSE;
            save_data();
            llInstantMessage(llGetOwner(), "NEW CLAIM -" +  get_rentalbox_info());
            state leased;
        }
    }
    
    touch_start(integer total_number)
    {
        DEBUG("touch event in unleased");
        load_data();
        llSay(0,"Claim Info");
       
        llSay(0, "Available for "  + (string)PERIOD + " days ");
        llSay(0, "Initial Min. Lease Time: " + (string)PERIOD  + " days");
        llSay(0, "Max Lease Length: " + (string)MAXPERIOD + " days");
        llSay(0, "Max Prims: " + (string)PRIMMAX);

        touchedKey = llDetectedKey(0);
        llGiveInventory(touchedKey,llGetInventoryName(INVENTORY_NOTECARD,0));
        dialog();
    }

    // clear out the channel listener, the menu timed out
    timer()
    {
        dialogActiveFlag = FALSE;
        llListenRemove(listener);
    }
}

state leased
{
    state_entry()
    {
        DEBUG("Leased mode");
        DEBUG((string)llGetUnixTime());
       
        load_data();
        llSetScale(SMALL_SIZE);    
        llSetTexture(lease_busy,ALL_SIDES);
        llSetText("",<1,0,0>, 1.0);
        if (MY_STATE != 1 || PERIOD == 0 || LEASER == "")
        {
            DEBUG("MY_STATE:" + (string) MY_STATE);
            DEBUG("PERIOD:" + (string) PERIOD);
            DEBUG("LEASER:" + (string) LEASER);
           
            MY_STATE = 0;
            save_data();           
            llOwnerSay("Returning to unleased. Data was not correct.");
            state unleased;
        }

        DEBUG("Remaining time:" +  timespan(llGetUnixTime()-LEASED_UNTIL));

            llSetTimerEvent(1); //check now
    }
    
    listen(integer channel, string name, key id, string message)
    {
        DEBUG("listen event in leased");
        dialogActiveFlag = FALSE;
        if (message == "Yes")
        {
            load_data();
            if (MY_STATE != 1 || PERIOD == 0 || LEASER == "")
            {
                DEBUG("MY_STATE:" + (string) MY_STATE);
                DEBUG("PERIOD:" + (string) PERIOD);
                DEBUG("LEASER:" + (string) LEASER);

                MY_STATE = 0;
                save_data();
                llSay(0,"Returning to unleased. Data is not correct.");
                state unleased;
            }
            else if (IS_RENEWABLE)
            {
                integer timeleft = LEASED_UNTIL - llGetUnixTime();

                DEBUG("Remaining time:" +  timespan(llGetUnixTime()-LEASED_UNTIL));
                DEBUG("DAYSEC:" + (string) DAYSEC);
                DEBUG("timeleft:" + (string) timeleft);
                DEBUG("MAXPERIOD:" + (string) MAXPERIOD);

                if (DAYSEC + timeleft > MAXPERIOD * DAYSEC)
                {
                    llSay(0,"Sorry, you can not claim more than the max time");
                }
                else
                {
                    DEBUG("Leased");
                    SENT_WARNING = FALSE;
                    LEASED_UNTIL += (integer) PERIOD;
                    DEBUG("Leased until " + (string)LEASED_UNTIL );
                    save_data();
                    llSetScale(SMALL_SIZE);
                    llSetTexture(leased,ALL_SIDES);
                    llSetText("",<1,0,0>, 1.0);
                    llInstantMessage(llGetOwner(), "Renewed: " + get_rentalbox_info());
                }
            }
            else
            {
                llSay(0,"Sorry you can not renew at this time.");
            }
        }
    }
    
    timer()
    {
        if (dialogActiveFlag)
        {
            dialogActiveFlag = FALSE;
            llListenRemove(listener);
            return;
        }
       
       
        if(!debug)
            llSetTimerEvent(900); //15 minute checks
        else
            llSetTimerEvent(30); // 30  second checks for
       
        DEBUG("timer event in leased");
       
        load_data();
       
        if (MY_STATE != 1 || PERIOD == 0 || LEASER == "")
        {
            DEBUG("MY_STATE:" + (string) MY_STATE);
            DEBUG("PERIOD:" + (string) PERIOD);
            DEBUG("LEASER:" + (string) LEASER);

            MY_STATE = 0;
            save_data();
            llSay(0,"Returning to unleased. Data is not correct.");
            state unleased;
        }

        integer count = llGetParcelPrimCount(llGetPos(),PARCEL_COUNT_TOTAL, FALSE);
       
        if (count -1  > PRIMMAX && !SENT_PRIMWARNING) // no need to countthe sign, too.
        {
            llInstantMessage(LEASERID, get_rentalbox_info() + " There are supposed to be no more than " + (string)PRIMMAX
                + " prims rezzed, yet there are "
                +(string) count + " prims rezzed on this parcel. Plese remove the excess.");
            llInstantMessage(llGetOwner(),  get_rentalbox_info() + " There are supposed to be no more than " + (string)PRIMMAX
                + " prims rezzed, yet there are "
                +(string) count + " prims rezzed on this parcel, warning sent to " + LEASER );
            SENT_PRIMWARNING = TRUE;
        } else {
            SENT_PRIMWARNING = FALSE;
        }
       


        DEBUG("Remaining time:" +  timespan(llGetUnixTime()-LEASED_UNTIL));
       
        if (IS_RENEWABLE)
        {

            DEBUG( (string) LEASED_UNTIL + " > " + (string) llGetUnixTime());
            
            DEBUG( "RENTWARNING * DAYSEC " + (string) (RENTWARNING * DAYSEC));
            
            if (LEASED_UNTIL > llGetUnixTime() && LEASED_UNTIL - llGetUnixTime() < RENTWARNING * DAYSEC)
            {
                DEBUG("Claim must be renewed");
                llSetTexture(lease_ex,ALL_SIDES);
                llSetText("Claim must be renewed!",<1,0,0>, 1.0);
            }
            else if (LEASED_UNTIL < llGetUnixTime()  && llGetUnixTime() - LEASED_UNTIL < GRACEPERIOD * DAYSEC)
            {
                if (!SENT_WARNING)
                {
                    DEBUG("sending warn");
                    llInstantMessage(LEASERID, "Your claim needs to be renewed, please touch the sign and claim it again! - " + get_rentalbox_info());
                    llInstantMessage(llGetOwner(), "CLAIM DUE - " + get_rentalbox_info());
                    SENT_WARNING = TRUE;
                    save_data();
                }
                llSetTexture(lease_ex,ALL_SIDES);
                llSetText("CLAIM IS PAST DUE!",<1,0,0>, 1.0);
            }
            else if (LEASED_UNTIL < llGetUnixTime())
            {
                DEBUG("expired");
                llInstantMessage(LEASERID, "Your claim has expired. Please clean up the space or contact the space owner.");  
                llInstantMessage(llGetOwner(), "CLAIM EXPIRED: CLEANUP! -  " + get_rentalbox_info());
                MY_STATE = 0;
                save_data();
                state default;
                
            }
        }   
        else if (LEASED_UNTIL < llGetUnixTime())
        {
            llInstantMessage(llGetOwner(), "CLAIM EXPIRED: CLEANUP! -  " + get_rentalbox_info());
            DEBUG("TIME EXPIRED. RETURNING TO DEFAULT");
            state default;
        }
    }
            
    touch_start(integer total_number)      
    {
        DEBUG("touch event in leased");
        load_data();
       
        if (MY_STATE != 1 || PERIOD == 0 || LEASER == "" )
        {
            DEBUG("MY_STATE:" + (string) MY_STATE);
            DEBUG("PERIOD:" + (string) PERIOD);
            DEBUG("LEASER:" + (string) LEASER);

            MY_STATE = 0;
            save_data();
            llSay(0,"Returning to unleased. Data is not correct.");
            state unleased;
        }
        
        llSay(0,"Space currently rented by " + LEASER);
        llSay(0,"Claim due in " + timespan(llGetUnixTime()-LEASED_UNTIL));

        // same as money
        if (llDetectedKey(0) == LEASERID && IS_RENEWABLE)
        {
            touchedKey = llDetectedKey(0);
           
         llGiveInventory(touchedKey,llGetInventoryName(INVENTORY_NOTECARD,0));   dialog();
        }

        // same as money
        if (llDetectedKey(0) == LEASERID && !IS_RENEWABLE)
        {
             llSay(0,"The parcel cannot be claimed again");
        }

       
       
    }
     
} 
