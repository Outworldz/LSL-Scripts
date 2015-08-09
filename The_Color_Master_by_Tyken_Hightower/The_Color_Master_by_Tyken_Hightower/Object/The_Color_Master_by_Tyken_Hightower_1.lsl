// :CATEGORY:Color
// :NAME:The_Color_Master_by_Tyken_Hightower
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:07
// :ID:884
// :NUM:1253
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// The Color Master by Tyken Hightower.lsl
// :CODE:

//********************************************************
//This Script was pulled out for you by YadNi Monde from the SL FORUMS at http://forums.secondlife.com/forumdisplay.php?f=15, it is intended to stay FREE by it s author(s) and all the comments here in ORANGE must NOT be deleted. They include notes on how to use it and no help will be provided either by YadNi Monde or it s Author(s). IF YOU DO NOT AGREE WITH THIS JUST DONT USE!!!
//********************************************************








//The Color Master
//UPDATE 02/26/07: Pasted new code into this post. Allows for prims to be part of multiple groups (explained in the script comments at top), and fixed minor bugs.
//
//One night, out of boredom, I decided it would be fun and potentially useful to make a script that acts as a coloring engine (including alpha) for any whole object. I know many people tend to rely on color-changing abilities in their products by means of putting a script in every prim and having them take commands link messages. While this is generally an elegant solution that takes relatively little time to implement (all you need to do is make a script for each set of prims that needs to be colored, or, more tediously, for individual prims if they require different faces).
//However, we've probably all seen things like the 170-prim (or more) wings, cars, etc., that have a script in every prim. Clearly, at this point, the solution is no longer efficient for simulator performance. So to that end, I made a solution that allows for all of this, in a single script.
//
//Current Features (at time of posting)
//> Fully menu-driven user interface
//> Optional full-feature object-only control through link messages, plus the ability to trigger a menu for a specific avatar
//> Definitions for specific sets of prims to color
//> Definitions for specific faces on any prim
//> Coloring options for specific prims on touch
//> Coloring options for defined sets or all prims (can be a part of multiple groups)
//
//In order to define sets of prims and faces, I store information in the linked prims' names, as well as the object's description. The arguments are separated by the '/' character. In the object description are the names of all the defined groups, the group the root prim belongs to (if any), and the predefined faces for the root prim (if any). The child prims store the same data in their names, except that the first argument in any child is the name of the child (if you want to name it), not the names of all of the groups. Finally, names of the groups are separated by commas, and the predefined faces are separated just by '/'s.
//
//An example would look like this:
//Root prim's description: "Foo,Bar/Foo/0/1/3"
//
//This means that there are two predefined groups, "Foo" and "Bar". The root prim is a member of "Foo," and the example child prim is a member of "Bar." The predefined faces to color on the root prim are 0, 1, and 3; the predefined faces on the child prim are 0, 2, and 3.
//
//Play around with it; comments/inquiries/suggestions are welcome. Most of the code is not commented well, except the link message controls. I personally believe the purposes of many functions and such are obvious, although that's clearly only IMHO.
//I've mildly tested everything (except the link message controls), but it should all work fluidly. I made this in 2 days off and on, so it's not entirely as elegant as it could be. Some parts (particularly the listen conditionals) are spaghetti code (definitely needs comments, too lazy), and might look cleaner with revision. The script uses 2 separate listens on random, rare channels that automatically close themselves after 2 minutes of inactivity.
//
//Cheers!



//In order to define sets of prims and faces, I store information in the linked prims' names, as well as the object's description.
//The arguments are separated by the '/' character.
//In the object description are the names of all the defined possible groups, the group(s) the root prim belongs to (if any), and the predefined faces for the root prim (if any).
//The child prims store the same data in their names, except that the first argument in any child is the name of the child (if you want to name it), not the names of all of the possible groups.
//Finally, names of the groups are separated by commas, and the predefined faces are separated just by '/'s.

//An example would look like this:
//Root prim's description: "Foo,Bar/Foo/0/1/3"
//Example child prim that belongs to both groups: "Random Child Prim Name/Foo,Bar/0/2/3"

