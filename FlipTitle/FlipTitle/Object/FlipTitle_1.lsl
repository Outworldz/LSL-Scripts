// :CATEGORY:HoverText
// :NAME:FlipTitle
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:53
// :ID:322
// :NUM:430
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// FlipTitle.lsl
// :CODE:

string command = "";
string person = "";
key owner;

default
{
    state_entry()
    {
        owner = llGetOwner();
        llListen(0,"",owner,"");
    }

    attach(key attached)
    {
        if (attached != NULL_KEY)
        {
            llInstantMessage(owner,"To set a title: title <color name> <title text>");
            llInstantMessage(owner,"To remove title: title off");
            llInstantMessage(owner,"<color name> can be: white, black, red, green, blue, pink, cyan, purple, yellow, orange");
            llResetScript();
        }
    }

    listen(integer channel, string name, key id, string message)
    {
        list strings = llParseString2List(message,[" "],[]);
        string command=llList2String(strings,0);
        string string1=llList2String(strings,1);
        if(command=="title")
        {
            vector color=<0,0,0>;
            if(string1=="blue")
            {
                color=<0,0,1>;
            }
            else if(string1=="orange")
            {
                color=<1,0.5,0>;
            }
            else if(string1=="cyan")
            {
                color=<0,1,1>;
            }
            else if(string1=="pink")
            {
                color=<1,0,1>;
            }
            else if(string1=="green")
            {
                color=<0,1,0>;
            }
            else if(string1=="red")
            {
                color=<1,0,0>;
            }
            else if(string1=="white")
            {
                color=<1,1,1>;
            }
            else if(string1=="yellow")
            {
                color=<1,1,0.1>;
            }
            else if(string1=="purple")
            {
                color=<0.7,0,0.7>;
            }
            else
            {
                color=<0,0,0>;
            }
            string title = "";
            integer i;
            for(i=2; i<=12; i++)
            {
                if(llStringLength(llList2String(strings,i)))
                {
                    title = title + llList2String(strings,i) + " ";
                }
            }
            if(title == "off")
            {
                llSetText("",<0,0,0>,1.0);
            } else {
                llSetText(title, color, 1.0);   
            }
        }   
    }
}// END //
