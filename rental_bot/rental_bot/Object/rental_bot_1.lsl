// :CATEGORY:Rental
// :NAME:rental_bot
// :AUTHOR:deaz
// :CREATED:2010-01-10 05:20:56.300
// :EDITED:2013-09-18 15:39:01
// :ID:694
// :NUM:948
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Rentals Help// ----------------// // please click and enable editmode rental  before typing comands!!!// ----------------------------------------------------------// 
// set price ?             |    sets price of space to whatever ? is
// set weeks ?          |    sets weeks to whatever ? is
// set prims ?            |    sets prims to whatever ? is
// set offset ?          |    sets info box offset to whatever ? is
// set renter ?          |    sets name of renter to whatever ? is
// set offset ?          |    sets info box offset to whatever ? is
// set rentedfor  ?   |    sets how long rented for in days:hours:mins:seconds this info is put where ? is
// set split ?              |   set who you split mony with ? must be users key who you are sharing with
// split remove ?       |  removes name from split list requires name (case sensative)
//  (only after rented)
//  
// features of 1.4
//  
//  renters can now pay for extra weeks while in use
//  displayed exact time left to renters and owner 
//  
//  New fetures of 1.5
//  now im's user on expire
//  able to split money with other people
// :CODE:
// several compil errors andsyntax repairs, re-formatted by Fred Beckhusen (Ferd Frederix)

list splitwith;
list splitname;
string ownername;
integer not_registered = TRUE;
vector original_location;
vector original_scale;
integer objects = 25; // objects
integer price = 350; // price
integer weeks = 1; // weaks
vector offset = <0, 0, 2>;
integer mature = 0;
string rentor;
string rentorkey;
integer rented = FALSE;
string rentperiod;
integer numListen;
integer randchannel;
integer editmode;
integer stopper;
string daterented;
integer rentedweeks;
integer timerevent;

