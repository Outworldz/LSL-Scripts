// :CATEGORY:Useful Subroutines
// :NAME:List_Find_Last_Index
// :AUTHOR:Void Singer
// :CREATED:2010-02-01 19:28:04.393
// :EDITED:2013-09-18 15:38:56
// :ID:476
// :NUM:643
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// List_Find_Last_Index
// :CODE:
integer uGetLstIdxRev( list vLstSrc, list vLstTst ){
    integer vIdxFnd =
      (vLstSrc != []) +
      ([] != vLstTst) +
      ([] != llParseString2List(
               llList2String(
                 llParseStringKeepNulls(
                   llDumpList2String( vLstSrc, "\x95" ),
                   (list)llDumpList2String( vLstTst, "\x95" ),
                   [] ),
                 -1 ),
               (list)"\x95",
               [] ));
    return (vIdxFnd | (vIdxFnd >> 31));
}
/*//--                       Anti-License Text                         --//*/
/*//     Contributed Freely to the Public Domain without limitation.     //*/
/*//   2009 (CC0) [ http://creativecommons.org/publicdomain/zero/1.0 ]   //*/
/*//  Void Singer [ https://wiki.secondlife.com/wiki/User:Void_Singer ]  //*/
/*//--          
