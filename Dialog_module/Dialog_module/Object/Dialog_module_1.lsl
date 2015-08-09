// :CATEGORY:Dialog
// :NAME:Dialog_module
// :AUTHOR:Strife Onizuka
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2014-01-17 11:07:14
// :ID:233
// :NUM:319
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// This script is a standalone module for the handling of dialog boxes.
// :CODE:
// The dialog boxes each use a random unique negative channel, for each dialog box.
// Channel numbers range from -2147483648 to -255 with the possibility of the lower 8 bits being zero.
// The listens are bound to the user's key. This means that no script or other user can activate the interface.
// By using a negative number there is no way for the user to type in a command and have it mistaken as a response.
// Only responses that are valid buttons from the requested user (and in the mask) will result in a return; no 3rd party tampering is possible.
// It would be very difficult for anyone to predict the channel number to listen on (2 billion is a big range).
// 
// The Request:
// The link message string format is a list. The first element of this list is the integer that will be used as the second integer in the return the link message. The rest of this list is string that will be returned (in list form with the same separating character).
// 
// The link message key format is a list. The first element is the key of the user, if this is left blank (or NULL_KEY) the owner is assumed. The second element is the message, this can be any valid string. The third element is a float, which is the dialog box time to live. The forth element is an integer it is used as a mask for when a button is pressed if it will trigger a response. The rest of the list is for the buttons; an empty list can be used, but it will default to ["OK"] (there is no way around this, just cope).
// 
// The Response:
// The link message string format is a list. It is whatever was passed as the second string minus the first entry of that list.
// The link message key format is a list. The first element of this list is the number of the button pressed (or error code). The second entry is the text of the button pressed. The third entry is the key it used for creating the dialog box. The forth entry is the user name. The fifth entry is how much time was left in the time to live of the dialog box (not very useful but maybe it is).
// The response always goes back to only the prim that requested the dialog box.
// 
// (string)dump(llList2List(parse(paramString),1,-1)),
// (key)dump([integer buttonNum, string buttonText, key user, string userName, float aproxTimeLeft],"")
// 
// 
// There is no way to create a dialog box that won't timeout. The value must be between 5.0 and 7200.0; or it will be replaced by the default timeout. The timeout won't make a box disapeer off the users screen, but the script will stop listening for results.
// 
// Notes:
// Know your data; if your strings contain "|" then don't use "|" as the separator. If the script acts weirdly this is probably why. The separator can only be one character. The two different strings being passed in the linked message can use different separating characters.
// 
// Misc:
// The ButtonMask has a few extra tricks.
// The first 12 bits corespond to the 12 buttons (bits 0 -> 11)
// Bits 16 through 22 are special bits for error handling and setup.
// All other bits are ignored, do with them as you please but be warned they may be used in the future.
// Bit 	Hex Value 	Event 	Return Button
// 0 	0x000001 	Button 0 Pressed 	0
// 1 	0x000002 	Button 1 Pressed 	1
// 2 	0x000004 	Button 2 Pressed 	2
// 3 	0x000008 	Button 3 Pressed 	3
// 4 	0x000010 	Button 4 Pressed 	4
// 5 	0x000020 	Button 5 Pressed 	5
// 6 	0x000040 	Button 6 Pressed 	6
// 7 	0x000080 	Button 7 Pressed 	7
// 8 	0x000100 	Button 8 Pressed 	8
// 9 	0x000200 	Button 9 Pressed 	9
// 10 	0x000400 	Button 10 Pressed 	10
// 11 	0x000800 	Button 11 Pressed 	11
// 16 	0x010000 	Dialog box times out 	-1
// 17 	0x020000 	Queue being cleared 	-2
// 18 	0x040000 	Target agent not found 	-3
// 19 	0x080000 	No buttons to listen for, bad mask or bad return channel 	-4
// 20 	0x100000 	Clears the queue then creates the dialog box 	-2 via Bit 17
// 21 	0x200000 	Same as bit 20 but only for boxes for the current user 	-2 via Bit 17
// 22 	0x400000 	Target agent has left the sim 	-5
// 
// The queue is cleared in two ways: on_rez or when creating a dialog box requests it. When the script is rez'ed, the old dialog box requests become meaningless (because the script cannot receive the response). By having bit 17 on, it allows for this event to be returned to the script requesting the box. By having bit 20 turned on also causes the queue to be reset (exactly like an on_rez). Using bit 20 may have undesired effects if you are using this module with multiple scripts. Using bit 21 causes a partial clear. It clears out all boxes for the requested user; it is advisable to use this option instead of bit 20.
// 
// Todo:
// When bits 20 and 21 are true have the inverse result happen. All boxes not of the current user would be cleared from the queue.
// 
// Tricks:
// Pass a list of useful values as the return list. Have them correspond to the button list. Then use the code below to get that value from the return (remember if you have any of bits 16 -> 19 enabled you will get negative index values on errors).
// 
// llList2String(parse(c),(integer)llList2String(parse(d),0));

string sepchar = "|";
integer answer = 546;
integer DialogComm = 12;

dialog(key user, string message, float timeout, list buttons, integer buttonmask, integer retchan, list ret)
{
    llMessageLinked(llGetLinkNumber(), DialogComm, dump([retchan] + ret, sepchar),
        dump([user, message, timeout, buttonmask] + buttons, sepchar));
}

string dump(list a, string b)
{
    string c = (string)a;
    if(1+llSubStringIndex(c,b) || llStringLength(b)!=1)
    {
        b += "|\\/?!@#$%^&*()_=:;~{}[],\n qQxXzZ";
        integer d = -llStringLength(b);
        while(1+llSubStringIndex(c,llGetSubString(b,d,d)) && d)
            d++;
        b = llGetSubString(b,d,d);
    }
    return b + llDumpList2String(a, b);
}

list parse(string a) {
    string b = llGetSubString(a,0,0);//save memory
    return llParseStringKeepNulls(llDeleteSubString(a,0,0), [b],[]);
}

default
{
    state_entry()
    {
        integer rint = 6;
        string question = "Would you like a drink?";
        list Answers = ["Yes", "No", "Strongest"];
        integer AnswerMask = 0x005;
        list ExtraPassback = ["extra info to pass back"];
        dialog(llGetOwner(), question, 30,Answers, AnswerMask , answer, ExtraPassback);
    }
    touch_start(integer a)
    {
        dialog(llDetectedKey(0), "Hello\nDo you like me?", 30, ["Yes", "No"], 0xf0fff, answer, ["I think they like us"]);
    }
    link_message(integer a, integer b, string c, key d)
    {
        if(b==answer)
        {
            llWhisper(0,(string)b);
            llWhisper(0,llList2CSV(parse(c)));
            llWhisper(0,llList2CSV(parse(d)));
            //c is the return list
            //d is a list [button number pressed, user, time left, user name, button text]
        }
    }
}

