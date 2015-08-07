// :CATEGORY:Email
// :NAME:Email_Module
// :AUTHOR:Christopher Omega
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:52
// :ID:279
// :NUM:374
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// // Here's an example script that utilizes this module:
// :CODE:
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

// Replacement for llEmail:
m_sendEmailData(string address, string subject, string message) {
    callMethod(0, "sendEmailData", [address, subject, message]);
}

// Handy wrapper that makes object<->object emails simpler:
m_sendObjectEmail(key uuid, string subject, string message) {
    callMethod(0, "sendObjectEmail", [uuid, subject, message]);
}

default {
    state_entry() {
        m_sendEmailData("foo.bar@fubar.com", "BOOM!", "Happy April Fools Day!");
        m_sendObjectEmail("a003e27c-1623-ae7d-3bdb-19e26d4986e2", "explode", "confetti");
    }
    link_message(integer sender, integer callIdent, string params, key methodName) {
        if (methodName == "receivedEmailData") {
            list paramList = stringToList(params);
            string timestamp = llList2String(paramList, 0);
            string from = llList2String(paramList, 1);
            string subject = llList2String(paramList, 2);
            string message = llList2String(paramList, 3);
            // email event code goes here.
            if (subject == "damn you" && from == "foo.bar@fubar.com") {
                m_sendEmailData("foo.bar@fubar.com", ":-P", "haha");
            }
        }
    }
}
