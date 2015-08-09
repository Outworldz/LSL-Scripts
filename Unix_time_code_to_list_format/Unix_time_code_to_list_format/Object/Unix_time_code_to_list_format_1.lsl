// :CATEGORY:Useful Subroutines
// :NAME:Unix_time_code_to_list_format
// :AUTHOR:Void Singer
// :CREATED:2010-02-01 19:30:39.987
// :EDITED:2013-09-18 15:39:08
// :ID:935
// :NUM:1343
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Unix_time_code_to_list_format
// :CODE:
Time codes before the year 1902 or past the end of 2037
  are capped to the first second of 1902 and 2038 respectively
 
 Output is [Y, M, D, h, m, s] list format.
 
 This version could be improved.
 
list uUnix2StampLst( integer vIntDat ){
	if (vIntDat / 2145916800){
		vIntDat = 2145916800 * (1 | vIntDat >> 31);
	}
	integer vIntYrs = 1970 + ((((vIntDat %= 126230400) >> 31) + vIntDat / 126230400) << 2);
	vIntDat -= 126230400 * (vIntDat >> 31);
	integer vIntDys = vIntDat / 86400;
	list vLstRtn = [vIntDat % 86400 / 3600, vIntDat % 3600 / 60, vIntDat % 60];
 
	if (789 == vIntDys){
		vIntYrs += 2;
		vIntDat = 2;
		vIntDys = 29;
	}else{
		vIntYrs += (vIntDys -= (vIntDys > 789)) / 365;
		vIntDys %= 365;
		vIntDys += vIntDat = 1;
		integer vIntTmp;
		while (vIntDys > (vIntTmp = (30 | (vIntDat & 1) ^ (vIntDat > 7)) - ((vIntDat == 2) << 1))){
			++vIntDat;
			vIntDys -= vIntTmp;
		}
	}
	return [vIntYrs, vIntDat, vIntDys] + vLstRtn;
}
/*//--                       Anti-License Text                         --//*/
/*//     Contributed Freely to the Public Domain without limitation.     //*/
/*//   2009 (CC0) [ http://creativecommons.org/publicdomain/zero/1.0 ]   //*/
/*//  Void Singer [ https://wiki.secondlife.com/wiki/User:Void_Singer ]  //*/
/*//--                    
