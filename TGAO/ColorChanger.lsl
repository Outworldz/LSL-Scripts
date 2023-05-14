default
{
    link_message( integer _sender, integer _num, string _message, key _id) 
    {    
        // Coming from an interface script
        if ( _message == "ZHAO_AOON" ) {
            llSetColor(<0.2,1,0.2>, ALL_SIDES);
        } else if ( _message == "ZHAO_AOOFF" ) {
            llSetColor(<1,0.2,0.2>, ALL_SIDES);
        }
    }
}