// :CATEGORY:Dialog
// :NAME:Dialog_module
// :AUTHOR:Strife Onizuka
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:51
// :ID:233
// :NUM:321
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// ESL Version:
// :CODE:
//////////////////////////////////////////////////////////////////////////////////////
//
//    Dialog Module
//    Version 9.3 Release
//    Copyright (C) 2004-2006, Strife Onizuka
//    http://home.comcast.net/~mailerdaemon/
//    http://secondlife.com/badgeo/wakka.php?wakka=LibraryDialogModule
//    
//    This library is free software; you can redistribute it and/or
//    modify it under the terms of the GNU Lesser General Public License
//    as published by the Free Software Foundation; either
//    version 2.1 of the License, or (at your option) any later version.
//    
//    This library is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU Lesser General Public License for more details.
//    
//    You should have received a copy of the GNU Lesser General Public License
//    along with this library; if not, write to the Free Software
//    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
//    
//////////////////////////////////////////////////////////////////////////////////////

#ifndef DIALOGCOMM
    #define DIALOGCOMM    12
#endif
#ifdef USESCRIPTNAME
integer DialogComm = DIALOGCOMM;
#elif !defined DialogComm
#define DialogComm DIALOGCOMM
#endif

#ifndef TICKSIZE
    #define TICKSIZE 5.0
#endif
#ifndef DEFAULTTIMEOUT
    #define DEFAULTTIMEOUT TICKSIZE
#endif
//////////////////////////////////////////////////////////////////////////////////////
//Don't change anything else unless you *really* need to.
#define ZERO_INTEGER 0
list handles;
list time;
list chans;
string users;//save memory
list answer;
list button;
list prim;
list mask;
list intchan;

integer ticks;

remove(integer a)
{
    llListenRemove(llList2Integer(handles,a));
    handles = llDeleteSubList(handles,a,a);
    time    = llDeleteSubList(time,   a,a);
    chans   = llDeleteSubList(chans,  a,a);
    answer  = llDeleteSubList(answer, a,a);
    button  = llDeleteSubList(button, a,a);
    prim    = llDeleteSubList(prim,   a,a);
    mask    = llDeleteSubList(mask,   a,a);
    intchan = llDeleteSubList(intchan,a,a);
    users   = llDeleteSubString(users,a*=36,a+35);
}

#define wipe() llSetTimerEvent(ticks = ZERO_INTEGER)
#define quickdump(a, b)  (b + llDumpList2String(a, b)) 
#ifndef quickdump
string quickdump(list a, string b){  return b + llDumpList2String(a, b); }
#endif

list TightListParse(string a) {
    string b = llGetSubString(a,ZERO_INTEGER,ZERO_INTEGER);//save memory
    return llParseStringKeepNulls(llDeleteSubString(a,ZERO_INTEGER,ZERO_INTEGER), [a=b],[]);
}

clear()
{
    integer a = llGetListLength(handles);
    while(a)
    {
        llListenRemove(llList2Integer(handles,--a));
        if(llList2Integer(mask,a)&0x20000)
            llMessageLinked(llList2Integer(prim,a), llList2Integer(intchan,a),
                    llList2String(answer,a), "|-2||"+llGetSubString(users,a * 36,(a * 36) + 35)+"||-1");
    }
    wipe();
}