//This means that there are two predefined groups, "Foo" and "Bar".
//The root prim is a member of "Foo," and the example child prim is a member of "Bar." The second example belongs to both.
//The predefined faces to color on the root prim are 0, 1, and 3; the predefined faces on the child prim are 0, 2, and 3.


integer     listener = 0;
integer     com_channel = 0;
integer     data_listen = 0;
integer     data_channel = 0;

integer     touch_active = TRUE;
integer     plugin_use = FALSE;
integer     touched_link = -1;
string      touched_data = "";
string      touched_name = "";
list        touched_faces = [];
string      auto = "ALL_SIDES";
string      group = "";

vector      color = <1.0,1.0,1.0>;
float       alpha = 1.0;

key         user_id = "";
string      last_menu = "";
string      sub_menu = "";
string      adjusting = "";

float       touch_timeout = 120.0;

open_channel() {
    llListenRemove(listener);
    llListenRemove(data_listen);
    com_channel = (integer)(llCeil(llFrand(2000000000.0)) + 1000.0);
    data_channel = -(integer)(llCeil(llFrand(2000000000.0)) + 1000.0);
    listener = llListen(com_channel, "", user_id, "");
    data_listen = llListen(data_channel, "", user_id, "");
    llSetTimerEvent(touch_timeout);
}

string fetch_name(string data) {
    if (touched_link == LINK_ROOT || touched_link == 0) return llGetObjectName();
    else return llList2String(llParseStringKeepNulls(data, ["/"], []), 0);
}

string fetch_group(string data) {
    return llList2String(llParseStringKeepNulls(data, ["/"], []), 1);
}

list fetch_faces(string data) {
    list temp = llParseStringKeepNulls(data, ["/"], []);
    integer i = 0;
    integer length = (temp != []);
    for (i = 0; i < length; i = -~i)
        temp = llListReplaceList(temp, [llList2Integer(temp, i)], i, i);
    return llList2List(temp, 2, -1);
}

list generate_groups() {
    list groups = llCSV2List(llList2String(llParseStringKeepNulls(llGetObjectDesc(), ["/"], []), 0));
    integer i = 0;
    integer length = (groups != []);
    for (i = 0; i < length; i = -~i) if (llList2String(groups, i) == "") groups = llDeleteSubList(groups, i, i);
    return groups;
}

string format_color() {
    return "Current Color: " + (string)((integer)(color.x * 255.0)) + "R " + (string)((integer)(color.y * 255.0)) + "G " + (string)((integer)(color.z * 255.0)) + "B";
}

string format_alpha() {
    return "Current Opacity: " + (string)((integer)(alpha * 100.0)) + "%";
}

main_menu() {
    last_menu = "main_menu";
    string text = "";
    list buttons = ["Set Prims", "All Prims"];
    
    if (touched_link >= 0) {
        buttons = ["This Prim"] + buttons;
        touched_name = fetch_name(touched_data);
        if (touched_name != "") text += "Selection: " + touched_name + "\n\n";
        else text += "Selection: [Unnamed Prim]\n\n";
    }
    
    if (plugin_use) buttons += ["Done"];
    
    text += "Coloring options:";
    
    open_channel();

    llDialog(user_id, text, buttons, com_channel);
}

prim_menu() {
    last_menu = "prim_menu";
    string text = "";
    
    if (touched_name != "") text += "Selection: " + touched_name + "\n";
    else text += "Selection: [Unnamed Prim]\n";
    
    if (touched_faces == []) touched_faces = fetch_faces(touched_data);
    if (touched_faces == []) touched_faces = [ALL_SIDES];
    
    text += "Selected Faces: [";
    if (llList2Integer(touched_faces, 0) == ALL_SIDES) text += "ALL_SIDES]\n";
    else text += llDumpList2String(touched_faces, ", ") + "]\n";
    
    text += format_color() + "\n";
    text += format_alpha() + "\n\n";
    
    text += "Prim options:";
    
    llDialog(user_id, text, ["Pick Faces", "Pick Color", "Apply Color", "Main Menu"], com_channel);
}

