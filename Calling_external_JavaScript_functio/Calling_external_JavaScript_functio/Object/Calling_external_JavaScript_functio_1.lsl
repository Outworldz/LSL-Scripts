// :CATEGORY:Viewer 2
// :NAME:Calling_external_JavaScript_functio
// :AUTHOR:Becky Pippen
// :CREATED:2010-09-02 11:14:37.050
// :EDITED:2013-09-18 15:38:50
// :ID:143
// :NUM:209
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Press enter to accept Project Name  or type a new descriptionalling_external_JavaScript_functions
// :CODE:
integer face = 4;
string externalJavascript =
    "http://ajax.googleapis.com/ajax/libs/jquery/1.4/jquery.min.js";
default
{
    state_entry()
    {
        string dataURI = "data:text/html," +
            "<head><script src='" + externalJavascript + "'></script></head>" +
            "<button>Toggle</button>" +
            "<p>Hello<br />World</p>" +
            "<script>$('button').click(function () " +
            "{$('p').slideToggle('slow');});</script>";

        llSetPrimMediaParams(face,
            [PRIM_MEDIA_CURRENT_URL, dataURI]);
    }
} 
