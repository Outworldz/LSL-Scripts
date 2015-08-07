// :CATEGORY:Viewer 2
// :NAME:Google_Chart_demo
// :AUTHOR:Pavcules Superior
// :CREATED:2010-09-02 12:02:52.270
// :EDITED:2013-09-18 15:38:54
// :ID:362
// :NUM:495
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Google_Chart_demo
// :CODE:
show(string html)
{
 
    llOwnerSay(html);
 
    llSetPrimMediaParams(0,                  // Side to display the media on.
            [PRIM_MEDIA_AUTO_PLAY,TRUE,      // Show this page immediately
             PRIM_MEDIA_CURRENT_URL,html,    // The url if they hit 'home'
             PRIM_MEDIA_HOME_URL,html,       // The url currently showing
             PRIM_MEDIA_HEIGHT_PIXELS,512,   // Height/width of media texture will be
             PRIM_MEDIA_WIDTH_PIXELS,512]);  //   rounded up to nearest power of 2.
}
 
// This creates a data: url that will render the output of the http-in url 
// given.
string build_url()
{
    return "data:text/html, 
<html>
<head>
<script type=\"text/javascript\">
    
function makeRequest()
{
    var oChart = document.getElementById('chart');
    var v2 = 100 - document.getElementById('d1').value;
    
    oChart.src = 'http://chart.apis.google.com/chart?chs=500x200&chd=t:' + document.getElementById('d1').value + ',' + v2 + '&cht=p3&chl=Hello|World\';
    //document.body.appendChild(oScript);  
}


</script>
</head>
<body>
Value:<input id=\"d1\" type=\"text\" />
<input type=\"button\" value=\"Click Me\" onclick=\"makeRequest()\" />
<img id=\"chart\" />
</body>
</html>";
}

 
default
{
    state_entry()
    {
        show(build_url());
    }
 
}
