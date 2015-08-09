// :CATEGORY:Viewer 2
// :NAME:Display_text_with_HTML_markup
// :AUTHOR:Becky Pippen
// :CREATED:2010-09-02 11:07:45.097
// :EDITED:2013-09-18 15:38:51
// :ID:243
// :NUM:333
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// The text of the data URI will be %-hex-escaped automatically for you, so there's no need to use llEscapeURL(). All you need in the data URI is the prefix data:text/html, plus your HTML. 
// :CODE:
default
{
    state_entry()
    {
        integer face = 4;
        string message = "<i>Hello</i><h2>World!</h2>";
        llSetPrimMediaParams(face,
            [PRIM_MEDIA_CURRENT_URL, "data:text/html," + message]);
    }
} 
