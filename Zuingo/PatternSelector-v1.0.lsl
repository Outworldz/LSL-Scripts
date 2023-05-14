list lBlues = [   22730431 //E
                , 32772191 //N
                , 18157905 //X
                ,  7509183 //P
                , 31119031 //S
                ,  1113121 //T
                , 22369621 //1010101 etc...
                ];

default {
    link_message(integer sender, integer num, string msg, key id) {
        if (msg == "getblues") {
            llMessageLinked(LINK_THIS, llList2Integer(lBlues, (integer)llFrand( llGetListLength(lBlues)-1 )), "setblues", id); //comment this line and uncomment next line for testing
        }
    }
}
