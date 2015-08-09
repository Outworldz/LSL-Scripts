// :CATEGORY:Greeter
// :NAME:v7D_Advanced_Visitor_Greeter
// :AUTHOR:Void Singer
// :CREATED:2010-02-01 19:37:23.033
// :EDITED:2013-09-18 15:39:09
// :ID:943
// :NUM:1353
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// v7D_Advanced_Visitor_Greeter
// :CODE:
/*//( v7-D Advanced Avatar Greeter v1.4 )//*/
 
/*//-- NOTE:
 Remove Any Instances Of "(gLstAvs = []) + " Or "(gLstTms = []) + " When Compiling This
 Script To MONO. They Are Provided For LSO Memory Preservation And Do Nothing In MONO
//*/
 
list    gLstAvs;        /*//-- List Of Avatars Keys Greeted --//*/
list    vLstChk;        /*//-- List Of Av Key Being Checked During Sensor Processing --//*/
integer vIdxLst;        /*//-- Index Of Checked Item In List (reused) --//*/
integer gIntMax = 500;  /*//-- Maximum Number of Names To Store --//*/
 /*//-- Previous Code Line PreSet to Ease Removing Dynamic Memory Limitation Code --//*/
 
 /*//-- Next Code Line  Belongs to Dynamic Memory Limitation Section --//*/
integer int_MEM = 1000; /*//-- memory to preserve for safety--//*/
 
 /*//-- Start Av Culling Section --//*/
integer gIntPrd = 172800; /*//-- Number Of Seconds After Detection To Store Av --//*/
integer vIntNow;          /*//-- Integer To Store Current Time During Sensor Processing --//*/
list    gLstTms;          /*//-- List Of Most Recent Times Avs Were Greeted At --//*/
list    vLstTmt;          /*//-- List To Store Timeout During Sensor Processing --//*/
 /*//-- End Av Culling Section --//*/
 
default{
  state_entry(){
     /*//-- Next Code Line Belongs To Dynamic Memory Limitation Section --//*/
    gIntMax = 1000;                      /*//-- Intial list Max --//*/
    llSensor( "", "", AGENT, 95.0, PI ); /*//-- Pre-Fire Sensor For Immediate Results --//*/
    llSetTimerEvent( 30.0 );             /*//-- Sensor Repeat Frequency --//*/
  }
 
  timer(){
    llSensor( "", "", AGENT, 95.0, PI ); /*//-- Look For Avatars --//*/
  }
 
  sensor( integer vIntTtl ){
     /*//-- Save Current Timer to Now, Then Add Period and Save To Timeout--//*/
    vLstTmt = (list)(gIntPrd + (vIntNow = llGetUnixTime()));
     /*//-- Previous Code Line Belongs to Av Culling Section --//*/
    @Building;{
       /*//-- Is This Av Already In Our List? --//*/
      if (~(vIdxLst = llListFindList( gLstAvs, (vLstChk = (list)llDetectedKey( --vIntTtl )) ))){
         /*//-- Delete The Old Entries & Add New Entries to Preserve Order --//*/
        gLstAvs = llDeleteSubList( (gLstAvs = []) + gLstAvs, vIdxLst, vIdxLst ) + vLstChk;
         /*//-- Next Code Line Belongs to Av Culling Section --//*/
        gLstTms = llDeleteSubList( (gLstTms = []) + gLstTms, vIdxLst, vIdxLst ) + vLstTmt;
      }
      else{
         /*//-- Oo Goody, Hi New Av! Add Them To The Lists & Preserve Max List Size--//*/
        llInstantMessage( (string)vLstChk, "Hello " + llDetectedName( vIntTtl ) );
        gLstAvs = llList2List( (gLstAvs = []) + vLstChk + gLstAvs, 0, gIntMax );
         /*//-- Next Code Line Belongs to Av Culling Section --//*/
        gLstTms = llList2List( (gLstTms = []) + vLstTmt + gLstTms, 0, gIntMax );
      }
    }if (vIntTtl) jump Building;
 
     /*//-- Start Dynamic Memory Limitation Section --//*/
     /*//-- Only lower Max List Size Once For Saftey --//*/
    if (int_MEM == gIntMax){
       /*//-- do we have plenty of room in the script? --//*/
      if (int_MEM > llGetFreeMemory()){
         /*//-- running out of room, set the Max list size lower --//*/
        gIntMax = ~([] != gLstAvs);
      }
    }
     /*//-- End Dynamic Memory Limitation Section --//*/
 
     /*//-- Start Av Culling Section --//*/
     /*//-- do we have keys? --//*/
    if (vIdxLst = llGetListLength( gLstTms )){
       /*//-- Do Any Need Culled? --//*/
      if (vIntNow > llList2Integer( gLstTms, --vIdxLst )){
         /*//-- Find The Last Index that hasn't hit timeout status --//*/
        @TheirBones; if (--vIdxLst) if (vIntNow > llList2Integer( gLstTms, vIdxLst )) jump TheirBones;
         /*//-- Thin the herd --//*/
        gLstAvs = llList2List( (gLstAvs = []) + gLstAvs, 0, vIdxLst );
        gLstTms = llList2List( (gLstTms = []) + gLstTms, 0, vIdxLst );
      }
    }
     /*//-- End Av Culling Section --//*/
  }
}
 
/*//--                           License Text                           --//*/
/*//  Free to copy, use, modify, distribute, or sell, with attribution.   //*/
/*//    (C)2009 (CC-BY) [ http://creativecommons.org/licenses/by/3.0 ]    //*/
/*//   Void Singer [ https://wiki.secondlife.com/wiki/User:Void_Singer ]  //*/
/*//  All usages must contain a plain text copy of the previous 2 lines.  //*/
/*//--                                                                  --//*/
