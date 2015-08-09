// :CATEGORY:Useful Subroutines
// :NAME:String_Find_Last_Index
// :AUTHOR:Void Singer
// :CREATED:2010-02-01 19:25:41.253
// :EDITED:2013-09-18 15:39:05
// :ID:839
// :NUM:1167
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// String_Find_Last_Index
// :CODE:
integer uGetStrIdxRev1( string vStrSrc, string vStrTst ){
    integer vIdxFnd =
      llStringLength( vStrSrc ) -
      llStringLength( vStrTst ) -
      llStringLength(
        llList2String(
          llParseStringKeepNulls( vStrSrc, (list)vStrTst, [] ),
          -1)
        );
    return (vIdxFnd | (vIdxFnd >> 31));
}
/*//--                       Anti-License Text                         --//*/
/*//     Contributed Freely to the Public Domain without limitation.     //*/
/*//   2009 (CC0) [ http://creativecommons.org/publicdomain/zero/1.0 ]   //*/
/*//  Void Singer [ https://wiki.secondlife.com/wiki/User:Void_Singer ]  //*/
/*//--        
