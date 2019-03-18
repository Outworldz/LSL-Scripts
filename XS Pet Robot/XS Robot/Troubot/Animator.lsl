// :CATEGORY:XS Pet
// :NAME:XS Pet Robot
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS: Pet,XS,breed,breedable,companion,Ozimal,Meeroo,Amaretto,critter,Fennux,Pets
// :CREATED:2013-09-06
// :EDITED:2014-01-30 12:24:21
// :ID:988
// :NUM:1456
// :REV:0.50
// :WORLD:Second Life, OpenSim
// :DESCRIPTION:
// XS Pet  prim animator compiler 
// :CODE:

// Author: Fred Beckhusen (Ferd Frederix)
// This prim animator compiler is a very useful and easy to use script for Second Life and OpenSim. Setup is very simple. Just drop the two script into the object, click the object, and give your animation a name. Move all the prims around, and click Record. When done, click the Compile button. It writes fast, optimized code for you.

// Downloaded from : http://www.outworldz.com/cgi/freescripts.plx?ID=1691

// This program is free software; you can redistribute it and/or modify it.
// Additional Licenes may apply that prevent you from selling this code
// and these licenses may require you to publish any changes you make on request.
//
// There are literally thousands of hours of work in these scripts. Please respect
// the creators wishes and Copyright law and follow their license requirements.
//
// License information included herein must be included in any script you give out or use.
// Licenses may also be included in the script or comments by the original author, in which case
// the authors license must be followed, and  their licenses override any licenses outlined in this header.
//
// You cannot attach a license to any of these scripts to make any license more or less restrictive.
//
// All scripts by avatar Fred Beckhusen (Ferd Frederix), unless stated otherwise in the script, are licensed as Creative Commons By Attribution and Non-Commercial.
// Commercial use is NOT allowed - no resale of my scripts in any form.  
// This means you cannot sell my scripts but you can give them away if they are FREE.  
// Scripts by Fred Beckhusen (Ferd Frederix) may be sold when included in a new object that actually uses these scripts. Putting my script in a prim and selling it on marketplace does not constitute a build.
// For any reuse or distribution, you must make clear to others the license terms of my works. This is done by leaving headers intact.
// See http://creativecommons.org/licenses/by-nc/3.0/ for more details and the actual license agreement.
// You must leave any author credits and any headers intact in any script you use or publish.
///////////////////////////////////////////////////////////////////////////////////////////////////
// If you don't like these restrictions and licenses, then don't use these scripts.
//////////////////////// ORIGINAL AUTHORS CODE BEGINS ////////////////////////////////////////////
// For more details on how this script works, see <a href="http://www.outworldz.com/secondlife/posts/prim-compiler/">http://www.outworldz.com/secondlife/posts/prim-compiler/</a>
//
//This is the Animator menu system.  You will also need to the compiler script.  You can adjust the script for OpenSim or Second Life with one variable set to TRUE or FALSE for memory checking.   
// ______           _  ______            _           _
// |  ___|         | | |  ___|          | |         (_)
// | |_ ___ _ __ __| | | |_ _ __ ___  __| | ___ _ __ ___  __
// |  _/ _ \ '__/ _` | |  _| '__/ _ \/ _` |/ _ \ '__| \ \/ /
// | ||  __/ | | (_| | | | | | |  __/ (_| |  __/ |  | |>  <
// \_| \___|_|  \__,_| \_| |_|  \___|\__,_|\___|_|  |_/_/\_\
//
// fred@mitsi.com
// 2-19-2012

// Animator front-end for Compiler Script
// This is free software, it is not for sale at any price

integer playchannel = 1;    // the playback channel, this is the channel you use in LinkMessages
integer debug = FALSE;      // if set to TRUE, debug info appears
integer dialogchannel ;         // dialog boxes
integer nPrims;                 // total number of prims
integer wantname;               // flag indicating we are waiting for a name to be chatted
integer wantnum;                // flag asking for numbers to be chatted.

// Link messages
integer CLEAR = -234756;
integer DATA = -234757;
integer COMPILE = -234758;
integer DIE = -234759;

// the list of coords
list masterlist;        // master list of all positions
list llastPrimList;      // storage of the last prim position we learned
string curranimation;   // what we are playing
integer STRIDE = 5;     // size of the master list
integer lastSTRIDE = 3; // size of the last prim list
integer listener;       // temp listener when we are waiting for them to give us a name
vector InitSize;        // the initial size when the prims were recorded
list LoadedAnims;       // animations added to the Menu display

DEBUG(string msg)
{
    if (debug) llOwnerSay("// " + msg);
}