face_menu() {
    sub_menu = "face_menu";
    string text = "";
    
    if (touched_name != "") text += "Selection: " + touched_name + "\n";
    else text += "Selection: [Unnamed Prim]\n";
    
    text += "Selected Faces: [";
    if (llList2Integer(touched_faces, 0) == ALL_SIDES) text += "ALL_SIDES]\n\n";
    else text += llDumpList2String(touched_faces, ", ") + "]\n\n";
    
    text += "Face options:";
    
    list buttons = [];
    integer i = 0;
    for (i = 0; i < 9; i = -~i) {
        if (llListFindList(touched_faces, [i]) >= 0) buttons += ["- " + (string)i];
        else buttons += ["+ " + (string)i];
    }
    buttons += ["+ ALL_SIDES", "Back"];
    
    llDialog(user_id, text, buttons, data_channel);
}

color_menu() {
    sub_menu = "color_menu";
    string text = "Color Picker\n";
    
    text += format_color() + "\n";
    text += format_alpha() + "\n\n";
    
    text += "Color options:";
    
    llDialog(user_id, text, ["Red", "Green", "Blue", "Alpha", "Back"], com_channel);
}

color_adjust() {
    sub_menu = "adjust_menu";
    string text = adjusting + " Adjustment\n";
    
    text += format_color() + "\n";
    text += format_alpha() + "\n\n";
    
    text += "Adjustment options:";
    
    string char = llGetSubString(adjusting, 0, 0);
    list buttons = ["- 1" + char, "- 15" + char, "- 50" + char, "+ 1" + char, "+ 15" + char, "+ 50" + char, "0" + char];
    if (char == "A") buttons += ["100A", "Back"];
    else buttons += ["255" + char, "Back"];
    
    llDialog(user_id, text, buttons, data_channel);
}

check_color() {
    if (color.x < 0.0) color.x = 0.0;
    else if (color.x > 1.0) color.x = 1.0;
    if (color.y < 0.0) color.y = 0.0;
    else if (color.y > 1.0) color.y = 1.0;
    if (color.z < 0.0) color.z = 0.0;
    else if (color.z > 1.0) color.z = 1.0;
    if (alpha > 1.0) alpha = 1.0;
    else if (alpha < 0.0) alpha = 0.0;
}

apply_color() {
    if (last_menu == "prim_menu") {
        integer length = (touched_faces != []);
        integer i = 0;
        for (i = 0; i < length; i = -~i) {
            llSetLinkColor(touched_link, color, llList2Integer(touched_faces, i));
            llSetLinkAlpha(touched_link, alpha, llList2Integer(touched_faces, i));
        }
    } else if (last_menu == "group_menu") {
        integer prims = llGetNumberOfPrims();
        integer i = 0;
        if (auto == "Automatic") {
            if (llListFindList(llCSV2List(fetch_group(llGetObjectDesc())), [group]) > -1) {
                list fetch = fetch_faces(llGetObjectDesc());
                integer length = (fetch != []);
                for (i = 0; i < length; i = -~i) {
                    llSetLinkColor(LINK_ROOT, color, llList2Integer(fetch, i));
                    llSetLinkAlpha(LINK_ROOT, alpha, llList2Integer(fetch, i));
                }
            }
            integer n = 0;
            for (i = 2; i <= prims; i = -~i) {
                string link = llGetLinkName(i);
                if (llListFindList(llCSV2List(fetch_group(link)), [group]) > -1) {
                    list fetch = fetch_faces(link);
                    integer length = (fetch != []);
                    for (n = 0; n < length; n = -~n) {
                        llSetLinkColor(i, color, llList2Integer(fetch, n));
                        llSetLinkAlpha(i, alpha, llList2Integer(fetch, n));
                    }
                }
            }
        } else if (auto == "ALL_SIDES") {
            if (llListFindList(llCSV2List(fetch_group(llGetObjectDesc())), [group]) > -1) {
                llSetLinkColor(LINK_ROOT, color, ALL_SIDES);
                llSetLinkAlpha(LINK_ROOT, alpha, ALL_SIDES);
            }
            for (i = 2; i <= prims; i = -~i) {
                string link = llGetLinkName(i);
                if (llListFindList(llCSV2List(fetch_group(link)), [group]) > -1) {
                    llSetLinkColor(i, color, ALL_SIDES);
                    llSetLinkAlpha(i, alpha, ALL_SIDES);
                }
            }
        }
    } else if (last_menu == "object_menu") {
        integer prims = llGetNumberOfPrims();
        integer i = 0;
        if (auto == "Automatic") {
            list fetch = fetch_faces(llGetObjectDesc());
            integer length = (fetch != []);
            for (i = 0; i < length; i = -~i) {
                llSetLinkColor(LINK_ROOT, color, llList2Integer(fetch, i));
                llSetLinkAlpha(LINK_ROOT, alpha, llList2Integer(fetch, i));
            }
            integer n = 0;
            for (i = 2; i <= prims; i = -~i) {
                fetch = fetch_faces(llGetLinkName(i));
                length = (fetch != []);
                for (n = 0; n < length; n = -~n) {
                    llSetLinkColor(i, color, llList2Integer(fetch, n));
                    llSetLinkAlpha(i, alpha, llList2Integer(fetch, n));
                }
            }
        } else if (auto == "ALL_SIDES") {
            llSetLinkColor(LINK_SET, color, ALL_SIDES);
            llSetLinkAlpha(LINK_SET, alpha, ALL_SIDES);
        }
    }
}

