// :CATEGORY:Rental
// :NAME:Rental_Vendor
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:01
// :ID:696
// :NUM:950
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Rental (Vendor).lsl
// :CODE:
// mods on 1/10/2013 to fix this for inworldz 
//Put this in the Description of the prim:
// 100,1,7,100,1 
// These are RATE,PERIOD, MAXPERIOD, PRIMMAX, IS_RENEWABLE 

// RATE ==100 Lindens a day 
// PERIOD == 1 day
// MAXPERIOD is set to 7 days, that is as long as they can lease
// PRIMMAX is set to 100 prims 
// IS_RENEWABLE is set to 1, or TRUE, so they can renew

//Uses several textures that need to be made and put in the prims inventory:
//lease-ex - lease expired
//lease-large - leased signage
//lease-question - busy signage
//bayhill-question  - in use

list my_data; 
integer MY_STATE =0; 
string LEASER = ""; 
key LEASERID; 
integer RATE =0; 
integer PERIOD =0; //DAYS 
integer PRIMMAX =0; 
integer MAXPERIOD =0; 
integer CHANNEL = 192; 
integer CREDIT = 0; 
integer LEASED_UNTIL = 0; 
integer IS_RENEWABLE = FALSE; 
integer can_renew = FALSE; 
integer DAYSEC = 86400; 
integer SENT_WARNING = FALSE; 
integer RENTWARNING = 3; //Day allowed to renew earlier 
integer GRACEPERIOD = 3; // Days allowed to miss payment 
vector FULL_SIZE = <1.5,.375,1.5>; 
vector SMALL_SIZE = <.25,.25,.25>; 
integer INIT = FALSE; 

DEBUG(string data) 
{ 
    llOwnerSay("DEBUG: " + data); 
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
    len = llGetListLength(my_data); 
    RATE = (integer) llList2String(my_data,0); 
    PERIOD = (integer) llList2String(my_data,1); 
    MAXPERIOD = (integer) llList2String(my_data,2); 
    PRIMMAX = (integer) llList2String(my_data,3); 
    IS_RENEWABLE = (integer) llList2String(my_data, 4); 
    MY_STATE = (integer) llList2String(my_data, 5);      
    LEASER = llList2String(my_data, 6);   
    LEASERID = llList2Key(my_data, 7); 
    CREDIT = (integer) llList2String(my_data, 8); 
    LEASED_UNTIL = (integer) llList2String(my_data, 9); 
    SENT_WARNING = (integer) llList2String(my_data, 10); 
} 

save_data() 
{ 
    my_data =  [RATE,PERIOD, MAXPERIOD, PRIMMAX, IS_RENEWABLE, MY_STATE, LEASER, LEASERID, CREDIT, LEASED_UNTIL, SENT_WARNING]; 
    llSetObjectDesc(llList2CSV(my_data)); 
} 

default 
{ 
    state_entry() 
    { 
        if (!INIT) 
        { 
            llRequestPermissions(llGetOwner(),PERMISSION_DEBIT  ); 
            INIT = TRUE; 
        } 
        load_data();   
        llSetScale(SMALL_SIZE);    
        llSetTexture("lease-ex",ALL_SIDES); 
        llOwnerSay("Click this rental box to activate after configuring.");   
        llSetText("DISABLED",<0,0,0>, 1.0); 
    } 
     
    on_rez(integer start_param) 
    { 
        load_data(); 
    } 
     
    money(key giver, integer ammount) 
    { 
        llWhisper(0,"Unable to accept money right now"); 
        llGiveMoney(giver,ammount); 
    } 

    touch_start(integer total_number) 
    { 
        if (llDetectedKey(0) == llGetOwner()) 
        { 
            load_data(); 
            if (PERIOD == 0 || RATE ==0 || (!IS_RENEWABLE && LEASED_UNTIL < llGetUnixTime())) 
            { 
                llSay(0,"This space is not currently purchasble or requires configuration."); 
            } 
            else 
            { 
                llSay(0,"Activating..."); 
                if (MY_STATE == 0) 
                    state unleased; 
                else if (MY_STATE == 1) 
                    state leased; 
            } 
        } 
    } 
} 