Record()
{
    if (llStringLength(curranimation) > 0)
    {
        integer foundmovement = 0;      // will be set if any child moved
        integer PrimCounter ;        // skip past the root prim
        for (PrimCounter =2; PrimCounter <= nPrims; PrimCounter++ )
        {
            //DEBUG("Checking Prim " + (string) PrimCounter);

            list my_list = llGetLinkPrimitiveParams(PrimCounter,[PRIM_POSITION,PRIM_ROTATION, PRIM_SIZE ]);
            // position is always in region coordinates, even if the prim is a child or the root prim of an attachment.
            // rot is always the global rotation, even if the prim is a child or the root prim of an attachment.
            // get current prim pos, rot and size
            vector      vrealPrimPos    = llList2Vector (my_list,0) - llGetPos();   // position subtract Global Pos
            vrealPrimPos /= llGetRot();
            rotation    rrealPrimRot    = llList2Rot    (my_list,1) / llGetRot();   // rotation subtract Global Rot
            vector      vrealPrimSize   = llList2Vector (my_list,2);                 // size

            // compare it to the last one we had
            integer iindex = (PrimCounter - 2) * lastSTRIDE;    // zeroth position is PrimCounter - start, or 2

            // get the last thing we remembered about this prim
            vector      vlastPrimPos    = llList2Vector     (llastPrimList, iindex);
            rotation    rlastPrimRot    = llList2Rot        (llastPrimList, iindex+1);
            vector      vlastPrimSize   = llList2Vector     (llastPrimList, iindex+2);

            //if (debug)
            //{
            //    vrealPrimPos = <1,2,llFrand(1)>; // make a small change for debugging in LSL Editor
            //}

            // if anything changed on this prim, we must record it.
            if (vlastPrimPos != vrealPrimPos ||
                rlastPrimRot != rrealPrimRot ||
                vlastPrimSize!= vrealPrimSize
                    )
                    {
                        foundmovement++;

                        //Save changes in the master list of all animations
                        masterlist += curranimation;
                        masterlist += (float) PrimCounter;
                        masterlist += vrealPrimPos;
                        masterlist += rrealPrimRot;
                        masterlist += vrealPrimSize;

                        string msg =  curranimation + "|" + (string) PrimCounter + "|" + (string) vrealPrimPos + "|" + (string) rrealPrimRot + "|" + (string) vrealPrimSize ;
                        llMessageLinked(LINK_ROOT,DATA,msg,"");

                        // update the last movement list
                        llastPrimList = llListReplaceList(llastPrimList,[vrealPrimPos],iindex,iindex);
                        llastPrimList = llListReplaceList(llastPrimList,[rrealPrimRot],iindex+1,iindex+1);
                        llastPrimList = llListReplaceList(llastPrimList,[vrealPrimSize],iindex+2,iindex+2);

                    } // if
            else
            {
                //DEBUG( (string) PrimCounter);
            }
        } // for

        //DEBUG("history:" + llDumpList2String(llastPrimList,":"));

        if (foundmovement)
        {
            llOwnerSay("Recorded " + (string) foundmovement + " prims" );
        }
        else
        {
            llOwnerSay("You must move at least one child prim.");
        }
    }
    else
    {
        llOwnerSay("You must name your animation.");
        llOwnerSay("Type the new animation name on channel /" + (string) dialogchannel);
        wantname++;
    }
}

// on reset, record the base position in history so we can see changes
Clear()
{
    llMessageLinked(LINK_ROOT,CLEAR,"","");
    LoadedAnims = [];           // wipe out Menu
    masterlist = [];            // wipe all recordings
    llastPrimList = [];         // wipe last animations
    integer PrimCounter ;       // skip 1, which is the root prim
    integer counter = 0;
    // save all the current settings in memory
    for (PrimCounter=2; PrimCounter <= nPrims; PrimCounter++ )
    {
        list my_list = llGetLinkPrimitiveParams(PrimCounter,[PRIM_POSITION,PRIM_ROTATION, PRIM_SIZE ]);

        // save the local  pos and rot, since llGetLinkPrimitiveParams returns global pos and rot
        vector primpos      = llList2Vector (my_list,0) - llGetPos();
        primpos /= llGetRot();
        rotation primrot    = llList2Rot    (my_list,1) / llGetRot();
        vector primsize     = llList2Vector (my_list,2) ;


        llastPrimList += primpos;
        llastPrimList += primrot;
        llastPrimList += primsize;
        counter++;
    }
    llOwnerSay("There are " + (string) counter + " animatable prims");
}

DumpBack ()
{
    integer imax = llGetListLength(masterlist);
    integer howmany = imax / STRIDE ;
    llOwnerSay("Preprocessing " + (string) howmany + " movements. " );
    llMessageLinked(LINK_ROOT,COMPILE,"","");
}


rotation calcChildRot(rotation rdeltaRot)
{

    if (llGetAttached())
        return rdeltaRot/llGetLocalRot();
    else
        return rdeltaRot/llGetRootRotation();

}


