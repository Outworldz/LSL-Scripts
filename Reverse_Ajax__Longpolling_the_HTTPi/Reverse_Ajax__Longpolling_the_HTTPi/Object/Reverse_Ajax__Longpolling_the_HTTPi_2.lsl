// :CATEGORY:Viewer 2
// :NAME:Reverse_Ajax__Longpolling_the_HTTPi
// :AUTHOR:Becky Pippen
// :CREATED:2010-09-02 11:18:14.347
// :EDITED:2013-09-18 15:39:01
// :ID:700
// :NUM:956
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Here's an expanded listing for reference with more descriptive names:
// :CODE:
<!DOCTYPE HTML>
<html>
  <body>
    <div>
      <script id='script'> </script>
    </div>
    <script>
      var poll=function(){
        var script=document.getElementById('script'),
        timeoutId,
        seq=0,
        newScript;
        return {
          beg:function() {                                      // Initiate a long-poll GET
            newScript=document.createElement('script');        // The response will go here
            newScript.onload=poll.end;                         // Call poll.end() when we get a response
            timeoutId=setTimeout('poll.end()',20000);          // ... or if we time out
            newScript.src=' HTTP-in URL goes here /?r='+(seq++);
            script.parentNode.replaceChild(newScript,script);  // this triggers the GET
            script=newScript;},

          end:function() {
            clearTimeout(timeoutId);
            timeoutId=null;
            script.onload=null;
            setTimeout('poll.beg()',500);                      // Wait a bit before re-polling
          },
        };
      }();
    </script>
    <button id='btn'onclick=poll.beg()>Start<button>
    <div id='dv'> </div>
  </body>
</html>
