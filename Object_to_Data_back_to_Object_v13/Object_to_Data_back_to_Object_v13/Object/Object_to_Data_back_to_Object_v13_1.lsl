// :CATEGORY:Building
// :NAME:Object_to_Data_back_to_Object_v13
// :AUTHOR:Xaviar Czervik
// :CREATED:2011-01-22 12:03:27.567
// :EDITED:2013-09-18 15:38:58
// :ID:579
// :NUM:792
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
(http://www.gnu.org/copyleft/fdl.html) in the spirit of which this script is GPL'd. Copyright (C) 2009 Xaviar Czervik// // This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.// // This is one of the projects that I've spent a significant amount of time on, and that I've uploaded to the wiki. It's purpose is simple: it allows anyone to transfer objects through text. This may seem trivial, but it has several advantages to it. Below are a few ways in which this script can be used:// 
//    1. The Internet. There is no way (yet) to go on to the Internet and request an object be sent to your SL character. This solves this issue. One could post the data on to the Internet, and allow people to copy the text down to SL, run this script, and obtain an object from it.
//    2. Management Scripts. There is no way to have an object create a totally new object. And objects can only call llGiveInventory on other objects when in the same sim. This solves the issue by allowing objects to use email to send data, which can then be turned into an object. 
// 
// Revision History
// 
// Version 1.3:
// 
//    1. 100% success rate.
//    2. Added PRIM_GLOW
//    3. Added functionality for multiple notecards (for really big objects).
//    4. Improved efficiency; removed the delink/relink sections. 
// 
// Version 1.2:
// 
//    1. Around 95% success rate.
//    2. Changed to almost all llGetPrimitiveParams calls.
//    3. Added more than just ten different descriptors of an object.
//    4. Removed freakish menu-controlled system.
//    5. Script need only be dropped in root object, not every prim. 
// 
// Version 1.1:
// 
//    1. Made process simpler: removed replicate from listen.
//    2. Changed to work (slightly) better. 
// 
// Version 1.0:
// 
//    1. First release. 
// 
// 
// Instructions
// 
// Thanks to DMC Zsigmond for the original documentation shown below, modified for Version 1.3 by Xaviar.
// 
// Check List (Parts Required):
// 
// 1 x Script, named: "Data To Object" 1 x Script, named: "Object to Data" 1 x Script, named: "Holo Script" 1 x Object, named: "HoloBox" 1 x Notecard, named: "Data_Default" Plus, 1 x Any Object you wish to use these scripts with to turn into data, or re-rez it back again.
// 
// 
// Part 1/2 - Instructions to convert an Object to Data
// 
//    1. Select an Object you wish to turn into data (NB. perhaps start with a single object which is relatively simple).
//    2. Rez the Object you wish to turn into data on the ground.
//    3. Right-click the Object you wish to turn into data, and select edit. Then click on the "Content" tab to view its contents.
//    4. Open your "Inventory", and create a new folder, called: "Object to Data v1.3".
//    5. Under the new "Object to Data v1.3" folder, right-click and create a new script, named "Data To Object". Then copy and paste the "Data To Object" LSL code on this wiki page into the "Data To Object" script you just created under your "Object to Data v1.3" folder. Click on "Save" to compile the "Data to Object" script, and then after that "Data to Object" script has successfully compiled, close the script.
//    6. Repeat Step 5, for both "Object to Data", "Replicate Main" and "Holo Script" scripts.
//    7. With the Object you wish to turn into data still selected, and with the "Content" tab highlighted/activated, drag'n'drop the "Replicate Main" script you created in your Inventory, from your "Object to Data v1.3" folder into the "Contents" folder of the Object you wish to turn into data.
//    8. Now drag'n'drop the "Object to Data" script you created in your Inventory, from your "Object to Data v1.3" folder into the "Contents" folder of the Object you wish to turn into data. Your Local Chat window will now inform you that the Object is deploying scripts, and to please wait...
//    9. Once it finishes, deselect the Object you wish to turn into data, and then right-click on it, and select, "Take", to take the object back into your inventory.
//   10. Locate your Object you wish to turn into data from within your "Inventory", and then re-rez it on the ground again.
//   11. At this point, the right-click on the "Object" you wish to turn into data and "select" it again.
//   12. With the Object selected, go to your "Tools" menu on the Second Life browser, and select "Set Scripts to Running in Selection". A "Set Running Progress" dialogue box will pop up notifying you that the "Object to Data" script inside it, is running - and Done.
//   13. Close this dialogue box, and then right-click on the Object you wish to turn into data and select, "Take" to take the object back into your Inventory for a 2nd time.
//   14. Locate your Object you wish to turn into data from within your "Inventory" for a 2nd time.
//   15. Re-rez the Object on the ground for a final time. Wait a few moments (or possibly a minute or two) until your Local Chat Window outputs the Object's data.
//   16. Copy the text data from your Local Chat Window (including the time code) from the very beginning to the very end.
//   17. Return to your Inventory folder named, "Object to Data v1.3", and then right-click and create a new note (i.e. notecard) called, "Data_Default".
//   18. Paste the Object code data copied from your Local Chat Window to the "Data_Default" notecard, and then "Save" it. This notecard now holds the data information for your Object.
//   19. If the information does not fit in to one notecard, the first object stays named "Data_Default", however name the second notecard "Data_Default 1", the third "Data_Default 2", etc. 
// 
// The entire object has now been turned into data. It can now be transferred through many means not usually possible, including a text file on the Internet.
// 
// End of Part 1/2.
// 
// 
// Part 2/2 Instructions to convert Data to Object
// 
//    1. Create a new Object on the ground, and then right-click on it, and select "Edit".
//    2. Under the "General" tab, name the Object you just created as, "HoloBox". This object must be inserted into your "Data to Object" object in future to supply the prim that will be converted back into the original Object you once sort to have turned into text/notecard data.
//    3. Go the the "Content" tab of the "HoloBox" prim, to view its contents.
//    4. Drag'n'drop the "Holo Script" script under the "Object to Data v1.3" folder in your Inventory, to the "Contents" folder of the "HoloBox" object you have selected.
//    5. Right-click the "HoloBox" object, and select "Take, to take the object back into your inventory.
//    6. Create a new Object on the ground, right-click it, and select "Edit". (Move the object some meters above the ground, since it will silently fail and hang if later [=>14.] it attempts to rez objects slightly below ground level!)
//    7. Under the "General" tab, name the Object you just created as, "Data to Object". (not necessary)
//    8. Go the the "Content" tab of the "Data to Object" prim, to view its contents.
//    9. Drag'n'drop the "Data To Object" script under the "Object to Data v1.3" folder in your Inventory, to the "Contents" folder of the "Data to Object" object you have selected.
//   10. Drag'n'drop the "HoloBox" object you have either in your "Objects" folder in your Inventory or under the "Object to Data v1.3" folder in your Inventory, to the "Contents" folder of the "Data to Object" object you have selected.
//   11. Drag'n'drop the "Data_Default" notecard(s) under the "Object to Data v1.3" folder in your Inventory, to the "Contents" folder of the "Data to Object" object you have selected.
//   12. Confirm in the "Contents" folder of your object named "Data to Object", you now have the following items contained inside it: 1 x Script, named "Data to Object"; 1 (or as many as needed) x Notecard(s), named "Data_Default" (with following numbers, if needed); and 1 x Object, named "HoloBox".
//   13. Deselect the object, "Data to Object".
//   14. Now touch the object, "Data to Object" to begin rebuilding the original Object that you had turned into data. It can now be turned back into an Object again.
//   15. View your Local Chat window for confirm of the build "Start", and notification when the build is "Done". 
// 
// The original Object you sort to have turned into data will now rez as a new object above the "Data to Object" prim.
// 
// This object will be empty, ready for use as intended.
// 
// End of Part 2/2
// 
// 
// Data To Object (Script) 
// :CODE:
string name = "Data_Default";
 
integer numberOfNotes;
key     qid;
integer line = 0;
integer lineTotal = 0;
integer prims;
list    totalLines;
integer totalLinesTotal;
 
string hexDigits = "0123456789ABCDEF";
 
integer rand;
 
integer whichNote;
 
vector start;
 
get() {
    if (whichNote == 0) {
        qid = llGetNotecardLine(name, line);
    } else {
        qid = llGetNotecardLine(name + " " + (string)whichNote, line);
    }
 
}
 
rezObj(vector pos, string num) {
    while (llVecDist(llGetPos(), start-pos) > .001) llSetPos(start-pos);
    llRezObject("HoloBox", llGetPos(), <0,0,0>, <0,0,0,0>, hex2int(num) + rand);
}
 
integer hex2int(string hex) {
    integer p1 = llSubStringIndex(hexDigits, llGetSubString(hex, 0, 0));
    integer p2 = llSubStringIndex(hexDigits, llGetSubString(hex, 1, 1));
    integer data = p2 + (p1 << 4);
    return data;
}
 
default {
    touch_start(integer i) {
        llSetText("Starting Up... (1/4)", <1,1,1>, 1);
        numberOfNotes = llGetInventoryNumber(INVENTORY_NOTECARD);
 
        qid = llGetNumberOfNotecardLines(name);
    }
    dataserver(key queryId, string data) {
        if (queryId == qid)  {
            totalLines += data;
            totalLinesTotal += (integer)data;
            ++whichNote;
            if (whichNote < numberOfNotes) {
                llOwnerSay(name + " " + (string)whichNote);
                qid = llGetNumberOfNotecardLines(name + " " + (string)whichNote);
            } else {
                state rez;
            }
        }
    }
}
 
state rez {
    state_entry() {
        start = llGetPos();
        rand = (integer)llFrand(0x6FFFFFFF) + 0x10000000;
        llOwnerSay("Start");
        line = 0;
        qid = llGetNotecardLine(name, line); 
        whichNote = 0;
    }
    dataserver(key queryId, string data) {
        if (queryId == qid)  {
            if (data != EOF) {
                data = llList2String(llParseString2List(data, ["-----: "], []), 1);
                if (llGetSubString(data, 0, 3) == "#NEW") {
                    string num = llGetSubString(data, 5, 6);
                    vector pos = (vector)llGetSubString(data, 8, -1);
                    rezObj(pos, num);
                }
                llSetText("Rezing Prims: " + (string)((integer)(100*lineTotal/totalLinesTotal)) + "% (2/4)", <1,1,1>, 1);
                line += 1;
                lineTotal += 1;
                get();
            } else {
                whichNote++;
                if (whichNote < numberOfNotes) {
                    line = 0;
                    get();
                } else {
                    state run;
                }
            }
        }
    }
}
 
state run {
    state_entry() {
        line = 0;
        lineTotal = 0;
        qid = llGetNotecardLine(name, line); 
        whichNote = 0;
    }
    dataserver(key queryId, string data) {
        if (queryId == qid)  {
            if (data != EOF) {
                data = llList2String(llParseString2List(data, ["-----: "], []), 1);
                if (llGetSubString(data, 0, 3) != "#NEW") {
                    list parts = llParseString2List(data, [":::"], []);
                    integer prim = hex2int(llList2String(parts, 0));
                    llRegionSay(rand + prim, llList2String(parts, 1));
                }
                llSetText("Sending Data: " + (string)((integer)(100*lineTotal/totalLinesTotal)) + "% (3/4)", <1,1,1>, 1);
                line += 1;
                lineTotal += 1;
                get();
            } else {
                whichNote++;
                if (whichNote < numberOfNotes) {
                    line = 0;
                    get();
                } else {
                    llSetText("Cleaning Up... (4/4)", <1,1,1>, 1);
                    integer i = 0;
                    while (i < 256) {
                        llRegionSay(rand + i, "Finish");
                        ++i;
                    }
                    llSetTimerEvent(3);
                }
            }
        }
    }
    timer() {
        llSetText("Finished.", <1,1,1>, 1);
        llOwnerSay("Done");
        llSetTimerEvent(0);
        llResetScript();
    }
}

