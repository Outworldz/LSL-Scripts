// :CATEGORY:ChatBot
// :NAME:Pandora_Chatbot
// :AUTHOR:Destiny Niles
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:59
// :ID:603
// :NUM:826
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// An ALICE base chatbot hosted at Pandorabots.com// // // Place these two scripts in an object. The first one is the listener for you to customize and control who it listens to. The second one is the actual engine itself.
// :CODE:
string mesg;
key gOwner;
list talkers;


listen_to(key talker)
{
        integer index = llListFindList( talkers, [talker] );
    if ( index != -1 )
        {
        talkers = llDeleteSubList(talkers, index, index);
         llMessageLinked(LINK_SET,0,"BYE",talker);
        }
    else
        {
        talkers = talkers + talker;
         llMessageLinked(LINK_SET,0,"HI",talker);
        }
}


default
{    
    state_entry()    
    {
        gOwner = llGetOwner();
        llListen(0,"",NULL_KEY,"");
    }

    on_rez(integer i) 
    {
        llWhisper(0,"Owner say /chat or touch me");
        llResetScript();
    }
    
    touch_start(integer num_detected)
    {
        listen_to(llDetectedKey(0));
    }

        listen(integer channel, string name, key id, string msg)
    {
        if (msg == "/chat")
        {
            listen_to(id);
            return;
        }
        if ((msg == "/reset") && (id == gOwner))
        {
            llWhisper(0,"Resetting");
            llResetScript();
        }
            


        integer index = llListFindList( talkers, [id] );
        if (index != -1)
        {
            mesg = llToLower(msg);
            llMessageLinked(LINK_SET,0,msg,id);
        }
    }

}
