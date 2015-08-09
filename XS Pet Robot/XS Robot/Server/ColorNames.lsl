string gHEX_STRING = "0123456789abcdef";    // hex string index **uses lower case

// vector values of all known system colors
list sysColorsVector =
    [
        <0.941176,0.972549,1.000000>,
        <0.980392,0.921569,0.843137>,
        <0.000000,1.000000,1.000000>,
        <0.498039,1.000000,0.831373>,
        <0.941176,1.000000,1.000000>,
        <0.960784,0.960784,0.862745>,
        <1.000000,0.894118,0.768627>,
        <0.000000,0.000000,0.000000>,
        <1.000000,0.921569,0.803922>,
        <0.000000,0.000000,1.000000>,
        <0.541176,0.168627,0.886275>,
        <0.647059,0.164706,0.164706>,
        <0.870588,0.721569,0.529412>,
        <0.372549,0.619608,0.627451>,
        <0.498039,1.000000,0.000000>,
        <0.823529,0.411765,0.117647>,
        <1.000000,0.498039,0.313725>,
        <0.392157,0.584314,0.929412>,
        <1.000000,0.972549,0.862745>,
        <0.862745,0.078431,0.235294>,
        <0.000000,1.000000,1.000000>,
        <0.000000,0.000000,0.545098>,
        <0.000000,0.545098,0.545098>,
        <0.721569,0.525490,0.043137>,
        <0.662745,0.662745,0.662745>,
        <0.000000,0.392157,0.000000>,
        <0.741176,0.717647,0.419608>,
        <0.545098,0.000000,0.545098>,
        <0.333333,0.419608,0.184314>,
        <1.000000,0.549020,0.000000>,
        <0.600000,0.196078,0.800000>,
        <0.545098,0.000000,0.000000>,
        <0.913725,0.588235,0.478431>,
        <0.560784,0.737255,0.545098>,
        <0.282353,0.239216,0.545098>,
        <0.184314,0.309804,0.309804>,
        <0.000000,0.807843,0.819608>,
        <0.580392,0.000000,0.827451>,
        <1.000000,0.078431,0.576471>,
        <0.000000,0.749020,1.000000>,
        <0.411765,0.411765,0.411765>,
        <0.117647,0.564706,1.000000>,
        <0.698039,0.133333,0.133333>,
        <1.000000,0.980392,0.941176>,
        <0.133333,0.545098,0.133333>,
        <1.000000,0.000000,1.000000>,
        <0.862745,0.862745,0.862745>,
        <0.972549,0.972549,1.000000>,
        <1.000000,0.843137,0.000000>,
        <0.854902,0.647059,0.125490>,
        <0.501961,0.501961,0.501961>,
        <0.000000,0.501961,0.000000>,
        <0.678431,1.000000,0.184314>,
        <0.941176,1.000000,0.941176>,
        <1.000000,0.411765,0.705882>,
        <0.803922,0.360784,0.360784>,
        <0.294118,0.000000,0.509804>,
        <1.000000,1.000000,0.941176>,
        <0.941176,0.901961,0.549020>,
        <0.901961,0.901961,0.980392>,
        <1.000000,0.941176,0.960784>,
        <0.486275,0.988235,0.000000>,
        <1.000000,0.980392,0.803922>,
        <0.678431,0.847059,0.901961>,
        <0.941176,0.501961,0.501961>,
        <0.878431,1.000000,1.000000>,
        <0.980392,0.980392,0.823529>,
        <0.827451,0.827451,0.827451>,
        <0.564706,0.933333,0.564706>,
        <1.000000,0.713725,0.756863>,
        <1.000000,0.627451,0.478431>,
        <0.125490,0.698039,0.666667>,
        <0.529412,0.807843,0.980392>,
        <0.466667,0.533333,0.600000>,
        <0.690196,0.768627,0.870588>,
        <1.000000,1.000000,0.878431>,
        <0.000000,1.000000,0.000000>,
        <0.196078,0.803922,0.196078>,
        <0.980392,0.941176,0.901961>,
        <1.000000,0.000000,1.000000>,
        <0.501961,0.000000,0.000000>,
        <0.400000,0.803922,0.666667>,
        <0.000000,0.000000,0.803922>,
        <0.729412,0.333333,0.827451>,
        <0.576471,0.439216,0.858824>,
        <0.235294,0.701961,0.443137>,
        <0.482353,0.407843,0.933333>,
        <0.000000,0.980392,0.603922>,
        <0.282353,0.819608,0.800000>,
        <0.780392,0.082353,0.521569>,
        <0.098039,0.098039,0.439216>,
        <0.960784,1.000000,0.980392>,
        <1.000000,0.894118,0.882353>,
        <1.000000,0.894118,0.709804>,
        <1.000000,0.870588,0.678431>,
        <0.000000,0.000000,0.501961>,
        <0.992157,0.960784,0.901961>,
        <0.501961,0.501961,0.000000>,
        <0.419608,0.556863,0.137255>,
        <1.000000,0.647059,0.000000>,
        <1.000000,0.270588,0.000000>,
        <0.854902,0.439216,0.839216>,
        <0.933333,0.909804,0.666667>,
        <0.596078,0.984314,0.596078>,
        <0.686275,0.933333,0.933333>,
        <0.858824,0.439216,0.576471>,
        <1.000000,0.937255,0.835294>,
        <1.000000,0.854902,0.725490>,
        <0.803922,0.521569,0.247059>,
        <1.000000,0.752941,0.796078>,
        <0.866667,0.627451,0.866667>,
        <0.690196,0.878431,0.901961>,
        <0.501961,0.000000,0.501961>,
        <1.000000,0.000000,0.000000>,
        <0.737255,0.560784,0.560784>,
        <0.254902,0.411765,0.882353>,
        <0.545098,0.270588,0.074510>,
        <0.980392,0.501961,0.447059>,
        <0.956863,0.643137,0.376471>,
        <0.180392,0.545098,0.341176>,
        <1.000000,0.960784,0.933333>,
        <0.627451,0.321569,0.176471>,
        <0.752941,0.752941,0.752941>,
        <0.529412,0.807843,0.921569>,
        <0.415686,0.352941,0.803922>,
        <0.439216,0.501961,0.564706>,
        <1.000000,0.980392,0.980392>,
        <0.000000,1.000000,0.498039>,
        <0.274510,0.509804,0.705882>,
        <0.823529,0.705882,0.549020>,
        <0.000000,0.501961,0.501961>,
        <0.847059,0.749020,0.847059>,
        <1.000000,0.388235,0.278431>,
        <1.000000,1.000000,1.000000>,
        <0.250980,0.878431,0.815686>,
        <0.933333,0.509804,0.933333>,
        <0.960784,0.870588,0.701961>,
        <1.000000,1.000000,1.000000>,
        <0.960784,0.960784,0.960784>,
        <1.000000,1.000000,0.000000>,
        <0.603922,0.803922,0.196078>
    ];

