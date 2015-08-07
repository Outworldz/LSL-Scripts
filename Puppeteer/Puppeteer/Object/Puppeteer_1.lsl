// :CATEGORY:Prim
// :NAME:Puppeteer
// :AUTHOR:Kira Komarov
// :KEYWORDS:
// :CREATED:2012-03-24 17:21:10.650
// :EDITED:2014-02-07 19:09:18
// :ID:666
// :NUM:906
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// [K] Puppeteer Animator
// :CODE:
// How it Works// The puppeteer works in the following way:// 1.) You drop the [K] Puppeteer Recorder in a prim you wish to create an animation for.// 2.) You move / rotate the prim to the next position and at each step, you touch the prim and select "◆ Mark ◆".// 3.) Once you have marked several positions, you touch the puppeteer recorder and select "◆ Dump ◆". This will dump all the recoded data on the local chat and it would look something like this:// Object: ------------- BEGIN CUT -------------
// Object: #<57.401940, 113.362300, 1001.491000>#<56.057780, 113.362300, 1001.491000>#<56.057780, 113.362300, 1002.707000>#<56.649890, 113.362300, 1002.707000>#<56.649890, 113.362300, 1003.624000>#<55.782050, 113.362300, 1003.624000>#
// Object: [K]
// Object: #<0.000000, 0.000000, 0.000000, 1.000000>#<0.000000, 0.000000, 0.000000, 1.000000>#<0.000000, 0.000000, 0.000000, 1.000000>#<0.000000, 0.000000, 0.000000, 1.000000>#<0.000000, 0.000000, 0.000000, 1.000000>#<0.000000, 0.000000, 0.000000, 1.000000>#
// Object: -------------- END CUT --------------
// 4.) Now you need to clean it up a little bit to delete the object name (in this case "Object: ") from the data as well as the cut lines. After the cleaning, based on the previous example, the data should look like this:
// #<57.401940, 113.362300, 1001.491000>#<56.057780, 113.362300, 1001.491000>#<56.057780, 113.362300, 1002.707000>#<56.649890, 113.362300, 1002.707000>#<56.649890, 113.362300, 1003.624000>#<55.782050, 113.362300, 1003.624000>#
// [K]
// #<0.000000, 0.000000, 0.000000, 1.000000>#<0.000000, 0.000000, 0.000000, 1.000000>#<0.000000, 0.000000, 0.000000, 1.000000>#<0.000000, 0.000000, 0.000000, 1.000000>#<0.000000, 0.000000, 0.000000, 1.000000>#<0.000000, 0.000000, 0.000000, 1.000000>#
// 5.) Now, you take that cleaned data, and save it in a notecard called Puppet.
// 6.) You delete the puppeteer recorder script from the prim and add the notecard Puppet with the data you just cleaned.
// 7.) Finally you add the [K] Puppeteer Animator script in the prim along with the notecard and the prim will start executing each step.

// Here is the [K] Puppeteer Recorder script:

//////////////////////////////////////////////////////////
//                 PUPPETEER RECORDER                   //
//////////////////////////////////////////////////////////
// Gremlin: Puppeteer Recorder, see Puppeteer Animator
//////////////////////////////////////////////////////////
// [K] Kira Komarov - 2011, License: GPLv3              //
// Please see: http://www.gnu.org/licenses/gpl.html     //
// for legal details, rights of fair usage and          //
// the disclaimer and warranty conditions.              //
//////////////////////////////////////////////////////////
 
list pos = [];
list rot = [];
 
integer comChannel;
integer comHandle;
 
default
{
    touch_start(integer total_number)
    {
        comChannel = ((integer)("0x"+llGetSubString((string)llGetOwner(),-8,-1)) & 0x3FFFFFFF) ^ 0xBFFFFFFF;
        comHandle = llListen(comChannel, "", llGetOwner(), "");
        llDialog(llGetOwner(), "\nWelcome to the Puppeteer:\n\n1.) ◆ Mark ◆ is for recording each step. Move/Rotate the prim and press ◆ Mark ◆ to record that position.\n2.) Use ◆ Wipe ◆ if you want to delete all existing recoded data.\n3.) Use ◆ Dump ◆ after you have recoded several steps.\n4.) ◆ Undo ◆ lets you delete the previous step. This works multiple times.\n5.) ◆ Preview ◆ will allow you to watch the animation before dumping the data.\n", 
        [ "◆ Mark ◆", "◆ Wipe ◆", "◆ Dump ◆", "◆ Undo ◆", "◆ Preview ◆" ], comChannel);
    }
 
    listen(integer channel, string name, key id, string message) {
        if(message == "◆ Mark ◆") {
            pos += (list)llGetLocalPos();
            rot += (list)llGetLocalRot();
            llOwnerSay("--MARK--");
            jump close;
        }
        if(message == "◆ Dump ◆") {
            if(llGetListLength(pos) == 0) {
                llOwnerSay("Sorry, you need to first record steps before dumping the data.");
                jump close;
            }
            llOwnerSay("------------- BEGIN CUT -------------");
            integer itra;
            string pLine;
            integer mLine;
            for(itra=0, mLine=0; itra<llGetListLength(pos); itra++) {
                if(llStringLength(pLine) + llStringLength(llList2String(pos, itra)) < 254) {
                    pLine += (llList2String(pos, itra) + "#");
                    jump continue_p;
                }
                llOwnerSay("#" + pLine);
                pLine = "";
                mLine = 1;
@continue_p;
            }
            if(!mLine) llOwnerSay("#" + pLine);
            llOwnerSay("[K]");
            string rLine;
            for(itra=0, mLine=0; itra<llGetListLength(rot); itra++) {
                if(llStringLength(rLine) + llStringLength(llList2String(rot, itra)) < 254) {
                    rLine += (llList2String(rot, itra)+ "#");
                    jump continue_r;
                }
                llOwnerSay("#" + rLine);
                rLine = "";
                mLine = 1;
@continue_r;
            }
            if(!mLine) llOwnerSay("#" + rLine);
            llOwnerSay("-------------- END CUT --------------");
            jump close;
        }
        if(message == "◆ Wipe ◆") {
            pos = [];
            rot = [];
            llOwnerSay("All recorded steps have been wiped.");
            jump close;
        }
        if(message == "◆ Undo ◆") {
            if(llGetListLength(pos) == 0) {
                llOwnerSay("No more steps left to undo.");
                jump close;
            }
            vector rPos = llList2Vector(pos, llGetListLength(pos)-1);
            pos = llDeleteSubList(pos, llGetListLength(pos)-1, llGetListLength(pos)-1);
            rotation rRot = llList2Rot(rot, llGetListLength(rot)-1);
            rot = llDeleteSubList(rot, llGetListLength(rot)-1, llGetListLength(rot)-1);
            llSetPos(rPos);
            llSetLocalRot(rRot);
            jump close;
        }
        if(message == "◆ Preview ◆") {
            llOwnerSay("Animation will run once and then stop.");
            state puppet;
        }
@close;
        llListenRemove(comHandle);
    }
}
 
state puppet {
    state_entry() {
        integer itra;
        for(itra=0; itra<llGetListLength(pos); itra++) {
            llSetPos(llList2Vector(pos, itra));
            llSetLocalRot(llList2Rot(rot, itra));
        }
        llOwnerSay("Animation done, resuming normal operation.");
        state default;
    }
}
