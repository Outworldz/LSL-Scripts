// :CATEGORY:Chat-To-Speech
// :NAME:Chat-To-Speech-MOAP
// :AUTHOR:John Jamison
// :CREATED:2013-09-25 14:03:26
// :EDITED:2013-09-25 14:03:21
// :ID:997
// :NUM:1523
// :REV:1.0
// :WORLD:Second Life, OpenSim
// :DESCRIPTION:
// Put on a prim, enable shared media, click the prim face,  and type something.
// requires the Media on a prim be enabled.
// immediately speaks "Hello, chat to speech is ready!" - if this does not work, you have issued with MOAP, flash, or other issues.
// Check the Ctrl-P settings to be sure Media on a prim is enabled.
// It assumes that the language spoken is the same as that detected in the viewer of the chatter.
// :CODE:

// Original script by  John Jamison john at imagilearning.com
// Mods by Fred Beckhusen (Ferd Frederix) for various speakers
// resets when rezzed to establish listener.
// checks for > 100 chars, which Google ignores

string getLang (key id)
{
     string lang = llGetAgentLanguage(id);

    if (lang != "zh-CN" && lang != "zh-TW")           
    {
        lang = llGetSubString(lang,0,1);
    }
    return lang;
}

default
{
    state_entry()    {
        
        llListen(PUBLIC_CHANNEL,"","","");
        llSetText("Text 2 Voice",<1,1,1>,1.0);
        string URL = "http://translate.google.com/translate_tts?ie=utf-8&tl=en&q=" + llEscapeURL("Hello, chat to speech is ready!");
        //URL = "http://www.outworldz.com";
        llSetPrimMediaParams(1,[PRIM_MEDIA_CONTROLS,PRIM_MEDIA_CONTROLS_STANDARD,PRIM_MEDIA_HOME_URL,URL,PRIM_MEDIA_AUTO_PLAY,TRUE]);
    }
    
    listen(integer chan, string name, key id, string message)
    {
        if (llStringLength(message) < 100) {
            llSetText("Text 2 Voice",<1,1,1>,1.0);
            string URL = "http://translate.google.com/translate_tts?ie=utf-8&tl=" + getLang(id) + "&q="+llEscapeURL(message);
            //llOwnerSay(URL);
            llSetPrimMediaParams(1,[PRIM_MEDIA_CONTROLS,PRIM_MEDIA_CONTROLS_STANDARD,PRIM_MEDIA_CURRENT_URL,URL,PRIM_MEDIA_AUTO_PLAY,TRUE]);
        } else {
            llSetText("Text 2 Long",<1,0,0>,1.0);
        }
    }

    on_rez(integer start_param)    {
        // Restarts the script every time the object is rezzed
        llResetScript();
    }

}
