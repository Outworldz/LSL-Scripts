// :CATEGORY:Security
// :NAME:Mango_Wylders_Security_Orb
// :AUTHOR:mangowylder
// :CREATED:2012-09-10 21:15:15.873
// :EDITED:2013-09-18 15:38:57
// :ID:505
// :NUM:675
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Mango Wylder's Security Orb    
// :CODE:
// Written by Mango Wylder except where noted
// Mods by Ferd Frederix for OpenSim on 3-1-2013
// Mods by Ferd from the Second Life wiki, thanks to a tip from Perrie Juran 5-29-2013
// Please see the notes below  for usage

// I wrote this script a couple of years ago.
// Did some cleanup 09/10/2012
// Got rid of llInstantmessage
// Changed to llRegionSayto to get rid of delay
// Added some sanity checks
// Hope I didn't break anything :)
// If so let me know


// There is very little of the original code in this script.
// What original code is left is after sensor(integer nr)
// and little of that is left

// There is a problem with this script and the original script.
// http://www.outworldz.com/cgi/freescripts.plx?ID=1119
// It uses llSleep when an avi is detected.
// Why is this a problem?
// Well if you invite someone to your parcel and they are not allowed,
// you can't do anything with the scanner once the avi is detected during the Warn Time period (sleep time)
// i.e You can't turn it off for example.
// The Avi will get booted then you will have to have to make changes to the Security Orb to
// allow the visitor.
// You might ask why not just use a timer?
// I'm using the timer to ensure no stray listens and to prevent writing to the wrong list in the
// event of no user input.
// I'm working on a major rewrite but for now it is what it is :)

// Mango Wylder

//Globals

// additional and untested modfications by Innula Zenovka to usernames rather than legacy names
// fix by Rolig Loon for issues with number of names allowed on whitelist
// fix by Rolig Loon  to reset when rezzed from http://community.secondlife.com/t5/LSL-Scripting/Using-Mango-Wylders-Security-Orb/m-p/2026281/highlight/false#M17590
// you might also want to look at this link for case-sensitve names: http://community.secondlife.com/t5/LSL-Scripting/Help-With-a-List-Limit-Problem-Resolved-Thank-you-for-the-help/m-p/1825625/highlight/true#M15232

list    gLstChoices = ["Show Admin", "Add Admin", "Del Admin", "Show White", "Add White", "Del White", "Turn On", "Turn Off", "Orb Status", "More", "Cancel"];
list    gLstChoicesMore = ["ShowBan",  "PurgeBan", "DelBan", "ShowEjected", "DelEject", "ClearEject", "Warn Time", "SetRange", "SetBanTime", "<< Back", "Group Mode", "Scan Rate"];
list    gLstChoiceGroup = ["Group On", "Group Off"];
list    gLstOwnerName = [];
list    gLstAdminNames = [];
//      scanner ignores anyone in this list
list    gLstIgnore = [];
//      ejected is where avi's are logged if scanner is on and not in White List
list    gLstEjected = [];
//      LstBan is where avi's are added with a timestamp if they return within BanTime
list    gLstBan = [];
//      LstEjectR is where avi's are add if they come back a second time within BanTime
//      avi's will automatically be deleted from LstEjectR when added to LstBan
//      this combination allows for the third visit within BanTime and LLTeleportHome
//      Three strikes and you are out
list    gLstEjectR = [];
//      find out if the toucher is authorized
key     gKeyToucherID;
//      default scanner range is 30 meteres
float   gFltRange = 30.0;
//      default warning time is 30 seconds
float   gFltWarnTime = 30;
float   gFltScanRate = 30;
integer gIntChannel_Dialog;
integer gIntChannel_Chat;
integer gIntListen_Id;
integer gIntListen_Id_Chat;
//      limit the white list to 25 users
integer gIntWhite_LstLen = 25;
//      limit ejected list to 25 (25 plus the unix time stamp for each avi
integer gIntEject_LstLen = 50;
//      limit admin list to 12 users
integer gIntAdmin_LstLen = 6;
//      initial scanner range
integer gIntRange = 30;
//      initial bantime in seconds (1 hour)
integer gIntBanTime = 3600;
//      initial bantime in hours
integer gIntBanTimeH = 1;
integer gIntMasterRW = TRUE;
integer gIntWhiteAD;
integer gIntActive;
integer gIntSetBanTime;
integer gIntEjected;
integer gIntBanned;
integer gIntSetRange;
integer gIntWarnTime;
integer gIntSetWarnTime;
integer gIntSetScanRate;
integer gIntVectorX;
//      scanner will ignore anyone with the same active group tag if activated
integer gIntGroupSet = 0;
string  gStrWarnTime = "30";
string  gStrBanTime = "1";
string  gStrRange = "30";
string  gStrScanRate = "30";
string  gParcelName;
string  gStrToucherName;
string  gStrNewOwnerName;

