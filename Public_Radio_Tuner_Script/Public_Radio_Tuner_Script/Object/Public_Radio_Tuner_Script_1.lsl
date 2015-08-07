// :CATEGORY:Radio
// :NAME:Public_Radio_Tuner_Script
// :AUTHOR:Angrybeth Shortbread
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:00
// :ID:665
// :NUM:905
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Public Radio Tuner Script.lsl
// :CODE:

//  Random Tuner by Angrybeth Shortbread - 2005
//
//  Attach this script to an object in your parcel, to randomly change the current
//  streaming audio track on touch. This script is set to the Soma FM channels.
//  Change the URL's to your own streams.

integer voice;

default
{
    on_rez(integer start_param)
    {
        llResetScript();
    }
    
    
    state_entry()
    {
        llSay(0, "Touch me for a serendipitous choice of tunes");
        llOwnerSay("Say radio 1 thru to 6 to change stations, list - to gets stations , or stop - to switch me off");
         voice = llListen(0, "", NULL_KEY, "");
    }

    touch_start(integer total_number) // This allows any on to change the music..
    {
       state Radio;
    }
    
    listen(integer channel, string name, key id, string message) {  // this is for the owner only...
        if (message == "stop") 
        {
        llSetParcelMusicURL(" ");
        llSay(0, "No more tunes :(");
        state default;
        }
        
        if (message == "list") 
        {
        
        llOwnerSay("radio 1 for Groove Salad.");
        llOwnerSay("radio 2 for Drone Zone.");
        llOwnerSay("radio 3 for cliqhop.");
        llOwnerSay("radio 4 for Secret Agent.");
        llOwnerSay("radio 5 for Indie Pop Rocks!");
        llOwnerSay("radio 6 for BeatBlender.");
        state default;
        }
        
        if (message == "radio 1")
        {
            llSay(0, "..Groove Salad: a nicely chilled plate of ambient beats and grooves. [SomaFM]");
            llSetParcelMusicURL("http://somafm-sc.streamguys.com:8066");
            state default;
        }

        else if (message == "radio 2")
        {
            llSay(0, "..Drone Zone: Atmospheric ambient space music. Serve Best Chilled. Safe with most medications. [SomaFM]");
            llSetParcelMusicURL("http://somafm-sc.streamguys.com:8054");
            state default;
        }
        
        else if (message == "radio 3")
        {
            llSay(0, "..<-- cliqhop --> blips'n'bleeps backed w/ beats. broadband. [SomaFM]");
            llSetParcelMusicURL("http://somafm-sc.streamguys.com:8062");
            state default;
        }
        
        else if (message == "radio 4")
        {
            llSay(0, "..Secret Agent: The soundtrack for your stylish, mysterious, dangerous life. For Spys and P.I.'s too! [SomaFM]");
            llSetParcelMusicURL("http://somafm-sc.streamguys.com:8052");
            state default;
        }
        
        else if (message == "radio 5")
        {
            llSay(0, "..SomaFM presents: Indie Pop Rocks! [SomaFM]");
            llSetParcelMusicURL("http://207.200.96.231:8022");
            state default;
        }
        
        else if (message == "radio 6")
        {
            llSay(0, "..BeatBlender: A late night blend of deep-house & downtempo chill [SomaFM]");
            llSetParcelMusicURL("http://64.124.44.102:8388");
            state default;
        }
    
}
}

state Radio
{
     state_entry()
     {
     llSay(0, "Tuning in...");
        
        float   FloatValue;
        integer IntValue;
        string  StringValue;
        
        FloatValue  = llFrand(5);
        IntValue    = llRound(FloatValue);
        StringValue = (string)IntValue;
        
        if (StringValue == "0")
        {
            llSay(0, "..Groove Salad: a nicely chilled plate of ambient beats and grooves. [SomaFM]");
            llSetParcelMusicURL("http://somafm-sc.streamguys.com:8066");
            state default;
        }

        else if (StringValue == "1")
        {
            llSay(0, "..Drone Zone: Atmospheric ambient space music. Serve Best Chilled. Safe with most medications. [SomaFM]");
            llSetParcelMusicURL("http://somafm-sc.streamguys.com:8054");
            state default;
        }
        
        else if (StringValue == "2")
        {
            llSay(0, "..<-- cliqhop --> blips'n'bleeps backed w/ beats. broadband. [SomaFM]");
            llSetParcelMusicURL("http://somafm-sc.streamguys.com:8062");
            state default;
        }
        
        else if (StringValue == "3")
        {
            llSay(0, "..Secret Agent: The soundtrack for your stylish, mysterious, dangerous life. For Spys and P.I.'s too! [SomaFM]");
            llSetParcelMusicURL("http://somafm-sc.streamguys.com:8052");
            state default;
        }
        
        else if (StringValue == "4")
        {
            llSay(0, "..SomaFM presents: Indie Pop Rocks! [SomaFM]");
            llSetParcelMusicURL("http://207.200.96.231:8022");
            state default;
        }
        
        else if (StringValue == "5")
        {
            llSay(0, "..BeatBlender: A late night blend of deep-house & downtempo chill [SomaFM]");
            llSetParcelMusicURL("http://204.15.0.150:80");
            state default;
        }
        
        
    }
}// END //
