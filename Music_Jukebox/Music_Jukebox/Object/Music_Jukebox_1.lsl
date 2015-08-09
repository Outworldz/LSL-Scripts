// :CATEGORY:Music
// :NAME:Music_Jukebox
// :AUTHOR:Shine Renoir
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:58
// :ID:549
// :NUM:747
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Place this script in an object. If you want to play your own music, change the url variable and upload the sounds into this directory as 1.ogg, 2.ogg etc. Enter the title in the music list, 1.ogg the first entry etc. llSetParcelMusicURL works only, if the owner of the object is the owner of the land where the object is placed. To start a music, touch the object.
// :CODE:
// Jukebox Music Script

// 2007 Copyright by Shine Renoir (fb@frank-buss.de)

// Use it for whatever you want, but keep this copyright notice

// and credit my name in notecards etc., if you use it in

// closed source objects

//

// Don't forget to change the music URL, if you use it



list music = [

    "Chant de nuit, Artist: Dreamer, Album: Demo",

    "Court Métrage N°1 - Ehma, Artist: Le Consortium des Artistes Libres, Album: The Urban Tale",

    "Emptiness, Artist: Alexander Blu, Album: May",

    "Sensitive part, Artist: arnoldsrecords, Album: Our own ways Out",

    "Suite Irlandaise, Artist: Avel Glas, Album: Vent Bleu",

    "Ploneïs, Artist: Avel Glas, Album: Vent Bleu",

    "Cosmo, Artist: Alexander Blu, Album: May" ];



string url = "http://www.frank-buss.de/sl/";

default

{

    touch_start(integer num)

    {

        // show dialog with available musics

        llDialog(llGetOwner(), "Select free music from http://www.jamendo.com/", [

            "Chant de nuit",

            "Cosmo",

            "stop music",

            "Emptiness",

            "Ploneïs",

            "Suite Irlandaise",

            "Sensitive part",

            "Court Métrage N°1" ],

            -45);

    }

    

    state_entry()

    {

        llTargetOmega(<0.0, 0.0, 1.0>, 0.2, 1);

        llListen(-45, "", NULL_KEY, "");

    }

    

    listen(integer channel,string name,key id,string msg)

    {

        if (msg == "stop music") {

            // setting URL to empty string stops music playback

            llSetParcelMusicURL("");

        } else {

            // search position in music list

            integer len = llGetListLength(music);

            integer i;

            for (i = 0; i < len; i++) {

                string info = llList2String(music, i);

                if (llGetSubString(info, 0, llStringLength(msg) - 1) == msg) {

                    // show info

                    llWhisper(0, "loading music: " + info + "...");

                    llWhisper(0, "click the play button at screen bottom");

                    

                    // stop previous music

                    llSetParcelMusicURL("");



                    // musics are named 1.ogg, 2.ogg etc.

                    llSetParcelMusicURL(url + (string) (i+1) + ".ogg");

                }

            }

        }

    }

}
