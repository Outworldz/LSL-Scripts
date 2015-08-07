// :CATEGORY:Viewer 2
// :NAME:llSetPrimMediaParams
// :AUTHOR:Kelly Linden
// :CREATED:2010-09-02 10:55:12.380
// :EDITED:2013-09-18 15:38:56
// :ID:486
// :NUM:653
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// llSetPrimMediaParams
// :CODE:
 
default
{
    state_entry()
    {
        llSetPrimMediaParams(0,                             // Side to display the media on.
            [PRIM_MEDIA_AUTO_PLAY,TRUE,                     // Show this page immediately
             PRIM_MEDIA_CURRENT_URL,"http://google.com",    // The url currently showing
             PRIM_MEDIA_HOME_URL,"http://google.com",       // The url if they hit 'home'
             PRIM_MEDIA_HEIGHT_PIXELS,512,                  // Height/width of media texture will be
             PRIM_MEDIA_WIDTH_PIXELS,512]);                 //   rounded up to nearest power of 2.
    }
}
