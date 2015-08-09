// :CATEGORY:Avatar
// :NAME:AllowedorNot
// :AUTHOR:Tribal Toland
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:47
// :ID:28
// :NUM:39
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Allowed-or-Not.lsl
// :CODE:


//Simple OpenSource Licence (I am trusting you to be nice)
//1.  PLEASE SEND ME UPDATES TO THE CODE
//2.  You can do what you want with this script including selling it in other objects and so on.
//You can sell it in closed source objects if you must, but please try to send any updates or
//improvements back to me for possible inclusion in the main trunk of development.
//3.  You must always leave these instructions in any object created; notecard written; posting to
//any electronic medium such as Forum, Email &c. of the source code & generally be nice (as
//already requested!)
//4.  You must not claim that anyone apart from Tribal Toland wrote the original version of this script.
//Thank you for your co-operation
//Tribal Toland
//Instructions - These are not going to be too detailed
//because the script is open-source so you can see how
//it works
//say "/5 add=(avatar name)" To add a person to the list
//The name must be spelt exactly as it is on secondlife
//casesensitive
//say "/5 del=(avatar name)" To remove a person from the list
//say "/5 find=(avatar name)" to check if that person is on the list
//say "/5 clear" To wipe the list clean
//say "/5 read" To hear a list of all the people on the listlist allowed = [];//This decalares the global variable list allowed
key owner;//This decalares the global variable key owner
integer lkey;//This decalares the global variable integer lkey
integer lch;//This decalares the global variable integer lchspeak(string message)
{//This decalares the global function speak
    llSay(0, message);//When this function is used the message in the brackets of the function is used in the llSay function. For example speak("Message here") is just the same as using llSay(0, "Message here").
}pause()
{//This decalares the global function speak
    llSleep(0.5);
    speak("Allowed list is:");
}
default
{//The default state    state_entry()
    { //The state_entry event occurs whenever a new state is entered, including script start/reset, and is always the first event handled.
        llSetText("Touch Me to see if you are allowed or not",<1,1,1>,1); //Creates "hover text" of "Touch Me to see if you are allowed or not"
        lch = 5; //Sets the integer lch declared as a global variable to 5
        lkey = llListen(lch,"","",""); //Sets the integer lkey declared as a global variable to the listen function. This is done so we can later remove the listen if we want using. llListenRemove(lkey);
        allowed = [];//Clears the allowed list
        owner = llGetOwner(); //Sets the global variable to the function llGetOwner();
    }    listen(integer channel, string name, key id, string message)
    {
        //The listen() event handler is invoked whenever a chat message matching the constraints passed in the llListen function is heard.
        //The channel the chat was picked up on, the name and id of the speaker and the message are passed.
        list cmdline = llParseString2List(message,["="],[]);
        //Turns the message into a list using "=" as a seperator between the values
        //for example if "hello there you" was heard it would thurn that into a list
        // such as this ["hello", "there", "you"]
        string cmd = llList2String(cmdline,0); //this turns the first  part of the list into a string
        string param = llList2String(cmdline,1); //this turns the secondpart of the list into a string        if(id == owner)
        {//Checks the key id of the person heard againts the owners key. If they are both the same (==) then continue what is in the brackets
            if(cmd == "add")
            {//If the cmd is "add"                if(llListFindList(allowed,[param]) < -0.5)
                { //Cheaks the allowed list to see if the person is on it. Returns -1 if the person is not on the list
                    speak(param+" was added to the allowed list "+name); //Calls the global function speak with a message of param+" was added to the allowed list "+name
                    allowed += [param];//adds the person to the list
                    pause();//calls the global function pause()
                    speak(llDumpList2String(allowed,"n"));
                    //Calls the global function speak. lllDumpList2String turns a
                    //list into a string using the seperator between the values (in this
                    //case "n" between the values) If the list was ["foo", "bar"] this
                    //would return as "foonbarn". The n makes what is said appear on a new line
                }                else
                { //If the person is allready on the list
                    speak("Already added to the allowed list");//Calls the global function speak
                    speak(llDumpList2String(allowed,"n"));//Calls the global function speak. And dumps the list
                }
            }            if(cmd == "del")
            {//If the cmd is "del"
                integer find = llListFindList(allowed,[param]); //the integer find is the first instance of "param". Returns -1 if not found
                if(find > -0.5)
                {//if the integer find is bigger that minus 0.5. Continue in the brackets
                    speak(param+" was deleted from the allowed list "+name);//Calls the global function speak
                    string allow = llDumpList2String(allowed,"=");//The string allow is  llDumpList2String(allowed,"=")
                    string var = param; //the string var is the param
                    integer pos = llSubStringIndex(allow,var);//the integer pos is the index where var first appears
                    allow = llDeleteSubString(allow,pos,pos+llStringLength(var) - 1);//removes the indicated string and returns the result
                    allowed = llParseString2List(allow,["="],[]);//turns the string allow into a list
                    pause();//Calls the global function pause()
                    speak(llDumpList2String(allowed,"n"));//Calls the global function speak.
                }                else
                {
                    speak(param+" was not found on the allowed list");//Calls the global function speak.
                }
            }            if(cmd == "find")
            {//If the cmd is "find"
                string test = param;//The string test is the param.
                integer to_find = llListFindList(allowed,(list)test);//the integer to find is llListFindList(allowed,(list)test). Returns -1 if test s not found                if(to_find == -1)
                {//if test is not found
                    speak("Could not find "+test+ " on the allowed list.");//Calls the global function speak.
                    pause();//Calls the global function pause
                    speak(llDumpList2String(allowed,"n"));//Calls the global function speak.
                }                else
                {//If they are on the list.
                    speak(test+" has been found on the allowed list");//Calls the global function speak.
                }
            }            if(cmd == "clear")
            {//If the cmd is "clear"
                speak("Allowed list has been wiped clean");//Calls the global function speak.
                allowed = [];//Clears the allowed list
            }            if(cmd == "read")
            {//If the cmd is "read"
                speak("People of allow list are:n"+llDumpList2String(allowed,"n"));//Calls the global function speak.
            }
        }
    }    touch_start(integer num_detected)
    {//If the object is touched this event is called
        string name = llDetectedName(0);//The string name is the person who touched the object. ( llDetectedName(0) )
        key id = llDetectedKey(0);//The key id is the key of the person who touched the object. ( llDetectedKey(0) )        if(llListFindList(allowed,[name]) == -1 && id !=llGetOwner())
        {
            //If the name is not on the list and the id of the name is not the owner of the prim
            speak("Sorry "+name+" but you do not have the correct authority to use this object! Please contact the owner");//Calls the global function speak.
        }        else
        {//if the person who touched the object is on the list or is the owner.
            if(id == llGetOwner())
            {//if it is the owner
                speak("Hello "+llKey2Name(llGetOwner())+" you are the owner of me");//Calls the global function speak.
            }            else
            {//if not the owner but still on the allowed list
                speak("Hello there "+name+" you are allowed to use this as you are on the allowed list. You should feel special! :D");//Calls the global function speak.
            }
        }
    }//End of the touch_start event
}//End of the script.    // end 
