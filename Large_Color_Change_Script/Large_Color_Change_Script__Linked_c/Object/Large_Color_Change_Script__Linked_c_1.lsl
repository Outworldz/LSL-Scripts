// :CATEGORY:Color
// :NAME:Large_Color_Change_Script
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:56
// :ID:461
// :NUM:622
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Large Color Change Script - Linked channel 1 color.lsl
// :CODE:

// This code is public domain. 
// masa was here 20050302 

integer CHANNEL = 1; // channel to listen for commands on 
integer OWNER_ONLY = TRUE; // only owner can control 
integer USE_IMS = TRUE; // send IMs instead of using chat 
string COMMAND_CHANGE_COLOR = "color"; // command to change color 
string COMMAND_LIST_COLORS = "listcolors"; // command to list colors 
integer MAX_CHAT_LENGTH = 255; // max size for one message 
string PREFIX_HEX = "#"; // prefix to specify hex code 
string PREFIX_VECTOR = "<"; // prefix to specify vector code 
list LINKS_TO_SET = [LINK_SET, ALL_SIDES]; // [link number, link face, ...] 

list COLORS; 

// the list is too big to set at once :o 
// note that you may get syntax errors and need to rearrange this list 
// if you change the script much. 
set_colors() { 
COLORS = [ 
// [url]http://halflife.ukrpack.net/csfiles/help/colors.shtml[/url] 
"steelblue", "#4682B4", "royalblue", "#041690", "cornflowerblue", "#6495ED", 
"lightsteelblue", "#B0C4DE", "mediumslateblue", "#7B68EE", "slateblue", "#6A5ACD", 
"darkslateblue", "#483D8B", "midnightblue", "#191970", "navy", "#000080", 
"darkblue", "#00008B", "mediumblue", "#0000CD", "blue", "#0000FF", 
"dodgerblue", "#1E90FF", "deepskyblue", "#00BFFF", "lightskyblue", "#87CEFA", 
"skyblue", "#87CEEB", "lightblue", "#ADD8E6", "powderblue", "#B0E0E6", 
"azure", "#F0FFFF", "lightcyan", "#E0FFFF", "paleturquoise", "#AFEEEE", 
"mediumturquoise", "#48D1CC", "lightseagreen", "#20B2AA", "darkcyan", "#008B8B", 
"teal", "#008080", "cadetblue", "#5F9EA0", "darkturquoise", "#00CED1", 
"aqua", "#00FFFF", "cyan", "#00FFFF", "turquoise", "#40E0D0", 
"aquamarine", "#7FFFD4", "mediumaquamarine", "#66CDAA", "darkseagreen", "#8FBC8F" 
] + [ 
"mediumseagreen", "#3CB371", "seagreen", "#2E8B57", "darkgreen", "#006400", 
"green", "#008000", "forestgreen", "#228B22", "limegreen", "#32CD32", 
"lime", "#00FF00", "chartreuse", "#7FFF00", "lawngreen", "#7CFC00", 
"greenyellow", "#ADFF2F", "yellowgreen", "#9ACD32", "palegreen", "#98FB98", 
"lightgreen", "#90EE90", "springgreen", "#00FF7F", "mediumspringgreen", "#00FA9A", 
"darkolivegreen", "#556B2F", "olivedrab", "#6B8E23", "olive", "#808000", 
"darkkhaki", "#BDB76B", "darkgoldenrod", "#B8860B", "goldenrod", "#DAA520", 
"gold", "#FFD700", "yellow", "#FFFF00", "khaki", "#F0E68C", "palegoldenrod", "#EEE8AA", 
"blanchedalmond", "#FFEBCD", "moccasin", "#FFE4B5", "wheat", "#F5DEB3", 
"navajowhite", "#FFDEAD", "burlywood", "#DEB887", "tan", "#D2B48C" 
] + [ 
"rosybrown", "#BC8F8F", "sienna", "#A0522D", "saddlebrown", "#8B4513", 
"chocolate", "#D2691E", "peru", "#CD853F", "sandybrown", "#F4A460", 
"darkred", "#8B0000", "maroon", "#800000", "brown", "#A52A2A", 
"firebrick", "#B22222", "indianred", "#CD5C5C", "lightcoral", "#F08080", 
"salmon", "#FA8072", "darksalmon", "#E9967A", "lightsalmon", "#FFA07A", 
"coral", "#FF7F50", "tomato", "#FF6347", "darkorange", "#FF8C00", 
"orange", "#FFA500", "orangered", "#FF4500", "crimson", "#DC143C", 
"red", "#FF0000", "deeppink", "#FF1493", "fuchsia", "#FF00FF", 
"magenta", "#FF00FF", "hotpink", "#FF69B4", "lightpink", "#FFB6C1", 
"pink", "#FFC0CB", "palevioletred", "#DB7093", "mediumvioletred", "#C71585" 
] + [ 
"purple", "#800080", "darkmagenta", "#8B008B", "mediumpurple", "#9370DB", 
"blueviolet", "#8A2BE2", "indigo", "#4B0082", "darkviolet", "#9400D3", 
"darkorchid", "#9932CC", "mediumorchid", "#BA55D3", "orchid", "#DA70D6", 
"violet", "#EE82EE", "plum", "#DDA0DD", "thistle", "#D8BFD8", 
"lavender", "#E6E6FA", "ghostwhite", "#F8F8FF", "aliceblue", "#F0F8FF", 
"mintcream", "#F5FFFA", "honeydew", "#F0FFF0", "lightgoldenrodyellow", "#FAFAD2", 
"lemonchiffon", "#FFFACD", "cornsilk", "#FFF8DC", "lightyellow", "#FFFFE0", 
"ivory", "#FFFFF0", "floralwhite", "#FFFAF0", "linen", "#FAF0E6", 
"oldlace", "#FDF5E6", "antiquewhite", "#FAEBD7", "bisque", "#FFE4C4 ", 
"peachpuff", "#FFDAB9", "papayawhip", "#FFEFD5", "beige", "#F5F5DC" 
] + [ 
"seashell", "#FFF5EE", "lavenderblush", "#FFF0F5", "mistyrose", "#FFE4E1", 
"snow", "#FFFAFA", "white", "#FFFFFF", "whitesmoke", "#F5F5F5", 
"gainsboro", "#DCDCDC", "lightgrey", "#D3D3D3", "silver", "#C0C0C0", 
"darkgray", "#A9A9A9", "gray", "#808080", "lightslategray", "#778899", 
"slategray", "#708090", "dimgray", "#696969", "darkslategray", "#2F4F4F", 
"black", "#000000" 
] + [ 
// :o 
"carnationpink", "#FA7FC1" 
]; 
} 

