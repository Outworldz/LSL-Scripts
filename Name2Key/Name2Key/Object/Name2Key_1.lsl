// :CATEGORY:Owner Key
// :NAME:Name2Key
// :AUTHOR:Takat Su
// :CREATED:2011-10-16 19:28:26.180
// :EDITED:2013-09-18 15:38:58
// :ID:551
// :NUM:749
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Usage sample 
// :CODE:
integer cmdName2Key = 19790;
integer cmdName2KeyResponse = 19791;
 
default {
    state_entry() {
        llMessageLinked( LINK_SET, cmdName2Key, "Test Name", NULL_KEY );
    }
 
    link_message( integer inFromPrim, integer inCommand, string inKeyData, key inReturnedKey ) {
        if( inCommand == cmdName2KeyResponse ) {
            list lParts = llParseString2List( inKeyData, [":"], [] );
            string lName = llList2String( lParts, 0 );
            key lKey = (key)llList2String(lParts, 1 );
        }
    }
}
