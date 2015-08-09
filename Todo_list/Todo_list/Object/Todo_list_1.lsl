// :CATEGORY:Floating Text
// :NAME:Todo_list
// :AUTHOR:Hydrais
// :CREATED:2010-04-26 10:33:29.923
// :EDITED:2013-09-18 15:39:07
// :ID:901
// :NUM:1277
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// I may also make it so that it can read things off of a notecard.
// :CODE:
vector color = <1,1,1>; //Starting color, black

list colors = ["blue",<0,0,1>,"green",<0,1,0>,"red",<1,0,0>,"black",<0,0,0>,"white",<1,1,1>,"yellow",<1,1,0>];  //color list, first color,then its vector

list todo = [""]; //where your added todo stuff is put
list msg = [""]; //this is the new message all nice and parsed so it can do things


todolist(string cmd, string obj) { //my todo function that way if need be i can use else where
    if(cmd == "-atl") {
        todo += obj;
        llSetText("To Do List: \n" + llDumpList2String(todo, "\n"),color,1);
        msg = [""];
    }
    if(cmd == "-dtl") {
        todo = llDeleteSubList(todo, (integer)obj,(integer)obj);
        llSetText("To Do List: \n" + llDumpList2String(todo, "\n"),color,1);
        msg = [""];
    }
    if(cmd == "-cc") {
        if(llListFindList(colors, [obj]) != -1) {
            color = llList2Vector(colors, llListFindList(colors, [obj])+1) ;
            llSetText("To Do List: \n" + llDumpList2String(todo, "\n"),color,1); 
        }
        else {
            color = (vector)obj;
            llSetText("To Do List: \n" + llDumpList2String(todo, "\n"),color,1); 
        }
    }
}

default {
    state_entry() {
        key owner = llGetOwner();
        llListen(0,"",llGetOwner(),"");
        llSetText("To Do List: \n" + llDumpList2String(todo, "\n"),<1,0,0>,1);
    }
    listen(integer channel, string name, key id, string message) {
        msg = llParseString2List(message, ["."], []);
        todolist(llList2String(msg,0), llList2String(msg,1));
    }
}
