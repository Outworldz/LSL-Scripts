// :CATEGORY:Map
// :NAME:v7D_Enh_Landmark2Map
// :AUTHOR:Void Singer
// :CREATED:2010-02-01 19:36:08.207
// :EDITED:2013-09-18 15:39:09
// :ID:945
// :NUM:1356
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Script (Small Code Version) 
// :CODE:
/*//( v7-D Enhanced Landmark Mapper v1.1s )//*/
 
/*//-- Requirements:
 3 linked Prims (minimum)
 1 Named "prev" (this will be your previous landmark button)
 1 Named "next" (this will be your next landmark button)
 any other prim in the object will trigger the map destination for the
 currently displayed Landmark name. Recommended to rename landmarks.
//*/
 
integer gIdxTgt; /*//-- Index of Target LM --//*/
string  gStrLMN; /*//-- String of Landmark Name --//*/
vector  gPosLoc; /*//-- Position of Location --//*/
key     gKeySec; /*//-- Key for Security checking dataserver calls --//*/
 
uUpdateLM( integer vIntCng ){
  integer vIntCnt = llGetInventoryNumber( INVENTORY_LANDMARK );
  if (vIntCnt){
    gIdxTgt = gIdxTgt = (vIntCnt + (gIdxTgt + vIntCng)) % vIntCnt;
     /*//-- " + vIntCnt" correct for positive index needed by Req.Inv.Dat. --//*/
     /*//-- " % vIntCnt" range limit for current LM count --//*/
    gStrLMN = llGetInventoryName( INVENTORY_LANDMARK, gIdxTgt *= (gIdxTgt >= 0) );
     /*//-- (gIdxTgt >= 0) to protect against mass deletions of LMs enabling negative indices --//*/
    gKeySec = llRequestInventoryData( gStrLMN );
    llSetTimerEvent( 5.0 );
  }
  else{
     /*//-- Uh Oh, set a default of current sim, center, ground level --//*/
    llSetText( "Out Of Order, No Landmarks Present", <1.0, 0.0, 0.0>, 1.0 );
    gPosLoc = <128.0, 128.0, 0.0>;
  }
}
 
default{
  state_entry(){
    uUpdateLM( 0 );
  }
 
  dataserver( key vKeySec, string vStrLoc ){
     /*//-- verify we're getting our data, not another scripts --//*/
    if (gKeySec == vKeySec){
       /*//-- Clear the timeout --//*/
      llSetTimerEvent( 0.0 );
       /*//-- Store/Display New Target --//*/
      gPosLoc = (vector)vStrLoc;
      llSetText( gStrLMN, <1.0, 0.0, 0.0>, 1.0 );
    }
  }
 
  touch_start( integer vInt ){
     /*//-- Check if a prim named "prev" or "next" was touched --//*/
    integer vIntTst = llSubStringIndex( "prevnext", llGetLinkName( llDetectedLinkNumber( 0 ) ) );
    if (~vIntTst){
      uUpdateLM( (vIntTst > 0) - (vIntTst == 0) );
    }
    else{
       /*//-- Trigger map for any other touched prim in this object --//*/
      llMapDestination( llGetRegionName(), gPosLoc, ZERO_VECTOR );
    }
  }
 
  timer(){
    llOwnerSay( "Dataserver Response Timed Out. Unable To Change Destination; Try Again In A Moment" );
     /*//-- Clear the key so we don't update when it might interfere with a user --//*/
    gKeySec = "";
  }
}
 
/*//--                           License Text                           --//*/
/*//  Free to copy, use, modify, distribute, or sell, with attribution.   //*/
/*//    (C)2009 (CC-BY) [ http://creativecommons.org/licenses/by/3.0 ]    //*/
/*//   Void Singer [ https://wiki.secondlife.com/wiki/User:Void_Singer ]  //*/
/*//  All usages must contain a plain text copy of the previous 2 lines.  //*/
/*//--       