PlayBack (string name)
{
    integer i;
    integer imax = llGetListLength(masterlist);

    integer linknum = 0;

    for (i = 0; i < imax; i+= STRIDE)
    {
        string saniName = llList2String(masterlist,i);

        vector scale = llGetScale();
        float delta =  scale.x / InitSize.x ;   // see if the root prim has grown or shrunk as a percentage
        if (saniName == name)
        {
            float fprimNum      = llList2Float(masterlist,i+1);
            vector  vPos        = llList2Vector(masterlist,i+2);
            rotation rRot       = llList2Rot(masterlist,i+3) ;
            vector vprimSize    = llList2Vector(masterlist,i+4) ;

            vPos *= delta;                           // add any difference in size to it positions there
            vprimSize *= delta;                      // grow the child prim, too

            // support negative prim numbers as a delay
            if (fprimNum < 0)
            {
                // DEBUG("Sleeping " + (string) (fprimNum * -1));
                llSleep((float) fprimNum * -1);
            }
            else
            {
                // set the local pos and locat rot to the prims orientation and position
                rRot  = calcChildRot(rRot);

                list actions = [PRIM_POSITION,vPos,PRIM_ROTATION,rRot,PRIM_SIZE,vprimSize];
                //DEBUG("Moving prim :" + (string) fprimNum + ":" + llDumpList2String(actions,":"));

                llSetLinkPrimitiveParamsFast((integer) fprimNum,actions);
            }
        }
    }
}

MakeMenu()
{
    list amenu = ["Reset","Record","Help","Name","Compile","Pause", "Finish"] + LoadedAnims;

    llListenRemove(listener);
    listener = llListen(dialogchannel,"","","");
    amenu = llDeleteSubList(amenu,12,99);
    llDialog(llGetOwner(), "Pick a command",amenu,dialogchannel);
}


default
{
    state_entry()
    {
        InitSize = llGetScale();            // save the size  when we recorded the prims
        nPrims = llGetNumberOfPrims();      // how many we are recording
        llOwnerSay("Prim count = " + (string) nPrims);
        Clear();

        dialogchannel = (integer) (llFrand(100) +600);
        MakeMenu();
    }


    touch_start(integer total_number)
    {
        if (llDetectedKey(0) == llGetOwner())
        {
            llOwnerSay("FreeMemory="+(string)llGetFreeMemory());
            MakeMenu();
        }
    }

    listen( integer channel, string name, key id, string message )
    {
        if (message == "Finish")
        {
            llMessageLinked(LINK_ROOT,DIE,"die","");
            if (! debug)
            {
                llRemoveInventory(llGetScriptName());
            }
        }
        else if (message == "Reset")
        {
            llResetScript();
        }
        else if (wantnum)
        {
            float num = (float) message;
            if (num > 0.0)
            {
                num = -1 * (num /1000);
                masterlist += curranimation;
                masterlist += num;
                masterlist += <0,0,0>;  // pos
                masterlist += <0,0,0,1>;// rot
                masterlist += <0,0,0>;  // size
                string msg =  curranimation + "|" + (string) num + "|<0,0,0>|<0,0,0,1>|<0,0,0>" ;
                llMessageLinked(LINK_ROOT,DATA,msg,"");
            }
            else
            {
                llOwnerSay("Please enter numbers in milliseconds. 1000=1000ms = 1 second. 500=500ms = 1/2 a second.");
                llOwnerSay("What is a milliHelen?  A milliHelen is a face that can launch one ship!");
            }
            wantnum = FALSE;
            MakeMenu();
        }
        else if (message =="Pause")
        {
            wantnum= TRUE;
            llListenRemove(listener);
            listener = llListen(dialogchannel,"","","");
            llTextBox(llGetOwner(), "Enter a delay in milliseconds:\n1000 = 1 second\n500 = 1/2 second",dialogchannel);
        }
        else if (message == "Record")
        {
            Record();
            MakeMenu();
        }
        else if (message == "Name")
        {
            llOwnerSay("Enter a new name, or type the animation name on channel /" + (string) dialogchannel);

            wantname = TRUE;
            MakeMenu();
            llTextBox(llGetOwner(),"Enter an Animation Name",dialogchannel);
        }
        else if (message == "Compile")
        {
            DumpBack();
            MakeMenu();
        }
        else if (message == "Help")
        {
            llLoadURL(llGetOwner(),"View online help", "http://secondlife.mitsi.com/secondlife/Posts/Prim-Compiler");
        }
        else if (wantname)
        {
            curranimation = message;
            LoadedAnims += message;

            MakeMenu();
            llOwnerSay("Recording is ready for animation '" + curranimation + "'");
            llOwnerSay("Position any child  prims, then select the menu item 'Record', and repeat as necessary. When finished, click 'Compile' to save the animation, or click the animation name to play it back.  Click 'Name' to start a new animation sequence");
            wantname = 0;
        }
        else
        {
            if (llListFindList(LoadedAnims,[message]) != -1)
            {
                PlayBack(message);
                MakeMenu();
            }
        }


    }
}


