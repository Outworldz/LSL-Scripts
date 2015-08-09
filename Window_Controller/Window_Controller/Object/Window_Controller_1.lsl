// :CATEGORY:Windows
// :NAME:Window_Controller
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:09
// :ID:982
// :NUM:1404
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Window Controller.lsl
// :CODE:

// if not linked just remove the link_message section )
//
// Place in all of the prims in the link set including the "master"
// then just touch and choose an option
//   Phantom            Walk thru walls :-)
//   Solid        As you would expect
//   Visible      100% visible
//   Clear        100% Invisible
//
// When the question is answered all of the prims in the link set are given the message 
// so they all change to be the same.
// 
// This has been coded so that it can be the the master ( the prim touched )
// or any of the link set - reading link messages
// So that as long as it exists in all prims in the link set it doesnt matter which one is master.
//
// The listener is deleted after 60 seconds or as soon as the dialog is answered - to reduce lag
//
integer lkey;

init()
{
}
default
{
    state_entry()
    {
        init(); 
    }
    on_rez( integer param )
    {
        init();
    }
    touch_start( integer num )
    {
        if ( llDetectedKey(0) == llGetOwner() )
        {
        lkey = llListen( 8192, "", llGetOwner(), "" );
        llSetTimerEvent(60);
        llDialog( llDetectedKey(0), "Window Options :",
                  [ "Phantom", "Solid", "Clear", "Visible" ], 8192 );
        }
    }
    timer()
    {
        llListenRemove( lkey );
        llSetTimerEvent( 0 );
    }
    listen ( integer channel, string name, key id, string message )
    {
        llListenRemove( lkey );
        if ( message == "Solid" ) 
        {
            llMessageLinked( LINK_SET, 0 , "Solid" , NULL_KEY );
            llSetPrimitiveParams( [PRIM_PHANTOM,FALSE] );
        }
        if ( message == "Visible" )
        {
            llMessageLinked( LINK_SET, 0 , "Visible" , NULL_KEY );
            llSetAlpha( 1, ALL_SIDES );
        }
        if ( message == "Clear" )
        {
            llMessageLinked( LINK_SET, 0 , "Clear" , NULL_KEY );
            llSetAlpha( 0,ALL_SIDES );
        }
        if ( message == "Phantom" )
        {
            llMessageLinked( LINK_SET, 0 , "Phantom" , NULL_KEY );
            llSetPrimitiveParams( [PRIM_PHANTOM,TRUE] );
        }
    }
    link_message( integer to, integer from , string message, key id )
    {
        if ( message == "Solid" ) 
        {
            llSetPrimitiveParams( [PRIM_PHANTOM,FALSE] );
        }
        if ( message == "Visible" )
        {
            llSetAlpha( 1, ALL_SIDES );
        }
        if ( message == "Clear" )
        {
            llSetAlpha( 0,ALL_SIDES );
        }
        if ( message == "Phantom" )
        {
            llSetPrimitiveParams( [PRIM_PHANTOM,TRUE] );
        }
    }
}    // END //