// names of all known system colors
list sysColorsName =
    [
        "AliceBlue",
        "AntiqueWhite",
        "Aqua",
        "Aquamarine",
        "Azure",
        "Beige",
        "Bisque",
        "Black",
        "BlanchedAlmond",
        "Blue",
        "BlueViolet",
        "Brown",
        "BurlyWood",
        "CadetBlue",
        "Chartreuse",
        "Chocolate",
        "Coral",
        "CornflowerBlue",
        "Cornsilk",
        "Crimson",
        "Cyan",
        "DarkBlue",
        "DarkCyan",
        "DarkGoldenrod",
        "DarkGray",
        "DarkGreen",
        "DarkKhaki",
        "DarkMagenta",
        "DarkOliveGreen",
        "DarkOrange",
        "DarkOrchid",
        "DarkRed",
        "DarkSalmon",
        "DarkSeaGreen",
        "DarkSlateBlue",
        "DarkSlateGray",
        "DarkTurquoise",
        "DarkViolet",
        "DeepPink",
        "DeepSkyBlue",
        "DimGray",
        "DodgerBlue",
        "Firebrick",
        "FloralWhite",
        "ForestGreen",
        "Fuchsia",
        "Gainsboro",
        "GhostWhite",
        "Gold",
        "Goldenrod",
        "Gray",
        "Green",
        "GreenYellow",
        "Honeydew",
        "HotPink",
        "IndianRed",
        "Indigo",
        "Ivory",
        "Khaki",
        "Lavender",
        "LavenderBlush",
        "LawnGreen",
        "LemonChiffon",
        "LightBlue",
        "LightCoral",
        "LightCyan",
        "LightGoldenrodYellow",
        "LightGray",
        "LightGreen",
        "LightPink",
        "LightSalmon",
        "LightSeaGreen",
        "LightSkyBlue",
        "LightSlateGray",
        "LightSteelBlue",
        "LightYellow",
        "Lime",
        "LimeGreen",
        "Linen",
        "Magenta",
        "Maroon",
        "MediumAquamarine",
        "MediumBlue",
        "MediumOrchid",
        "MediumPurple",
        "MediumSeaGreen",
        "MediumSlateBlue",
        "MediumSpringGreen",
        "MediumTurquoise",
        "MediumVioletRed",
        "MidnightBlue",
        "MintCream",
        "MistyRose",
        "Moccasin",
        "NavajoWhite",
        "Navy",
        "OldLace",
        "Olive",
        "OliveDrab",
        "Orange",
        "OrangeRed",
        "Orchid",
        "PaleGoldenrod",
        "PaleGreen",
        "PaleTurquoise",
        "PaleVioletRed",
        "PapayaWhip",
        "PeachPuff",
        "Peru",
        "Pink",
        "Plum",
        "PowderBlue",
        "Purple",
        "Red",
        "RosyBrown",
        "RoyalBlue",
        "SaddleBrown",
        "Salmon",
        "SandyBrown",
        "SeaGreen",
        "SeaShell",
        "Sienna",
        "Silver",
        "SkyBlue",
        "SlateBlue",
        "SlateGray",
        "Snow",
        "SpringGreen",
        "SteelBlue",
        "Tan",
        "Teal",
        "Thistle",
        "Tomato",
        "Transparent",
        "Turquoise",
        "Violet",
        "Wheat",
        "White",
        "WhiteSmoke",
        "Yellow",
        "YellowGreen"
    ];

