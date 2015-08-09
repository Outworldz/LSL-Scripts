// :CATEGORY:Viewer 2
// :NAME:Display_plain_text__XyText_replacem
// :AUTHOR:Becky Pippen
// :CREATED:2010-09-02 11:05:38.490
// :EDITED:2013-09-18 15:38:51
// :ID:242
// :NUM:332
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Press enter to accept Project Name  or type a new descriptionDisplay_plain_text__XyText_replacement
// :CODE:
default
{
    state_entry()
    {
        integer face = 4;
        string message = "Hello World";
        llSetPrimMediaParams(face,
            [PRIM_MEDIA_CURRENT_URL, "data:text/html," + message]);
    }
} 