group_menu() {
    last_menu = "group_menu";
    string text = "";
    
    if (group != "") text += "Selected Group: [" + group + "]\n";
    text += "Selected Faces: [" + auto + "]\n";
    text += format_color() + "\n";
    text += format_alpha() + "\n\n";
    
    text += "Group options:";
    
    llDialog(user_id, text, ["Faces", "Pick Color", "Apply Color", "Pick Group", "Main Menu"], com_channel);
}

group_picker() {
    sub_menu = "group_picker";
    string text = "";
    
    if (group != "") text += "Selected Group: [" + group + "]\n\n";
    
    text += "Available groups:";
    
    list buttons = ["Back"];
    list groups = generate_groups();
    if (groups != []) buttons += groups;
    
    llDialog(user_id, text, buttons, data_channel);
}

object_menu() {
    last_menu = "object_menu";
    string text = "";

    text += "Selected Faces: [" + auto + "]\n";
    
    text += format_color() + "\n";
    text += format_alpha() + "\n\n";
    
    text += "Object options:";
    
    llDialog(user_id, text, ["Faces", "Pick Color", "Apply Color", "Main Menu"], com_channel);
}

default
{
    state_entry() {
        //llOwnerSay((string)llGetFreeMemory());
    }
    
    link_message(integer sender, integer data, string msg, key id) {
        //Opens the touch menu for agent <id>
        if (msg == "COLOR_MENU_OPEN") {
            plugin_use = TRUE;
            user_id = id;
            main_menu();
        //Activates the touch menu trigger
        } else if (msg == "COLOR_MENU_TOUCH_ON") {
            touch_active = TRUE;
        //Removes the touch menu trigger
        } else if (msg == "COLOR_MENU_TOUCH_OFF") {
            touch_active = FALSE;
        //Sets the current color 255RGB scale ex: id = "50,100,150"
        } else if (msg == "COLOR_MENU_COLOR") {
            list args = llCSV2List(id);
            color = <llList2Float(args, 0), llList2Float(args, 1), llList2Float(args, 2)> / 255.0;
        //Sets the current alpha 100% scale ex: id = "40"
        } else if (msg == "COLOR_MENU_ALPHA") {
            alpha = (float)((string)id) / 100.0;
        //Activates predefined prim faces to be painted on
        } else if (msg == "COLOR_MENU_FACES_ON") {
            auto = "Automatic";
        //Disables predefined prim face painting - ALL_SIDES will be used
        } else if (msg == "COLOR_MENU_FACES_OFF") {
            auto = "ALL_SIDES";
        //Paints on the specified prim group <id> ex: id = "Array 1"
        //This is affected by predefined prim faces, if toggled on
        } else if (msg == "COLOR_MENU_APPLY_GROUP") {
            group = (string)id;
            last_menu = "group_menu";
            apply_color();
        //Paints on all prims in the object
        //This is affected by predefined prim faces, if toggles on
        } else if (msg == "COLOR_MENU_APPLY_ALL") {
            last_menu = "object_menu";
            apply_color();
        }
    }
    
    touch_start(integer number) {
        if (touch_active) {
            if (llDetectedKey(0) == llGetOwner()) {
                plugin_use = FALSE;
                if (llGetNumberOfPrims() > 1) {
                    touched_link = llDetectedLinkNumber(0);
                    touched_data = llGetLinkName(touched_link);
                } else {
                    touched_link = 0;
                    touched_data = llGetObjectDesc();
                }
                user_id = llDetectedKey(0);
                main_menu();
            }
        }
    }
    
    listen(integer channel, string name, key id, string msg) {
        if (touch_active) llSetTimerEvent(touch_timeout);
        if (channel == com_channel) {
            if (msg == "This Prim") prim_menu();
            else if (msg == "Set Prims") group_menu();
            else if (msg == "All Prims") object_menu();
            else if (msg == "Pick Faces") face_menu();
            else if (msg == "Pick Color") color_menu();
            else if (msg == "Apply Color") {
                apply_color();
                if (last_menu == "prim_menu") prim_menu();
                else if (last_menu == "group_menu") group_menu();
                else if (last_menu == "object_menu") object_menu();
            } else if (msg == "Back") {
                if (sub_menu == "adjust_menu") color_menu();
                else if (last_menu == "prim_menu") prim_menu();
                else if (last_menu == "group_menu") group_menu();
                else if (last_menu == "object_menu") object_menu();
            } else if (msg == "Pick Group") {
                group_picker();
            } else if (msg == "Main Menu") {
                main_menu();
            } else if (msg == "Red" || msg == "Green" || msg == "Blue" || msg == "Alpha") {
                adjusting = msg;
                color_adjust();
            } else if (msg == "Faces") {
                if (auto == "Automatic") auto = "ALL_SIDES";
                else if (auto == "ALL_SIDES") auto = "Automatic";
                if (last_menu == "object_menu") object_menu();
                else if (last_menu == "group_menu") group_menu();
            } else if (msg == "Done") {
                llMessageLinked(LINK_SET, 0, "COLOR_MENU_DONE", "");
            }
        }
        if (channel == data_channel) {
            if (msg == "Back") {
                if (sub_menu == "adjust_menu") color_menu();
                else if (last_menu == "prim_menu") prim_menu();
                else if (last_menu == "group_menu") group_menu();
                else if (last_menu == "object_menu") object_menu();
            } else if (sub_menu == "face_menu") {
                if (msg == "+ ALL_SIDES") touched_faces = [ALL_SIDES];
                else if (llList2Integer(touched_faces, 0) == ALL_SIDES) touched_faces = [(integer)llGetSubString(msg, 2, 2)];
                else if (llGetSubString(msg, 0, 0) == "+") touched_faces += [(integer)llGetSubString(msg, 2, 2)];
                else if (llGetSubString(msg, 0, 0) == "-") {
                    integer index = llListFindList(touched_faces, [(integer)llGetSubString(msg, 2, 2)]);
                    touched_faces = llDeleteSubList(touched_faces, index, index);
                }
                face_menu();
            } else if (sub_menu == "adjust_menu") {
                float amount = 0.0;
                string lead = llGetSubString(msg, 0, 0);
                if (lead == "0") amount = -255.0;
                else if (lead == "1" || lead == "2") amount = 255.0;
                else {
                    amount = (float)(llGetSubString(msg, 2, llStringLength(msg) - 2));
                    if (lead == "-") amount = -amount;
                }
                string tail = llGetSubString(msg, -1, -1);
                if (tail == "R") color.x += (amount / 255.0);
                else if (tail == "G") color.y += (amount / 255.0);
                else if (tail == "B") color.z += (amount / 255.0);
                else if (tail == "A") alpha += (amount / 100.0);
                check_color();
                color_adjust();
            } else if (sub_menu == "group_picker") {
                group = msg;
                group_picker();
            }
        }
    }
    
    timer() {
        llListenRemove(listener);
        llListenRemove(data_listen);
        llSetTimerEvent(0.0);
    }
} // END //
