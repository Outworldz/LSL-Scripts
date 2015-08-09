// :CATEGORY:Map
// :NAME:v7D_Enh_Landmark2Map
// :AUTHOR:Void Singer
// :CREATED:2010-02-01 19:36:08.207
// :EDITED:2013-09-18 15:39:09
// :ID:945
// :NUM:1355
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Script (Fast Response Version) 
// :CODE:
/*//( v7-D Enhanced Landmark Mapper v1.1f )//*/
 
/*//-- Requirements:
 3 linked Prims (minimum)
 1 Named "prev" (this will be your previous landmark button)
 1 Named "next" (this will be your next landmark button)
 any other prim in the object will trigger the map destination for the
 currently displayed Landmark name. Recommended to rename landmarks.
//*/
 
integer gIdxTgt; /*//-- Index of Target --//*/
list    gLstLMs; /*//-- List of Landmarks --//*/
list    gLstLoc; /*//-- Listt of Locations--//*/
 
key     gKeySec;       /*//-- Key for Security checking dataserver calls --//*/
float   gFltTmt = 5.0; /*//-- Float for Timeout (dataserver calls & inventory changes) --//*/
 
default{
  state_entry(){
    llOwnerSay( "Rebuilding Database" );
    gIdxTgt = llGetInventoryNumber( INVENTORY_LANDMARK );
     /*//-- Gab Landmark Names For Display --//*/
    if (gIdxTgt){
      while(gIdxTgt){
        gLstLMs = (list)llGetInventoryName( INVENTORY_LANDMARK, --gIdxTgt ) + gLstLMs;
      }
       /*//-- Get First LM Location --//*/
      gKeySec = llRequestInventoryData( llList2String( gLstLMs, gIdxTgt = (gLstLMs != []) - 1 ) );
       /*//-- (gLstLMs != []) == llGetListLength( gLstLMs ) --//*/
       /*//-- negative indices would've been nice if they were supported by the Req.Inv.Data call --//*/
      llSetTimerEvent( gFltTmt );
    }
    else{
      gLstLMs = (list)"Out Of Order, No Landmarks Present";
      gLstLoc = (list)<128.0, 128.0, 0.0>;
      state sReady;
    }
  }
 
  dataserver( key vKeySec, string vStrLoc ){
     /*//-- verify we're getting our data, not another scripts --//*/
    if (gKeySec == vKeySec){
       /*//-- Store Location Vector --//*/
      gLstLoc = (list)((vector)vStrLoc) + gLstLoc;
      if (gIdxTgt){
         /*//-- Get Next LM Location --//*/
        gKeySec = llRequestInventoryData( llList2String( gLstLMs, --gIdxTgt ) );
        llSetTimerEvent( gFltTmt );
      }
      else{
         /*//-- Clear Timeout Because Timers Cross States --//*/
        llSetTimerEvent( 0.0 );
        state sReady;
      }
    }
  }
 
  timer(){
    llOwnerSay( "Dataserver Response Timed Out, auto retry in " + (string)((integer)gFltTmt) + " seconds" );
    llSleep( gFltTmt );
    llResetScript();
  }
 
  state_exit(){
     /*//-- Set The Initial Display --//*/
    llSetText( llList2String( gLstLMs, gIdxTgt ), <1.0, 0.0, 0.0>, 1.0 );
    llOwnerSay( "Ready" );
  }
}
 
state sReady{
  touch_start( integer vInt ){
     /*//-- Check if a prim named "prev" or "next" was touched --//*/
    integer vIntTst = llSubStringIndex( "prevnext", llGetLinkName( llDetectedLinkNumber( 0 ) ) );
    if (~vIntTst){
       /*//-- Update Index Target --//*/
      gIdxTgt += ((vIntTst > 0) - (vIntTst < 0));
       /*//-- ((vIntTst > 0) - (vIntTst < 0)) same as: -1 for "prev", +1 for "next" --//*/
 
       /*//-- Update Display --//*/
      llSetText( llList2String( gLstLMs, (gIdxTgt %= (gLstLMs != [])) ), <0.0, 1.0, 0.0>, 1.0 );
       /*//-- (gLstLMs != []) == llGetListLength( gLstLMs ) --//*/
       /*//-- "gInCnt %= " allows us to wrap our references so they don't go out of range --//*/
    }
    else{
       /*//-- Trigger map for any other touched prim in this object --//*/
      llMapDestination( llGetRegionName(), llList2Vector( gLstLoc, gIdxTgt ), ZERO_VECTOR );
    }
  }
 
  changed( integer vBitChg ){
    if (vBitChg & CHANGED_INVENTORY){
       /*//-- give the user more time to add new LMs before we recompile our database lists. --//*/
       /*//-- We could check the count too, but don't in case the change was a change of name --//*/
      llSetTimerEvent( gFltTmt );
    }
  }
 
  timer(){
    llResetScript();
  }
}
 
/*//--                           License Text                           --//*/
/*//  Free to copy, use, modify, distribute, or sell, with attribution.   //*/
/*//    (C)2009 (CC-BY) [ http://creativecommons.org/licenses/by/3.0 ]    //*/
/*//   Void Singer [ https://wiki.secondlife.com/wiki/User:Void_Singer ]  //*/
/*//  All usages must contain a plain text copy of the previous 2 lines.  //*/
/*//--                                                                  --//*/
