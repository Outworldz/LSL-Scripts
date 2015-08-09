// :CATEGORY:Visitor Counter
// :NAME:Visitor_List_Maker
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:09
// :ID:956
// :NUM:1378
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Visitor List Maker.lsl
// :CODE:

// Global variables
list visitor_list;
float range = 10.0; // in meters
float rate = 1.0; // in seconds
 
 
// Functions
integer isNameOnList( string name )
{
    integer len = llGetListLength( visitor_list );
    integer i;
    for( i = 0; i < len; i++ )
    {
        if( llList2String(visitor_list, i) == name )
        {
            return TRUE;
        }
    }
    return FALSE;
}
 
// States
default
{
    state_entry()
    {
        llSay(0, "Visitor List Maker started...");
        llSay(0, "The owner can say 'help' for instructions."); 
        llSensorRepeat( "", "", AGENT, range, TWO_PI, rate );
        llListen(0, "", llGetOwner(), "");
    }
      
                
    sensor( integer number_detected )
    {
        integer i;
        for( i = 0; i < number_detected; i++ )
        {
            if( llDetectedKey( i ) != llGetOwner() )
            {
                string detected_name = llDetectedName( i );
                if( isNameOnList( detected_name ) == FALSE )
                {
                    visitor_list += detected_name;
                }
            }
        }    
    }
    
    listen( integer channel, string name, key id, string message )
    {
        if( id != llGetOwner() )
        {
            return;
        }
        
        if( message == "help" )
        {
            llSay( 0, "This object records the names of everyone who" );
            llSay( 0, "comes within "+ (string)range + " meters." );
            llSay( 0, "Commands the owner can say:" );
            llSay( 0, "'help'  - Shows these instructions." );
            llSay( 0, "'say list'   - Says the names of all visitors on the list.");
            llSay( 0, "'reset list' - Removes all the names from the list." );
        }
        else
        if( message == "say list" )
        {
            llSay( 0, "Visitor List:" );
            integer len = llGetListLength( visitor_list );
            integer i;
            for( i = 0; i < len; i++ )
            {
                llSay( 0, llList2String(visitor_list, i) );
            }
            llSay( 0, "Total = " + (string)len ); 
        }
        else
        if( message == "reset list" )
        {
            visitor_list = llDeleteSubList(visitor_list, 0, llGetListLength(visitor_list));
            llSay( 0, "Done resetting.");
        }
    }        
}

// END //
