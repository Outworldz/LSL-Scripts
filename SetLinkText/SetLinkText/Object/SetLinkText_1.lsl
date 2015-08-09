// :CATEGORY:Set Text
// :NAME:SetLinkText
// :AUTHOR:Tacusin Memo
// :CREATED:2010-12-27 12:36:28.040
// :EDITED:2013-09-18 15:39:02
// :ID:744
// :NUM:1027
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
I've always seen lots of scripts that used llMessageLinked() and llSetText() to be able to make hover text over prims other then the prim the script is in. it's because of this that i made this custom function which uses llSetLinkPrimitiveParamsFast() to set hover text over prims via one script other than the prim that the script is in. I first looked to see if someone else had done this and i found this page https://wiki.secondlife.com/wiki/LlSetLinkText . that is pretty much what i did and the format for using it.// // // To use a custom function such as this the function you must put it be before default in the script which I will show in the example. Afterwords you can use it to your hearts desire within the script itself.// // -Disclaimer- Your allowed to modify this any way you want and use it. If any way is found to use this for Griefing I am not to be held responsible. 
// :CODE:
SetLinkText( integer linknumber, string text, vector color, float alpha )
{
    llSetLinkPrimitiveParamsFast(linknumber,[PRIM_TEXT,text,color,alpha]);
}
/*
Above here is the function that allows it to work
 
This example makes the prim you click in the Link Set display the word Hello above it in Red text
*/
default
{
    touch_start(integer total_number)
    {
        SetLinkText(llDetectedLinkNumber(0),"Hello",<1,0,0>,1);
    }
}
