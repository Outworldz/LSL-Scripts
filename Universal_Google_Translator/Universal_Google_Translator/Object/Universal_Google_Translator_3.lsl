// :CATEGORY:Translator
// :NAME:Universal_Google_Translator
// :AUTHOR:Hank Ramos
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:08
// :ID:934
// :NUM:1342
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Interface Handler// // This is the interface, or menu-system of the translator. It handles all of the numerous dialogs, language selection, etc. of the translator. 
// :CODE:
//Menu System
//Copyright 2006-2009 by Hank Ramos
 
//Variables
integer randomDialogChannel;
integer lastAttachPoint;
list    detectedAgentKeyList;
list    detectedAgentNameList;
key     agentInDialog;
integer isInitialized = FALSE;
list    agentsInTranslation;
integer translatorCount;
 
//Options
integer groupAccess    = FALSE;
integer autoLanguage   = TRUE;
integer deviceAttached;
integer enabled        = FALSE;
integer isShowTran     = FALSE;
integer showAgents     = TRUE;
string  displayStringMD5;
integer isMaster = 1;
integer tranObjects = TRUE;
 
//Constants
list    languages= [
"Chinese-Simple", "Chinese-Trad", "Croatian",  
"Bulgarian", "Belarusian", "Catlan",
"Afrikaans", "Albanian", "Arabic",   
 
"Filipino", "French", "Galician",    
"Finnish", "English", "Estonian",     
"Czech", "Danish", "Dutch",  
 
"Indonesian", "Irish", "Italian",      
"Hindi", "Hungarian", "Icelandic", 
"German", "Greek", "Hebrew",    
 
"Maltese", "Norwegian", "Persian",   
"Lithuanian", "Macedonian", "Malay",   
"Japanese", "Korean", "Latvian",   
 
"Slovenian", "Spanish", "Swahili", 
"Russian", "Serbian", "Slovak", 
"Polish", "Portuguese", "Romanian", 
 
"Yiddish", "\t     ", "\t     ",
"Ukrainian", "Vietnamese", "Welsh",
"Swedish", "Thai", "Turkish"];
 
list    languageCodes = [
"zh-CN", "zh-TW", "hr",  
"bg", "be", "ca",
"af", "sq", "ar",   
 
"tl", "fr", "gl",    
"fi", "en", "et",     
"cs", "da", "nl",  
 
"id", "ga", "it",      
"hi", "hu", "is", 
"de", "el", "iw",    
 
"mt", "no", "fa",   
"lt", "mk", "ms",   
"ja", "ko", "lv",   
 
"sl", "es", "sw", 
"ru", "sr", "sk", 
"pl", "pt-PT", "ro", 
 
"yi", "", "",
"uk", "vi", "cy",
"sv", "th", "tr"];
 
//Functions
//Takes in the offsets, and the attach point 
vector fn_makePos(integer attach_point, vector offset) {
    if ((attach_point == 31) || (attach_point == 35)) { //center 2 & center        
        return <0,0,0>;
    } else if (attach_point == 32) { // Top right
        return <offset.x, offset.y, offset.z * -1>;
    } else if (attach_point == 33) { // Top
        return <offset.x, 0, offset.z * -1>;
    } else if (attach_point == 34) { // Top Left
        return <offset.x, offset.y * -1, offset.z * -1>;
    } else if (attach_point == 36) { // Bottom Left
        return <offset.x, offset.y * -1 , offset.z>;
    } else if (attach_point == 37) { // Bottom
        return <offset.x, 0, offset.z>;
    } else if (attach_point == 38) { // Bottom Right - Baseline
        return offset;
    } else { //Not a HUD point? Then return it's current pos
        return llGetLocalPos();
    }
}
 
