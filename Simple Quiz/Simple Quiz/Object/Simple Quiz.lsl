// :CATEGORY:Quiz
// :NAME:Simple Quiz
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2014-09-24 14:53:12
// :EDITED:2014-09-24
// :ID:1049
// :NUM:1663
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// A simple notecard game with collision, or touch. Itgives a notecard when the question is answered.
// :CODE:

//if you touch or collide with the prim that this script is in, it will speak in chat the Prompt "Enter the password". 
//if they answer "password", it will ask them "How many steps are there leading up to the Elven village from the Queens Castle?";
//If they answer "5",  it will give them the first notecard it can find in inventory.

    
integer COLLISION = TRUE;    // if set to TRUE instead of FALSE, anyone who walks thru this prim will get prompted for the secret password.
integer TOUCH = TRUE;    // if set to TRUE instead of FALSE, anyone who touches this prim will get prompted for the secret password.
integer IM = TRUE;        // if TRUE, they get an Instant Message privately in chat. if FALSE it speaks Publicly.
string Prompt = "Enter the password";
string SecretWord = "password";
string Question = "How many steps are there leading up to the Elven village from the Queens Castle?";
string Answer = "5";

default
{
    on_rez(integer N)    {
        llResetScript();
    }
   
    state_entry() {
        if (COLLISION)
            llVolumeDetect(TRUE);    //make it phantom, and collidable
        else
            llVolumeDetect(FALSE );
        
        llListen(0,"","","");
    }
       
    listen(integer channel, string name, key id, string message)    {
        if (message == SecretWord && ! IM)
            llSay(0, Question);


        else if (message == SecretWord &&  IM)
            llInstantMessage(id, Question);

        else if (message == Answer)
            llGiveInventory(id, llGetInventoryName(INVENTORY_NOTECARD,0));        
    }
    touch(integer total_number)    {
        if (TOUCH && ! IM)
            llSay(0,Prompt);
        if (TOUCH &&  IM)
           llInstantMessage(llDetectedKey(0),Prompt);
    }
}
