// :CATEGORY:Viewer 2
// :NAME:Selfserved_HTML_and_JavaScript
// :AUTHOR:Becky Pippen
// :CREATED:2010-09-02 11:15:26.630
// :EDITED:2013-09-18 15:39:02
// :ID:736
// :NUM:1004
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Example #1  using script src= and .innerHTML= // // When you can't fit all the JavaScript into one data URI, just move the JavaScript into an external file and reference the file with script src=URL . When the URL refers to the script's own HTTP-in URL, then the page served can contain up to 2K bytes, so you get at least that many bytes plus whatever logic you can fit into the rest of the data URI. If you move that JavaScript to an external web server, the size of the external JavaScript file can be as large as the client web browser can render.// //     * Your script can serve an arbitrary number of different pages through one HTTP-in URL by appending a path or parameter to the URL.// 
//     * This works by assigning a string containing HTML to the innerHTML contents of the div element with id "clock". This achieves something similar to the Ajax-like technique published by Tali Rosca and mentioned here. In those techniques, a string is constructed containing an href= tag and an href= that points to the script's HTTP-in URL. That string then replaces the body element using: 
// 
// document.getElementsByTagName('body')[0].innerHTML = new-content
// :CODE:
integer face = 4;
string myURL;

// This can be up to 2KBytes after %-hex-escaping:
string servedPage = "
function checklength(i){if (i<10) {i='0'+i;} return i;}      
function clock(){ 
 var now = new Date();  
 var hours = checklength(now.getHours());  
 var minutes = checklength(now.getMinutes());  
 var seconds = checklength(now.getSeconds());  
 var format = 1; //0=24 hour format, 1=12 hour format   
 var time;  
 if (format == 1) { 
  if (hours >= 12) {  
   if (hours ==12 ) { hours = 12;
   } else { hours = hours-12; } 
   time=hours+':'+minutes+':'+seconds+' PM';   
  } else if(hours < 12) { 
   if (hours ==0) {hours=12;}   
   time=hours+':'+minutes+':'+seconds+' AM';   
  }   
 }  
 if (format == 0) {time= hours+':'+minutes+':'+seconds;}   
 document.getElementById('clock').innerHTML=time;
 setTimeout('clock();', 500); 
} "; // yes, that's one long string.

displayPage()
{
    string dataURI = "data:text/html,<script src='" +
        myURL + "'></script>" +
        "<div id='clock'><script>clock();</script></div>";
    llSetPrimMediaParams(face, [PRIM_MEDIA_CURRENT_URL, dataURI]);
}

default
{
    state_entry()
    {
        llRequestURL();
    }

    http_request(key id, string method, string body)
    {
        if (method == URL_REQUEST_GRANTED) {
            myURL = body;
            displayPage();
        } else if (method == "GET") {
            llHTTPResponse(id, 200, servedPage);
        }
    }
} 
