// :CATEGORY:Music
// :NAME:Simple_MP3_music_player
// :AUTHOR:Ferd Frederix
// :CREATED:2010-06-16 15:25:21.700
// :EDITED:2013-09-18 15:39:02
// :ID:763
// :NUM:1050
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Add music URLs to a list, and call 'play(llDumpList2String(playlist,","));'// // This function then builds the necessary data for autostarting the music , continually streaming the mp3's back-to-back, and loops them when done.// // Your limit is 1024K bytes for the embedded URL's, which is a lot of URL's, even when the escape function triples some of the characters
// :CODE:
// Author: Ferd Frederix
// simple mp3 player for SL
// See http://wpaudioplayer.com/standalone/ for details 



// Add music URLs to a list, and call 'play(llDumpList2String(playlist,","));'
//
//This function then builds the necessary data for autostarting the music , continually streaming the mp3's back-to-back, and loops them when done.
//
//Your limit is 1024K bytes for the embedded URL's, which is a lot of URL's, even when the escape function triples some of the characters
//
// Author: Ferd Frederix
// simple mp3 player for SL
play(string url)
{

    if (llStringLength(url) > 1024)
    {
        llOwnerSay("Too many files!");
        return;
   }

string html = "<html><head><script src=\"http://secondlife.mitsi.com/cgi/audio-player/audio-player.js\"></script><script>AudioPlayer.setup(\"http://secondlife.mitsi.com/cgi/audio-player/player.swf\", {width:290});</script></head><body><p id=\"a\"></p><script>AudioPlayer.embed(\"a\",{soundFile: \""
    + url + "\",autostart:\"yes\",loop:\"yes\"});</script></body></html>";
        


   html = "data:text/html," + llEscapeURL(html); // you may need to escape funny chars
 //  html = "data:text/html," + html; // or not, this depends upon your URL's
    if (llStringLength(html) > 32768)
        llOwnerSay("Web page too big!");
    else
        llSetPrimMediaParams(0,                  // Side to display the media on.
            [PRIM_MEDIA_AUTO_PLAY,TRUE,      // Show this page immediately
             PRIM_MEDIA_CURRENT_URL,html,    // The url currently showing
             PRIM_MEDIA_HOME_URL,html,       // The url if they hit 'home'
             PRIM_MEDIA_HEIGHT_PIXELS,512,   // Height/width of media texture will be
             PRIM_MEDIA_WIDTH_PIXELS,256  // rounded up to nearest power of 2.
            ]);  

}

default
{
    state_entry()
    {
        list playlist = [
        "http://www.mrtv4.com.mm/sites/www.mrtv4.com.mm/files/toptensongs/11825/2.%20Pink%20-%20Just%20Give%20Me%20A%20Reason.mp3",
        "http://ed101.bu.edu/StudentDoc/Archives/spring04/jgc/sounds/songs/classical music - mozart - marriage of figaro.mp3"
        ];
// You can use or http://bit.ly or http://tinyurl.com URL's to save room , as the total length must be < 1024
        play(llDumpList2String(playlist,","));
    }
}

