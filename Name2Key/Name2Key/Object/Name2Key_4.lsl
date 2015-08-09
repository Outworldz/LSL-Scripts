// :CATEGORY:Owner Key
// :NAME:Name2Key
// :AUTHOR:Takat Su
// :CREATED:2011-10-16 19:28:26.180
// :EDITED:2013-09-18 15:38:58
// :ID:551
// :NUM:752
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Library 
// :CODE:
integer cmdName2Key = 19790;
integer cmdName2KeyResponse = 19791;
 
list gRequests;
 
key requestName2Key( string inName ) {
    list lNameParts = llParseString2List( inName, [" "], [] );
    string lFirstName = llList2String( lNameParts, 0 );
    string lLastName = llList2String( lNameParts, 1 );
    return llHTTPRequest( "http://name2key.appspot.com/?name=" + lFirstName + "%20" + lLastName, [], "" );
}
 
default {
    link_message( integer inFromPrim, integer inCommand, string inName, key inKey ) {
        if( inCommand == cmdName2Key )
            gRequests += [requestName2Key( inName ), inKey ];
    }
 
    http_response(key inKey, integer inStatus, list inMetaData, string inBody ) {
        integer lPosition = llListFindList( gRequests, [inKey]);
        if( lPosition != -1 ) {
            llMessageLinked( LINK_SET, cmdName2KeyResponse, inBody, llList2Key( gRequests, lPosition+1 ) );
            gRequests = llDeleteSubList( gRequests, lPosition, lPosition + 1 );
        }
    }
}
