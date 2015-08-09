// :CATEGORY:Building
// :NAME:Set_and_Move
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:02
// :ID:741
// :NUM:1024
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Set and Move.lsl
// :CODE:

integer lkey;

init()
{
    llOwnerSay ( "Touch the object and set to store its current position" );
    llOwnerSay ( "choose 'move 2' to return to its stored position" );
    llOwnerSay ( "rm script to remove the script from the object" );
    llOwnerSay ( "Position is stored in object desc if you want to change it manually" );
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

    touch_start(integer total_number)
    {
        if ( llDetectedKey(0) == llGetOwner() )
        {
            lkey = llListen( 8192, "",llGetOwner(),"" );
            llSetTimerEvent( 60 );
            llDialog( llGetOwner(), "Object Options:",
                     [ "set pos", "move 2 pos", "rm script" ],8192);
        }
    }
    listen ( integer ch, string nm, key id, string message )
    {
        llListenRemove( lkey );
        if ( message == "set pos" )
        {
            llSetObjectDesc( (string)llGetRootPosition() );
            llOwnerSay ( "Position stored as " + llGetObjectDesc() );
        }
        if ( message == "move 2 pos" )
        {
            vector pos = (vector)llGetObjectDesc();
            do {
                llSetPos( pos ) ;
            } while ( llVecDist( llGetRootPosition(), pos ) > 0.01 );
            llOwnerSay ( "Object moved to " + (string)pos );
        }
        if ( message == "rm script" )
        {
            llRemoveInventory( llGetScriptName() );
        }
    }
    timer()
    {
        llListenRemove( lkey );
        llSetTimerEvent( 0 );
    }
}
// END //
