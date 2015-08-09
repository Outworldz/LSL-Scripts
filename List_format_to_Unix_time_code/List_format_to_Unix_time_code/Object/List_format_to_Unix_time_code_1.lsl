// :CATEGORY:Timestamp
// :NAME:List_format_to_Unix_time_code
// :AUTHOR:Void Singer
// :CREATED:2010-02-01 19:31:30.380
// :EDITED:2013-09-18 15:38:56
// :ID:477
// :NUM:644
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// List_format_to_Unix_time_code
// :CODE:
/*//-- Notes:
 Time codes before the year 1902 or past the end of 2037
 are capped to the first second of 1902 or 2038 respectively
 
 Input format is [Y, M, D, h, m, s] in numerals. Strings are converted.
 Elements past the end are safely ignored, for compatibility with 
 llParseString2List( llGetTimestamp(), ["-", "T", ":", "."], [] )
 Short [Y, M, D] format is supported for compatibility with
 llParseString2List( llGetDate(), ["-"], [] )
//*/
 
//-- unsafe version (missing day/month or bad values not handled)
integer uStamp2UnixInt( list vLstStp ){
	integer vIntYear = llList2Integer( vLstStp, 0 ) - 1902;
	integer vIntRtn;
	if (vIntYear >> 31 | vIntYear / 136){
		vIntRtn = 2145916800 * (1 | vIntYear >> 31);
	}else{
		integer vIntMnth = ~-llList2Integer( vLstStp, 1 );
		vIntRtn = 86400 * ((integer)(vIntYear * 365.25 + 0.25) - 24837 +
		  vIntMnth * 30 + (vIntMnth - (vIntMnth < 7) >> 1) + (vIntMnth < 2) -
		  ((vIntYear & 3) > 0) * (vIntMnth > 1) +
		  (~-llList2Integer( vLstStp, 2 )) ) +
		  llList2Integer( vLstStp, 3 ) * 3600 +
		  llList2Integer( vLstStp, 4 ) * 60 +
		  llList2Integer( vLstStp, 5 );
	}
	return vIntRtn;
}
 
//-- this version safely supports missing Day/Month
integer uStamp2UnixInt( list vLstStp ){
	integer vIntYear = llList2Integer( vLstStp, 0 ) - 1902;
	integer vIntRtn;
	if (vIntYear >> 31 | vIntYear / 136){
		vIntRtn = 2145916800 * (1 | vIntYear >> 31);
	}else{
		integer vIntMnth = ~-llList2Integer( vLstStp, 1 );
		integer vIntDays = ~-llList2Integer( vLstStp, 2 );
		vIntMnth += !~vIntMnth;
		vIntRtn = 86400 * ((integer)(vIntYear * 365.25 + 0.25) - 24837 +
		  vIntMnth * 30 + (vIntMnth - (vIntMnth < 7) >> 1) + (vIntMnth < 2) -
		  ((vIntYear & 3) > 0) * (vIntMnth > 1) +
		  vIntDays + !~vIntDays ) +
		  llList2Integer( vLstStp, 3 ) * 3600 +
		  llList2Integer( vLstStp, 4 ) * 60 +
		  llList2Integer( vLstStp, 5 );
	}
	return vIntRtn;
}
 
//-- Double Safe (as previous, with bad input capping)
integer uStamp2UnixInt( list vLstStp ){
	integer vIntYear = llList2Integer( vLstStp, 0 ) - 1902;
	integer vIntRtn;
	if (vIntYear >> 31 | vIntYear / 136){
		vIntRtn = 2145916800 * (1 | vIntYear >> 31);
	}else{
		integer vIntMnth = ~-llList2Integer( vLstStp, 1 );
		integer vIntDays = ~-llList2Integer( vLstStp, 2 );
		vIntMnth = llAbs( (vIntMnth + !~vIntMnth) % 12 );
		vIntRtn = 86400 * ((integer)(vIntYear * 365.25 + 0.25) - 24837 +
		  vIntMnth * 30 + (vIntMnth - (vIntMnth < 7) >> 1) + (vIntMnth < 2) -
		  ((vIntYear & 3) > 0) * (vIntMnth > 1) +
		  llAbs( (vIntDays + !~vIntDays) % 31 ) ) +
		  llAbs( llList2Integer( vLstStp, 3 ) % 24 ) * 3600 +
		  llAbs( llList2Integer( vLstStp, 4 ) % 60 ) * 60 +
		  llAbs( llList2Integer( vLstStp, 5 ) % 60 );
	}
	return vIntRtn;
}
/*//--                       Anti-License Text                         --//*/
/*//     Contributed Freely to the Public Domain without limitation.     //*/
/*//   2009 (CC0) [ http://creativecommons.org/publicdomain/zero/1.0 ]   //*/
/*//  Void Singer [ https://wiki.secondlife.com/wiki/User:Void_Singer ]  //*/
/*//--                
