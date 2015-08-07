// :CATEGORY:Timestamp
// :NAME:Timestamp_Get_Weekday_from_timestam
// :AUTHOR:Void Singer
// :CREATED:2010-02-01 19:32:11.520
// :EDITED:2013-09-18 15:39:07
// :ID:895
// :NUM:1271
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Timestamp_Get_Weekday_from_timestam
// :CODE:
/*//-- Note:
 Accurate from 1901 to 2099 (no limiting code)
//*/
 
string uUnix2WeekdayStr( integer vIntDat ){
    return llList2String( ["Thursday", "Friday", "Saturday", "Sunday", "Monday", "Tuesday", "Wednesday"],
                           vIntDate % 604800 / 86400  - (vIntDate < 0) );
}
/*//--                       Anti-License Text                         --//*/
/*//     Contributed Freely to the Public Domain without limitation.     //*/
/*//   2009 (CC0) [ http://creativecommons.org/publicdomain/zero/1.0 ]   //*/
/*//  Void Singer [ https://wiki.secondlife.com/wiki/User:Void_Singer ]  //*/
/*//--                                                                 --//*/
