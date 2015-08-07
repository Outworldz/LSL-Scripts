// :CATEGORY:Dialog
// :NAME:DIALOG_MENU
// :AUTHOR:Kyrah Abbatoir
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:51
// :ID:232
// :NUM:318
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// DIALOG MENU by Kyrah Abattoir.lsl
// :CODE:

//DIALOG MENU by Kyrah Abattoir


integer menu_handler;
integer menu_channel;
menu(key user,string title,list buttons)//make dialog easy, pick a channel by itself and destroy it after 5 seconds
{
    menu_channel = (integer)(llFrand(99999.0) * -1);//yup a different channel at each use
    menu_handler = llListen(menu_channel,"","","");
    llDialog(user,title,buttons,menu_channel);
    llSetTimerEvent(5.0);
}

default
{
    touch_start(integer t)
    {
        menu(llDetectedKey(0),"hello world",["yes","no"]);
    }
    timer() //so the menu timeout and close its listener
    {
        llSetTimerEvent(0.0);
        llListenRemove(menu_handler);
    }
    listen(integer channel,string name,key id,string message)
    {
        if (channel == menu_channel) //in case you have others listeners
        {
            if(message == "yes")
            {
                //do stuffs
            }
            else if(message == "no")
            {
                //do other stuffs
            }
        }
    }
}// END //
