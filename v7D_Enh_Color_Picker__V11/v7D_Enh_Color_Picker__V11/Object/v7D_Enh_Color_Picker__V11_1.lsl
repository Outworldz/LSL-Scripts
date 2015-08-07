// :CATEGORY:Color
// :NAME:v7D_Enh_Color_Picker__V11
// :AUTHOR:Void Singer
// :CREATED:2010-02-01 19:35:20.927
// :EDITED:2013-09-18 15:39:09
// :ID:944
// :NUM:1354
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// v7D_Enh_Color_Picker__V11
// :CODE:
/*//( v7-D Enh. Color Picker v1.2 )//*/
 
/*//-- IMPORTANT NOTE
 This Script MUST be
 placed in one  of the
 prims it is going to
 modify or it will not
 work properly!
 
 All Prims that are to
 be modified at the
 same time MUST have
 the SAME NAME !!!
//*/
 
key     gKeyOwner;
integer gIdxPanel;
integer gChnDialog;
list    gLstTargets;
integer gIntTargets;
vector  gColDefault = <0.0, 0.0, 0.0>;
string  gStrProduct = "v7-D Adv Color Picker v1.2";
list    gLstButtons = ["-1", "-8", "-64", "+1", "+8", "+64",
                       "Recall", "Done!", "Save",
                       "All Colors", "Red Only", "Green Only", "Blue Only"];
list    gLstBValues = [-0.003922, -0.031373, -0.250980, 0.003922, 0.031373, 0.250980,
                       <1.0, 1.0, 1.0>, <1.0, 0.0, 0.0>, <0.0, 1.0, 0.0>, <0.0, 0.0, 1.0>];
 
 
fColorDialog(){
  vector vColTemp = llGetColor( ALL_SIDES ) * 255;
   //-- build the dialog to send
  llDialog( gKeyOwner,
            gStrProduct + "\n\nModifying "
            + llList2String( gLstButtons, gIdxPanel )
            + "\n\nCurrent Values (0-255):\n"
            + "R:" + (string)llRound( vColTemp.x )
            + ", G:" + (string)llRound( vColTemp.y )
            + ", B:" + (string)llRound( vColTemp.z )
            + " = #" + fFloat2HexStr( vColTemp.x )
            + fFloat2HexStr( vColTemp.y )
            + fFloat2HexStr( vColTemp.x ),
            llDeleteSubList( gLstButtons, gIdxPanel, gIdxPanel ),
            gChnDialog );
  llSetTimerEvent( 45.0 );
}
 
string fFloat2HexStr( float vFltInput ){
  integer vBitInput = llRound( vFltInput );
  string  vStrValue = "0123456789ABCDEF";
  return llGetSubString( vStrValue, gIntTargets = vBitInput / 16, gIntTargets )
         + llGetSubString( vStrValue, gIntTargets = vBitInput % 16, gIntTargets );
}
 
fSetColor( vector vColUse ){
   //-- loop through target list of linked prims
  gIntTargets = gLstTargets != [];
  @Loop;
    llSetLinkColor( llList2Integer( gLstTargets, --gIntTargets ), vColUse, ALL_SIDES );
  if (gIntTargets) jump Loop;
}
 
 
default{
  state_entry(){
    gKeyOwner = llGetOwner();
    gChnDialog = (integer)("0xF" + llGetSubString( gKeyOwner, 1, 7 ));
 
    string  vStrTargetID = llGetObjectName();
    gIntTargets = llGetNumberOfPrims();
    @Loop;
      if (llGetLinkName( gIntTargets ) == vStrTargetID){
          gLstTargets += (list)gIntTargets;
      }
    if (~(--gIntTargets)) jump Loop;
    state sReady;
  }
 
  changed( integer vBitChanges ){
    if ((CHANGED_OWNER | CHANGED_LINK) & vBitChanges){
      llResetScript();
    }
  }
}
 
state sReady{
  state_entry(){
    gIdxPanel = 9;
  }
 
  touch_end( integer vIntTotal ){
    if (llDetectedKey( 0 ) == gKeyOwner){
      state sRunning;
    }
  }
 
  changed( integer vBitChanges ){
    if ((CHANGED_OWNER | CHANGED_LINK) & vBitChanges){
      state default;
    }
  }
}
 
 
state sRunning{
  state_entry(){
    llListen( gChnDialog, "", gKeyOwner, "" );
    fColorDialog();
  }
 
  listen( integer vIntChannel, string vStrName, key vKeySpeaker, string vStrHeard ){
     //-- get the index of the reply from our button list
    integer vIdxReply = llListFindList( gLstButtons, (list)vStrHeard );
     //-- is it a valid index? ~(-1) = FALSE
    if (~vIdxReply){
       //-- reply index 0 -5
      if (6 > vIdxReply){
         //-- get current color add change amount form dialog
        vector vColCalc = llGetColor( ALL_SIDES )
                          + llList2Vector( gLstBValues, gIdxPanel - 3 )
                          * llList2Float( gLstBValues, vIdxReply );
         //-- Clamp color values to [0, 1]

// change by fkb 1/10/2013
        float a = (integer) (0.0 < vColCalc.x && vColCalc.x < 1.0) * vColCalc.x;    
        float b = (integer) (0.0 < vColCalc.y && vColCalc.y < 1.0) * vColCalc.y;
        float  c = (integer) (0.0 < vColCalc.z && vColCalc.z < 1.0) * vColCalc.z;

        integer d = (vColCalc.x >= 1.0);
        integer e = (vColCalc.y >= 1.0);
        integer f = (vColCalc.z >= 1.0);


                                
        fSetColor( <a,b,c> +  <d,e,f> );


//        fSetColor( <(0.0 < vColCalc.x && vColCalc.x < 1.0) * vColCalc.x,
//                    (0.0 < vColCalc.y && vColCalc.y < 1.0) * vColCalc.y,
//                    (0.0 < vColCalc.z && vColCalc.z < 1.0) * vColCalc.z>
//                   + <(vColCalc.x >= 1.0),
//                     (vColCalc.y >= 1.0),
//                       (vColCalc.z >= 1.0)> );

       //-- reply index 6-8
      }else if (9 > vIdxReply){
         //-- Apply Saved Color
        if (6 == vIdxReply){
          fSetColor( gColDefault );
         //-- done, go back to waiting
        }else if (7 == vIdxReply){
          llSetTimerEvent( 0.0 );
          state sReady;
         //-- save current color
        }else{
          gColDefault = llGetColor( ALL_SIDES );
          llWhisper( 0, "Color saved." );
        }
       //-- reply index 9-12
      }else if (13 > vIdxReply){
       //-- change dialog panel
        gIdxPanel = vIdxReply;
      }
      fColorDialog();
    }
  }
 
  timer(){
     //-- timeout to kill listens
    llSetTimerEvent( 0.0 );
    llOwnerSay( gStrProduct + " Dialog Timed Out." );
    state sReady;
  }
 
  changed( integer vBitChanges ){
    if ((CHANGED_OWNER | CHANGED_LINK) & vBitChanges){
      state default;
    }
  }
}
 
/*//--                           License Text                           --//*/
/*//  Free to copy, use, modify, distribute, or sell, with attribution.   //*/
/*//    (C)2009 (CC-BY) [ http://creativecommons.org/licenses/by/3.0 ]    //*/
/*//   Void Singer [ https://wiki.secondlife.com/wiki/User:Void_Singer ]  //*/
/*//  All usages must contain a plain text copy of the previous 2 lines.  //*/
/*//--                                                                  --//*/
