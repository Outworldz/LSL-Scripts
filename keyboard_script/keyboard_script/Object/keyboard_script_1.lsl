// :CATEGORY:Keyboards
// :NAME:keyboard_script
// :AUTHOR:max Case
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:55
// :ID:420
// :NUM:576
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// keyboard script.lsl
// :CODE:

//Max Case's Free Keyboard Script 1.0  04/18/2005
//Feel free to reuse, etc.  
//Please don't just resell this script. That would be lame, since I am giving it to you for free.
//naturally, if you build something nice off of it, sell that. 
//Or make a nice texture you would like to sell with keyboard script, that's ok. Just leave script open to all to see.
//Feedback/Rates/Donations always welcome. Don't be shy.
//leave in the comments. they don't affect performance.
// &ndash; Max
//modded for my use - Misch Lameth
key owner;
integer status;

initialize()
{
        //llOwnerSay("owner has changed, resetting");
        //llOwnerSay("initializing...");
        llSetLinkAlpha(LINK_SET,0.0, ALL_SIDES);
        llSetTimerEvent(.7); //honestly you could make this shorter, but what would be the point? .5 seems to work nice.   
        owner = llGetOwner();
        status = 0;
        
}

default 
{
    
    state_entry()
    {
        llOwnerSay("Wear me :)");
        llOwnerSay("Thanks for shopping at SquirrelTech");
        if(llGetOwner() != owner) //checks to see if we have changed owner
        {
            initialize();
        }
    }
           
    on_rez(integer total_number) 
    {
        if(llGetOwner() != owner)
        {
            initialize();
        }
    }

    timer()
    {
    integer temp = llGetAgentInfo(owner) & AGENT_TYPING; // are we typing?
        if (llGetAgentInfo(owner) & AGENT_TYPING) //status changed since last checked?
        {
            llSetLinkAlpha(LINK_SET,1.0,ALL_SIDES);//flip the status (this makes it 1 or 0, instead of AGENT_TYPING or 0)          
            llMessageLinked(LINK_SET,0,"typing","");
            status = temp;//save the current status.
        }
        else 
        {
            
            llSetLinkAlpha(LINK_SET,0.0,ALL_SIDES);
            llMessageLinked(LINK_SET,0,"not_typing","");
        }
    
    
    }  
}// END //
