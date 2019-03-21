// :CATEGORY:Water
// :NAME:Flash_Water__cool_effect_for_Viewer
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2010-06-18 22:25:45.157
// :EDITED:2013-09-18 15:38:53
// :ID:315
// :NUM:423
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Just drop this into any prim and then click it.  It requires the media be enabled in viewer 2.0.  
// :CODE:
play()
{
    string html = "
<html>
<head>
<object width=\"2048\" height=\"2048\"  type=\"application/x-shockwave-flash\" data=\"http://flash-effects.com/swf/water_ripple_follow.swf\" id=\"sb-content\" style=\"visibility: visible;\"><param name=\"bgcolor\" value=\"#000000\"><param name=\"allowFullScreen\" value=\"true\"></object></body>
</html>";
        
   // html = "data:text/html," + llEscapeURL(html); // you may need to escape funny chars
   html = "data:text/html," + html; // or not, this depends upon your URL's
   llSetPrimMediaParams(0,                 // Side to display the media on.
            [PRIM_MEDIA_PERMS_CONTROL , PRIM_MEDIA_PERM_NONE,
            PRIM_MEDIA_PERMS_INTERACT, PRIM_MEDIA_PERM_ANYONE,
        
            PRIM_MEDIA_AUTO_PLAY,TRUE,      // Show this page immediately
             PRIM_MEDIA_CURRENT_URL,html,    // The url currently showing
             PRIM_MEDIA_HOME_URL,html,       // The url if they hit 'home'
             PRIM_MEDIA_HEIGHT_PIXELS,2048 ,  // Height/width of media texture will be
             PRIM_MEDIA_WIDTH_PIXELS,2048  // rounded up to nearest power of 2.
             
            ]);  

}

default
{
    state_entry()
    {
                play();
    }
    
    on_rez(integer p)
    {
        llResetScript();
    }
}
