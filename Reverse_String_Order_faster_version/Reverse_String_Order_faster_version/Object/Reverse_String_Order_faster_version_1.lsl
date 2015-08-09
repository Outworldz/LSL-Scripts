// :CATEGORY:Useful Subroutines
// :NAME:Reverse_String_Order_faster_version
// :AUTHOR:Void SInger
// :CREATED:2010-02-01 19:22:04.783
// :EDITED:2013-09-18 15:39:01
// :ID:702
// :NUM:958
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Reverse_String_Order_faster_version
// :CODE:
string uStringRevF( string vStrSrc ){
    integer vIntCnt = llStringLength( vStrSrc );
    @Loop; if (vIntCnt--){
        vStrSrc += llGetSubString( vStrSrc, vIntCnt, vIntCnt );
        jump Loop;
    }
    return llGetSubString( vStrSrc, llStringLength( vStrSrc ) >> 1, -1 );
}
/*//--                       Anti-License Text                         --//*/
/*//     Contributed Freely to the Public Domain without limitation.     //*/
/*//   2009 (CC0) [ http://creativecommons.org/publicdomain/zero/1.0 ]   //*/
/*//  Void Singer [ https://wiki.secondlife.com/wiki/User:Void_Singer ]  //*/
/*//--             
