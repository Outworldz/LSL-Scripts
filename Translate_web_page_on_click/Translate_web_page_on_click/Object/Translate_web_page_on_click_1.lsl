// :CATEGORY:Translator
// :NAME:Translate_web_page_on_click
// :AUTHOR:Ferd Frederix
// :CREATED:2012-09-16 11:41:22.897
// :EDITED:2013-09-18 15:39:08
// :ID:919
// :NUM:1317
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Change the url="" to your blog or marketplace listing.
// :CODE:
string url = "http://www.outworldz.com/secondlife/tools/tools.htm";

default
{
    touch_start(integer total_number)
    {
        
        string lang = llGetAgentLanguage(llDetectedKey(0));
        
        // lang="es"; // uncomment to debug, this is espanol, or spanish
        
        lang = llGetSubString(lang,0,1);
        if (lang == "" || lang == "en")
        {
            llLoadURL(llDetectedKey(0),"Information",url);
        }  else  {
            string url = "http://translate.google.com/translate?sl=auto&tl=" + lang + "&js=n&prev=_t&hl=en&ie=UTF-8&layout=2&eotf=1&u=" + llEscapeURL(url);;
           llLoadURL(llDetectedKey(0),"Information",url);
        }
    }
}
