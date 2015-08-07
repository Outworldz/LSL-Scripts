// :CATEGORY:Building
// :NAME:Object_to_Data_back_to_Object_v13
// :AUTHOR:Xaviar Czervik
// :CREATED:2011-01-22 12:03:27.567
// :EDITED:2013-09-18 15:38:58
// :ID:579
// :NUM:794
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Object To Data (Script) 
// :CODE:
string hexc="0123456789ABCDEF";//faster
 
string Float2Hex(float input)
{// Copyright Strife Onizuka, 2006-2007, LGPL, http://www.gnu.org/copyleft/lesser.html
    if((integer)input != input)//LL screwed up hex integers support in rotation & vector string typecasting
    {//this also keeps zero from hanging the zero stripper.
        float unsigned = llFabs(input);//logs don't work on negatives.
        integer exponent = llFloor(llLog(unsigned) / 0.69314718055994530941723212145818);//floor(log2(b)) + rounding error
        integer mantissa = (integer)((unsigned / (float)("0x1p"+(string)(exponent -= (exponent == 128)))) * 0x1000000);//shift up into integer range
        integer index = (integer)(llLog(mantissa & -mantissa) / 0.69314718055994530941723212145818);//index of first 'on' bit
        string str = "p" + (string)((exponent += index) - 24);
        mantissa = mantissa >> index;
        do
            str = llGetSubString(hexc,15&mantissa,15&mantissa) + str;
        while(mantissa = mantissa >> 4);
        if(input < 0)
            return "-0x" + str;
        return "0x" + str;
    }//integers pack well so anything that qualifies as an integer we dump as such, supports netative zero
    return llDeleteSubString((string)input,-7,-1);//trim off the float portion, return an integer
}
 
 
string safeVector(vector v) {
    return "<"+safeFloat(v.x)+","+safeFloat(v.y)+","+safeFloat(v.z)+">";
}
 
string safeRotation(rotation v) {
    return "<"+safeFloat(v.x)+","+safeFloat(v.y)+","+safeFloat(v.z)+","+safeFloat(v.s)+">";
}
 
string safeFloat(float f) {
    return Float2Hex(f);
}
 
string list2string(list l) {
    string ret;
    integer len = llGetListLength(l);
    integer i;
 
    while (i < len) {
        integer type = llGetListEntryType(l, i);
        if (type == 1) {
            ret += "#I"+(string)llList2Integer(l, i);
        } else if (type == 2) {
            ret += "#F"+safeFloat(llList2Float(l, i));
        } else if (type == 3) {
            ret += "#S"+llList2String(l, i);
        } else if (type == 4) {
            ret += "#K"+(string)llList2Key(l, i);
        } else if (type == 5) {
            ret += "#V"+safeVector(llList2Vector(l, i));        
        } else if (type == 6) {
            ret += "#R"+safeRotation(llList2Rot(l, i));
        }
        ret += "-=-";
        i++;
    }
    return ret;
}
 
string getTexture() {
    string ret;
 
    integer sides = llGetNumberOfSides();
 
    integer same = 1;
    list texture;
    list repeat;
    list offset;
    list rot;
 
    integer i = 0;
    while (i < sides) {
        list side  = llGetPrimitiveParams([PRIM_TEXTURE, i]);
        texture += llList2String(side, 0);
        repeat  += llList2Vector(side, 1);
        offset  += llList2Vector(side, 2);
        rot     += llList2Float(side, 3);
 
        if (!(llList2String(texture, i) == llList2String(texture, i-1) && llList2Vector(repeat, i) == llList2Vector(repeat, i-1) &&
            llList2Vector(offset, i) == llList2Vector(offset, i-1) && llList2Float(rot, i) == llList2Float(rot, i-1))) {
                same = 0;
        }
        i++;
    }
 
    if (same) {
        ret += list2string([PRIM_TEXTURE, ALL_SIDES, llList2String(texture, 0), llList2Vector(repeat, 0), llList2Vector(offset, 0), llList2Float(rot, 0)]);
    } else {
        integer j = 0;
        while (j < llGetListLength(texture)) {
            ret += list2string([PRIM_TEXTURE, j, llList2String(texture, j), llList2Vector(repeat, j), llList2Vector(offset, j), llList2Float(rot, j)]);
            j++;
        }
    }        
 
    return ret;
}
 
string getColor() {
    string ret;
 
    integer sides = llGetNumberOfSides();
 
    integer same = 1;
    list color;
    list alpha;
 
    integer i = 0;
    while (i < sides) {
        list side  = llGetPrimitiveParams([PRIM_COLOR, i]);
        alpha += llList2Float(side, 1);
        color  += llList2Vector(side, 0);
 
        if (!(llList2String(color, i) == llList2String(color, i-1) && llList2Vector(alpha, i) == llList2Vector(alpha, i-1))) {
                same = 0;
        }
        i++;
    }
 
    if (same) {
        ret += list2string([PRIM_COLOR, ALL_SIDES, llList2Vector(color, 0), llList2Float(alpha, 0)]);
    } else {
        integer j = 0;
        while (j < llGetListLength(color)) {
            ret += list2string([PRIM_COLOR, j, llList2Vector(color, j), llList2Float(alpha, j)]);
            j++;
        }
    }        
 
    return ret;
}
 
