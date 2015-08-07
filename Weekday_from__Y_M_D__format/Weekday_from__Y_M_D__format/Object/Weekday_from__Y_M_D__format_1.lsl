// :CATEGORY:Timestamp
// :NAME:Weekday_from__Y_M_D__format
// :AUTHOR:Void Singer
// :CREATED:2010-02-01 19:33:05.643
// :EDITED:2013-09-18 15:39:09
// :ID:972
// :NUM:1394
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Weekday_from__Y_M_D__format
// :CODE:
/*//-- Note:
 Accurate from 1901 to 2099 (no limiting code)
 
 This version could be improved.
//*/
 
string uStamp2WeekdayStr( integer vIntYear, integer vIntMonth, integer vIntDay ){
return llList2String ( ["Friday", "Saturday", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday"],
                       (vIntYear + (vIntYear >> 2) - ((vIntMonth < 3) & !(vIntYear & 3)) + vIntDay
                       + (integer)llGetSubString( "_033614625035", vIntMonth, vIntMonth )) % 7 );
}
/*//--                       Anti-License Text                         --//*/
/*//     Contributed Freely to the Public Domain without limitation.     //*/
/*//   2009 (CC0) [ http://creativecommons.org/publicdomain/zero/1.0 ]   //*/
/*//  Void Singer [ https://wiki.secondlife.com/wiki/User:Void_Singer ]  //*/
/*//--           
