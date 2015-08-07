// :CATEGORY:Viewer 2
// :NAME:Link_to_external_CSS_file_forms_exa
// :AUTHOR:Becky Pippen
// :CREATED:2010-09-02 11:13:08.863
// :EDITED:2013-09-18 15:38:56
// :ID:473
// :NUM:634
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Link_to_external_CSS_file_forms_example
// :CODE:
default
{
    state_entry()
    {
        integer face = 4;
        string externalCSS =
            "http://www.google.com/css/modules/buttons/g-button-chocobo.css";

        string dataURI = "data:text/html,<head><link href='" +
                externalCSS + "' rel='stylesheet' type='text/css' /></head>" +
                "<form><input type='button' value='Click Me' class='g-button' /></form>";

        llSetPrimMediaParams(face,
                [PRIM_MEDIA_CURRENT_URL, dataURI]);
    }
}  
