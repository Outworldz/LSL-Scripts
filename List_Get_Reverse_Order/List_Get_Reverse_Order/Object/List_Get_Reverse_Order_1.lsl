// :CATEGORY:Useful Subroutines
// :NAME:List_Get_Reverse_Order
// :AUTHOR:Void Singer
// :CREATED:2010-02-01 19:26:31.660
// :EDITED:2013-09-18 15:38:56
// :ID:478
// :NUM:645
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// List_Get_Reverse_Order
// :CODE:
list uListRevF( list vLstSrc ){
    integer vIntCnt = (vLstSrc != []);
    @Loop; if (vIntCnt--){
        vLstSrc += llList2List( vLstSrc, vIntCnt, vIntCnt );
        jump Loop;
    }
    return llList2List( vLstSrc, (vLstSrc != []) >> 1, -1 );
}
/*//--                       Anti-License Text                         --//*/
/*//     Contributed Freely to the Public Domain without limitation.     //*/
/*//   2009 (CC0) [ http://creativecommons.org/publicdomain/zero/1.0 ]   //*/
/*//  Void Singer [ https://wiki.secondlife.com/wiki/User:Void_Singer ]  //*/
/*//--              
