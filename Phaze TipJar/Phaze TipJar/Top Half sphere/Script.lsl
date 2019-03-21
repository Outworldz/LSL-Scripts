// :SHOW:
// :CATEGORY:tipjar
// :NAME:Phaze TipJar
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2016-05-02 12:59:52
// :EDITED:2016-05-02  11:59:52
// :ID:1103
// :NUM:1889
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// A tipjar made with two spheres.  The top will pop when touched
// :CODE:
//Keknehv Psaltery Updated Version of DONATION BOX By jean cook, ama omega, and nada epoch Debugged by YadNi Monde.
// changed into a butterfly dispenser by Fred Beckhusen (Ferd Frederix)
// (LoL) Yea, that s a Bunch O Peeps =)

//Summary: The following script will make an object accept donations on your behalf.
//Usage: stick it on any object you own(my favorite is a top hat), and it will promptly display:
//"<your name>'s donation hat.
//Donate if you are so inclined."
//at which point anyone can right click on it and give you a tip. also, the script tells the donator thanks, and then tells you who donated how much
//also shows the total amount donated



integer totaldonated = 103793;
string owner;

default
{
    on_rez( integer sparam )
    {
        llResetScript();
    }
    state_entry()
    {
        llSetPayPrice(PAY_HIDE, [50 ,100, 200, 500]);
        owner = llKey2Name( llGetOwner() );
        llSetText( owner + "'s Tip Jar.\nRelease the butterflies!",<.25,1,.65>,1);
    }

    money(key id, integer amount)
    {
            
        totaldonated += amount;
        string name= llKey2Name(id);
        llSetText( owner + "'s Tip Jar.\nRelease the butterflies!\n  \nLast Donor:\n " + name + " gave $L" + (string)amount ,<.25,1,.65>,1);
        //llInstantMessage(id,"Thanks for the tip!  I really appreciate it. ~ Fred Beckhusen (Ferd Frederix)");
     
        if (amount == 1)
            llSay(0,"Uhh, thanks I think, " + name );
        
        if (amount > 0)
            llSay(0,"Thanks for the tip, " + name +"! I really appreciate it. ~ Fred Beckhusen (Ferd Frederix)");
        else if (amount > 100)
            llSay(0,"Thanks for the awesome tip, " + name +"!  I  appreciate it. ~ Fred Beckhusen (Ferd Frederix)");
        else if (amount > 300)
            llSay(0,"Thanks for the AWESOME tip, " + name +"!  I really appreciate it. ~ Fred Beckhusen (Ferd Frederix)");
                
        llInstantMessage(llGetOwner(),(string)llKey2Name(id)+" donated $" + (string)amount);
        
        llMessageLinked(LINK_ALL_OTHERS, 0, "touched", "");
        llPlaySound("pop",1.0);
        llSetAlpha(0,ALL_SIDES);   
        llSetTimerEvent(10.0);
        llEmail("fred@mitsi.com",(string)llKey2Name(id)+" donated $" + (string)amount,"");
    }
    touch_start(integer total_number)
    {
        llWhisper(0,"Butterfly Tip Jar for 'Phase Demesnes', total donated so far: " + (string) totaldonated );  
    }
    
    timer()
    {
        llSetAlpha(0.1,ALL_SIDES);  
        llSetTimerEvent(0.0); 
    }
}     
