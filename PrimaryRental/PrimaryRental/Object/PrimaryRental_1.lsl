// :CATEGORY:Rental
// :NAME:PrimaryRental
// :AUTHOR:Encog Dod
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:00
// :ID:656
// :NUM:893
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// PrimaryRental
// :CODE:
// From the book:
//
// Scripting Recipes for Second Life
// by Jeff Heaton (Encog Dod in SL)
// ISBN: 160439000X
// Copyright 2007 by Heaton Research, Inc.
//
// This script may be freely copied and modified so long as this header
// remains unmodified.
//
// For more information about this book visit the following web site:
//
// http://www.heatonresearch.com/articles/series/22/

// constants
float       TIMER_CLOSE = 5.0;      
integer     DOOR_OPEN   = 1;
integer     DOOR_CLOSE  = 2;
integer     DAYSEC = 86400;

// configuration
integer config_rentwarning = 3;
integer config_graceperiod = 3;
integer config_rate = 43;
integer config_min_days = 7;

// data about renter
string data_rented;
key data_rented_key;
integer data_leased_until;

// other variables
vector originalPos; 
string text;
list allow;

integer warningSent = FALSE;
integer reminderSent = FALSE;


// simple function to open or close the door
// this works by rotating the door                        
door(integer what) 
{
    vector scale = llGetScale();
    
    
    llSetTimerEvent(0); 
    
    if ( what == DOOR_OPEN ) 
    {
        llTriggerSound("doorOpen", 1);
        scale.x = 1;      
        vector pos = llGetPos();
        pos.x+=2.5;
        llSetPos(pos);
    } else if ( what == DOOR_CLOSE) 
    {   
        llTriggerSound("doorClose", 1);
        scale.x = 5;
    }
    
    llSetScale(scale);    
}

integer validateUser(string who)
{    
    integer shouldOpen = FALSE;
    if( who==llKey2Name(llGetOwner()) )
        shouldOpen = TRUE;
            
    if( data_rented==who )
        shouldOpen = TRUE;
            
    string name = llToUpper(who);
    if( llListFindList(allow,[name]) != -1 )
        shouldOpen = TRUE;
    
    return shouldOpen;
}


string rentalInfo()
{
    
    return llGetRegionName()  + " @ " + (string)llGetPos() + " (Leaser: \"" + data_rented;   
}

updateText()
{
    string display = "";
    if( llStringLength(data_rented)>0 )
    {
        display = "Rented by: " + data_rented;
        display+= "\nExpires in: " + timespan(data_leased_until - llGetUnixTime());
        llSetTexture("rental-rented",3);
    }
    else
    {
        display = "Not rented\n";
        display+="Rent for " + (string)(config_rate*config_min_days) + "L/";
        if( config_min_days!=7 )
        {
            display+=(string)config_min_days+" day(s).";
        }
        else
        {
            display+="week.";
        }

        llSetTexture("rental-forrent",3);
        display+="\nTo rent, right-click and choose pay.";
    }
    llSetText(display,<0,0,0>,1.0);
}