default
{
    on_rez(integer change)
    {
    	llInstantMessage(llGetOwner(),"for help click item then select help from menu");
        llSetTexture("rentit", ALL_SIDES);
        llRequestPermissions(llGetOwner(), PERMISSION_DEBIT);
        llListen(0,"","","");
        randchannel = (integer)llFrand(10000000);
        llListen(randchannel,"","","");
        editmode = 0;
        timerevent = 0;
        rented = FALSE;
	}

    listen(integer c, string n, key id, string m)
    {
        stopper = 0;
        string objectname;
        objectname = llGetObjectName();
        if (m == "Vacent" && c == randchannel && id == llGetOwner() && rented == TRUE)
        {
            llSetTexture("rentit", ALL_SIDES);
            llSetPos(original_location);
            llSetScale(original_scale);   
            llListenRemove(numListen);
            numListen = llListen(0, "", "", "" );  
            rentperiod = "";
            rentor = "";
            rentorkey = NULL_KEY;
            rented = FALSE;
            daterented = "";
            rentedweeks = 0;
            timerevent = 0;
            llSetTimerEvent(0);
            llSay(0, objectname + " is vacent");
        }
        if (m == "Mature" && c == randchannel && id == llGetOwner())
        {
       	 	mature = 1;
        	llSay(0,"set to Mature Area");
        }
        if (m == "Renter info" && c == randchannel && id == llGetOwner())
        {
        	integer weeks2;
    	weeks2 = timerevent / 7 / 24 / 60 / 60;
	    integer days;
	    days = timerevent / 24 / 60 / 60 - (weeks2 * 7);
	    integer hours;
	    hours = timerevent / 60 / 60 - (weeks2 * 7 * 24) - (days * 24);
	    integer mins;
	    mins = timerevent / 60  - (weeks2 * 7 * 24 * 60) - (days * 24 * 60) - (hours * 60);
	    integer seconds;
	    seconds = timerevent - (weeks2 * 7 * 24 * 60 * 60) - (days * 24 * 60 * 60) - (hours * 60 * 60) - (mins * 60);
        llInstantMessage(llGetOwner(),"Rented Date: " + daterented);
        llInstantMessage(llGetOwner(),"Rented Left: " + (string)weeks2 + " weeks | " + (string)days + " days | " + (string)hours + ":" + (string)mins + ";" +(string)seconds);
        if (rentedweeks >= 2)
        {
        	llInstantMessage(llGetOwner(),"Rented amount: " + (string)rentedweeks + " weeks");
        }
        if (rentedweeks == 1)
        {
        	llInstantMessage(llGetOwner(),"Rented amount: " + (string)rentedweeks + " week");
        }
        if (rentedweeks <= 0)
        {
        	llInstantMessage(llGetOwner(),"Rented amount: N/A");
        }
        }
        if (m == "PG" && c == randchannel && id == llGetOwner())
        {
        	mature = 0;
        	llSay(0,"set to PG Area");  
        }
        if (m == "Status" && c == randchannel && id == llGetOwner())
        {
            string mit;
         	llInstantMessage(llGetOwner(),"Prim's set to " + (string)objects);
         	llInstantMessage(llGetOwner(),"Week's set to " + (string)weeks);
         	llInstantMessage(llGetOwner(),"Offset set to " + (string)offset);            
         	if (mature == 1)
         	{
           		mit = "Yes";
            }
            else
            {
              mit = "No";   
            }
         	llInstantMessage(llGetOwner(),"Regen Mature: " + (string)mit);
        }
        if(m == "Edit Mode" && editmode == 0 && stopper == 0 &&  c == randchannel && id == llGetOwner())
        {
        	stopper = 1;
        	editmode = 1;
        	llInstantMessage(llGetOwner(),"editmode on");
        }
        if(m == "Edit Mode" && editmode == 1 && stopper == 0 && c == randchannel && id == llGetOwner())
        {
        	stopper = 1;
        	editmode = 0;
        	llInstantMessage(llGetOwner(),"editmode off");
        }
        
        if (m == "Help" && c == randchannel && id == llGetOwner())
        {
        	llGiveInventory(llGetOwner(), "Rentals Help");
        }
        if (llGetSubString(m,0,8) == "set weeks" && id==llGetOwner()  && editmode == 1)
        {
        	weeks = (integer)llGetSubString(m,9,llStringLength(m));
        	llSay(0,"weeks set to " + (string)weeks);   
        }
        if (llGetSubString(m,0,10) == "set renter " && id==llGetOwner()  && editmode == 1)
        {
        	rentor = llGetSubString(m,11,llStringLength(m));
        	llSay(0,"renter set to " + rentor);   
        }
        if (llGetSubString(m,0,9) == "set split " && id==llGetOwner()  && editmode == 1)
        {
        	key id1 = (key)llGetSubString(m,10,llStringLength(m));
	        splitwith += id1;
	        splitname += llKey2Name(id1);
	        llSay(0,llKey2Name(id1) + "added to split with list");   
        }
        if (llGetSubString(m,0,12) == "split remove " && id==llGetOwner()  && editmode == 1)
        {
        	string name = llGetSubString(m,13,llStringLength(m));
        	integer finddata = llListFindList(splitname,(list)name);
        	if(finddata == -1)
        	{
         		llSay(0,"sorry " + name + " not found");   
        	}else
        	{
         		llDeleteSubList(splitwith,finddata,finddata);
	         	llDeleteSubList(splitname,finddata,finddata);
	         	llSay(0,name +" removed from shared list");
	        }
        }
        if (llGetSubString(m,0,13) == "set rentedfor " && id==llGetOwner()  && editmode == 1)
        {
        	string date = llGetTimestamp();
	        daterented = llGetSubString(date,8,9) + "/" + llGetSubString(date,5,6) + "/" + llGetSubString(date,0,3) + " | Time " + llGetSubString(date,11,15);
	        original_scale = llGetScale();
	        original_location = llGetPos();
	        list renttime = llParseStringKeepNulls(llGetSubString(m,14,llStringLength(m)), [":"], []);
	        integer days = llList2Integer(renttime,0);
	        integer hours = llList2Integer(renttime,1);
	        integer minites = llList2Integer(renttime,2);
	        integer seconds = llList2Integer(renttime,3);
	        integer total;
	        total = (days * 24 * 60 * 60) + (hours * 60 * 60) + (minites * 60) + (seconds);
	        llSetTexture("info", ALL_SIDES);
	        llSetPos(original_location + offset);
	        llSetScale(<0.236,0.236,0.236>);
	        timerevent = total;
	        llSetTimerEvent(1);
	        llWhisper(0,"set to " + (string)days + " days " + (string)hours + " hours " + (string)minites + " mins " + (string)seconds + " seconds");
			rented = TRUE;     
        }
        if (llGetSubString(m,0,10) == "set offset " && id==llGetOwner()  && editmode == 1)
        {
        	offset = (vector)llGetSubString(m,11,llStringLength(m));
        	llSay(0,"Offset set to " + (string)offset);   
        }
        if (llGetSubString(m,0,8) == "set prims" && id==llGetOwner() && editmode == 1)
        {
        	objects = (integer)llGetSubString(m,9,llStringLength(m));
        	llSay(0,"Prims set to " + (string)objects);   
        }
        if (llGetSubString(m,0,8) == "set price" && id==llGetOwner() && editmode == 1)
        {
        	price = (integer)llGetSubString(m,9,llStringLength(m));
        	llSay(0,"Price set to L$" + (string)price);   
        }
        
    }
    state_entry()
    {
        editmode = 0;
        randchannel = (integer)llFrand(10000000);
        llWhisper(0, "Activating...");
        ownername = llKey2Name(llGetOwner());
        llWhisper(0, "Asking for permission from owner " + ownername + ".");        
        llRequestPermissions(llGetOwner(), PERMISSION_DEBIT);        
        original_location = llGetPos();
        original_scale = llGetScale();
        llListenRemove(numListen);
        rentedweeks = 0;
        numListen = llListen(0, "", "", "" );
        llListen(randchannel,"","","");
        timerevent = 0;  
    }

    run_time_permissions(integer type)
    {
        if (type == PERMISSION_DEBIT)
        {
            ownername = llKey2Name(llGetOwner());
            llWhisper(0, "This space is now available for rent.");  
            not_registered = FALSE;
        }
    }
    
	timer()
	{
        timerevent--;
        if (! timerevent)
        {
            if(rentorkey != (string) NULL_KEY)
            {
                llInstantMessage(rentorkey,"Your rental at " + llGetRegionName() + " has expired");
            }
            llSay(0,"rental expired");
            string objectname;        
            objectname = llGetObjectName();
            llSetTexture("rentit", ALL_SIDES);
            llSetPos(original_location);
            llSetScale(original_scale);        
            numListen = llListen(0, "", "", "" );  
            rentperiod = "";
            rentor = "";
            rentorkey = NULL_KEY;
            daterented = "";
            rentedweeks = 0;
            rented = FALSE;
            timerevent = 0;
            llSetTimerEvent(0);         
        }
    }
       
    touch_start(integer total_number)
    {
    	if(llDetectedKey(0) == llGetOwner())
    	{
    		string edit;
	    	if (editmode == 0)
		    {
		     	edit = "off"; 
			}
		    if (editmode == 1)
		    {
		     	edit = "on";  
		    }
		    llDialog(llGetOwner(),"vender editor \n editmode is set to: " + edit,["Mature","PG","Vacent","Edit Mode","Renter info","Help","Status"],randchannel);
		}
		else
		{
	        if(rented == FALSE)
	        {
		        llWhisper(0, "This space is for rent. The price is $" +(string)price+ " per week. Prim limit is "+(string)objects+" prims. Obey prim limits to avoid termination of agreement. Rent is non-refundable.");
		        if (mature == 1)
		        {
	    		    llWhisper(0, "Usage Restrictions:  This spot is for comercial use.  Keep within prim limits or face termination of lease.");
				} else	{
					llWhisper(0, "Usage Restrictions:  This spot is for comercial use.  Keep within prim limits or face termination of lease.  Keep To PG Rules as in PG Sim");
				}	        
	        	llWhisper(0, "Right click and pay to rent this space. Minimum rental period is "+(string)weeks+" weeks, at $" +(string)(price*weeks)+". If you have any questions, please feel free to IM " + ownername + ". For Help please IM " + ownername + ".");
	        }
	        else 
	        {
	         	integer weeks2;
	    		weeks2 = timerevent / 7 / 24 / 60 / 60;
			    integer days;
			    days = timerevent / 24 / 60 / 60 - (weeks2 * 7);
			    integer hours;
			    hours = timerevent / 60 / 60 - (weeks2 * 7 * 24) - (days * 24);
			    integer mins;
			    mins = timerevent / 60  - (weeks2 * 7 * 24 * 60) - (days * 24 * 60) - (hours * 60);
			    integer seconds;
			    
				seconds = timerevent - (weeks2 * 7 * 24 * 60 * 60) - (days * 24 * 60 * 60) - (hours * 60 * 60) - (mins * 60);
	        	llWhisper(0, "This space is occupied by " + rentor + " for " + (string)weeks2 + " weeks | " + (string)days + " days | " + (string)hours + ":" + (string)mins + ";" +(string)seconds);   
	        	llWhisper(0, "Max prims is " + (string)objects + ". For help please IM " + ownername + ".");
	        }
    	}
   	}
    
    money(key giver, integer amount)
    {
        integer amount2 = amount%price;
        integer weeks = amount/price;
        if(amount>=price*weeks && amount2==0 && rented == FALSE)
        {
            rentedweeks = amount/price;
            string date = llGetTimestamp();
            daterented = llGetSubString(date,8,9) + "/" + llGetSubString(date,5,6) + "/" + llGetSubString(date,0,3) + " | Time " + llGetSubString(date,11,15);
            original_scale = llGetScale();
            original_location = llGetPos();
            timerevent = 604800*weeks;
            //vector offset = <-2, 0, -1>;
            llWhisper(0, "Correct amount");
            rentor = llKey2Name(giver);
            rented = TRUE;
            rentperiod = (string)weeks;
            llWhisper(0, "Prim limit is "+(string)objects+" prims.");
            llWhisper(0, "Keep prim limits or risk termination of agreement.Rent is non-refundable. IM " + ownername + " with questions.");
            llWhisper(0, "Thank you for renting this space . Thank You For Purchasing "+(string)weeks+" weeks . Feel Free To Put Your stuff in now");
            llSetTexture("info", ALL_SIDES);
            llSetPos(original_location + offset);
            llSetScale(<0.236,0.236,0.236>);
            rentorkey = giver;
            llSetTimerEvent(1);
            if(splitwith != [])
            {
          	  integer devide = llGetListLength(splitwith) + 1;
	            integer totatogive = amount/devide;    
	            integer no;
	            while(no < llGetListLength(splitwith))
	            {
		            key dest = llList2Key(splitwith,no);
		            llGiveMoney(dest,totatogive);
	        		llInstantMessage(dest,"you have bee payed L$"+ (string)totatogive +" by " + llGetObjectName());
	            	no ++; 
	            }
            }
        }
        else if(rented == TRUE)
        { 
            if (llKey2Name(giver) == rentor && amount>=price*weeks && amount2==0)
            {      
         	   	timerevent += (604800*weeks);
	            llSay(0, "you have incresed your rental by " + (string)weeks + " weeks");
	            rentedweeks += weeks;
	            if(splitwith != [])
	            {
	            	integer devide = llGetListLength(splitwith) + 1;
		            integer totatogive = amount/devide;    
		            integer no;
		            while(no < llGetListLength(splitwith))
		            {
		            	key dest = llList2Key(splitwith,no);
		            	llGiveMoney(dest,totatogive);
		        		llInstantMessage(dest,"you have bee payed L$"+ (string)totatogive +" by " + llGetObjectName());
		            	no ++; 
		            } 
	            }
        	}
            else
            {
             	llGiveMoney(giver, amount);
             	llSay(0,"sorry please check rental");
            }
        }
        else
        {
            llWhisper(0, "Minimum rental period is "+(string)weeks+" weeks, at $" +(string)(price*weeks)+ ". If you have any questions, please feel free to IM" + ownername + ".");
            llWhisper(0, "Giving money back.");
            llGiveMoney(giver, amount);
        }
    }
}