string getShiny() {
    string ret;
 
    integer sides = llGetNumberOfSides();
 
    integer same = 1;
    list shiny;
    list bump;
 
    integer i = 0;
    while (i < sides) {
        list side  = llGetPrimitiveParams([PRIM_BUMP_SHINY, i]);
        shiny += llList2Integer(side, 0);
        bump += llList2Integer(side, 1);
 
        if (!(llList2Integer(shiny, i) == llList2Integer(shiny, i-1) && llList2Integer(bump, i) == llList2Integer(bump, i-1))) {
                same = 0;
        }
        i++;
    }
 
    if (same) {
        ret += list2string([PRIM_BUMP_SHINY, ALL_SIDES, llList2Integer(shiny, 0), llList2Integer(bump, 0)]);
    } else {
        integer j = 0;
        while (j < llGetListLength(shiny)) {
            ret += list2string([PRIM_BUMP_SHINY, j, llList2Integer(shiny, j), llList2Integer(bump, j)]);
            j++;
        }
    }        
 
    return ret;
}
 
string getBright() {
    string ret;
 
    integer sides = llGetNumberOfSides();
 
    integer same = 1;
    list fullbright;
 
    integer i = 0;
    while (i < sides) {
        list side  = llGetPrimitiveParams([PRIM_FULLBRIGHT, i]);
        fullbright += llList2Integer(side, 0);
 
        if (!(llList2Integer(fullbright, i) == llList2Integer(fullbright, i-1))) {
                same = 0;
        }
        i++;
    }
 
    if (same) {
        ret += list2string([PRIM_FULLBRIGHT, ALL_SIDES, llList2Integer(fullbright, 0)]);
    } else {
        integer j = 0;
        while (j < llGetListLength(fullbright)) {
            ret += list2string([PRIM_FULLBRIGHT, j, llList2Integer(fullbright, j)]);
            j++;
        }
    }        
 
    return ret;
}
string getGlow() {
    string ret;
 
    integer sides = llGetNumberOfSides();
 
    integer same = 1;
    list glow;
 
    integer i = 0;
    while (i < sides) {
        list side  = llGetPrimitiveParams([PRIM_GLOW, i]);
        glow += llList2Integer(side, 0);
 
        if (!(llList2Integer(glow, i) == llList2Integer(glow, i-1))) {
                same = 0;
        }
        i++;
    }
 
    if (same) {
        ret += list2string([PRIM_GLOW, ALL_SIDES, llList2Integer(glow, 0)]);
    } else {
        integer j = 0;
        while (j < llGetListLength(glow)) {
            ret += list2string([PRIM_GLOW, j, llList2Integer(glow, j)]);
            j++;
        }
    }        
 
    return ret;
}
 
vector getPos() {
    vector pos = llList2Vector(llGetPrimitiveParams([PRIM_POSITION]), 0);
    pos -= llList2Vector(llGetObjectDetails(llGetLinkKey(0), [OBJECT_POS]), 0);
    if (llGetLinkNumber() == 1) {
        pos = <0,0,0>;
    }
    return pos;
}
 
string getType() {
    list type = [PRIM_TYPE] + llGetPrimitiveParams([PRIM_TYPE]);
    type += [PRIM_PHYSICS] + llGetPrimitiveParams([PRIM_PHYSICS]);
    type += [PRIM_MATERIAL] + llGetPrimitiveParams([PRIM_MATERIAL]);
    type += [PRIM_TEMP_ON_REZ] + llGetPrimitiveParams([PRIM_TEMP_ON_REZ]);
    type += [PRIM_PHANTOM] + llGetPrimitiveParams([PRIM_PHANTOM]);
    type += [PRIM_ROTATION] + llGetPrimitiveParams([PRIM_ROTATION]);
    type += [PRIM_SIZE] + llGetPrimitiveParams([PRIM_SIZE]);
    type += [PRIM_FLEXIBLE] + llGetPrimitiveParams([PRIM_FLEXIBLE]);
    type += [PRIM_POINT_LIGHT] + llGetPrimitiveParams([PRIM_POINT_LIGHT]);
    return list2string(type);
}
 
 
string getPrimitiveParams() {
    string ret;
    ret += getType();
    ret += getTexture();
    ret += getShiny();
    ret += getColor();
    ret += getBright();
    ret += getGlow();
    return ret;
}
 
string getMeta() {
    return llDumpList2String([llGetObjectName(), llGetObjectDesc()], "-=-");
}
 
string int2hex(integer num) {
    integer p1 = num & 0xF;
    integer p2 = (num >> 4) & 0xF;
    string data = llGetSubString(hexc, p2, p2) + llGetSubString(hexc, p1, p1);
    return data;
}
 
string meta;
 
 
default {
    on_rez(integer i) {
        meta = getMeta();
        llSetObjectName("-----");
        llOwnerSay("#NEW " + int2hex(llGetLinkNumber()) + " " + safeVector(llGetRootPosition()-llGetPos()));
        string data = getPrimitiveParams();
        llOwnerSay(int2hex(llGetLinkNumber()) + ":::0"+meta);
        integer i = 0;
        integer num = 1;
        while (i < llStringLength(data)) {
            llOwnerSay(int2hex(llGetLinkNumber()) + ":::" + (string)num + "" + (string)llGetSubString(data, i, i+199));
            i += 200;
            llSleep(.1);
            num++;
        }
        llRemoveInventory(llGetScriptName());
    }
}
