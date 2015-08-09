// :CATEGORY:Email
// :NAME:Email_Module
// :AUTHOR:Christopher Omega
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:52
// :ID:279
// :NUM:373
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// To use this module, copy and paste the above into a script and name it "EmailModule". The script requires ChatCodec in the same object's inventory. To send emails, an object named "email" must be in the same object's inventory as EmailModule. The object named "email" must also contain ChatCodec and the script below:
// :CODE:
// Copyright (c) 2006 Francisco V. Saldana (Christopher Omega)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in 
// the Software without restriction, including without limitation the rights to use, 
// copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the 
// Software, and to permit persons to whom the Software is furnished to do so, 
// subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all 
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN 
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

// Deligates llEmail-calling duties, so EmailModule doesn't need to incur the 20-second delay.
// Requires ChatCodec.

// ========== For method invocation ==========
string randomSeperator(integer len) {
    integer firstChar = (integer)llFrand(60) + 20;  // Range of printable chars = 0x20 to 0x7E
    if (len <= 1)
        return llUnescapeURL("%"+(string)firstChar);
    integer lastChar;
    do { // Last char must not equal first char.
        lastChar = (integer)llFrand(60) + 20; 
    } while (lastChar == firstChar);
    string ret = llUnescapeURL("%"+(string)firstChar);
    for (len -= 2; len > 0; --len)
        ret += llUnescapeURL("%" + (string)((integer)llFrand(60) + 20));
    return ret + llUnescapeURL("%"+(string)lastChar);
}

string listToString(list src) {
    string chars = (string) src; // Squashes all elements together.
    string seperator;
    do { // Find a seperator that's not in the list's string form
        seperator = randomSeperator(3); // so we dont kill data.
    } while (llSubStringIndex(chars, seperator) != -1);
    return seperator + llDumpList2String(src, seperator);
}

list stringToList(string src) { // First 3 chars is seperator.
    return llParseStringKeepNulls(llDeleteSubString(src, 0, 2),
        [llGetSubString(src, 0, 2)], []);
}

callMethod(integer identifyer, string methodName, list parameters) {
    llMessageLinked(LINK_THIS, identifyer, // ID only necessary for return value.
        listToString(parameters), methodName);
}

returnValue(integer identifyer, string methodName, list value) {
    callMethod(identifyer, methodName + "_ret", value);
}
// =============================================

m_addChatHandle(string moduleName, integer channel) {
    callMethod(0, "addChatHandle", [moduleName, channel]);
}

m_moduleReset(string moduleName) {
    callMethod(0, "moduleName", []);
}

string this;
default {
    state_entry() {
        this = llGetScriptName();
        m_moduleReset(this);
    }
    on_rez(integer param) {
        if (param != 0) {
            llSetPrimitiveParams([PRIM_TEMP_ON_REZ, TRUE]);
            m_addChatHandle(this, param);
        }
    }
    link_message(integer sender, integer call, string params, key methodName) {
        if (methodName == "receivedChatData") {
            list paramList = stringToList(params);
            // Method sig:
            // receivedChatData(integer channel, string name, key id, string message)
            integer channel = (integer) llList2String(paramList, 0);
            string  name    = llList2String(paramList, 1);
            key     id      = (key) llList2String(paramList, 2);
            string  message = llList2String(paramList, 3);
            if (channel == llGetStartParameter()) {
                list paramList = stringToList(message);
                llEmail(llList2String(paramList, 0), llList2String(paramList, 1), llList2String(paramList, 2));
                llDie();
            }
        }
    }
}
