// :CATEGORY:Money
// :NAME:Simple_profit_splitter
// :AUTHOR:Adalace Jewell
// :CREATED:2010-11-16 11:16:57.120
// :EDITED:2013-09-18 15:39:02
// :ID:767
// :NUM:1054
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Simple_profit_splitter
// :CODE:
// Simple profit splitter in % of amount, with dialog pay menu 

   
// By Adalace Jewell

 
integer percentage = 20; //The percentage of money to give to the person with the UUI key 
key nonprofit_resp1 = "19de8e15-a3eb-4908-ab1a-c8a958b8a176"; // Change this UUI key with yours
string nonprofit_name1 = "your name here"; // Enter the name of your organization here



key nonprofit_resp2 = "97981694-0f2c-48a0-8203-208e4d65dfdc"; // Change this UUI key with yours
string nonprofit_name2 = "your name here"; // Enter the name of the organization receiving the split % here




default
{
    on_rez(integer start_param)
    {
        llResetScript();
    }
    
    state_entry()
    {
        llSetText("Simple Donation split to Nonprofits 1.1", <0.0,1.0,0.0>, 1);
        llRequestPermissions(llGetOwner(), PERMISSION_DEBIT);
    }
    
    run_time_permissions(integer perms)
    {
        if (perms > 0)
        {
            state permok;
        }
    }
}


state permok
{
    money(key id, integer amount)
    {
        llGiveMoney(nonprofit_resp1, llRound(amount * (float)(percentage/100.0)));
        llGiveMoney(nonprofit_resp2, llRound(amount * (float)(percentage/100.0)));
        llWhisper(0, "Thank you for your donation to " + (string)nonprofit_name1);
        llWhisper(0, "Thank you for your donation to " + (string)nonprofit_name2);
    }
}