//////// test a string for valid hex characters ////////

integer is_hex(string test)
{
    integer i;
    integer count = llStringLength(test);
   
    // if any character is not a hex string then test is not a hex string
    for (i=0;i<count;i++)
        if ( !~llSubStringIndex(gHEX_STRING, llGetSubString(test, i, i)) )
            return FALSE;
   
    // all characters are hex - test is valid
    return TRUE;
}


//////// return decimal string from hex string ////////

string hex2dec(string hexString)
{
    // check for valid hex string
    if (!is_hex(hexString))
        return "invalid";
   
    // 32 bit integers are 8 hex bites long
    integer bites = llStringLength(hexString);
    if (llStringLength(hexString) > 8)
        return "overflow";
       
    // calculate value of hex string
    integer i;
    integer decimal;
    for (i=0;i<bites;i++)
        decimal = (decimal << (4*i)) + llSubStringIndex(gHEX_STRING, llGetSubString(hexString, i, i));
   
    return (string) decimal;
}


//////// return vector string from html color code ////////

string HTML2Vector (string HTMLColorCode)
{
    // html color code format starts with '#' - '#ffffff' = white
    if (llGetSubString(HTMLColorCode, 0, 0) != "#")
        return "invalid";
   
    // require full expression
    if (llStringLength(HTMLColorCode) < 7)
        return "invalid";
   
    // get decimal values for each rgb pair
    string r = hex2dec(llGetSubString(HTMLColorCode, 1, 2));
    string g = hex2dec(llGetSubString(HTMLColorCode, 3, 4));
    string b = hex2dec(llGetSubString(HTMLColorCode, 5, 6));
       
    // hex2dec returns 'invalid' if string is not a valid hex
    if ((r == "invalid") | (g == "invalid") | (b == "invalid"))
        return "invalid";
   
    // convert values to color vector
    return (string)(<(float)r / 255, (float)g / 255, (float)b / 255>);
}

//////// find the best color match for osDraw() functions from any given HTML code ////////

string HTML2SysColorBestMatch(string HTMLColorCode)
{
    // convert HTML code to vector string
    string ColorVector = HTML2Vector(HTMLColorCode);
   
    if ((ColorVector == "invalid") || (ColorVector == "overflow"))
        return ColorVector;
   
    // type cast vector string to a vector
    vector userColor = llList2Vector([ColorVector], 0);
   
   
    // start with a large variance and narrow down
    float variance = 2.0;
    float test;
    integer index;
   
    integer count = llGetListLength(sysColorsVector);
    integer i;
    for (i=0;i<count;i++)
    {
        test = llVecMag(userColor - llList2Vector(sysColorsVector, i));
        if (test < variance)
        {
            variance = test;
            index = i;
        }
    }
   
    return llList2String(sysColorsName, index);
}

default
{
    on_rez(integer param)
    {
        llResetScript();
    }
   
    state_entry()
    {
        integer handle = llListen(10, "", llGetOwner(), "");
        llOwnerSay("Say any HTML color code on channel 10 (e.g. /10 #1a2bef) to get the system color best match for osDraw functions.");
    }
   
    listen(integer channel, string name, key id, string message)
    {
        llOwnerSay("The best match for " + message + " is " + HTML2SysColorBestMatch(message) + ".");
    }
}

 