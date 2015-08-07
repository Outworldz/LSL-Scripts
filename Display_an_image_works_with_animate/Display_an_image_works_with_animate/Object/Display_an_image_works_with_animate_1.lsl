// :CATEGORY:Viewer 2
// :NAME:Display_an_image_works_with_animate
// :AUTHOR:Becky Pippen
// :CREATED:2010-09-02 11:10:25.473
// :EDITED:2013-09-18 15:38:51
// :ID:240
// :NUM:330
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Display_an_image_works_with_animate
// :CODE:
default
{
    state_entry()
    {
        integer face = 4;
        string imageURL =
          "http://upload.wikimedia.org/wikipedia/commons/7/70/Rotating_earth_(small).gif";
        string dataURI = "data:text/html,<object data='" + imageURL + "'></object>";
        llSetPrimMediaParams(face,
            [PRIM_MEDIA_CURRENT_URL, dataURI,
             PRIM_MEDIA_WIDTH_PIXELS, 256,
             PRIM_MEDIA_HEIGHT_PIXELS, 256]);
    }
} 
