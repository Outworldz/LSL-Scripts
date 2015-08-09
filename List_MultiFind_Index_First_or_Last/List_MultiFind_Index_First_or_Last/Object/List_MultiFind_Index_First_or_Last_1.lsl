// :CATEGORY:Useful Subroutines
// :NAME:List_MultiFind_Index_First_or_Last
// :AUTHOR:Void Singer
// :CREATED:2010-02-01 19:29:37.737
// :EDITED:2013-09-18 15:38:56
// :ID:480
// :NUM:647
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// List_MultiFind_Index_First_or_Last
// :CODE:
integer uMatchLstIdxRev( list vLstSrc, list vLstTst ){
  return (vLstSrc != []) -
    (llParseString2List(
       llList2String(
         llParseString2List( 
           llDumpList2String( vLstSrc, ";" ),
           vLstTst, [] ),
         -1 ),
       (list)";",
       [] ) != []) - 1;
}
/*//--                       Anti-License Text                         --//*/
/*//     Contributed Freely to the Public Domain without limitation.     //*/
/*//   2009 (CC0) [ http://creativecommons.org/publicdomain/zero/1.0 ]   //*/
/*//  Void Singer [ https://wiki.secondlife.com/wiki/User:Void_Singer ]  //*/
/*//--          
