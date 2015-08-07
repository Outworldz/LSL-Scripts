// :CATEGORY:Viewer 2
// :NAME:SVG__Beyond_124_characters
// :AUTHOR:herina Bode
// :CREATED:2010-09-02 12:05:22.880
// :EDITED:2013-09-18 15:39:05
// :ID:852
// :NUM:1182
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// SVG__Beyond_124_characters
// :CODE:
string url; // Our base http-in url

//string svg1 = "<svg xmlns=\"http://www.w3.org/2000/svg\" version=\"1.1\" width=\"500\" height=\"300\"><title>Exemple simple de figure SVG</title><desc>Cette figure est constitu\xE9e d'un rectangle, d'un segment de droite et d'un cercle.</desc><rect width=\"100\" height=\"80\"  x=\"0\" y=\"70\" fill=\"green\" /><line x1=\"5\" y1=\"5\" x2=\"250\" y2=\"95\" stroke=\"red\" /><circle cx=\"90\" cy=\"80\" r=\"50\" fill=\"blue\" /><text x=\"300\" y=\"60\">Shared medias SVG</text></svg>";

//string svg1 = "<rect width=\"100\" height=\"80\"  x=\"0\" y=\"70\" fill=\"green\" /><line x1=\"5\" y1=\"5\" x2=\"250\" y2=\"95\" stroke=\"red\" /><circle cx=\"90\" cy=\"80\" r=\"50\" fill=\"blue\" /><text x=\"300\" y=\"60\">Shared medias SVG</text>";

string svg2 = "<svg version=\"1.1\" baseProfile=\"full\" xmlns=\"http://www.w3.org/2000/svg\"><rect width=\"100%\" height=\"100%\" fill=\"white\" /><rect x=\"30\" y=\"50\" width=\"240\" height=\"100\" fill=\"red\" /><circle cx=\"150\" cy=\"100\" r=\"80\" fill=\"red\" /><text x=\"150\" y=\"125\" font-size=\"60\" text-anchor=\"middle\" fill=\"white\">SVG</text></svg>";

//string svg3 = "<svg xmlns=\"http://www.w3.org/2000/svg\" version=\"1.1\" viewBox=\"0 0 100 100\" preserveAspectRatio=\"xMidYMid slice\" style=\"width:100%; height:100%; position:absolute; top:0; left:0; z-index:-1;\"><linearGradient id=\"gradient\"><stop class=\"begin\" offset=\"0%\"/><stop class=\"end\" offset=\"100%\"/></linearGradient><rect x=\"0\" y=\"0\" width=\"100\" height=\"100\" style=\"fill:url(#gradient)\" /><circle cx=\"50\" cy=\"50\" r=\"30\" style=\"fill:url(#gradient)\" /></svg>";

show(string html)
{
    llSetPrimMediaParams(0,                  // Side to display the media on.
            [PRIM_MEDIA_AUTO_PLAY,TRUE,      // Show this page immediately
             PRIM_MEDIA_CURRENT_URL,html,    // The url if they hit 'home'
             PRIM_MEDIA_HOME_URL,html,       // The url currently showing
             PRIM_MEDIA_HEIGHT_PIXELS,512,   // Height/width of media texture will be
             PRIM_MEDIA_WIDTH_PIXELS,512]);  //   rounded up to nearest power of 2.
}

string httpRequest(string url, string type, string elementID)
{
    //string content = "function httpRequest(IDRequest){";
    //content += "var Script=document.createElement('script');";
    //content += "Script.src='" + url + "httpRequest?' + IDRequest;";
    //content += "document.body.appendChild(Script);}";
    //return content;
    string content = "";
    content += "function ajaxHandler() {";
    content += "var xhr=null; ";
    content += "if (window.XMLHttpRequest) xhr = new XMLHttpRequest();";
    content += "else {httpResponse('texte','No XMLHttpRequest', 'blue'); return;}";
    content += "if (xhr!=null){";
    content += "xhr.onreadystatechange = function() { ";
    content += "if(xhr.readyState  == 4) { if(xhr.status == 200)"; 
    content += "httpResponse('texte', xhr.responseText, 'blue');";
    content += "else httpResponse('texte', 'xhr.readyState: ' + xhr.readyState + ' xhr.status: ' + xhr.status, 'blue');}};";
    content += "xhr.open('GET', '" + url + type + "', true);";
    content += "xhr.send();";
    content += "}}";
    return content;
}

string httpResponse()
{
    string content = "function httpResponse(id,sText,color)
    {
        var objet = document.getElementById(id);
        //var objet = svgdoc.getElementById(id);
        var child = objet.firstChild; 
        child.data = sText;
        objet.setAttributeNS(null ,'fill', color);
    }";
    return content;
}

string build_url(string url)
{
    return "data:image/svg+xml," + llEscapeURL("<svg xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" width=\"512\" height=\"512\" onload='init(evt)'><script xlink:href='" + url + "' type='text/javascript'></script></svg>");

}

