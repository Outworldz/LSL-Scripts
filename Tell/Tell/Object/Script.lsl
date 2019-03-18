// :CATEGORY:Speach
// :NAME:Tell
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:06
// :ID:875
// :NUM:1235
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Makes an object speak without using its name
// :CODE:



// utility to make an object speak without using the objects name


Tell (string story) {
    string oldname = llGetObjectName ();
    llSetObjectName ("");
    llSay (0, "/me " + story);
    llSetObjectName (oldname);
}



default {
    state_entry()
    {
        Tell("This prim speaks without reveling the name of the object");
    }

}