state unleased 
{ 
    state_entry() 
    { 
        load_data(); 
        if (MY_STATE !=0 || PERIOD == 0 || RATE == 0 || !IS_RENEWABLE) 
        { 
            llOwnerSay("Returning to default. Data might not be correct."); 
            state default; 
        }     
        llSetScale(FULL_SIZE); 
        //Blank texture 
        llSetTexture("5748decc-f629-461c-9a36-a35a221fe21f",ALL_SIDES); 
        llSetTexture("lease-large",1); 
        llSetTexture("lease-large",3); 
        llOwnerSay("Lease script is active..."); 
        llSetText("",<1,0,0>, 1.0); 
         
    } 
     
    money(key giver, integer ammount) 
    { 
        load_data(); 
        if (ammount < RATE * PERIOD) 
        { 
            llSay(0,"Sorry, you didn't pay anough."); 
            llGiveMoney(giver, ammount); 
        } 
        else if (ammount > MAXPERIOD * RATE) 
        { 
            llSay(0,"Sorry, you payed more then the max allows."); 
            llGiveMoney(giver, ammount); 
        } 
        else 
        { 
            llSay(0,"Thanks for renting! Please wait a few moments..."); 
            MY_STATE = 1; 
            LEASER = llKey2Name(giver); 
            LEASERID = giver; 
            if ((ammount % RATE) != 0) 
            { 
                llSay(0,"oops, you overpaid. Here is a partial refund"); 
                llGiveMoney(giver,(ammount % RATE)); 
            } 
            CREDIT = (ammount - (ammount % RATE))/RATE; 
            LEASED_UNTIL = llGetUnixTime() + (CREDIT * DAYSEC); 
            SENT_WARNING = FALSE; 
            save_data(); 
            llInstantMessage(llGetOwner(), "NEW LEASE - $" +  (string)(ammount - (ammount % RATE)) + "L - " + get_rentalbox_info()); 
            state leased; 
        } 
         
    } 
     
    touch_start(integer total_number) 
    { 
        load_data(); 
        llSay(0,"Bay Hills Lease"); 
        //llSay(0,"Only $L" + (string)RATE + " per day"); 
        llSay(0, "Only $L" + (string)(RATE * PERIOD) + " for "  + (string)PERIOD + " days ($L" + (string)RATE + " per day)"); 
        llSay(0, "Initial Min. Lease Time: " + (string)PERIOD  + " days"); 
        llSay(0, "Max Lease Payment Length: " + (string)MAXPERIOD + " days"); 
        llSay(0, "Max Prims: " + (string)PRIMMAX); 
        llGiveInventory(llDetectedKey(0),llGetInventoryName(INVENTORY_NOTECARD,0)); 
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
        llSetTexture("lease-question",ALL_SIDES); 
        llSetText("",<1,0,0>, 1.0); 
        if (MY_STATE != 1 || PERIOD == 0 || RATE == 0 || LEASER == "" || CREDIT == 0) 
        { 
            MY_STATE = 0; 
            save_data(); 
            llOwnerSay("Returning to unleased. Data might not be correct."); 
            state unleased; 
        } 
        llSetTimerEvent(900); //15 minute checks      
                              
    } 
     
    money(key giver, integer ammount) 
    { 
        load_data(); 
        if (MY_STATE != 1 || PERIOD == 0 || RATE == 0 || LEASER == "" || CREDIT == 0) 
        { 
            MY_STATE = 0; 
            save_data(); 
            llSay(0,"Returning to unleased. Data might not be correct."); 
            llGiveMoney(giver,ammount); 
            state unleased; 
        } 
              
        if (llGetOwner() != giver && giver != LEASERID) 
        { 
            llSay(0,"Well thats nice that you want to pay this rent but only the leaser may do so."); 
            llGiveMoney(giver,ammount);     
        } 
         
        else if (IS_RENEWABLE || llGetOwner() == giver) 
        { 
             
            integer timeleft = LEASED_UNTIL - llGetUnixTime(); 
            integer curammount = (ammount - (ammount % RATE))/RATE; //Caculated sum after refund 
             
            if (((curammount * DAYSEC) + timeleft) > MAXPERIOD * DAYSEC) 
            { 
                llSay(0,"Sorry, you can not purchase more then the max time"); 
                llGiveMoney(giver,ammount); 
            } 
            //** 
            //** - Not going to punish anyone right now after they sigh up. let them pay day by day 
            //** 
            //else if (((curammount * DAYSEC) + timeleft) < PERIOD * DAYSEC) 
            //{ 
            //    llSay(0,"You have to pay anough to meet the min time"); 
            //    llGiveMoney(giver,ammount); 
            //} 
            else 
            { 
                 
                //Refund code 
                if ((ammount % RATE) != 0) 
                { 
                    llSay(0,"oops, you overpaid. Here is a partial refund"); 
                    llGiveMoney(giver,(ammount % RATE)); 
                } 
                CREDIT = curammount; 
                SENT_WARNING = FALSE; 
                LEASED_UNTIL += (curammount * DAYSEC); 
                save_data(); 
                llSetScale(SMALL_SIZE);     
                llSetTexture("bayhill-question",ALL_SIDES); 
                llSetText("",<1,0,0>, 1.0); 
                llInstantMessage(llGetOwner(), "LEASE CREDIT - $" +  (string) (curammount * RATE) + "L - " + get_rentalbox_info()); 
            }                         
        } 
        else 
        { 
            llGiveMoney(giver,ammount); 
            llSay(0,"Sorry you can not renew at this time."); 
        } 
         
    } 
     
    timer() 
    { 
        load_data(); 
        if (MY_STATE != 1 || PERIOD == 0 || RATE == 0 || LEASER == "" || CREDIT == 0) 
        { 
            MY_STATE = 0; 
            save_data(); 
            llSay(0,"Returning to unleased. Data might not be correct."); 
            state unleased; 
        } 
          
        if (IS_RENEWABLE) 
        { 
            if (LEASED_UNTIL > llGetUnixTime() && LEASED_UNTIL - llGetUnixTime() < RENTWARNING * DAYSEC) 
            { 
                llSetTexture("lease-ex",ALL_SIDES); 
                llSetText("Rent Due!",<1,0,0>, 1.0); 
            } 
            else if (LEASED_UNTIL < llGetUnixTime()  && llGetUnixTime() - LEASED_UNTIL < GRACEPERIOD * DAYSEC) 
            { 
                if (!SENT_WARNING) 
                { 
                    llInstantMessage(LEASERID, "Your rent is due! - " + get_rentalbox_info()); 
                    llInstantMessage(llGetOwner(), "RENT DUE - " + get_rentalbox_info()); 
                    SENT_WARNING = TRUE; 
                    save_data(); 
                } 
                llSetTexture("lease-ex",ALL_SIDES); 
                llSetText("RENT PAST DUE!",<1,0,0>, 1.0); 
            } 
            else if (LEASED_UNTIL < llGetUnixTime()) 
            { 
                llInstantMessage(LEASERID, "Your lease has expired. Please clean up the space or contact the space owner.");   
                llInstantMessage(llGetOwner(), "LEASE EXPIRED: CLEANUP! -  " + get_rentalbox_info()); 
                MY_STATE = 0; 
                save_data(); 
                state default; 
                 
            } 
        }    
        else if (LEASED_UNTIL < llGetUnixTime()) 
        { 
            llInstantMessage(llGetOwner(), "LEASE EXPIRED: CLEANUP! -  " + get_rentalbox_info()); 
            DEBUG("TIME EXPIRED. RETURNING TO DEFAULT"); 
            state default; 
        } 
    } 
             
    touch_start(integer total_number)       
    { 
        load_data();
        if (MY_STATE != 1 || PERIOD == 0 || RATE == 0 || LEASER == "" || CREDIT == 0) 
        { 
            MY_STATE = 0; 
            save_data(); 
            llSay(0,"Returning to unleased. Data might not be correct."); 
            state unleased; 
        } 
         
     
        llSay(0,"Space currently rented by " + LEASER); 
        llSay(0,"Rent due in " + timespan(llGetUnixTime()-LEASED_UNTIL)); 
    } 
      
} 