updateDisplay()
{
    string  tempString;
    integer listLength;
    integer x;
    string  agentName;
 
    if (isInitialized == FALSE) return;
    tempString = "Universal Translator";
    if (isMaster != 1)
        tempString += " (Link-" + (string)(translatorCount + 1) + ")";
    tempString += "\n===============";
 
    if (enabled) 
    {
        listLength = llGetListLength(agentsInTranslation);
        if (((showAgents) && (listLength <= 40)) && (listLength != 0))
        {
            for (x = 0; x < listLength; x += 4)
            {
                agentName = llList2String(llGetObjectDetails(llList2Key(agentsInTranslation, x), [OBJECT_NAME]), 0);
                if (llStringLength(agentName) > 25)
                    agentName = llGetSubString(agentName, 0, 24);
                if (agentName != "")
                    tempString += "\n" + agentName + "(" + llList2String(agentsInTranslation, x + 1) + ")";
            }
        }
        else
        {
            tempString += "\n# Agents Translated: " + (string)llRound(listLength/3);
        }
    }
    else
    {
        tempString += "\n>> Disabled <<";
    }
 
    if (llMD5String(tempString, 0) != displayStringMD5)
    {
        displayStringMD5 = llMD5String(tempString, 0);
        llSetText(tempString, <1,1,1>, 1);
    }
}
 
showMainMenu(key id)
{
    if (isInitialized == FALSE) return;
    integer avatarParticipating;
    list buttonList = ["Language", "Help"];
    string dialogMsg = "Main Menu\nLANGUAGE: manually choose your source language. Target languages are detected automatically\nHELP: get help notecard";
    buttonList += "FREE Copy";
    dialogMsg += "\nFREE COPY: receive FREE copy of Universal Translator."; 
 
    if (llList2String(agentsInTranslation, llListFindList(agentsInTranslation, [(string)id]) + 1) != "xx")
    {
        buttonList += "Opt-Out";
        dialogMsg += "\nOPT-OUT: disable receipt of translations";
    }
    else
    {
        buttonList += "Opt-In";
        dialogMsg += "\nOPT-IN: join the translations";
    }
 
    if (id == llGetOwner())
    {
        buttonList += "Donate";
        dialogMsg += "\nDONATE: donate L$ to the developer of Universal Translator.";
    }
    if ((id == llGetOwner()) || ((groupAccess) && (llSameGroup(id))))
    {
        buttonList += "Reset";
        buttonList += "Options";
        buttonList += "Send Copy";
        dialogMsg += "\nSEND COPY: send FREE copy of Universal Translator."; 
 
        if (enabled)
        {
            buttonList += "Disable";
        }
        else
        {
            buttonList += "Enable";
        }
 
        dialogMsg += "\nRESET: reset all scripts in translator";
    }
 
    llDialog(id, dialogMsg, buttonList, randomDialogChannel);
}
 
showOptionsMenu(key id)
{
    integer avatarParticipating;
    list buttonList = [];
    string dialogMsg = "Options Menu.";
    if (id == llGetOwner())
    {
        if (groupAccess)
        {
            buttonList += "Group OFF";
        }
        else
        {
            buttonList += "Group ON";
        }
        dialogMsg += "\nGROUP: allow group members to admin.";
    }
    if ((id == llGetOwner()) || ((groupAccess) && (llSameGroup(id))))
    {
        buttonList += "Main Menu";
        if (!deviceAttached)
        {
            if (autoLanguage)
            {
                buttonList += "Scan OFF";
            }
            else
            {
                buttonList += "Scan ON";
            }
        }
        dialogMsg += "\nSCAN: scan for Avatars and automatically add to translation matrix.";
 
        if (isShowTran)
        {
            buttonList += "Echo OFF";
        }
        else
        {
            buttonList += "Echo ON";
        }
        dialogMsg += "\nECHO: show translations of your chat sent to others."; 
 
 
        if (tranObjects)
        {
            buttonList += "Objects OFF";
        }
        else
        {
            buttonList += "Objects ON";
        }
        dialogMsg += "\nOBJECTS: translate chat of scripted objects"; 
 
        if (showAgents)
        {
            buttonList += "Agents OFF";
        }
        else
        {
            buttonList += "Agents ON";
        }
        dialogMsg += "\AGENTS: show list of agents translated."; 
    }
 
    llDialog(id, dialogMsg, buttonList, randomDialogChannel);
}
 
