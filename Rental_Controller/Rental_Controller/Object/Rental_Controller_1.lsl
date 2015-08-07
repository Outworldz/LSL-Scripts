// :CATEGORY:Rental
// :NAME:Rental_Controller
// :AUTHOR:phoenix Behemoth
// :CREATED:2013-04-21 19:30:59.280
// :EDITED:2013-09-18 15:39:01
// :ID:695
// :NUM:949
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Rental_Controller
// :CODE:
// this is an open source project and should be given out

// full permissions for no more than L$10 to recoup land fees

// Created By phoenix Behemoth

//----------------------------------------------------------------

integer messagestoper;
integer timersteps = 60;
list splitwith;
list splitname;
string ownername;
integer not_registered = TRUE;
vector original_location;
vector original_scale;
integer objects = 150; // objects
float price = 10; // price
integer weeks = 1; // weaks
vector offset = <0, 0, 0>;
integer mature = 0;
string rentor;
key rentorkey;
integer rented = FALSE;
string rentperiod;
integer numListen;
integer randchannel;
integer editmode;
integer stopper;
string daterented;
integer rentedweeks;
integer timerevent;
integer errorcount;
string resident;
key requestid;
string httpfor;
list editmenu = ["Price","Weeks","Prims","Offset","Renter","Rented For","Split"];
list edittextmessage = ["Please type the price into the box below","Please type the minimum amount of weeks that can be put on","Please type the prim limit for this unit","Please type the offset in formated like <0,0,2> would make it go to 2m above when rented","Please type the name you want to rent case sensative","Please type in the box formated like days:hours:mins:seconds","To add put +username to remove -username"];
string editpromt = "";
 
    rented_fltext()
    {
       llSetText("Rented By: "+rentor+"\nTime Left:"+rentedval(0),<1,1,1>,1);
    }

string rentedval(integer type)
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
    if(type == 1)
    {
        return (string)weeks2 + " weeks | " + (string)days + " days | " + (string)hours + ":" + (string)mins + ";" +(string)seconds;
    }else
    {
        return (string)weeks2+" Weeks "+(string)days+" Days\n"+(string)hours+" Hours "+(string)mins+" Mins";
    }
}

unrented_fltext()
{
    llSetText("Price Per Week: L$"+(string)llCeil(price)+"\n Prims: "+(string)objects+"\nMinumum Weeks: "+(string)weeks,<1,1,1>,1);
}

clear_data()
{
    string objectname;
    objectname = llGetObjectName();
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
    unrented_fltext();
}

default
{
    state_entry()
    {
        llSetText("",<1,1,1>,1);
        llSetPayPrice(PAY_HIDE,[PAY_HIDE,PAY_HIDE,PAY_HIDE,PAY_HIDE]);
        errorcount = 0;
        editmode = 0;
        randchannel = (integer)llFrand(10000000);
        llWhisper(0, "Activating...");
        ownername = llKey2Name(llGetOwner());
        llWhisper(0, "Asking for permission from owner " + ownername + ".(for refunds on incorect amount only)");
        llRequestPermissions(llGetOwner(), PERMISSION_DEBIT);
        original_location = llGetPos();
        original_scale = llGetScale();
        rentedweeks = 0;
        llListen(randchannel,"","","");
        timerevent = 0;
    }
    on_rez(integer change)
    {
        llResetScript();
    }
    run_time_permissions(integer type)
    {
        if (type == PERMISSION_DEBIT)
        {
            ownername = llKey2Name(llGetOwner());
            llWhisper(0, "This space is now available for rent.");
            not_registered = FALSE;
            llSetPayPrice(PAY_DEFAULT,[llCeil(price * weeks),llCeil(price * weeks * 2),llCeil(price * weeks * 3),llCeil(price * weeks * 4),llCeil(price * weeks * 5),llCeil(price * weeks * 6)]);
            unrented_fltext();
            state running;
        }
        else
        {
            errorcount ++;
            if(errorcount == 1)
            {
                llOwnerSay("permissions are required to give refunds and give change this unit will not work without them ");
                llOwnerSay("second chance if you dont agree this time this unit will not work till next rez");
                llRequestPermissions(llGetOwner(), PERMISSION_DEBIT);
            }
        }
    }
}

