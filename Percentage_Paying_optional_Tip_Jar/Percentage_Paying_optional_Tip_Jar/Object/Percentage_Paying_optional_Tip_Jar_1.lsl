// :CATEGORY:Tip Jar
// :NAME:Percentage_Paying_optional_Tip_Jar
// :AUTHOR:Fred Gandt
// :CREATED:2011-01-02 23:00:04.060
// :EDITED:2013-09-18 15:38:59
// :ID:620
// :NUM:844
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// This work uses content from the Second Life® Wiki article Viewer Architecture. Copyright © 2007-2009 Linden Research, Inc. Licensed under the Creative Commons Attribution-Share Alike 3.0 Licens
// :CODE:
// V1 //
 
key owner;
 
integer debit_perms = FALSE;
 
integer pay_price = 0;
 
list pay_buttons = [20, 50, 100, 250];
 
integer percentage = 50; // Percentage to pay to the founder of the group the object is set to.
 
key beneficiary;
 
string default_message = "/me is very grateful for the generous contribution from ";
 
string beneficiary_message = "% of which has been paid to the founder of ";
 
key group_key;
 
string group_name;
 
Function()
{
    owner = llGetOwner();
    string owner_name = llKey2Name(owner);
    string object_name = (owner_name + "'s Money Box");
    llSetObjectName(object_name);
    llSetPayPrice(pay_price, pay_buttons);
    if(percentage)
    llRequestPermissions(owner, PERMISSION_DEBIT);
}
 
default
{
    on_rez(integer param)
    {
        Function();
    }
    state_entry()
    {
        Function();
    }
    run_time_permissions(integer perms)
    {
        if(perms & PERMISSION_DEBIT)
        {
            debit_perms = TRUE;
            group_key = llList2Key(llGetObjectDetails(llGetKey(), [OBJECT_GROUP]), 0);
            if(group_key != NULL_KEY)
            llHTTPRequest("http://world.secondlife.com/group/" + ((string)group_key), [], "");
        }
        else
        llRequestPermissions(owner, PERMISSION_DEBIT);
    }
    http_response(key q, integer status, list metadata, string body)
    {
        if(status == 200)
        {
            integer name_start = (llSubStringIndex(body, "<title>") + 7);
            integer name_end = (llSubStringIndex(body, "</title>") - 1);
            integer founder_key_start = (llSubStringIndex(body, "founderid") + 20);
            integer founder_key_end = (founder_key_start + 35);
            beneficiary = llGetSubString(body, founder_key_start, founder_key_end);
            group_name = llGetSubString(body, name_start, name_end);
        }
        else
        {
            llHTTPRequest("http://world.secondlife.com/group/" + ((string)group_key), [], "");
        }
    }
    money(key id, integer amount)
    {
        string message = "";
        integer dividend;
        string payer = llKey2Name(id);
        if(!percentage)
        {
            message = (default_message + payer);
        }
        else
        {
            dividend = llFloor((((float)amount)/100.0) * ((float)percentage)); // I'm very tired and my eyes are sticky!
            if(dividend)
            {
                if(debit_perms)
                {
                    message = (default_message + payer + ".\n" + ((string)percentage) + beneficiary_message + group_name);
                    llGiveMoney(beneficiary, dividend);
                }
                else
                {
                    message = (default_message + payer);
                }
            }
        }
        llSay(PUBLIC_CHANNEL, message);
    }
}
