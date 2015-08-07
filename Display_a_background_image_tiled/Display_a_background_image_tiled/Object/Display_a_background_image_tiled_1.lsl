// :CATEGORY:Viewer 2
// :NAME:Display_a_background_image_tiled
// :AUTHOR:Becky Pippen
// :CREATED:2010-09-02 11:11:28.410
// :EDITED:2013-09-18 15:38:51
// :ID:239
// :NUM:327
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Method #1 — using CSS in a style element in <head>
// :CODE:
default

{

    state_entry()

    {

        integer face = 4;

        string imageURL =

            "http://www.google.com/intl/en_ALL/images/logo.gif";

        string dataURI = "data:text/html,<head>"

            + "<style type='text/css'>body{background-image:url(\""

            + imageURL + "\");}</style></head><body>Hello World</body>";

        llSetPrimMediaParams(face,

                [PRIM_MEDIA_CURRENT_URL, dataURI]);

    }

} 
