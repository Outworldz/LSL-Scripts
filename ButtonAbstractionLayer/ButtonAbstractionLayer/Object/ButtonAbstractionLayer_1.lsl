// :CATEGORY:Menu
// :NAME:ButtonAbstractionLayer
// :AUTHOR:Francisco V. Saldana
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:49
// :ID:134
// :NUM:200
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Button-Abstraction-Layer.lsl
// :CODE:


// ButtonAbstractionLayer
// This script is responsible for monitoring touchable linked prims ("buttons")
// It also implements the ability to toggle button availability
// via its enableButton and disableButton link_message events.

// Copyright (C) 2005-2006  Francisco V. Saldana
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
//
// Francisco V. Saldana can be contacted using his email account
//  username: dressedinblue, at domain: gmail.com
// and in Second Life by IMming Christopher Omega


// Library functions:

// Replaces the list elements in dest with elements in src, starting at start.
// For example, if dest was [A, B, C, D], src was [E, F] and start was 1,
// the list returned would be [A, E, F, D].
// If llGetListLength(src) + start > llGetListLength(dest), the returned list length
// will be greater then dest list's length.

string NULL = "";
list replaceListSlice(list dest, list src, integer start)
{
    if (llGetListEntryType(dest, start - 1) == TYPE_INVALID)
    {
        integer len;
        for(len = llGetListLength(dest); len < start; len++)
        {
            dest += NULL;
        }
    }
    integer srcLen = llGetListLength(src);
    return llListInsertList(llDeleteSubList(dest, start, start + srcLen - 1), src, start);
}

integer wildcardPatternMatches(string str, string pattern)
{
    string firstChar = llGetSubString(pattern,  0,  0);
    string lastChar  = llGetSubString(pattern, -1, -1);
    
    if (firstChar == "%")
    {
        if (lastChar == "%")
        {
            pattern = llGetSubString(pattern, 1, -2);
            return llSubStringIndex(str, pattern) != -1;
        }
    
        else
        {
            pattern = llDeleteSubString(pattern, 0, 0);
            return llSubStringIndex(str, pattern) == llStringLength(str) - llStringLength(pattern);
        }
    }
    
    else if (lastChar == "%")
    {
        pattern = llGetSubString(pattern, 0, -2);
        return llSubStringIndex(str, pattern) == 0;
    }

    else
    {
        return str == pattern;
    }
}

list    enabledButtonNamePatterns = [];
integer numPatterns               = 0;

integer isEnabled(string buttonName)
{
    integer patternIndex = 0;
    
    for (patternIndex = 0; patternIndex < numPatterns; patternIndex++)
    {
        string pattern = llList2String(enabledButtonNamePatterns, patternIndex);
        if (wildcardPatternMatches(buttonName, pattern))
        {
            return TRUE;
        }
    }
    return FALSE;
}

// ============ llDetected* Related ============
integer DETECTED_KEY         = 1002;
integer DETECTED_LINK_NUMBER = 1003;
integer DETECTED_NAME        = 1004;
integer DETECTED_POS         = 1006;
integer DETECTED_ROT         = 1007;

list collectDetectedData(integer toucher)
{
    return [
        DETECTED_KEY,           llDetectedKey(toucher),
        DETECTED_LINK_NUMBER,   llDetectedLinkNumber(toucher),
        DETECTED_NAME,          llDetectedName(toucher),
        DETECTED_POS,           llDetectedPos(toucher),
        DETECTED_ROT,           llDetectedRot(toucher)
    ];
}
// =============================================

list curFilter = [];

// This function must be executed in a touch_start event.
// it compares values in the curFilter list with values
// from the llDetected* functions, to see if the toucher is not
// filtered.
integer isTouchAllowed(integer toucher)
{
    if (curFilter == [])
    {
        return TRUE;
    }
        
    integer filterIndex;
    
    filterIndex = llListFindList(curFilter, [(string) DETECTED_KEY]);
    if (filterIndex != -1)
    {
        if (llList2String(curFilter, filterIndex + 1) != (string) llDetectedKey(toucher))
        return FALSE;
    }
    
    filterIndex = llListFindList(curFilter, [(string) DETECTED_NAME]);
    if (filterIndex != -1)
    {
        if (llList2String(curFilter, filterIndex + 1) != (string) llDetectedName(toucher))
        return FALSE;
    }
    
    return TRUE;
}

// ========== For method invocation ==========
string randomStr(string chars, integer len)
{
    integer numChars = llStringLength(chars);
    string ret;
    integer i;
    for (i = 0; i < len; i++)
    {
        integer randIndex = llFloor(llFrand(numChars));
        ret += llGetSubString(chars, randIndex, randIndex);
    }
    return ret;
}

