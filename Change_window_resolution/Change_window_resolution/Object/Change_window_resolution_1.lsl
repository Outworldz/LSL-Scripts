// :CATEGORY:Viewer 2
// :NAME:Change_window_resolution
// :AUTHOR:Becky Pippen
// :CREATED:2010-09-02 11:08:52.473
// :EDITED:2013-09-18 15:38:50
// :ID:164
// :NUM:232
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// The browser will add scroll bars if the rendered HTML doesn't fit within the specified PRIM_MEDIA_* size. 
// :CODE:
default
{
    state_entry()
    {
        integer face = 4;
        string message = "Hello World";
        llSetPrimMediaParams(face,
                [PRIM_MEDIA_CURRENT_URL, "data:text/html," + message,
                PRIM_MEDIA_WIDTH_PIXELS, 128,
                PRIM_MEDIA_HEIGHT_PIXELS, 32]);
    }
} 
