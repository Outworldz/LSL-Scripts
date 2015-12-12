// :SHOW:
// :CATEGORY:Building
// :NAME:Paramour Builder's Buddy
// :AUTHOR:Aine Caoimhe
// :KEYWORDS:
// :CREATED:2015-11-24 20:37:09
// :EDITED:2015-11-24  19:37:09
// :ID:1092
// :NUM:1867
// :REV:1
// :WORLD:OpenSim
// :DESCRIPTION:
// Paramour Builder's Buddy v1.0
// :CODE:
// 
// by Aine Caoimhe (LACM) Nov. 2015
// Provided under Creative Commons Attribution-Non-Commercial-ShareAlike 4.0 International license.
// Please be sure you read and adhere to the terms of this license: https://creativecommons.org/licenses/by-nc-sa/4.0/
//
// USER SETTINGS
// normally you shouldn't need to change these
key blankTexture="buddy_no_tex";           // builder's buddy face texture for no face...should be in the prim's inventory
string builderTexture="buddy";   // builder's buddy buttons texture name...should be in the prim's inventory
float timeOut=60.0;        // how many seconds to wait for a target key to be supplied before closing the listener
//
// DON'T CHANGE ANYTHING BELOW HERE UNLESS YOU KNOW WHAT YOU'RE DOING!
integer tPrim=1;
integer bPrim=2;
key target;
list faces;
integer FACE_SET_TARGET=0;
integer FACE_RESET_FACES=1;
integer FACE_GET_TEXTURES=2;
integer FACE_SET_TEXTURES=3;
integer FACE_NONE=5;
integer myChannel;
integer handle;

getTextures()
{
    if (!confirmTarget()) return;
    integer f;
    while (f<8)
    {
        if (llListFindList(faces,[f])>-1)
        {
            list data=osGetPrimitiveParams(target,[
                    PRIM_TEXTURE,f,
                    PRIM_COLOR,f,
                    PRIM_BUMP_SHINY,f,
                    PRIM_FULLBRIGHT,f,
                    PRIM_GLOW,f
                ]);
            data=[]+[PRIM_TEXTURE,f]+llList2List(data,0,3)+[PRIM_COLOR,f]+llList2List(data,4,5)+[PRIM_BUMP_SHINY,f]+llList2List(data,6,7)+[PRIM_FULLBRIGHT,f,llList2Integer(data,8),PRIM_GLOW,f,llList2Float(data,9)];
            llSetLinkPrimitiveParamsFast(tPrim,data);
        }
        f++;
    }
    llOwnerSay("Textures retrieved");
}
setTextures()
{
    if (!confirmTarget()) return;
    integer l=llGetListLength(faces);
    while (--l>-1)
    {
        integer f=llList2Integer(faces,l);
        list data=llGetLinkPrimitiveParams(tPrim,[
                PRIM_TEXTURE,f,
                PRIM_COLOR,f,
                PRIM_BUMP_SHINY,f,
                PRIM_FULLBRIGHT,f,
                PRIM_GLOW,f
            ]);
        data=[]+[PRIM_TEXTURE,f]+llList2List(data,0,3)+[PRIM_COLOR,f]+llList2List(data,4,5)+[PRIM_BUMP_SHINY,f]+llList2List(data,6,7)+[PRIM_FULLBRIGHT,f,llList2Integer(data,8),PRIM_GLOW,f,llList2Float(data,9)];
        osSetPrimitiveParams(target,data);
    }
    llOwnerSay("Textures set");
}
integer confirmTarget()
{
    if (llKey2Name(target)=="")
    {
        llOwnerSay("Cannot locate the target object with key "+(string)target+" in this region. Please set a new target");
        target=NULL_KEY;
        return FALSE;
    }
    else return TRUE;
}
countFaces()
{
    faces=[];
    integer f;
    while (f<8)
    {
        key tex=llList2Key(osGetPrimitiveParams(target,[PRIM_TEXTURE,f]),0);
        if (tex!="") faces=[]+faces+[f];
        else llSetLinkPrimitiveParamsFast(tPrim,[
                    PRIM_TEXTURE,f,blankTexture,<1,1,0>,ZERO_VECTOR,0.0,
                    PRIM_COLOR,ALL_SIDES,<1,1,1>,1,
                    PRIM_BUMP_SHINY,ALL_SIDES,PRIM_SHINY_NONE,PRIM_BUMP_NONE,
                    PRIM_FULLBRIGHT,ALL_SIDES,FALSE,
                    PRIM_GLOW,ALL_SIDES,0.0
                ]);
        f++;
    }
    string targetName=llList2String(llGetObjectDetails(target,[OBJECT_NAME]),0);
    llOwnerSay("Set target to the prim \""+targetName+"\" which has "+(string)llGetListLength(faces)+" faces");
}
resetFaces()
{
    llSetLinkPrimitiveParamsFast(tPrim,[
            PRIM_TEXTURE,ALL_SIDES,blankTexture,<1,1,0>,ZERO_VECTOR,0.0,
            PRIM_COLOR,ALL_SIDES,<1,1,1>,1,
            PRIM_BUMP_SHINY,ALL_SIDES,PRIM_SHINY_NONE,PRIM_BUMP_NONE,
            PRIM_FULLBRIGHT,ALL_SIDES,FALSE,
            PRIM_GLOW,ALL_SIDES,0.0
        ]);
    llSetLinkPrimitiveParamsFast(bPrim,[PRIM_TEXTURE,ALL_SIDES,builderTexture,<1,1,0>,<0,0,0>,0]);
    target=NULL_KEY;
}
getTarget()
{
    myChannel=0x80000000 | (integer)("0x"+(string)llGetKey());
    handle=llListen(myChannel,"",llGetOwner(),"");
    llTextBox(llGetOwner(),"Paste the key of your desired target object into this text box",myChannel);
    llSetTimerEvent(timeOut);
}
default
{
    state_entry()
    {
        target=NULL_KEY;
    }
    timer()
    {
        llOwnerSay("I did not hear a response yet. Closing the listener");
        llListenRemove(handle);
        llSetTimerEvent(0.0);
    }
    touch_start(integer num)
    {
        key toucher=llDetectedKey(0);
        if (toucher!=llGetOwner()) return;
        integer prim=llDetectedLinkNumber(0);
        integer face=llDetectedTouchFace(0);
        if (prim==tPrim) return;
        else if (face==FACE_NONE) return;
        else if (face==FACE_RESET_FACES) resetFaces();
        else if (target==NULL_KEY)
        {
            if ((prim==bPrim)&&(face==FACE_SET_TARGET)) getTarget();
            else llRegionSayTo(toucher,0,"No target set");
            return;
        }
        else if (face==FACE_GET_TEXTURES) getTextures();
        else if (face==FACE_SET_TEXTURES) setTextures();
    }
    changed(integer change)
    {
        if (change & CHANGED_OWNER) llResetScript();
        else if (change & CHANGED_REGION_START) llResetScript();
    }
    on_rez(integer foo)
    {
        llResetScript();
    }
    listen(integer channel, string name, key who, string message)
    {
        llListenRemove(handle);
        llSetTimerEvent(0.0);
        message=""+llStringTrim(message,STRING_TRIM);
        if (message!="")
        {
            if (osIsUUID(message))
            {
                if (llGetAgentSize((key)message)==ZERO_VECTOR)
                {
                    target=(key)message;
                    if (confirmTarget()) countFaces();
                }
                else llOwnerSay("You can't use this on an avatar");
            }
            else llOwnerSay("The key \""+message+"\" is not a valid UUID");
        }
        else llOwnerSay("Can't set an empty string as the target");
    }
}