string parcelName(vector p) {
    return llList2String(llGetParcelDetails(p, [PARCEL_DETAILS_NAME]) , 0);
}
//from the wiki https://wiki.secondlife.com/wiki/Category:LSL_Avatar/Name
string agentUsername(string agentLegacyName) {
    return llDumpList2String(llParseString2List(llToLower(agentLegacyName)+" ", [" resident ", " "],[]), ".");
}


default{
    state_entry()
    {
        gLstOwnerName = [gStrNewOwnerName = llGetUsername (llGetOwner ())] + gLstOwnerName;
        gLstIgnore = [gStrNewOwnerName] + gLstIgnore;
        gIntChannel_Dialog = ( -1 * (integer)("0x"+llGetSubString((string)llGetKey(),-5,-1)) ); // set a negative integer chat channel for the dialog box
        gIntChannel_Chat = 7; // Set a chat channel to listen to owners commands
        gParcelName = parcelName(llGetPos());
    }

    touch_start(integer total_number)
    {
        gKeyToucherID = llDetectedKey(0);
        gStrToucherName = llGetUsername(llDetectedKey(0)); // find out who is touching us
        list vOwnerAdminNames = gLstOwnerName + gLstAdminNames;
        if(~llListFindList(vOwnerAdminNames, [gStrToucherName])) // find out if the toucher is in the owners/admins list. If so they may proceed
        {
            gKeyToucherID = llDetectedKey(0);
            llDialog(gKeyToucherID, "Please make a choice.", gLstChoices, gIntChannel_Dialog);
            gIntListen_Id = llListen(gIntChannel_Dialog, "", gKeyToucherID, "");
            gIntChannel_Chat = 7;
            llSetTimerEvent(20); //set a time limit to llListen
        }
        else
        {
            llSay (0, "You are not authorized"); // if toucher isn't in the owner/admin list they get a warning
        }
    }

    listen(integer channel, string name, key id, string choice)
    {
        if(channel == gIntChannel_Dialog)
        {
            if (~llListFindList(gLstChoices, [choice]))  // verify dialog choice
            {
                if (choice == "Cancel")
                {
                    llListenRemove(gIntListen_Id);
                }
                else if (choice == "More")
                {
                    llDialog(gKeyToucherID, "Pick an option!", gLstChoicesMore, gIntChannel_Dialog); // present submenu on request
                }
                else if (choice == "Orb Status")
                {
                    if (gIntActive == 1)
                    {
                        llRegionSayTo(gKeyToucherID, 0, "Security Orb is active and scanning at " + gStrRange + " meters in eject mode" + " Scan Rate is set at " + gStrScanRate + " seconds.");
                        llRegionSayTo(gKeyToucherID, 0, "Bantime is set at " + gStrBanTime + " hour(s)" + " Warning time is set at " + gStrWarnTime + " seconds");
                    }
                    else
                    {
                        llRegionSayTo(gKeyToucherID, 0, "Security Orb is turned off"  + " Scan Rate is set at " + gStrScanRate + " seconds" );
                        llRegionSayTo(gKeyToucherID, 0, "Bantime is set at " + gStrBanTime + " hour(s)" + " Warning time is set at " + gStrWarnTime + " seconds");
                    }
                    llListenRemove(gIntListen_Id); //remove the listen on channel_dialog
                }
                else if (choice == "Turn On")
                {
                    if (gIntActive == 1)
                    {
                        llRegionSayTo(gKeyToucherID, 0, "Security Orb is already armed and scanning at " + gStrRange + " meters. I will eject anyone I can find unless they're in your White list." );
                        llRegionSayTo(gKeyToucherID, 0, "Bantime is set at " + gStrBanTime + " hour(s)" + " Warning time is set at " + gStrWarnTime + " seconds" + " Scan Rate is set at " + gStrScanRate + " seconds.");
                    }
                    else
                    {
                        gIntActive = 1;
                        llRegionSayTo(gKeyToucherID, 0, "Security Orb is armed and scanning at " + gStrRange + " meters. I will eject anyone I can find unless they're in your White list." );
                        llRegionSayTo(gKeyToucherID, 0, "Bantime is set at " + gStrBanTime + " hour(s)" + " Warning time is set at " + gStrWarnTime + " seconds" + " Scan Rate is set at " + gStrScanRate + " seconds.");
                        llSensorRepeat( "", "", AGENT, gFltRange, PI, gFltScanRate );
                    }
                    llListenRemove(gIntListen_Id); //remove the listen on channel_dialog
                }
                else if (choice == "Turn Off")
                {
                    llSensorRemove();
                    gIntActive = 0;
                    llRegionSayTo(gKeyToucherID, 0, " Security Orb is turned off");
                    llListenRemove(gIntListen_Id); //remove the listen on channel_dialog
                }
                else if (choice == "Show White")
                {
                    llRegionSayTo(gKeyToucherID, 0, "Here's your White list");
                    integer i;
                    integer s = llGetListLength(gLstIgnore);
                    do
                        llRegionSayTo(gKeyToucherID, 0, llList2String(gLstIgnore,i));
                    while(s>++i);
                    llListenRemove(gIntListen_Id); //remove the listen on channel_dialog
                }
                if (choice == "Add White")
                {
                    if (llGetListLength(gLstIgnore) >= (gIntWhite_LstLen + gIntAdmin_LstLen + llGetListLength(gLstOwnerName)))//Rolig
                    {
                        llRegionSayTo(gKeyToucherID, 0, " You have reached the maximum allowed in the White List.");
                        llRegionSayTo(gKeyToucherID, 0, " If you want to the White List, you will need to delete one first");
                    }
                    else
                    {
                        gIntWhiteAD = 1;
                        if(gIntWhiteAD == 1) {
                            llRegionSayTo(gKeyToucherID, 0, "Please Enter name to Add in chat window on Channel /7");
                            gIntListen_Id_Chat = llListen(gIntChannel_Chat, "", gKeyToucherID, ""); // listen to user on chat channel
                            llListenRemove(gIntListen_Id); //remove the listen on channel_dialog
                        }
                    }
                }
                else if (choice == "Del White")
                {
                    gIntWhiteAD = 2;
                    llRegionSayTo(gKeyToucherID, 0, "Please Enter name to Delete in chat window on Channel /7");
                    gIntListen_Id_Chat = llListen(gIntChannel_Chat, "", gKeyToucherID, ""); // listen to user on chat channel
                    llListenRemove(gIntListen_Id); //remove the listen on channel_dialog
                }
                else if (choice == "Add Admin")
                {
                    if (llGetListLength(gLstAdminNames) >= gIntAdmin_LstLen)
                    {
                        llRegionSayTo(gKeyToucherID, 0, " You have reached the maximum allowed Administrators.");
                        llRegionSayTo(gKeyToucherID, 0, " If you want to add another Administrator, you will need to delete one first");
                    }
                    else if(~llListFindList(gLstOwnerName, [gStrToucherName]))
                    {
                        gIntWhiteAD = 3;
                        llRegionSayTo(gKeyToucherID, 0, "Please Enter name of the Administrator to Add in chat window on Channel /7");
                        gIntListen_Id_Chat = llListen(gIntChannel_Chat, "", gKeyToucherID, ""); // listen to user on chat channel
                    }
                    else
                    {
                        llSay (0, "You are not authorized to add to the administrators list"); // if toucher isn't in the owner they get a warning
                    }
                    llListenRemove(gIntListen_Id); //remove the listen on channel_dialog
                }
                else if (choice == "Show Admin")
                {
                    if (gLstAdminNames == [])
                    {
                        llRegionSayTo(gKeyToucherID, 0, " The Administrators list is empty");
                    }
                    else
                    {
                        llRegionSayTo(gKeyToucherID, 0, "Here's your Administrators list");
                        llRegionSayTo(gKeyToucherID, 0, llList2CSV(gLstAdminNames));
                    }
                    llListenRemove(gIntListen_Id); //remove the listen on channel_dialog
                }
                else if (choice == "Del Admin")
                {
                    if(~llListFindList(gLstOwnerName, [gStrToucherName]))
                    {
                        if (gLstAdminNames == [])
                        {
                            llRegionSayTo(gKeyToucherID, 0, " The Administrators list is empty");
                        }
                        else if (gLstAdminNames)
                        {
                            gIntWhiteAD = 4;
                            llRegionSayTo(gKeyToucherID, 0, "Please Enter name of the Admin to Delete in chat window on Channel /7");
                            gIntListen_Id_Chat = llListen(gIntChannel_Chat, "", gKeyToucherID, ""); // listen to user on chat channel
                        }
                        else
                        {
                            llRegionSayTo(gKeyToucherID, 0, "You are not authorized to remove from the administrators list"); // if toucher isn't in the owner they get a warning
                        }
                    }
                    llListenRemove(gIntListen_Id); //remove the listen on channel_dialog
                }
            }
            if (~llListFindList(gLstChoicesMore, [choice]))  // verify dialog choice
            {
                if (choice == "Warn Time")
                {
                    gIntSetWarnTime = 1;
                    llRegionSayTo(gKeyToucherID, 0, "Please enter the new warning time on Channel /7");
                    gIntListen_Id_Chat = llListen(gIntChannel_Chat, "", gKeyToucherID, ""); // listen to user on chat channel
                    llListenRemove(gIntListen_Id); //remove the listen on gIntChannel_Dialog
                }
                else if (choice == "Scan Rate")
                {
                    gIntSetScanRate = 1;
                    llRegionSayTo(gKeyToucherID, 0, "Please enter a Scan Rate from 5 to 60 seconds in the chat window on Channel /7");
                    gIntListen_Id_Chat = llListen(gIntChannel_Chat, "", gKeyToucherID, ""); // listen to user on chat channel
                    llListenRemove(gIntListen_Id); //remove the listen on channel_dialog
                }
                else if (choice == "SetRange")
                {
                    gIntSetRange = 1;
                    llRegionSayTo(gKeyToucherID, 0, "Please enter the new scan range on Channel /7");
                    gIntListen_Id_Chat = llListen(gIntChannel_Chat, "", gKeyToucherID, ""); // listen to user on chat channel
                    llListenRemove(gIntListen_Id); //remove the listen on channel_dialog
                }
                else if (choice == "ShowEjected")
                {
                    if (gLstEjected == [])
                    {
                        llRegionSayTo(gKeyToucherID, 0, " The ejected list is empty");
                    }
                    else
                    {
                        llRegionSayTo(gKeyToucherID, 0, "Here's your ejected list");
                        integer i;
                        integer s = llGetListLength(gLstEjected);
                        do
                            llRegionSayTo(gKeyToucherID, 0, llList2String(gLstEjected,i));
                        while(s>++i);
                    }
                    llListenRemove(gIntListen_Id); //remove the listen on channel_dialog
                }
                else if (choice == "DelEject")
                {
                    if (gLstEjected == [])
                    {
                        llRegionSayTo(gKeyToucherID, 0, " The ejected list is empty");
                    }
                    else
                    {
                        gIntEjected = 1;
                        llRegionSayTo(gKeyToucherID, 0, "Please enter name to delete in chat window on Channel /7");
                        gIntListen_Id_Chat = llListen(gIntChannel_Chat, "", gKeyToucherID, ""); // listen to user on chat channel
                    }
                    llListenRemove(gIntListen_Id); //remove the listen on channel_dialog
                }
                else if (choice == "ClearEject")
                {
                    if (gLstEjected == [])
                    {
                        llRegionSayTo(gKeyToucherID, 0, " The ejected list is already empty");
                    }
                    else
                    {
                        gIntEjected = 2;
                        llRegionSayTo(gKeyToucherID, 0, "This will clear the Ejected List. Do you wish to proceeed? Enter y or n on Channel /7");
                        gIntListen_Id_Chat = llListen(gIntChannel_Chat, "", gKeyToucherID, ""); // listen to user on chat channel
                    }
                    llListenRemove(gIntListen_Id); //remove the listen on channel_dialog
                }
                else if (choice == "DelBan")
                {
                    if (gLstBan == [])
                    {
                        llRegionSayTo(gKeyToucherID, 0, " The Banned list is already empty");
                    }
                    else
                    {
                        gIntBanned = 1;
                        llRegionSayTo(gKeyToucherID, 0, "This will clear the Banned List. Do you wish to proceeed? Enter y or no on Channel /7");
                        gIntListen_Id_Chat = llListen(gIntChannel_Chat, "", gKeyToucherID, ""); // listen to user on chat channel
                    }
                    llListenRemove(gIntListen_Id); //remove the listen on channel_dialog
                }
                else if (choice == "PurgeBan")
                {
                    if (gLstBan == [])
                    {
                        llRegionSayTo(gKeyToucherID, 0, " The ejected Ban list is empty");
                    }
                    else
                    {
                        integer length = llGetListLength(gLstBan); //purge avi's that have been gone longer than Ban Time
                        integer i = - 1;
                        integer BOOT_TIME = llGetUnixTime(); // store current time
                        for (; i < length; i += 2) // for all timestamps
                        {
                            if (BOOT_TIME - llList2Integer(gLstBan,i) > gIntBanTime) //compare timestamp with current time
                            {
                                integer j = i - 1;
                                gLstBan = llDeleteSubList(gLstBan, j, i);
                                i -= 2;  // offset
                                length -= 2; // offset
                            }
                        }
                        llRegionSayTo(gKeyToucherID, 0, " The ejected Ban list has been purged of entries greater than " + gStrBanTime + " hour(s). Use Show Ban to see current entries.");
                    }
                    llListenRemove(gIntListen_Id); //remove the listen on channel_dialog
                }
                else if (choice == "ShowBan")
                {
                    if (gLstBan == [])
                    {
                        llRegionSayTo(gKeyToucherID, 0, " The Banned list is empty");
                    }
                    else
                    {
                        llRegionSayTo(gKeyToucherID, 0, llList2CSV (gLstBan));
                    }
                    llListenRemove(gIntListen_Id); //remove the listen on channel_dialog
                }
                else if (choice == "SetBanTime")
                {
                    gIntSetBanTime = 1;
                    llRegionSayTo(gKeyToucherID, 0, "Please enter Ban time in hours on Channel /7");
                    gIntListen_Id_Chat = llListen(gIntChannel_Chat, "", gKeyToucherID, ""); // listen to user on chat channel
                    llListenRemove(gIntListen_Id); //remove the listen on channel_dialog
                }
                else if (choice == "Group Mode")
                {
                    llDialog(gKeyToucherID, "Please ensure the Security Console is set to the correct group before enabling this feature.", gLstChoiceGroup, gIntChannel_Dialog);
                }
                else if (choice == "<< Back")
                {
                    llDialog(gKeyToucherID, "What do you want to do?", gLstChoices, gIntChannel_Dialog); // present main menu on request to go back
                }
            }
            if (~llListFindList(gLstChoiceGroup, [choice]))  // verify dialog choice
            {
                if (choice == "Group On")
                {
                    gIntGroupSet = 1;
                    llRegionSayTo(gKeyToucherID, 0, "Group Mode protection is activated");
                    llListenRemove(gIntListen_Id); //remove the listen on channel_dialog
                }
                else if (choice == "Group Off")
                {
                    gIntGroupSet = 0;
                    llRegionSayTo(gKeyToucherID, 0, "Group Mode protection is de-activated");
                    llListenRemove(gIntListen_Id); //remove the listen on channel_dialog
                }
            }
        }
        //end of channel_dialog

        if(channel == gIntChannel_Chat)
        {
        
            if (gIntMasterRW = TRUE) // check to see if modifying any list is still allowwd (not timed out)
            
            {  if(~llListFindList([1,2,3,4],[gIntWhiteAD])){
            choice = agentUsername (choice);
                if (gIntWhiteAD == 1)//ensure we should be here adding to the White List
                {
                    if(~llListFindList(gLstIgnore, [choice]))
                    {
                        llRegionSayTo(gKeyToucherID, 0, choice + " is already in the White List");
                    }
                    else if(~llListFindList(gLstEjected, [choice]))
                    {
                        integer i = llListFindList(gLstEjected, [choice]);
                        gLstEjected = llDeleteSubList(gLstEjected, i,i);
                        llRegionSayTo(gKeyToucherID, 0, choice + " was in the Ejected list " + choice + "  has been removed from the Ejected list" );
                        if(~llListFindList(gLstBan, [choice]))
                        {
                            integer j = llListFindList (gLstBan, [choice]);
                            gLstBan = llDeleteSubList(gLstBan, j,j + 1 ); //remove the avi and their timestamp from the Ban List
                        }
                        gLstIgnore = gLstIgnore + [choice]; //mono optimized list append
                    }
                    else
                    {
                        gLstIgnore = gLstIgnore + [choice]; //mono optimized list append
                        llRegionSayTo(gKeyToucherID, 0, choice + " has been added to the White List");
                    }
                    llListenRemove(gIntListen_Id_Chat); //remove the listen on channel_chat
                    llListenRemove(gIntListen_Id); //remove the listen on channel_dialog
                    gIntWhiteAD = 0;
                }
                else if (gIntWhiteAD == 2) // ensure we should be here removing from the White List
                {
                    if(~llListFindList(gLstOwnerName, [choice]))
                    {
                        llRegionSayTo(gKeyToucherID, 0, "You can not remove the owner name from the White list!");
                    }
                    else
                    {
                        integer j = llListFindList(gLstIgnore, [choice]);
                        if (j == -1)
                        {
                            gIntWhiteAD = 0;
                            llRegionSayTo(gKeyToucherID, 0, choice + " isn't in the White list");
                            llListenRemove(gIntListen_Id_Chat); //remove the listen on channel_chat
                            llListenRemove(gIntListen_Id_Chat); //remove the listen on channel_chat
                            return;
                        }
                        else {
                            gLstIgnore = llDeleteSubList(gLstIgnore, j,j);
                            llRegionSayTo(gKeyToucherID, 0, choice + " has been removed from the White list");
                        }
                    }
                    llListenRemove(gIntListen_Id_Chat); //remove the listen on channel_chat

                }
                else if (gIntWhiteAD == 3) // ensure we should be here adding to the Administrators List
                {
                    if(~llListFindList(gLstAdminNames, [choice]))
                    {
                        llRegionSayTo(gKeyToucherID, 0, choice + " is already in the Admin List");
                    }
                    else if(~llListFindList(gLstIgnore, [choice]))
                    {
                        gLstAdminNames = gLstAdminNames + [choice];
                        llRegionSayTo(gKeyToucherID, 0, choice + " has been added to the Administrators list");
                    }
                    else if(~llListFindList(gLstEjected, [choice]))
                    {
                        integer j = llListFindList(gLstEjected, [choice]);
                        gLstEjected = llDeleteSubList(gLstEjected, j,j);
                        llRegionSayTo(gKeyToucherID, 0, choice + " was in the Ejected list " + choice + "  has been removed from the Ejected list" );
                        if(~llListFindList(gLstBan, [choice]))
                        {
                            integer k = llListFindList (gLstBan, [choice]);
                            gLstBan = llDeleteSubList(gLstBan,k,k + 1 );
                        }
                        gLstAdminNames = gLstAdminNames + [choice];
                        gLstIgnore = gLstIgnore + [choice];
                        llRegionSayTo(gKeyToucherID, 0, choice + " has been added to the Administrators list");
                    }
                    else
                    {
                        gLstAdminNames = gLstAdminNames + [choice];
                        gLstIgnore = gLstIgnore + [choice];
                        llRegionSayTo(gKeyToucherID, 0, choice + " has been added to the Administrators list");
                    }
                    gIntWhiteAD = 0;
                    llListenRemove(gIntListen_Id_Chat); //remove the listen on channel_chat
                }
                else if (gIntWhiteAD == 4) // ensure we should be here to remove from Administrators list
                {
                    integer j = llListFindList(gLstAdminNames, [choice]);
                    if ( j == -1)
                    {
                        llRegionSayTo(gKeyToucherID, 0, choice + " isn't in the Administrators list");
                    }
                    else
                    {
                        gLstAdminNames = llDeleteSubList(gLstAdminNames, j,j); // remove the person from the admin list
                        llRegionSayTo(gKeyToucherID, 0, choice + " has been removed from the Administators list");
                    }
                    gIntWhiteAD = 0;
                    llListenRemove(gIntListen_Id_Chat); //remove the listen on channel_chat
                }
                }
                else if (gIntSetRange == 1) // set the scanner range
                {
                    gIntRange = (integer) choice;
                    if (gIntRange)
                    {
                        gStrRange = choice;
                        gFltRange = (float) gIntRange;
                        llSensorRemove();
                        llSensorRepeat("", "", AGENT, gFltRange, PI, gFltScanRate);
                        gIntActive = 1;
                        llRegionSayTo(gKeyToucherID, 0, "Changed range to: " + gStrRange + " meters and restarted the scanner");
                        llRegionSayTo(gKeyToucherID, 0, "Bantime is set at " + gStrBanTime + " hour(s)" + " Warning time is set at " + gStrWarnTime + " seconds" + " Scan Rate is set at " + gStrScanRate + " seconds.");
                    }
                    else
                    {
                        llRegionSayTo(gKeyToucherID, 0, "Invalid entry. Please enter an integer in meters up to 96 meters.");
                    }
                    llListenRemove(gIntListen_Id_Chat); //remove the listen on channel_chat
                    gIntSetRange = 0;
                }
                else if (gIntSetWarnTime == 1) // set the scan warn time
                {
                    gIntWarnTime = (integer) choice;
                    if (gIntWarnTime)
                    {
                        gStrWarnTime = choice;
                        gFltWarnTime = (integer) gIntWarnTime;
                        llRegionSayTo(gKeyToucherID, 0, " Warning time has been changed to " + gStrWarnTime + " seconds");
                    }
                    else
                    {
                        llRegionSayTo(gKeyToucherID, 0, "Invalid entry. Please try again!");
                    }

                    llListenRemove(gIntListen_Id_Chat); //remove the listen on channel_chat
                    gIntSetWarnTime = 0;
                }
                else if (gIntEjected == 1) // remove an avi from the Ejected list
                {
                    integer j = llListFindList(gLstEjected, [choice]);
                    if ( j == -1)
                    {
                        llRegionSayTo(gKeyToucherID, 0, choice + " isn't in the Ejected list");
                        llListenRemove(gIntListen_Id_Chat); // remove the listen on channel_chat
                        gIntEjected = 0;
                        return;
                    }
                    gLstEjected = llDeleteSubList(gLstEjected, j,j);
                    llRegionSayTo(gKeyToucherID, 0, choice + " has been removed from the Ejected list");
                    gIntEjected = 0;
                    llListenRemove(gIntListen_Id_Chat); // remove the listen on channel_chat
                }
                else if (gIntEjected == 2) // clear the Ejected list
                {
                    if (choice == "y")
                    {
                        llRegionSayTo(gKeyToucherID, 0, "Resetting the Ejected List");
                        gLstEjected = [];
                    }
                    if (choice == "n")
                    {
                        llRegionSayTo(gKeyToucherID, 0, "Aborting");
                    }
                    gIntEjected = 0;
                    llListenRemove(gIntListen_Id_Chat); //remove the listen on channel_chat
                }
                else if (gIntBanned == 1) // clear the Ban list
                {
                    if (choice == "y")
                    {
                        llRegionSayTo(gKeyToucherID, 0, "Resetting the Banned List");
                        gLstBan = [];
                    }
                    if (choice == "n")
                    {
                        llRegionSayTo(gKeyToucherID, 0, "Aborting");
                    }
                    gIntBanned = 0;
                    llListenRemove(gIntListen_Id_Chat); //remove the listen on channel_chat
                }
                else if (gIntSetBanTime == 1) // set the bantime in hours
                {
                    gIntBanTime = (integer) choice;
                    if (gIntBanTime)
                    {
                        gIntBanTime = gIntBanTime * 3600; // convert hours entered to seconds (3600 seconds in an hour)
                        gIntBanTimeH = gIntBanTime / 3600;
                        gStrBanTime = (string) gIntBanTimeH;
                        string hours;
                        if (gIntBanTime > 3600)
                        {
                            hours = " hours";
                        }
                        else
                        {
                            hours = " hour";
                        }
                        llRegionSayTo(gKeyToucherID, 0, " Ban time set to " + gStrBanTime +  hours);
                    }
                    else
                    {
                        llRegionSayTo(gKeyToucherID, 0, "Invalid entry. Please enter an integer in hours. i.e. Enter 2 for 2 hours");
                    }
                    gIntSetBanTime = 0;
                    llListenRemove(gIntListen_Id_Chat); // remove the listen on channel_chat
                }
                else if (gIntSetScanRate == 1) // set the scan rate in seconds
                {
                    gFltScanRate = (float) choice;
                    if (gFltScanRate)
                    {
                        gStrScanRate = choice;
                        llRegionSayTo(gKeyToucherID, 0, "ScanRate set to " + gStrScanRate + " seconds. Restarted the scanner");
                        llSensorRemove();
                        llSensorRepeat("", "", AGENT, gFltRange, PI, gFltScanRate);
                        gIntActive = 1;
                        llRegionSayTo(gKeyToucherID, 0, "Security Orb is active and scanning at " + gStrRange + " meters in eject mode" + " Scan Rate is set at " + gStrScanRate + " seconds.");
                        llRegionSayTo(gKeyToucherID, 0, "Bantime is set at " + gStrBanTime + " hour(s)" + " Warning time is set at " + gStrWarnTime + " seconds");
                    }
                    else
                    {
                        llRegionSayTo(gKeyToucherID, 0, "Invalid Entry. Please enter a Scan Rate between 10 and 60 seconds. i.e /7 30");
                    }
                    gIntSetScanRate = 0;
                    llListenRemove(gIntListen_Id_Chat); // remove the listen on channel_chat
                }
            }
        }

    }
    timer()
    { //TIMES UP!
        llListenRemove(gIntListen_Id_Chat);
        llListenRemove(gIntListen_Id);
        gIntMasterRW = FALSE;
        llRegionSayTo(gKeyToucherID, 0, "Times is up to make changes");
        llSetTimerEvent(0); // Stop the timer from being called repeatedly
    }

    sensor(integer nr)
    { // Here is where all people found in its vincinity are returned.
        // first we make sure the scanner is active before we continue
        if (gIntActive == 1)
        {
            integer i;
            do{
                integer found = FALSE;
                if (gIntGroupSet == 1)
                {
                    if (llSameGroup(llDetectedKey(i)))
                    {
                        found = TRUE;
                    }
                }
                string vNameTest = llGetUsername(llDetectedKey(i));
                
                // we scan through the list of names to see if this person is whitelisted
                if(~llListFindList(gLstIgnore,[vNameTest])){
                found = TRUE;
                }
            /*    for (j = 0; j < llGetListLength(gLstIgnore); ++j)
                {
                    if (llList2String(gLstIgnore, j) == vNameTest){
                        // they are in in the white list
                        found = TRUE;
                    }
                } */
                // verify the avi is on our parcel
                vector pos = llDetectedPos(i);
                string pname = parcelName(pos);
                if (pname == gParcelName)
                {
                    gIntVectorX = 1;
                }
                if (found == FALSE && gIntVectorX == 1 && llOverMyLand(llDetectedKey(i)) && (llDetectedKey(i) != llGetOwner())) // When the person has not been found we start to check if this person is on our land. And on popuar reques we will never kick the owner 
                {
                    if (~llListFindList (gLstEjectR, [vNameTest]))
                    {
                        integer index = llListFindList(gLstEjectR, [vNameTest]);
                        integer BOOT_TIME_TEST = llList2Integer(gLstEjectR, index + 1);
                        integer BOOT_TIME = llGetUnixTime();
                        integer timetest = (BOOT_TIME - BOOT_TIME_TEST);
                        if (timetest  <=  gIntBanTime )
                        {
                            llInstantMessage(llDetectedKey(i), "You are on private property. This is the second time you have been detected. If you are detected again you will be teleported home with no warning!"); // Let's notify this user that he has a few seconds to leave
                            if (llOverMyLand(llDetectedKey(i)))
                            {
                                llInstantMessage(llDetectedKey(i), "GOODBYE!");
                                llInstantMessage(llGetOwner(), "Ejecting from our home: "+ vNameTest);
                                llEjectFromLand(llDetectedKey(i));
                                gLstBan = gLstBan + [vNameTest, llGetUnixTime()];
                                gLstEjectR = llDeleteSubList(gLstEjectR,index,index + 1 );
                            }
                        }
                        if (timetest  >=  gIntBanTime )
                        {
                            gLstEjectR = llDeleteSubList(gLstEjectR,index,index + 1 );
                        }
                        if (llGetListLength(gLstEjectR) > gIntEject_LstLen)
                        {
                            gLstEjectR = llDeleteSubList(gLstEjectR, 0, 1 );
                        }
                    }
                    else if (~llListFindList(gLstBan, [vNameTest]))
                    {
                        integer index = llListFindList(gLstBan, [vNameTest]);
                        integer BOOT_TIME_TEST = llList2Integer(gLstBan, index + 1);
                        integer BOOT_TIME = llGetUnixTime();
                        integer timetest = (BOOT_TIME - BOOT_TIME_TEST);
                        if (timetest  <=  gIntBanTime )
                        {
                            llInstantMessage(llDetectedKey(i), "You have been twice ejected recently. Ejecting Home!");
                            llTeleportAgentHome (llDetectedKey(i));
                            llInstantMessage(llGetOwner(), "Ejecting from our home: "+vNameTest + ". Ejected within the last hour. No warning");
                        }
                        if (timetest  >=  gIntBanTime )
                        {
                            gLstBan = llDeleteSubList(gLstBan,index,index + 1 );
                        }
                        // auto purge
                        if (llGetListLength(gLstBan) > gIntEject_LstLen)
                        {
                            gLstBan = llDeleteSubList(gLstBan, 0, 1 );
                        }
                    }
                    else
                    {
                        // let's notify this user that they have a few seconds to leave
                        llInstantMessage(llDetectedKey(i), "You are on private property. You will be ejected from this parcel in " + gStrWarnTime + " seconds.");
                        // wait the time we gave them to leave
                        llSleep(gFltWarnTime);
                        if (llOverMyLand(llDetectedKey(i))) // Ok let's see if they have left.
                        { // if they are still on lets say BYE to them, and tell the owner someone is kicked off the land
                            llInstantMessage(llDetectedKey(i), "GOODBYE!");
                            llInstantMessage(llGetOwner(), "Ejecting from our home: "+vNameTest);
                            // and finaly we really kick them off
                            llEjectFromLand(llDetectedKey(i));
                            gLstEjectR = gLstEjectR + [vNameTest, llGetUnixTime()];
                            if (~llListFindList(gLstEjected, [vNameTest]))
                            {
                                return; // already in the ejected list so exit
                            }
                            else
                            {
                                gLstEjected = gLstEjected + vNameTest;
                            }
                        }
                        // auto purge
                        if (llGetListLength(gLstEjected) > gIntEject_LstLen)
                        {
                            gLstEjected = llDeleteSubList(gLstEjected, 0, 1 );
                        }
                    }
                }
            }while ((++i) < nr);
        }
    }

   on_rez (integer startup)
   {
       llResetScript();
   }
}
