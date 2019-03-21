// :SHOW:
// :CATEGORY:NPC
// :NAME:PMAC
// :AUTHOR:Aine Caoimhe
// :KEYWORDS:
// :CREATED:2015-11-24 20:39:02
// :EDITED:2015-11-24  19:39:02
// :ID:1095
// :NUM:1879
// :REV:1.1
// :WORLD:OpenSim
// :DESCRIPTION:
// PARAMOUR MULTI-ANIMATION CONTROLLER (PMAC) v1.02(OSSL)
// :CODE:




// by Aine Caoimhe January 2015
// Provided under Creative Commons Attribution-Non-Commercial-ShareAlike 4.0 International license.
// Please be sure you read and adhere to the terms of this license: https://creativecommons.org/licenses/by-nc-sa/4.0/
//
// rev 1.1 Added GIF capability - Fred Beckhusen (Ferd Frederix)
// Images from the Gif2SL program can be used. These have the name Texture;X;Y;FPS. The script detects the X, Y and FPS
// numbers and animates the face of the prim to match
//  Example: PMAC002;5;4;10 will animate a 5 X 4 GIF at 10 FPS

integer display=1;  // face for the main display
integer page;
integer showPageNum=FALSE;
vector floatyColour=<0.0, 1.0, 0.0>;
integer tCount;
integer init=TRUE;

integer textStep;
string textToSay;
list said;

sayText()
{
    if (textToSay=="")
    {
        llOwnerSay("Text finished. Next: slide "+(string)(page+1));
        return;
    }
    string thisText;
    integer stop=llSubStringIndex(textToSay,"*DELAY*");
    if (stop>-1)
    {
        thisText=llGetSubString(textToSay,0,stop-1);
        float delay=(float)llGetSubString(textToSay,stop+7,stop+11);
        textToSay=""+llGetSubString(textToSay,stop+12,-1);
        llSetTimerEvent(delay);
    }
    else
    {
        thisText=textToSay;
        textToSay="";
        llSetTimerEvent(0.25);
    }
    llSay(0," \n"+thisText);
}


gif(integer face, string t)
{

    list gif = llParseString2List(t,[";"],[]);

    
    string aname = llList2String(gif,0);
    
    integer X  = (integer) llList2String(gif,1);
    integer Y  = (integer) llList2String(gif,2);
    float   FPS  = (float)   llList2String(gif,3);

    float product = X * Y;
    
     // Set the new prim texture
    llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_TEXTURE,face,t,<1,1,0>,ZERO_VECTOR,0.0]);

    if (X && face == 1) {
        llSetTextureAnim( ANIM_ON | LOOP, 1, X, Y, 0.0, product, FPS);
    } else if (!X && face == 1) {
        llSetTextureAnim(  LOOP, 1, 1,1, 0.0, 1 , FPS);
    }
    
}
 
 
showPage()
{
    integer face;
    while (face<4)
    {
        integer tInd=page-1+face;
        if ((tInd>=0) && (tInd<tCount)) {
            string Texture = llGetInventoryName(INVENTORY_TEXTURE,tInd);
            gif(face,Texture);    
        }
        face++;
    }
    if (showPageNum) llSetText("Page "+(string)(page+1),floatyColour,1.0);
    if (init)
    {
        init=FALSE;
        return;
    }
    string card="~text"+(string)page;
    if (llListFindList(said,[card])==-1)
    {
        said=[]+said+[card];
        textToSay=""+osGetNotecard(card);
        sayText();
    }
}    
default
{
    state_entry()
    {
        page=0;
        said=[];
        if (!showPageNum) llSetText("",ZERO_VECTOR,0.0);
        tCount=llGetInventoryNumber(INVENTORY_TEXTURE);
        if (tCount<1) llOwnerSay("No textures to display");
        //showPage();
    }
    timer()
    {
        llSetTimerEvent(0.0);
        sayText();
    }
    on_rez(integer foo)
    {
        if (llGetAttached()!=0) return; // ignore if worn
        else llResetScript();
    }
    link_message(integer sender, integer val, string message, key users)
    {
        //llOwnerSay("Heard: "+message);
        list data=llParseString2List(message,["|"],[]);
        string command=llList2String(data,0);
        if (command=="GLOBAL_SYSTEM_RESET") return;
        else if (command=="GLOBAL_SYSTEM_GOING_DORMANT") return;
        else if (command=="GLOBAL_START_USING") llResetScript();
        else if (command=="GLOBAL_USER_STOOD") return;
        else if (command=="GLOBAL_ANIMATION_SYNCH_CALLED") return;
        else if (command=="GLOBAL_NEW_USER_ASSUMED_CONTROL") return;
        else if (command=="GLOBAL_NOTICE_ENTERING_EDIT_MODE") return;
        else if (command=="GLOBAL_EDIT_PERSIST_CHANGES") return;
        else if (command=="GLOBAL_STORE_ADDON_NOTICE") return;
        else if (command=="GLOBAL_EDIT_STORE_TO_CARD") return;
        else if (command=="GLOBAL_NOTICE_LEAVING_EDIT_MODE") return;
        else
        {
            list coms=llParseString2List(llList2String(data,1),["{","}"],[]);
            string addon=llList2String(coms,0);
            if (addon=="ainepres")
            {
                page=llList2Integer(coms,1);
                showPage();
            }
        }
    }
}