string pop()
{
    string result;
    integer i = llSubStringIndex(text, " ");
    
    if( i!=-1 )
    {
        i -=1;
        result = llGetSubString(text,0,i);
        text = llGetSubString(text,i+2,-1);
        return result;
    }
    else
    {
        result = text;
        text = "";
    }
    
    text = llStringTrim(text, STRING_TRIM);
    result = llStringTrim(result, STRING_TRIM);
    
    return result;
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

default
{
    state_entry()
    {
        llRequestPermissions(llGetOwner(), PERMISSION_DEBIT );  
    }

    run_time_permissions (integer perm)
    {
        if(perm & PERMISSION_DEBIT)
        {
            state ready;     
        }
    }
}
                        

state ready 
{       
    state_entry() 
    {
        integer amount = config_rate * config_min_days;
        llSetPayPrice(PAY_HIDE,[amount,amount*2,amount*3,amount*4]);
        originalPos = llGetPos();  
        llListen(0, "", NULL_KEY, ""); 
        llListen(72, "", NULL_KEY, "");  
        updateText();
        llSetTimerEvent(60);
    }
    
    money(key giver, integer amount)
    { 
        if( data_rented == "" )
        {
            llSay(0,"Thanks for renting! You may now open the doors.");
            llGiveInventory(giver,"Encogia Beach Apartments");
            data_rented = llKey2Name(giver);
            data_rented_key = giver;
            allow = [];
            
            if ((amount % config_rate ) != 0)
            {
                llSay(0,"You overpaid. Here is a partial refund");
                llGiveMoney(giver,(amount % config_rate));
            }
            integer credit = (amount - (amount % config_rate))/config_rate;
            data_leased_until = llGetUnixTime() + (credit * (24*60*60));
            llInstantMessage(llGetOwner(), "NEW LEASE - $" +  (string)(amount - (amount % config_rate)) + "L - " + rentalInfo());
            reminderSent = FALSE;
            warningSent = FALSE;
        }
        else
        {
            string who = llKey2Name(giver);
            
            if( who==data_rented )
            {
                integer credit = (amount - (amount % config_rate))/config_rate;
                data_leased_until = data_leased_until + (credit * (24*60*60));
                llSay(0,"Your lease has been extended.");
                reminderSent = FALSE;
                warningSent = FALSE;
            }
            else
            {
                llGiveMoney(giver,amount);
                llSay(0,"This unit is already rented, please find another to rent.");
            }
        }
        
        updateText();
    }
    
    touch_start(integer total_number) 
    {
        key who = llDetectedName(0);
        integer shouldOpen = validateUser(who);
        
        if( shouldOpen == TRUE )
        {
            llSay(0,"Hello " + llDetectedName(0) );
            door(DOOR_OPEN);
            state open_state;
        }
        else
        {
            if( data_rented=="" )
            {
                llGiveInventory(llDetectedKey(0),"Encogia Beach Apartments");
            }
            else
            {
                llSay(0,llDetectedName(0) + " is at the door." );
                llTriggerSound("doorbell", 0.8);
            }
        }
    }
    
    timer()
    {
        if( data_rented!="" )
        {
            if (data_leased_until > llGetUnixTime() && data_leased_until - llGetUnixTime() < config_rentwarning * DAYSEC)
            {
                if(!reminderSent)
                {
                    llInstantMessage(data_rented_key, "Your rent is due in "+(string)config_rentwarning+" days! - " + rentalInfo());
                    llSetTexture("lease-ex",ALL_SIDES);
                    reminderSent = TRUE;
                }
            }
            else if (data_leased_until < llGetUnixTime()  && llGetUnixTime() - data_leased_until < config_graceperiod * DAYSEC)
            {
                if (!warningSent)
                {
                    llInstantMessage(data_rented_key, "Your rent is due! - " + rentalInfo());
                    llInstantMessage(llGetOwner(), "RENT DUE - " + rentalInfo());
                    warningSent = TRUE;
                }
                llSetTexture("lease-ex",ALL_SIDES);
            }
            else if (data_leased_until < llGetUnixTime())
            {
                llInstantMessage(data_rented, "Your lease has expired. Please clean up the space or contact the space owner."); 
                llInstantMessage(llGetOwner(), "LEASE EXPIRED: CLEANUP! -  " + rentalInfo());
                data_rented = "";
                data_rented_key = "";
                allow = [];
                reminderSent = FALSE;
                warningSent = FALSE;
            }
            updateText();
        } 
        
    }
    
    moving_end() 
    {  
        originalPos = llGetPos();
    }
    
    listen(integer channel, string name, key id, string message) 
    {
        if( channel==72 )
        {
            list l = llCSV2List(message);
            string n = llList2String(l,0); // name
            string w = llList2String(l,1); // who
            string c = llList2String(l,2); // code
            if( name==llGetObjectName() )
            {
                
                if( validateUser(w)==TRUE )
                {
                    llSay(72,c);
                }
                else
                {
                    llSay(0,"To rent an apartment please visit the door located on the balcony.");
                }
            }
            
        }
        else if( (channel == PUBLIC_CHANNEL) && (id==llGetOwner() || llKey2Name(id)==data_rented) )
        {
            
            text = message;
            string prefix = llToLower(pop());
            
            if( prefix=="door" )
            {
                string command = pop();
                if( command=="" )
                {
                    llSay(0,"I am the smart door!");
                }
                else if( command=="clear" )
                {
                    llSay(0,"Clearing access list.");
                    allow = [];
                }
                else if( command=="add" )
                {
                    if( llStringLength(text)> 0 )
                    {
                        text = llToUpper(text);
                        allow+=[text];
                        llSay(0,"Adding " + text );
                    }
                    else
                    {
                        llSay(0,"You must also specify an avatar when using add.");
                    }
                }
                else if( command=="list" )
                {
                    integer length = llGetListLength(allow);
                    if( length==0 )
                    {
                        llSay(0,"No one, other than my owner, may open me.");
                    }
                    else
                    {
                        integer i;
                        llSay(0,"The following people have access to open me:");
                        for (i = 0; i < length; ++i) 
                        {
                           llSay(0,llList2String(allow, i));
                        }
                    }
                }
                else
                {
                    llSay(0,"I did not understand that command, say \"door\" for a list of commands.");
                }
            }
        }
        
    }
    
    
 
    
}

state open_state
{
    state_entry() 
    {
        llSetTimerEvent(TIMER_CLOSE);
    }
    
    touch_start(integer num) 
    {
        door(DOOR_CLOSE);
        llSetPos(originalPos);            
        state ready;
    }
    
    timer() 
    { 
        door(DOOR_CLOSE);
        llSetPos(originalPos);            
        state ready;
    }
    
    moving_start() 
    { 
        door(DOOR_CLOSE);
        state ready;
    }
}
