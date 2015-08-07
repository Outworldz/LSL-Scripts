// :CATEGORY:Viewer 2
// :NAME:llSetPrimMediaParams_for_data_urls
// :AUTHOR:Kelly Linden
// :CREATED:2010-09-02 10:56:33.190
// :EDITED:2013-09-18 15:38:56
// :ID:487
// :NUM:654
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Paste the below into your browser's address bar.// // data:text/html,<h1>This is a test</h1><h2>This is a test</h2><h3>This is a test</h3>// // llSetPrimMediaParams for data: urls// 
//     * Thus you can build arbitrary html in your LSL script and display it on the face of the prim 
// :CODE:
show(string html)
{
    html = "data:text/html," + llEscapeURL(html);
    llSetPrimMediaParams(0,                  // Side to display the media on.
            [PRIM_MEDIA_AUTO_PLAY,TRUE,      // Show this page immediately
             PRIM_MEDIA_CURRENT_URL,html,    // The url currently showing
             PRIM_MEDIA_HOME_URL,html,       // The url if they hit 'home'
             PRIM_MEDIA_HEIGHT_PIXELS,512,   // Height/width of media texture will be
             PRIM_MEDIA_WIDTH_PIXELS,512]);  //   rounded up to nearest power of 2.
}
default
{
    state_entry()
    {
        show("<h1>This is a test</h1><h2>This is a test</h2><h3>This is a test</h3>");
    }
}
