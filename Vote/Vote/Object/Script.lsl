// Voting script, only allows one vote per avi
// @author JB Kraft
// script from http://wiki.secondlife.com/wiki/Vote_Simple
// creative commons license
// ------------------------------------------------------------------------
// Feb 16, 2008  v1.1  - one avi, one vote
// Feb 14, 2008  v1.0  - simple voting, orig code
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// this message will be IM'd to the voter after they vote
string g_THANKS_MSG = "Thanks for voting";
// this will be in the hover text over the prim
string g_HOVER_TEXT = "Vote for Me iF YOU LIKE my SIM, Thanks";
 
// -- dont need to edit anything below here probably unless you want to change 
// how the message is delivered when someone votes. see: touch_start --
integer g_VOTES = 0;
// list of avis that voted
list g_VOTERS;
 
// ------------------------------------------------------------------------
update()
{
    llSetText( g_HOVER_TEXT + "\n" + (string)g_VOTES + " votes", <0,1,0>, 1.0 );
}
 
// ------------------------------------------------------------------------
integer addVote( key id )
{
    // check memory and purge the list if we are getting full
    if( llGetFreeMemory() < 1000 ) {
        g_VOTERS = [];
    }
 
    // make sure they have not voted already
    if( llListFindList( g_VOTERS, [id] ) == -1 ) {
        g_VOTES++;
        g_VOTERS = (g_VOTERS=[]) + g_VOTERS + [id];
        update();
        return TRUE;
    }    
 
    return FALSE;
}
 
// ------------------------------------------------------------------------
// D E F A U L T
// ------------------------------------------------------------------------
default
{
    // --------------------------------------------------------------------
    state_entry()
    {
        update();
    }
 
    // --------------------------------------------------------------------
    touch_start(integer total_number)
    {
        integer i;
        for( i = 0; i < total_number; i++ ) {
            if( addVote( llDetectedKey(i))) {
                if( g_THANKS_MSG != "" ) {
                    // uncomment one and only one of these next 3 lines
                    //llWhisper( 0, g_THANKS_MESSAGE );
                    //llSay( 0, g_THANKS_MSG );        
                    llInstantMessage( llDetectedKey(i), g_THANKS_MSG );
                }
            }
        }
    }
}