string SEPERATOR_CHARS = "`~!@#$%^&*()-_+[]{}|'";/?.>,<";
integer SEPERATOR_LEN  = 3;
string dumpList2String(list src)
{
    // Generate a seperator not present in any of the
    // elements in the list.
    string chars = (string) src; // Squashes all elements together.
    string seperator;
    do
    {
        seperator = randomStr(SEPERATOR_CHARS, SEPERATOR_LEN);
    }
    while (llSubStringIndex(chars, seperator) != -1);
    return seperator + llDumpList2String(src, seperator);
}

list parseStringKeepNulls(string src)
{
    // The seperator should be the first SEPERATOR_LEN
    // characters in the string.
    return llParseStringKeepNulls(llDeleteSubString(src, 0, SEPERATOR_LEN - 1),
    [llGetSubString(src, 0, SEPERATOR_LEN - 1)], []);
}

callMethod(integer callId, string methodName, list parameters)
{ 
    llMessageLinked(LINK_THIS, callId,
    dumpList2String(parameters), methodName);
}

returnValue(string methodName, integer methodIdentifyer, list value)
{
    llMessageLinked(LINK_THIS, methodIdentifyer,
    dumpList2String(value), methodName + "_ret");
}
// =============================================

trigger_buttonPressed(string buttonName, list detectedData)
{
    callMethod(0, "buttonPressed", [buttonName, dumpList2String(detectedData)]);
}

trigger_buttonReleased(string buttonName, list detectedData)
{
    callMethod(0, "buttonReleased", [buttonName, dumpList2String(detectedData)]);
}

trigger_reregisterButtons()
{
    callMethod(0, "reregisterButtons", []);
}

trigger_pong(string moduleName)
{
    callMethod(0, "pong", [moduleName]);
}

string this;
default
{
    state_entry()
    {
        this = llGetScriptName();
        trigger_reregisterButtons();
        llPassTouches(TRUE);
    }
    
    link_message(integer sender, integer num, string parameters, key methodName)
    {
        if (methodName == "addButtonListener")
        {
            list paramList = parseStringKeepNulls(parameters);
            // addButtonListener(string buttonNamePattern)
            string buttonNamePattern = llList2String(paramList, 0);
            
            if (llListFindList(enabledButtonNamePatterns, [buttonNamePattern]) == -1)
            {
                enabledButtonNamePatterns += buttonNamePattern;
                numPatterns               = llGetListLength(enabledButtonNamePatterns);
            }
            
        }
    
        else if (methodName == "removeButtonListener")
        {
            list paramList = parseStringKeepNulls(parameters);
            // removeButtonListener(string buttonNamePattern)
            string buttonNamePattern = llList2String(paramList, 0);
            integer patternIndex            = llListFindList(enabledButtonNamePatterns, [buttonNamePattern]);
            
            if (patternIndex != -1)
            {
                enabledButtonNamePatterns = llDeleteSubList(enabledButtonNamePatterns, patternIndex, patternIndex);
                numPatterns               = llGetListLength(enabledButtonNamePatterns);
            }
        }
    
        else if (methodName == "touchFilter")
        {
            list paramList = parseStringKeepNulls(parameters);
            // Method signature:
            // touchFilter(list rules)
            // Rules is a list of DETECTED_* values that we
            // use to filter touch_start events.
            list rules = parseStringKeepNulls(llList2String(paramList, 0));
            curFilter = rules;
        }
    
        else if (methodName == "ping")
        {
            list paramList = parseStringKeepNulls(parameters);
            // Method signature:
            // ping(string moduleName)
            string moduleName = llList2String(paramList, 0);
            if (moduleName == this)
                trigger_pong(this);
        }
    }

    touch_start(integer total_number)
    {
        // In case of griefers who spam touch a button to try and make the terminal
        // ignore the user, search through the list of touchers until the script finds 
        // one that the touchfilter will accept.
        integer i;
        for(i = 0; i < total_number; i++)
        {
            if (isTouchAllowed(i))
            {
                integer linkNumber = llDetectedLinkNumber(i);
                string linkName = llGetLinkName(linkNumber);
                    
                if (isEnabled(linkName))
                {
                    trigger_buttonPressed(linkName, collectDetectedData(i));
                }
                return;
            }
        }
    }
    
    touch_end(integer total_number)
    {
        integer i;
        for(i = 0; i < total_number; i++)
        {
            if (isTouchAllowed(i))
            {
                integer linkNumber = llDetectedLinkNumber(i);
                string linkName = llGetLinkName(linkNumber);
                
                if (isEnabled(linkName))
                {
                    trigger_buttonReleased(linkName, collectDetectedData(i));
                }
                return;
            }
        }
    }
}     // end 
