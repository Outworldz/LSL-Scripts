// :CATEGORY:Useful Subroutines
// :NAME:Reverse_String_Order_smaller_memory
// :AUTHOR:Void Singer
// :CREATED:2010-02-01 19:24:49.457
// :EDITED:2013-09-18 15:39:01
// :ID:703
// :NUM:959
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Reverse_String_Order_smaller_memory
// :CODE:
string uStringRevS( string vStrSrc ){
    integer vIntCnt = llStringLength( vStrSrc );
    @Loop; if (vIntCnt--){
        vStrSrc += llGetSubString( vStrSrc, vIntCnt, vIntCnt );
        vStrSrc = llDeleteSubString( vStrSrc, vIntCnt, vIntCnt );
        jump Loop;
    }
    return vStrSrc;
}
/*//--                       Anti-License Text                         --//*/
/*//     Contributed Freely to the Public Domain without limitation.     //*/
/*//   2009 (CC0) [ http://creativecommons.org/publicdomain/zero/1.0 ]   //*/
/*//  Void Singer [ https://wiki.secondlife.com/wiki/User:Void_Singer ]  //*/
/*//--              