say(key id, string str) { 
if ( USE_IMS ) llInstantMessage( id, str ); 
else llWhisper(0, str); 
} 

vector color_from_hex(string str) { 
return <(integer)("0x" + llGetSubString(str,1,2)), 
(integer)("0x" + llGetSubString(str,3,4)), 
(integer)("0x" + llGetSubString(str,5,6))> / 255; 
} 

vector color_from_vector(string vec) { 
// caveat: 1,1,1 will be treated as #ffffff, not #010101 
list l = llParseString2List(vec, [" ", ",", "<", ">"], []); 
vector v; 

v.x = (float)llList2String(l, 0); 
v.y = (float)llList2String(l, 1); 
v.z = (float)llList2String(l, 2); 

if ( v.x > 1 || v.y > 1 || v.z > 1 ) v /= 255; 

return v; 
} 

vector color_from_name(string name) { 
// vv strip spaces and force lowercase vv 
integer x = llListFindList(COLORS, [ llToLower(llDumpList2String(llParseString2List(name, [" "], []), "")) ]); 
if ( x == -1 ) return <-1,-1,-1>; 
return color_from_hex( llList2String(COLORS, x+1) ); 
} 

set_color(key id, string str) { 
vector color; 
integer i; 
if ( llGetSubString(str, 0, 0) == PREFIX_HEX ) // hex code 
color = color_from_hex( str ); 
else if ( llGetSubString(str, 0, 0) == PREFIX_VECTOR ) // vector 
color = color_from_vector( str ); 
else 
color = color_from_name( str ); 

if ( color.x < 0 || color.x > 1 || color.y < 0 || color.y > 1 || color.z < 0 || color.z > 1 ) { 
say( id, "Invalid color specified: " + str ); 
return; 
} 

//llSetColor(color,ALL_SIDES); 
llSetLinkColor(LINK_SET,color,ALL_SIDES);//used to color all prims in a linked object including start prim
} 

list_colors(key id) { 
string str = ""; 
string nstr = ""; 
integer i; 

for ( i = 0; i < llGetListLength( COLORS ); i += 2 ) { 
nstr = str + llList2String(COLORS, i) + ", "; 

if ( llStringLength(nstr) > MAX_CHAT_LENGTH ) { 
say(id, str); 
str = llList2String(COLORS, i); 
} else { 
str = nstr; 
} 
} 
if ( str != "" ) say(id, str); 
} 

default { 
on_rez(integer start_param) {
    llResetScript();
}
state_entry() { 
set_colors(); 
llListen( CHANNEL, "", llGetOwner(), "" ); 
} 

listen(integer channel, string name, key id, string msg) { 
string command; 
string argument; 
list l; 

if (OWNER_ONLY && id != llGetOwner()) return; 

l = llParseStringKeepNulls( msg, [" "], [] ); 
command = llList2String(l, 0); 
argument = llDumpList2String( llList2List(l, 1, -1), " " ); 

if ( command == COMMAND_CHANGE_COLOR ) 
set_color(id, argument); 
else if ( command == COMMAND_LIST_COLORS ) 
list_colors(id); 

} 
}// END //
