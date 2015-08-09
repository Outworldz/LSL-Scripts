// :CATEGORY:Tiny Prims
// :NAME:Fix_Small_Prims_Improved
// :AUTHOR:Innula Zenovka
// :CREATED:2010-11-16 11:04:06.810
// :EDITED:2013-09-18 15:38:53
// :ID:312
// :NUM:411
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Fix_Small_Prims_Improved
// :CODE:
/*based on the wonderful script, Fix Small Prims by Emma Nowhere, http://wiki.secondlife.com/wiki/Fix_Small_Prims, updated by Innula Zenovka to use llGetLinkPrimitiveParams and llSetLinkPrimitiveParamsFast. 
  
Issued under the "do what the hell you like with it, but you if you scam people by selling it on its own I shall be so cross" licence 

This works by finding all prims in a linkset that can't be shrunk any further and, when you click "fix", slightly increasing the size on any axis that's at the minimun, this allowing you to shrink them some more.    Click "rerun" if you hit the minimun size again, to find the small prims again, and then click "fix" to fix them.   Click Delete Script when you are done*/

list options =["Fix", "Delete Script", "ReRun"];
list start_scale;
list to_fix;
integer i;
integer max;
integer rescaleX = FALSE;
integer rescaleY = FALSE;
integer rescaleZ = FALSE;
integer chan;
vector scale;

integer fncStrideCount(list lstSource, integer intStride)
{
  return llGetListLength(lstSource) / intStride;
}

// Returns a Stride from a List
list fncGetStride(list lstSource, integer intIndex, integer intStride)
{
  integer intNumStrides = fncStrideCount(lstSource, intStride);

  if (intNumStrides != 0 && intIndex < intNumStrides)
  {
    integer intOffset = intIndex * intStride;
    return llList2List(lstSource, intOffset, intOffset + (intStride - 1));
  }
  return [];
}
default {
    state_entry() {
        chan = (integer)("0x"+llGetSubString((string)llGetKey(),-8,-1));
        to_fix=[];
        llListen(chan, "", llGetOwner(), "");
        max = llGetNumberOfPrims();
        llOwnerSay("checking for small prims");
        for (i = 1; i <= max; ++i) {
            scale = llList2Vector(llGetLinkPrimitiveParams(i,[PRIM_SIZE]), 0);
            start_scale +=[i] +[scale];    //record start sizes
            if (scale.x < .015) {
                scale.x = .015;
                rescaleX = TRUE;
            }
            if (scale.y < .015) {
                scale.y = .015;
                rescaleY = TRUE;
            }

            if (scale.z < .015) {
                scale.z = .015;
                rescaleZ = TRUE;
            }
            if (rescaleX || rescaleY || rescaleZ) {
                to_fix +=[i] +[scale]; // add new sizes to list
                llOwnerSay("need to fix linknumber "+(string)i);
                rescaleX = FALSE;
                rescaleY = FALSE;
                rescaleZ = FALSE;
            }
        }
        if (llGetListLength(to_fix)==0){
            llOwnerSay("no prims are at the minimum size");
        }
        else{
           llDialog(llGetOwner(),"Please choose one",options,chan);
        } 
    }
    
    touch_start(integer n){
        if(llDetectedKey(0)==llGetOwner()){
            llDialog(llGetOwner(),"Please choose one",options,chan);
        }
    }

    listen(integer channel, string name, key id, string msg) {
        msg=llToLower(msg);
        if(msg=="fix"){
            max=llGetListLength(to_fix)/2;
            for(i=0;i<max;i++){
             list temp = fncGetStride(to_fix, i, 2);
             llOwnerSay("fixing linknumber "+(string)llList2Integer(temp,i));
             llSetLinkPrimitiveParamsFast(llList2Integer(temp,i),[PRIM_SIZE,llList2Vector(temp,i+1)]);
            }
        }
        else if (msg=="restore"){
            llOwnerSay("going back to start size");
            max=llGetListLength(start_scale)/2;
            for(i=0;i<max;i++){
             list temp = fncGetStride(start_scale, i, 2);
             llSetLinkPrimitiveParamsFast(llList2Integer(temp,i),[PRIM_SIZE,llList2Vector(temp,i+1)]);
            }
        }
        
        else if (msg=="delete script"){
            llOwnerSay("deleting script");
            llRemoveInventory(llGetScriptName());
        }
        else if (msg=="rerun"){
            llResetScript();
        }
       
    }

}