showLanguageDialog1(key id)
{
    llDialog(id, "Select your TARGET language...", ["\t", "\t", ">> NEXT"] + llList2List(languages, 0, 8),  randomDialogChannel);
}
showLanguageDialog2(key id)
{
    llDialog(id, "Select your TARGET language..", ["<< BACK", "\t ", ">> NEXT "] + llList2List(languages, 9, 17),  randomDialogChannel);
}
showLanguageDialog3(key id)
{
    llDialog(id, "Select your TARGET language..", ["<< BACK ", "\t  ", ">> NEXT  "] + llList2List(languages, 18, 26),  randomDialogChannel);
}
showLanguageDialog4(key id)
{
    llDialog(id, "Select your TARGET language..", ["<< BACK  ", "\t   ", ">> NEXT   "] + llList2List(languages, 27, 35),  randomDialogChannel);
}
showLanguageDialog5(key id)
{
    llDialog(id, "Select your TARGET language..", ["<< BACK   ", "\t    ", ">> NEXT    "] + llList2List(languages, 36, 44),  randomDialogChannel);
}showLanguageDialog6(key id)
{
    llDialog(id, "Select your TARGET language..", ["<< BACK    ", "\t     ", "\t     "] + llList2List(languages, 45, 53),  randomDialogChannel);
}
processListen(string name, key id, string message)
{
    key listenKey;
 
    if (llListFindList(languages, [message]) > -1) //Language Selected in Dialog
    {
        if (message != "") llMessageLinked(LINK_THIS, 9384610, llList2String(languageCodes, llListFindList(languages, [message])), id);
    }    
    else if (llToLower(message) == "help") 
    {
        llGiveInventory(id, "Universal Translator Help");
    }
    else if (message == "Main Menu")
    {
        showMainMenu(id);
    }
    else if (message == "Options")
    {
        showOptionsMenu(id);
    }
    else if (message == "Language")
    {
        showLanguageDialog1(id);
    }
    else if (message == "Opt-In")
    {
        showLanguageDialog1(id);
    }
    else if (message == "Opt-Out")
    {
        llMessageLinked(LINK_THIS, 9384610, "xx", id);
    }
    else if (message == "FREE Copy")
    {
        llMessageLinked(LINK_THIS, 9455209, llKey2Name(id), id);
    }
    if (id == llGetOwner())
    {
        if (message == "Group ON")
        {
            groupAccess = TRUE;
            showMainMenu(id);
        }
        else if (message == "Group OFF")
        {
            groupAccess = FALSE;
            showMainMenu(id);
        }
        else if (message == "Donate")
        {
            llMessageLinked(LINK_THIS, 324235353254, "", llGetOwner());
        }
    }
    if ((id == llGetOwner()) || ((groupAccess) && (llSameGroup(id))))
    {
        if (message == "Reset")
        {
           llResetScript();
        }
        else if (message == "Enable")
        {
            enabled  = TRUE;
            llMessageLinked(LINK_THIS, 8434532, (string)enabled, id);
        }
        else if (message == "Disable")
        {
            enabled  = FALSE;
            llMessageLinked(LINK_THIS, 8434532, (string)enabled, id);
        }
        else if (message == "Echo ON")
        {
            isShowTran = TRUE;
            //llMessageLinked(LINK_THIS, 2734322, (string)isShowTran, id);
        }
        else if (message == "Echo OFF")
        {
            isShowTran = FALSE;
       }
        else if (message == "Objects OFF")
        {
            tranObjects = FALSE;
        }
        else if (message == "Objects ON")
        {
            tranObjects = TRUE;
        }
        else if (message == "Agents OFF")
        {
            showAgents = FALSE;
            llMessageLinked(LINK_THIS, 455832, (string)showAgents, id);
        }
        else if (message == "Agents ON")
        {
            showAgents = TRUE;
            llMessageLinked(LINK_THIS, 455832, (string)showAgents, id);
        }
        else if (message == "Scan ON")
        {
            autoLanguage  = TRUE;
            showMainMenu(id);
        }
        else if (message == "Scan OFF")
        {
            autoLanguage = FALSE;
            showMainMenu(id);
        }
        else if ((message == "Send Copy") || (message == ">>RESCAN<<"))
        {        
            agentInDialog = id;
            llSensor("", NULL_KEY, AGENT, 20.0, TWO_PI);
        }
        else
        {
            if (llGetListLength(detectedAgentNameList) > 0)
            {
                listenKey = llList2Key(detectedAgentKeyList, llListFindList(detectedAgentNameList, [message]));
                if (listenKey != "")
                {
                    llMessageLinked(LINK_THIS, 9455209, message, listenKey);
                }
                detectedAgentNameList = [];
            }
        }
    }
    if (message == ">> NEXT")
    {
        showLanguageDialog2(id);
    }
    else if (message == ">> NEXT ")
    {
        showLanguageDialog3(id);
    }
    else if (message == ">> NEXT  ")
    {
        showLanguageDialog4(id);
    }
    else if (message == ">> NEXT   ")
    {
        showLanguageDialog5(id);
    }
    else if (message == ">> NEXT    ")
    {
        showLanguageDialog6(id);
    }
    else if (message == "<< BACK")
    {
        showLanguageDialog1(id);
    }
    else if (message == "<< BACK ")
    {
        showLanguageDialog2(id);
    }
    else if (message == "<< BACK  ")
    {
        showLanguageDialog3(id);
    }
    else if (message == "<< BACK   ")
    {
        showLanguageDialog4(id);
    }
    else if (message == "<< BACK    ")
    {
        showLanguageDialog5(id);
    }
    if (message == "\t")
    {
        showLanguageDialog1(id);
    }
    else if (message == "\t ")
    {
        showLanguageDialog2(id);
    }
    else if (message == "\t  ")
    {
        showLanguageDialog3(id);
    }
    else if (message == "\t   ")
    {
        showLanguageDialog4(id);
    }
    else if (message == "\t    ")
    {
        showLanguageDialog5(id);
    }
    else if (message == "\t     ")
    {
        showLanguageDialog6(id);
    }
 
    llMessageLinked(LINK_THIS, 3342976, llList2CSV([isShowTran, tranObjects, autoLanguage]), id);
}
checkAttach()
{
    if (llGetAttached() > 0)
    {
        llSetScale(<0.125, 0.125, 0.087>);
        if(lastAttachPoint != llGetAttached())
        {
            llSetPos(fn_makePos(llGetAttached(), <0.00000, 0.13500, 0.15433>));
            llSetRot(<0,0,0,1>);
            lastAttachPoint = llGetAttached();                
        }
        llRequestPermissions(llGetOwner(), PERMISSION_TAKE_CONTROLS);
        llMessageLinked(llGetLinkNumber(), 3792114, (string)TRUE, NULL_KEY);
    }
    else
    {
        llSetScale(<0.5, 0.5, 0.750>);
        llReleaseControls();
        llMessageLinked(llGetLinkNumber(), 3792114, (string)FALSE, NULL_KEY);
    }
}
 