string build_response(string body)
{ 
    string str = "";
    str += "var svgdoc;";
    str += "function init(evt){
        ns_svg = 'http://www.w3.org/2000/svg';
        svgdoc = evt.target.ownerDocument;
        
        // create a g tag
        node=svgdoc.createElementNS(ns_svg , 'g');
        node.setAttributeNS(null , 'id' , 'node1');
        node.addEventListener('mousemove', move, false);
        node.addEventListener('mousedown', cliquer, false);
        node.addEventListener('mouseup', upmouse, false);
        ou=evt.target;
        ou.appendChild(node);

        // Create a rectangle in the tag g , id = node1
        node=svgdoc.createElementNS(ns_svg ,'rect');
        //node.setAttributeNS(null , 'id' , 'rectle');
        //node.setAttributeNS(null , 'transform', 'matrix(1 0 0 1 50 50)');
        node.setAttributeNS(null ,'x','0');node.setAttributeNS(null ,'y','0');
        node.setAttributeNS(null ,'width','500');node.setAttributeNS(null ,'height','400');
        node.setAttributeNS(null ,'fill','#EEEEEE');
        node.setAttributeNS(null ,'stroke','#0E0E0E');
        //node.addEventListener('click' , change_grect, false);
        ou=svgdoc.getElementById('node1');
        ou.appendChild(node);

        // Create a circle in the tag g , id = node1 
        node=svgdoc.createElementNS(ns_svg ,'ellipse');
        node.setAttributeNS(null , 'id' , 'cercle');
        node.setAttributeNS(null , 'transform', 'matrix(1 0 0 1 300 200)');
        node.setAttributeNS(null ,'cx','0');node.setAttributeNS(null ,'cy','0');
        node.setAttributeNS(null ,'rx','50');node.setAttributeNS(null ,'ry','50');
        node.setAttributeNS(null ,'fill','red');
        node.setAttributeNS(null ,'stroke','#0E0E0E');
        node.addEventListener('click' , change_circle, false);
        ou=svgdoc.getElementById('node1');
        ou.appendChild(node);
        
        // Create a rectangle in the tag g , id = node1
        node=svgdoc.createElementNS(ns_svg ,'rect');
        node.setAttributeNS(null , 'id' , 'rectangle');
        node.setAttributeNS(null , 'transform', 'matrix(1 0 0 1 50 50)');
        node.setAttributeNS(null ,'x','50');node.setAttributeNS(null ,'y','100');
        node.setAttributeNS(null ,'width','100');node.setAttributeNS(null ,'height','50');
        node.setAttributeNS(null ,'stroke','#0E0E0E');
        node.setAttributeNS(null ,'fill','green');
        node.addEventListener('click' , change_grect, false);
        ou=svgdoc.getElementById('node1');
        ou.appendChild(node);
        
        // Create a rectangle for ajax handler in the tag g , id = node1
        node=svgdoc.createElementNS(ns_svg ,'rect');
        node.setAttributeNS(null , 'id' , 'clickrectangle');
        node.setAttributeNS(null ,'x','300'); node.setAttributeNS(null ,'y','300');
        node.setAttributeNS(null ,'width','100');node.setAttributeNS(null ,'height','50');
        node.setAttributeNS(null ,'stroke','#0E0E0E');
        node.setAttributeNS(null ,'fill','grey');
        node.addEventListener('click' , ajax_call, false);
        ou=svgdoc.getElementById('node1');
        ou.appendChild(node);
        
        // Create a text area in the tag g , id = node1 
        node=svgdoc.createElementNS(ns_svg ,'text');
        node.setAttributeNS(null, 'id' , 'texte1');
        node.setAttributeNS(null, 'x','350');node.setAttributeNS(null ,'y','335');
        node.setAttributeNS(null, 'text-anchor','middle');
        node.setAttributeNS(null, 'font-size','25');
        node.setAttributeNS(null, 'font-family','Arial');
        node.setAttributeNS(null, 'fill','black');
        node.setAttributeNS(null ,'stroke','#FFFFFF');
        node.addEventListener('click' , ajax_call, false);
        var texte1=svgdoc.createTextNode('Ajax call');
        node.appendChild(texte1);
        ou=svgdoc.getElementById('node1');
        ou.appendChild(node);
        
        // Create a rectangle in the tag g , id = node1
        node=svgdoc.createElementNS(ns_svg ,'rect');
        node.setAttributeNS(null, 'id', 'rectangle1');
        node.setAttributeNS(null, 'transform', 'matrix(1 0 0 1 50 50)');
        node.setAttributeNS(null, 'x','50');node.setAttributeNS(null,'y','200');
        node.setAttributeNS(null, 'width','100');node.setAttributeNS(null,'height','50');
        node.setAttributeNS(null ,'stroke','#0E0E0E');
        node.setAttributeNS(null, 'fill','blue');
        node.addEventListener('click', change_brect, false);
        ou=svgdoc.getElementById('node1');
        ou.appendChild(node);
        
        
        // Create a text area in the tag g , id = node1 
        node=svgdoc.createElementNS(ns_svg ,'text');
        node.setAttributeNS(null, 'id' , 'texte');
        node.setAttributeNS(null, 'x','200');node.setAttributeNS(null ,'y','50');
        node.setAttributeNS(null, 'text-anchor','middle');
        node.setAttributeNS(null, 'font-size','25');
        node.setAttributeNS(null, 'font-family','Arial');
        node.setAttributeNS(null, 'fill','red');
        node.setAttributeNS(null ,'stroke','#0E0E0E');
        var texte=svgdoc.createTextNode('Clic and move objects');
        node.appendChild(texte);
        ou=svgdoc.getElementById('node1');
        ou.appendChild(node);
        
        // import a svg document (does not work for now)
        node=svgdoc.createElementNS(ns_svg , 'g');
        node.setAttributeNS(null , 'id' , 'tag_g1');
        ou=evt.target;
        ou.appendChild(node);
        node=svgdoc.createElementNS(ns_svg ,'svg:svg');
        node.setAttribute('type', 'image/svg+xml');
        node.setAttribute('data', 'data:image/svg+xml, "+ body +"');
        node.setAttributeNS(null ,'x','50');node.setAttributeNS(null ,'y','350');
        node.setAttributeNS(null ,'width','100');node.setAttributeNS(null ,'height','50');
        ou=svgdoc.getElementById('tag_g1');
        ou.appendChild(node);
        }";
        
    str += "function ajax_call(evt){ajaxHandler();}";
    
    str += "function change_brect(evt){httpResponse('texte','You clicked blue rectangle', 'blue');}";
    str += "function change_grect(evt){httpResponse('texte','You clicked green rectangle', 'green');}";
    str += "function change_circle(evt){httpResponse('texte','You clicked circle', 'red');}";
    str += httpRequest(url, "SVG_GET", "dummy");
    str += httpResponse();
    str += "var appui=false , cible='' , xd2=0 , yd2=0 , xd1=0 , yd1=0 , coeffs = new Array();";
    str += "function upmouse(evt) {appui = false;}";
    str += "function move(evt){
            if (!appui) return;
            var xm = evt.clientX;
            var ym = evt.clientY;
            if ((xm<=5)||(xm>=495)||(ym<=5)||(ym>=395)) {appui=false; return;}
            if ((cible != 'rectangle') && (cible != 'rectangle1') &&(cible != 'cercle')) return;
            svgdoc = evt.target.ownerDocument;  
            coeffs[4] = xm + xd1 - xd2;
            coeffs[5] = ym + yd1 - yd2; 
            if (cible=='rectangle' || cible=='rectangle1'){
                if (coeffs[4] < 0)   coeffs[4] = 0;
                if (coeffs[4] > 400) coeffs[4] = 400;
                if (coeffs[5] < 0)   coeffs[5] = 0;
                if (coeffs[5] > 350) coeffs[5] = 350;};
            if (cible=='cercle'){
                if (coeffs[4] < 50)  coeffs[4] = 50;
                if (coeffs[4] > 450) coeffs[4] = 450;
                if (coeffs[5] < 50)  coeffs[5] = 50;
                if (coeffs[5] > 350) coeffs[5] = 350;} 
            var chaine = 'matrix(' + coeffs.join(' ') + ')';
            svgdoc.getElementById(cible).setAttributeNS(null , 'transform' , chaine)}";

    str += "function cliquer(evt){
        cible=evt.target.getAttributeNS(null , 'id');
        if ((cible=='rectangle')|| (cible=='rectangle1')||(cible=='cercle')){
            appui=true;
            xd2 = evt.clientX;
            yd2 = evt.clientY;
            var transfo = evt.target.getAttributeNS(null , 'transform')
            transfo = transfo.substring(7 , transfo.length - 1)
            if (transfo.indexOf(',') > 0) coeffs = transfo.split(',')
            else coeffs = transfo.split(' ')
            xd1 = parseInt(coeffs[4]);
            yd1 = parseInt(coeffs[5]);}}";
    return str;
}


string BuildBody()
{
    
    string content = "";
    content += svg2;
    return content;
}

default
{
    state_entry()
    {
        llRequestURL();
    }

    http_request(key id, string method, string body)
    {
        if (method == URL_REQUEST_GRANTED)
        {
            url = body + "/";
            show(build_url(url));
        }
        else if (method == "GET")
        {
            string path = llGetHTTPHeader(id,"x-path-info");
            if (path == "/SVG_GET")
            {
                llOwnerSay ("One day... it will work!!!!!!");
                llHTTPResponse(id, 200, "reponse");
            }
            else
            {
                string content = BuildBody();
                llHTTPResponse(id, 200, build_response(content));
            }
        }
        
    }
}