state running
{
    on_rez(integer change)
    {
        llResetScript();
    }
    listen(integer c, string n, key id, string m)
    {
        stopper = 0;
        string objectname;
        objectname = llGetObjectName();
        if(m == "Free Rent" && price == 0)
        {
            timerevent += (604800*weeks);
            rentor = llKey2Name(id);
            rentorkey = id;
            rented = TRUE;
            rented_fltext();
            llWhisper(0, "Prim limit is "+(string)objects+" prims.");
            llWhisper(0, "Keep prim limits or risk termination of agreement.Rent is non-refundable. IM " + ownername + " with questions.");
            llWhisper(0, "Thank you for renting this space . Thank You For Purchasing "+(string)weeks+" weeks . Feel Free To Put Your stuff in now");
        }
        if(editpromt != "")
        {
            // text imput from dialog
            if(m == "")
            {
                 m = "Edit";  
            }
            else
            {
                //price ----------------------
                if (editpromt == "Price")
                {
                    price = (float)m;
                       llOwnerSay("Price set to L$" + (string)llCeil(price));
                    if(price > 0)
                    {
                        llSetPayPrice(PAY_DEFAULT,[llCeil(price * weeks),llCeil(price * weeks * 2),llCeil(price * weeks * 3),llCeil(price * weeks * 4),llCeil(price * weeks * 5),llCeil(price * weeks * 6)]);
                    }
                    else
                    {
                     llSetPayPrice(PAY_HIDE,[PAY_HIDE,PAY_HIDE,PAY_HIDE,PAY_HIDE,PAY_HIDE,PAY_HIDE]);  
                    }

                    if(~rented)
                    {
                        unrented_fltext();
                    }
                }

                // Renter ------------------

                if (editpromt == "Renter")
                {

                    rentor = m;
                    llOwnerSay("renter set to " + rentor);
                    httpfor = "rentor";
                    requestid = llHTTPRequest("http://w-hat.com/name2key?terse=1&name="+llEscapeURL(rentor),[HTTP_METHOD,"GET"],"");
                }

                    // Prims ---------------------
    
                 if (editpromt == "Prims")
                 {
                    objects = (integer)m;
                    llOwnerSay("Prims set to " + (string)objects);

                    if(~rented)
                    {        
                        unrented_fltext();
                    }
                }  

                // Weeks ---------------------
                 if (editpromt == "Weeks")
                 {
                    weeks = (integer)m;
                    llOwnerSay("weeks set to " + (string)weeks);
                    llSetPayPrice(PAY_DEFAULT,[llCeil(price * weeks),llCeil(price * weeks * 2),llCeil(price * weeks * 3),llCeil(price * weeks * 4),llCeil(price * weeks * 5),llCeil(price * weeks * 6)]);
                    if(~rented)
                    {
                        unrented_fltext();
                    }
                } 

                // Split ---------------------

                 if (llGetSubString(m,0,0) == "+" && editpromt == "Split")
                 {
                    string namex = llGetSubString(m,1,-1);
                    splitname +=namex;
                    resident = namex;
                    requestid = llHTTPRequest("http://w-hat.com/name2key?terse=1&name="+llDumpList2String(llParseString2List(namex,[" "],[]),"+"),[HTTP_METHOD,"GET"],"");
                }

               if (llGetSubString(m,0,0) == "-" && editpromt == "Split") 
               {

                    string name = llGetSubString(m,1,-1);
                    integer finddata = llListFindList(splitname,(list)name);
                    if(finddata == -1)
                    {
                        llSay(0,"sorry " + name + " not found");
                    }
                    else
                    {
                        splitwith = llDeleteSubList(splitwith,finddata,finddata);            
                        splitname =llDeleteSubList(splitname,finddata,finddata);            
                        llSay(0,name +" removed from shared list");            
                    }

                } 
                 // Offset -----------------------
                 if (editpromt == "Offset")        
                {
                    offset = (vector)m;
                    llOwnerSay("Offset set to " + (string)offset);
                }      
            }

            // Rented For--------------------

            if (editpromt  == "Rented For")
            {
                string date = llGetTimestamp();
                daterented = llGetSubString(date,5,6) + "/" + llGetSubString(date,8,9) + "/" + llGetSubString(date,0,3) + " | Time " + llGetSubString(date,11,15);
                original_scale = llGetScale();
                original_location = llGetPos();
                list renttime = llParseStringKeepNulls(m, [":"], []);
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
                llSetTimerEvent(timersteps);
                llWhisper(0,"set to " + (string)days + " days " + (string)hours + " hours " + (string)minites + " mins " + (string)seconds + " seconds");
                rented = TRUE;
                llSetText("",<1,1,1>,1);
            }
        }

        if(llListFindList(editmenu,[m]) != -1)
        {
            editpromt = m;
            if(editpromt != "Split")
            {
                llTextBox(llGetOwner(),llList2String(edittextmessage,llListFindList(editmenu,[m])),randchannel);
            }else
            {
                 llTextBox(llGetOwner(),llList2String(edittextmessage,llListFindList(editmenu,[m]))+"\n current split:\n"+llDumpList2String(splitname,"\n"),randchannel);  
            }
        }

        if (m == "Vacent" && c == randchannel && id == llGetOwner() && rented == TRUE)
        {
            clear_data();
        }
        if (m == "Mature" && c == randchannel && id == llGetOwner())
        {
            mature = 1;
            llOwnerSay("set to Mature Area");
        }
        if (m == "Renter info" && c == randchannel && id == llGetOwner())
        {
            llOwnerSay("Rented Date: " + daterented);
            llOwnerSay("Rented Left: " + rentedval(1));
            if (rentedweeks >= 2)
            {
                llOwnerSay("Rented amount: " + (string)rentedweeks + " weeks");
            }
            if (rentedweeks == 1)
            {
                llOwnerSay("Rented amount: " + (string)rentedweeks + " week");
            }
            if (rentedweeks <= 0)
            {
                llOwnerSay("Rented amount: N/A");
            }

            list keys = llGetParcelPrimOwners( llGetPos());
            integer prims = 0;
            integer count = llGetListLength(keys);
            if(count == 0)
            {
                prims = -1;
            }

            integer no;

            for(no = 0 ;no < count;no ++)
            {
                if(rentorkey == (key)llList2String(keys,no))
                {
                    prims = (integer)llList2String(keys,no + 1);
                }
            }
            if(prims != -1)
            {
                llOwnerSay("Current Prims are "+(string)prims+" out of "+(string)objects);
            }else
            {

                llOwnerSay("Current Prims are ??(as land is not owned) out of "+(string)objects);
            }
        }

        if (m == "PG" && c == randchannel && id == llGetOwner())
        {
            mature = 0;
            llOwnerSay("set to PG Area");
        }

        if (m == "Status" && c == randchannel && id == llGetOwner())
        {
            string mit;
            llOwnerSay("Prim's set to " + (string)objects);
            llOwnerSay("Week's set to " + (string)weeks);
            llOwnerSay("Offset set to " + (string)offset);
            llOwnerSay("Price is set to " + (string)price + "L$ per week");
            if (mature == 1)
            {
                mit = "Yes";
            }
            else
            {
                mit = "No";
            }

            llOwnerSay("Regen Mature: " + (string)mit);
        }

        if(m == "Edit" && stopper == 0 &&  c == randchannel && id == llGetOwner())
        {
            editpromt = "";
            stopper = 1;
            llDialog(llGetOwner(),"vender editor\nEdit",["Back"]+editmenu,randchannel);
        }

        if(m == "Back")
        {
            llDialog(llGetOwner(),"vender editor ",["Mature","PG","Vacent","Edit","Renter info","Help","Status"],randchannel);
        }

        if (m == "Help" && c == randchannel && id == llGetOwner())
        {
            llGiveInventory(llGetOwner(), "Rentals Help");
        }
     

        if (llGetSubString(m,0,9) == "set timer " && id==llGetOwner())
        {
            timersteps = (integer)llGetSubString(m,9,llStringLength(m));
            llOwnerSay("timer steps =" + (string)timersteps + " seconds");
            if(rented == TRUE)
            {
                llSetTimerEvent(timersteps);
            }
        }        
    }

    state_entry()
    {
        llOwnerSay("Touch For Menu");
        numListen = llListen(0, "", "", "" );
        llListen(randchannel,"","","");
    }
 

    timer() {
        timerevent-= timersteps;
        rented_fltext();
        if (timerevent >= 1)
        {
        }

        if(timerevent <= 172800 && messagestoper == 0 && rentorkey != NULL_KEY)
        {
            messagestoper = 1;
            llInstantMessage(rentorkey,"Your rental at " + llGetRegionName() + " has 2 days");
        }

        if(timerevent <= 86400 && messagestoper == 1 && rentorkey != NULL_KEY)
        {
            messagestoper = 2;
            llInstantMessage(rentorkey,"Your rental at " + llGetRegionName() + " is on its last day");
        }

        else if(timerevent <= 0)
        {
            llInstantMessage(llGetOwner(),"rental at "+llGetRegionName()+":"+(string)llGetPos()+" has expired");
            if(rentorkey != NULL_KEY)
            {
                llInstantMessage(rentorkey,"Your rental at " + llGetRegionName() + " has expired");
                messagestoper = 0;
            }
            llSay(0,"rental expired");
            clear_data();
        }
    }


    touch_start(integer total_number)
    {
        if(llDetectedKey(0) == llGetOwner()) 
        {
            llDialog(llGetOwner(),"vender editor ",["Mature","PG","Vacent","Edit","Renter info","Help","Status"],randchannel);
        }
        else
        {
            if(rented == FALSE)
            {
                list options = ["Close"];
                if(price == 0)options += "Free Rent";
                llDialog(llDetectedKey(0),"This space is for rent. The price is $" +(string)price+ " per week. Prim limit is "+(string)objects+" prims. Obey prim limits to avoid termination of agreement. Rent is non-refundable.",options,randchannel);

                if (mature == 1)
                {
                    llWhisper(0, "Usage Restrictions:Keep within prim limits or face termination of lease.");
                } else
                {
                    llWhisper(0, "Usage Restrictions: Keep within prim limits or face termination of lease.  Keep To PG Rules as in PG Sim");
                }
    
                llWhisper(0, "Right click and pay to rent this space. Minimum rental period is "+(string)weeks+" weeks, at $" +(string)(price*weeks)+". If you have any questions, please feel free to IM " + ownername + ". For Help please IM " + ownername + ".");
            }
            else
            {
                list keys = llGetParcelPrimOwners( llGetPos());
                integer prims = 0;
                integer count = llGetListLength(keys);
                if(count == 0)
                {
                    prims = -1;
                }

                integer no;
                for(no = 0 ;no < count;no ++)
                {
                    if(rentorkey == (key)llList2String(keys,no))
                    {
                        prims = (integer)llList2String(keys,no + 1);
                    }
                }

                string addon;
                if( prims != -1)
                {
                    addon = "Current Prims are "+(string)prims+" out of "+(string)objects;
                }else
                {
                    addon = "Max prims are " + (string)objects;
                }
                llDialog(llDetectedKey(0),"This space is occupied by " + rentor + " for "+rentedval(1)+ "\n\n"+addon + ". For help please IM " + ownername + ".",["OK"],-1); 
    
            }
    
        }
    
    }

 

    money(key giver, integer amount)
    {
        integer amount2 = amount%(integer)price;
        integer weeks = amount/(integer)price;
        if(amount>=price*weeks && amount2==0 && rented == FALSE)
        {
            if(~rented)
            {
                llSetText("",<1,1,1>,1);
            }
            rentedweeks = amount/(integer)price;
            string date = llGetTimestamp();
            daterented = llGetSubString(date,5,6) + "/" + llGetSubString(date,8,9) + "/" + llGetSubString(date,0,3) + " | Time " + llGetSubString(date,11,15);
            original_scale = llGetScale();
            original_location = llGetPos();
            timerevent = 604800*weeks;
            rentor = llKey2Name(giver);
            rented = TRUE;
            rentperiod = (string)weeks;
            llWhisper(0, "Prim limit is "+(string)objects+" prims.");
            llWhisper(0, "Keep prim limits or risk termination of agreement.Rent is non-refundable. IM " + ownername + " with questions.");
            llWhisper(0, "Thank you for renting this space . Thank You For Purchasing "+(string)weeks+" weeks . Feel Free To Put Your stuff in now");
            llSetTexture("info", ALL_SIDES);
            llSetPos(original_location + offset);
            llSetScale(<0.236,0.236,0.236>);
            rented_fltext();
            rentorkey = giver;
            llSetTimerEvent(timersteps);
            if(splitwith != [])
            {
                integer devide = llGetListLength(splitwith) + 1;
                integer totatogive = amount/devide;
                integer no;
                rented_fltext();
                while(no < llGetListLength(splitwith))
                {
                    if(amount >= devide)
                    {
                        key dest = llList2Key(splitwith,no);
                        llGiveMoney(dest,totatogive);
                        llInstantMessage(dest,"you have bee payed L$"+ (string)totatogive +" by " + llGetObjectName());
                    }else
                    {
                        key dest = llList2Key(splitwith,no);
    
                        llInstantMessage(dest,"Sorry not anough money to pay you has come into renter " + llGetObjectName());
    
                    }
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
                messagestoper = 0;
                if(splitwith != [])
                {
                    integer devide = llGetListLength(splitwith) + 1;
                    integer totatogive = amount/devide;
                    integer no;
                    while(no < llGetListLength(splitwith))
                    {
                        if(amount >= devide)
                        {
                            key dest = llList2Key(splitwith,no);
                            llGiveMoney(dest,totatogive);
                            llInstantMessage(dest,"you have bee payed L$"+ (string)totatogive +" by " + llGetObjectName());
                        }else
                        {
                            key dest = llList2Key(splitwith,no);
                            llInstantMessage(dest,"Sorry not anough money to pay you has come into renter " + llGetObjectName());
                        }
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

    http_response(key request_id, integer status, list metadata, string body)
    {
        if (request_id == requestid)
        {
            if ((key)body != NULL_KEY)
            {
                if(httpfor =="rentor")
                {
                    httpfor = "";
                    rentorkey = body;
                }else
                {
                    splitwith += body;
                    llSay(0,"Split Added with: \""+resident+"\"");
                
                }
            }
            else
            {
                splitname = llDeleteSubList(splitname,-1,-1);
                llSay(0,"No resident named \""+resident+"\" found in the w-hat name2key database");
            }

        } else
        {
            splitname= llDeleteSubList(splitname,-1,-1);
            llSay(0,(string)status+" error");    
        }
    }
}

 