default
{
    run_time_permissions(integer perms)
    {
        //integer hasPerms = llGetPermissions();
        llTakeControls( CONTROL_UP , TRUE, TRUE);
    }
    state_entry()
    {
        //llRequestPermissions(llGetOwner(),PERMISSION_TAKE_CONTROLS );
 
        string speakerLanguage;
        //llOwnerSay("Welcome to the Universal Translator, the best FREE translator in SL! Please consider making a L$ donation to help with maintenance and further updates. Select DONATE in the translator menu to make a donation.");
        //llSetText("Initializing...", <1,1,1>, 1);
 
        llSetText("Searching for\nnearby translators...", <1,1,1>, 1);
        checkAttach();
 
        randomDialogChannel = -(integer)llFrand(2147483647);
 
        llMessageLinked(LINK_SET, 20957454, "", NULL_KEY);
        llResetOtherScript("Universal Translator Engine");
        llResetOtherScript("HTTP Handler");
        llResetOtherScript("No-Script IM Handler");
        llResetOtherScript("Auto-Update");
        llResetOtherScript("Donation");
 
        //Other Setup
        llSleep(5);
        llListen(randomDialogChannel, "", NULL_KEY, "");
        llMessageLinked(LINK_THIS, 3342976, llList2CSV([isShowTran, tranObjects, autoLanguage]), "");        
 
        //llOwnerSay("Mem Free=" + (string)llGetFreeMemory());
    }
 
    on_rez(integer startup_param)
    {
        //checkAttach();
        llResetScript();
    }
 
    sensor(integer num_detected)
    {
        integer x;
        string  tempString;
 
        if (num_detected > 11)
            num_detected = 11;
 
        detectedAgentKeyList = [];
        detectedAgentNameList = [];
        for (x = 0; x < num_detected; x += 1)
        {
             detectedAgentKeyList += llDetectedKey(x);
             tempString = llDetectedName(x);
             if (llStringLength(tempString) > 24) tempString = llGetSubString(tempString, 0, 23);
             detectedAgentNameList += tempString;
        }
        if (llGetListLength(detectedAgentNameList) > 0)
        {
            llDialog(agentInDialog, "Select someone nearby to receive FREE a copy of the Universal Translator...", [">>RESCAN<<"] + detectedAgentNameList, randomDialogChannel);
        }
    }
    link_message(integer sender_num, integer num, string str, key id)
    {
        integer listPos;
        list    tempList;
        string  tempString;
 
        if (num == 2540664)
        {
            showMainMenu(id);
        }
        else if (num == 3792114)
        {
            deviceAttached = (integer)str;
            if (deviceAttached) autoLanguage = TRUE;
        }
        else if (num == 65635544)
        {
            translatorCount = ((integer)str)/2;
        }
        else if (num == 6877259)
        {
            if (isInitialized == FALSE)
            {
                isInitialized = TRUE;
                //Owner Language Detection
                tempString  = llGetAgentLanguage(llGetOwner());
                if (llGetSubString(tempString, 0, 1) == "en") tempString = "en";
 
                if (tempString == "") 
                {
                    tempString = "en";
                }
                llMessageLinked(LINK_THIS, 9384610, tempString, llGetOwner());
            }
 
          enabled = (integer)str; //marker
          updateDisplay();
        }
        else if (num == 34829304)
        {
            isMaster = (integer)str;
            updateDisplay();
        }
        else if (num == 455832)
        {
            showAgents = (integer)str;
            updateDisplay();
        }
        else if (num == 94558323)
        {
            agentsInTranslation = llCSV2List(str);
            updateDisplay();
        }
        else if (num == 3342977)
        {
            //Options are Show Tran and tranObjects at this time
            tempList = llCSV2List(str);
            isShowTran = llList2Integer(tempList, 0);
            tranObjects = llList2Integer(tempList, 1);
            autoLanguage = llList2Integer(tempList, 2);
       }
        else if (num == 32364364)
        {
            //Send Options
            llMessageLinked(LINK_THIS, 8434532, (string)enabled, NULL_KEY);            
        }
   }
 
    touch_start(integer num_detected)
    {
        integer x;
        key avatarKey;
 
        for (x = 0; x < num_detected; x++)
        {
            avatarKey = llDetectedKey(x);
            showMainMenu(avatarKey);
        }
    }
 
    listen(integer channel, string name, key id, string message)
    {                
        processListen(name, id, message);
    }
 
    attach(key id)
    {
        checkAttach();
        if (id) //tests if it is a valid key and not NULL_KEY
        {
            llRequestPermissions(llGetOwner(),PERMISSION_TAKE_CONTROLS );
        }
    }
    control(key id,integer held, integer change) {
        return;
    }
}
 
