// :CATEGORY:Lists
// :NAME:Multidimensional_Array_API
// :AUTHOR:Christopher Omega
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:57
// :ID:533
// :NUM:719
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Getting an element at index [1, 5, 2, 9], in an array "A" translates to:// Get list at index 1 in A, call this B,// Get list at index 5 in B, call this C,// Get list at index 2 in C, call this D,// Return element at index 9 in D.// 
// And here are the functions :)
// :CODE:
// Generates a random string of length len 
// from the characters passed to it.
string randomSeperator(integer len) {
    integer firstChar = (integer)llFrand(60) + 20;  // Range of printable chars = 0x20 to 0x7E
    if (len <= 1)
        return llUnescapeURL("%"+(string)firstChar);
    integer lastChar;
    do { // Last char must not equal first char.
        lastChar = (integer)llFrand(60) + 20; 
    } while (lastChar == firstChar);
    string ret = llUnescapeURL("%"+(string)firstChar);
    for (len -= 2; len > 0; --len) {
        integer val;
        do {
            val = (integer)llFrand(60) + 20;
        } while (val == firstChar || val == lastChar);
        ret += llUnescapeURL("%" + (string)val);
    }
    return ret + llUnescapeURL("%"+(string)lastChar);
}

integer SEPERATOR_LEN  = 3;
string dumpList2String(list src) {
    // Generate a seperator not present in any of the
    // elements in the list.
    string chars = (string) src; // Squashes all elements together.
    string seperator;
    do {
        seperator = randomSeperator(SEPERATOR_LEN);
    } while (llSubStringIndex(chars, seperator) != -1);
    return seperator + llDumpList2String(src, seperator);
}

list parseStringKeepNulls(string src) {
    // The seperator should be the first SEPERATOR_LEN
    // characters in the string.
    return llParseStringKeepNulls(llDeleteSubString(src, 0, SEPERATOR_LEN - 1),
        [llGetSubString(src, 0, SEPERATOR_LEN - 1)], []);
}

list setListElement(list dest, list src, integer index) {
    if (src == []) {
        return llListReplaceList(src, [""], index, index);
    } else {
        integer len = llGetListLength(dest);
        for (; len < index; ++len) {
            dest += "";
        }
        return llListReplaceList(dest, src, index, index + llGetListLength(src) - 1);
    }
}


list getArray(list array, list index){
    if (index == [])
        return array;
    integer numIndicies = llGetListLength(index);
    list src = array;
    integer i;
    for (i = 0; i < numIndicies - 1; ++i) {
        integer listIndex = llList2Integer(index, i);
        string element = llList2String(src, listIndex);
        if (llGetSubString(element, 0, 0) == "l")
            element = llDeleteSubString(element, 0, 0);
        src = parseStringKeepNulls(element);
    }
    string element = llList2String(src, llList2Integer(index, -1));
    if (llGetSubString(element, 0, 0) == "l") {
        // Caller is retreiving a dimension.
        return parseStringKeepNulls(llDeleteSubString(element, 0, 0));
    } else {
        return [element];
    }
}

// To set an element, we need to extract
// each list starting from where exactly the 
// new data will be. In a set of russian dolls, this
// would be equivelant to grabbing the littlest one
// first. then gradually adding back on the layers over it.
// I think its easiest to do this recursively.
list setArray(list array, list index, list data) {
    string element;
    if (llGetListLength(data) > 1) {
        // Data is a new dimension:
        element = "l" + dumpList2String(data);
    } else {
        // Data is a single element
        element = llList2String(data, 0);
    }
    if (llGetListLength(index) > 1) {
        // index is in the form [a,b,c,d]
        // here, we grab the list that d is in.
        list containerIndex = llDeleteSubList(index, -1, -1);
        list dest = getArray(array, containerIndex);
        integer listIndex = llList2Integer(index, -1); // Grab d
        dest = setListElement(dest, [element], listIndex); // replace the element in d's list.
        // Make sure the recursion treats the container like a list, not an element.
        if (llGetListLength(dest) == 1)
            dest += "";
        return setArray(array, containerIndex, dest);
    } else {
        return setListElement(array, [element], llList2Integer(index, 0));
    }
}