default
{
    state_entry()
    {
        #ifdef USESCRIPTNAME
        if((DialogComm += (integer)llList2String(llParseString2List(llGetScriptName(), [" "],[]), -1)) == DialogComm)
        {
        #endif
            llOwnerSay("Dialog Module, Version 9.2, Released Under the GNU Lesser General Public License");
            llOwnerSay("Copyright (C) 2004-2006, Strife Onizuka, http://secondlife.com/badgeo/wakka.php?wakka=LibraryDialogModule");
        #ifdef USESCRIPTNAME
        }
        #endif
    }
    on_rez(integer a)
    {
        clear();
    }
    link_message(integer a, integer b, string c, key d)
    {
        if(b == DialogComm)
        {
            b = llSubStringIndex(llDeleteSubString(c,ZERO_INTEGER,ZERO_INTEGER), llGetSubString(c,ZERO_INTEGER,ZERO_INTEGER));
            list    e = TightListParse(d);
            integer buttonmask =  (integer)llList2String(e,3);
            string  user       =  llList2String(e,ZERO_INTEGER);
            list    buttons    =  llDeleteSubList(e,ZERO_INTEGER,3);
            float   timeout    =  (float)llList2String(e,2);
            integer cat        =  (integer)llFrand(-2147483392.0) - 255;
            integer chan       =  (integer)llDeleteSubString(c, b + 1, ZERO_INTEGER);
            string  ans        =  llDeleteSubString(c,ZERO_INTEGER,b);
            
            if(buttonmask & 0x100000)
                clear();
            else if(buttonmask & 0x200000)
            {//clean out other box's that went to this user.
                while(1 + (b = llSubStringIndex(users, user)))
                {
                    if(llList2Integer(mask,b/=36)&0x20000)
                        llMessageLinked(llList2Integer(prim,b), llList2Integer(intchan,b),
                                        llList2String(answer,b), "|-2||"+llGetSubString(users,b * 36,(b * 36) + 35)+"||-1");
                    remove(b);
                }
                if(time == [])
                    wipe();
            }
            
            if(user == "" || user == NULL_KEY) //lazy check
                user = llGetOwner();
            if(!llGetAgentInfo(user)) 
            {// target not in the sim
                if(buttonmask & 0x40000)
                    llMessageLinked(a, chan, ans, "|-3||"+user+"||0");
                jump end1;//instead of a return, too many local variables to clear off the stack.
            }
            while(1+llListFindList(chans,[cat]))
                --cat;
            
            b = llListen(cat,"",user,"");
            llDialog(user, llList2String(e,1), buttons, cat);
            if(chan != DialogComm)
            {//loopback catch
                if(buttons == []) // so we can match the ok button
                    buttons = ["OK"];
                if(buttonmask & ((1<<llGetListLength(buttons)) - 1))
                { //we checked the mask to see if we should expect any values back
                    chans   +=  cat;
                    handles +=  b;
                    if(timeout < 5.0 || timeout > 7200)
                        timeout = DEFAULTTIMEOUT;
                    time    +=  (ticks + (timeout / TICKSIZE));
                    users   +=  user;
                    answer  +=  ans;
                    button  +=  quickdump(buttons,llGetSubString(d,ZERO_INTEGER,ZERO_INTEGER));
                    prim    +=  a;
                    mask    +=  buttonmask;
                    intchan +=  chan;
                    llSetTimerEvent(TICKSIZE);
                    jump end2;//instead of a return, too many local variables to clear off the stack.
                }
            }
            llListenRemove(b);
            if(buttonmask & 0x80000)
                llMessageLinked(a, chan, ans, "|-4||"+(string)user+"||0");
        }
        @end1;@end2;
    }
    listen(integer a, string b, key c, string d)
    {
        if(a+1 && llGetSubString(users,36 * a=llListFindList(chans,[a]),(a * 36) + 35) == c)
        {//it's one of our listens
            integer f = llListFindList(TightListParse(llList2String(button,a)),[d]);
            if(f+1)
            {//we matched a button
                if(llList2Integer(mask,a)&(1<<f))
                {
                    list ret = [f, d, c, b,(llList2Float(time,a) - ticks) * TICKSIZE];
                    if(llSubStringIndex(d = (string)ret,b = "|") + 1)
                    {
                        f = -37;
                        b = "|\\/?!@#$%^&*()_=:;~{}[]<>`',\n\" qQxXzZ";
                        do;while(1+llSubStringIndex(d,llGetSubString(b,f,f)) && ++f);
                        b = llGetSubString(b,f,f);
                    }
                    d = "";
                    llMessageLinked(llList2Integer(prim,a), llList2Integer(intchan,a), 
                                    llList2String(answer,a), quickdump(ret, b));
                }
                remove(a);
                if(time == [])
                    wipe();
            }
        }
    }
    timer()
    {
        ++ticks;
        integer a = llGetListLength(time);
        float c;
        key d;
        while(a)
        {
            if(((c = llList2Float(time,a)) <= ticks) || !llGetAgentInfo(d = llGetSubString(users,--a * 36,(a * 36) + 35)))
            {
                if(llList2Integer(mask,a)&0x10000)
                    llMessageLinked(llList2Integer(prim,a), llList2Integer(intchan,a),
                            llList2String(answer,a), "|-1||"+(string)d+"||"+(string)((ticks - c) * TICKSIZE));

                remove(a);
            }
        }
        if(time == [])
            wipe();
    }
}
