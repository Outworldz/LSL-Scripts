// :CATEGORY:Money Chair
// :NAME:Money_Chair
// :AUTHOR:Davy Maltz
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:57
// :ID:519
// :NUM:703
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Money_Chair
// :CODE:
integer moneyamount = 4;
integer totaltime = 65;
integer secondspassed;
integer minutespassed;
string timepassed;
string timeleft;
key sitter;

default
{
    on_rez(integer start_param)
    {
     llResetScript();   
    }
    state_entry()
    {
        llSitTarget(<0.5,0.0,0.5>,<0,0,0,0>);
        llSetText("Earn L$4 Per 10 Minutes!",<0,1,0>,1.0);
        llRequestPermissions(llGetOwner(), PERMISSION_DEBIT);
    }
    run_time_permissions(integer perm)
    {
        if(perm)
        {
           llOwnerSay("Permission Granted."); 
        }
        else
        {
            llOwnerSay("Must Grant Debit Permissions.");
          llRequestPermissions(llGetOwner(), PERMISSION_DEBIT);
        }
    }
    changed(integer change)
    {
        sitter = llAvatarOnSitTarget();
            if(sitter != NULL_KEY)
            {
                llSetTimerEvent(1.0); 
            }
            else if(sitter == NULL_KEY)
            {
                llSetTimerEvent(0.0);
                secondspassed = 0;
        minutespassed= 0;
        timepassed = "";
        llSetText("Earn L$4 Per 10 Minutes!",<0,1,0>,1.0);
            }
        }
    
    timer()
    {
        sitter = llAvatarOnSitTarget();  
if(sitter != NULL_KEY)
{
    secondspassed = secondspassed + 1;
        minutespassed = secondspassed / 60;
        timepassed = (string)minutespassed + ":" + (string)(secondspassed - (minutespassed * 60));
timeleft = (string)(secondspassed / 60) + ":" +  (string)(secondspassed - (minutespassed * 60));
if(llStringLength(llGetSubString(timeleft,llSubStringIndex(timeleft,":") + 1,llStringLength(timeleft))) == 1)
{
 timeleft = llGetSubString(timeleft,0,llStringLength(timeleft) - 2) + "0" + 
llGetSubString(timeleft,llStringLength(timeleft) - 1, llStringLength(timeleft));   
}
if(llStringLength(llGetSubString(timepassed,llSubStringIndex(timepassed,":") + 1,llStringLength(timepassed))) == 1)
{
 timepassed = llGetSubString(timepassed,0,llStringLength(timepassed) - 2) + "0" + 
llGetSubString(timepassed,llStringLength(timepassed) - 1, llStringLength(timepassed));    
}
llSetText(llKey2Name(sitter) + " Is Sitting On Me!" + "\n " + timepassed + " Has Passed!" + "\n " + timeleft + 
" Left untill next payment!",<0,1,0>,1.0);
        if(secondspassed >= totaltime)
        {
            llSay(0,llKey2Name(sitter) + ", You sat on me for " + timepassed + " and earned L$" + 
(string)moneyamount + "!");
            llGiveMoney(sitter,moneyamount);
            llUnSit(sitter);
            }
        }
    }
}
