// :CATEGORY:Email
// :NAME:Email_Module
// :AUTHOR:Christopher Omega
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:52
// :ID:279
// :NUM:372
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// The script
// :CODE:
// In order to preserve the integrity of the sent data, a seperater
// (declared below as a global constant) is prepended the message before it is sent.
// This is so programs can easily discard the additional data Linden Lab's email
// server prepends to the message passed to llEmail. 

// The suffix added to an object's UUID to send an email
// to it via llEmail.
string OBJECT_EMAIL_SUFFIX = "@lsl.secondlife.com";

// Specifies the amount of time between object email polls.
float EMAIL_POLL_INTERVAL = 5.0;

// Seperator between crap LL prepends to llEmail-sent messages and the real message.
string REAL_DATA_SEPERATOR = "#_|#|_#";

// Name of llEmail-calling worker object. 
string EMAIL_OBJECT_NAME = "email";


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

// Events triggered by this module:
m_receivedEmailData(string timestamp, string senderAddress, string senderSubject, string senderMessage) {
    callMethod(0, "receivedEmailData", [timestamp, senderAddress, senderSubject, senderMessage]);
}

m_moduleReset(string moduleName) {
    callMethod(0, "moduleReset", [moduleName]);
}

// Methods called:
m_chat(integer channel, string message) {
    callMethod(0, "chat", [channel, message]);
}

sendEmail(string address, string subject, string message) {
    if (llGetInventoryType(EMAIL_OBJECT_NAME) != INVENTORY_NONE) {
        integer chan = (integer) llFrand(10394) + 1;
        // Scripts in the email object do the actual sending.
        llRezObject(EMAIL_OBJECT_NAME, llGetPos(), ZERO_VECTOR, ZERO_ROTATION, chan);
        m_chat(chan, listToString([address, subject, REAL_DATA_SEPERATOR + message]));
    } else {
        // Unable to delegate llEmail call.
        llEmail(address, subject, message);
    }
}

// Global variables:
    string this;

default {
    state_entry() {
        this = llGetScriptName();
        m_moduleReset(this);
        if (llGetInventoryType(EMAIL_OBJECT_NAME) == INVENTORY_NONE
                || llGetInventoryType("ChatCodec") == INVENTORY_NONE) {
            llOwnerSay("Warning: Rapid llEmail optimization unavailable,"
                + "missing ChatCodec module or email object.");
        }
        state main;
    }
}

state main {
    state_entry() {
        llSetTimerEvent(EMAIL_POLL_INTERVAL);
    }
    
    link_message(integer sender, integer callId, string parameters, key methodName) {
        if (methodName == "sendEmailData") {
            list paramList = stringToList(parameters); 
            // Method signature:
            // sendEmailData(string address, string subject, string message);
            string address = llList2String(paramList, 0);
            string subject = llList2String(paramList, 1);
            string message = llList2String(paramList, 2);
            sendEmail(address, subject, message);
        } else if (methodName == "sendObjectEmail") {
            list paramList = stringToList(parameters); 
            // Method signature:
            // sendObjectEmail(key objectKey, string subject, string message)
            key    objectKey = (key) llList2String(paramList, 0);
            string subject   = llList2String(paramList, 1);
            string message   = llList2String(paramList, 2);
            sendEmail((string)objectKey + OBJECT_EMAIL_SUFFIX, subject, message);
        } else if (methodName == "moduleReady") {
            list paramList = stringToList(parameters);
            string module = llList2String(paramList, 0);
            if (module == this) 
                returnValue(callId, methodName, [TRUE]);
        }
    }
    
    timer() {
        llGetNextEmail("", "");
    }
    
    email(string timestamp, string senderAddress, string senderSubject, 
            string senderMessage, integer numQueued) {
        llSetTimerEvent(0);
        if (llSubStringIndex(senderMessage, REAL_DATA_SEPERATOR) != -1)
            senderMessage = llDumpList2String(llDeleteSubList(llParseStringKeepNulls(senderMessage, [REAL_DATA_SEPERATOR], []), 0, 0), REAL_DATA_SEPERATOR);
        m_receivedEmailData(timestamp, senderAddress, senderSubject, senderMessage);
        
        if (numQueued > 0) {
            llGetNextEmail("", "");
        } else {
            llSetTimerEvent(EMAIL_POLL_INTERVAL);
        }
    }
}
