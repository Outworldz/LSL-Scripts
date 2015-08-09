// :CATEGORY:Owner Key
// :NAME:Name2Key
// :AUTHOR:Takat Su
// :CREATED:2011-10-16 19:28:26.180
// :EDITED:2013-09-18 15:38:58
// :ID:551
// :NUM:750
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Google App Python Code - not needed unless you want to make your own app engine
// :CODE:
rom google.appengine.ext import webapp
from google.appengine.ext.webapp.util import run_wsgi_app
import urllib, urlparse
 
kURL = 'http://vwrsearch.secondlife.com/client_search.php?session=00000000-0000-0000-0000-000000000000&q='
kProfile = "Resident profile"
kResult = "secondlife:///app/agent/"
 
class MainPage( webapp.RequestHandler ):
    def get(self):
        inName = self.request.get("name").upper()
        name = inName.replace(" ", "%20")
        data = urllib.urlopen(kURL + name).read()
        start = data.index( kProfile )
        foundName = data[start+18:start+18+len(inName)]
	key = '00000000-0000-0000-0000-000000000000'
        if foundName.upper() == inName:
            start = data.index( kResult )
            key = data[start+len(kResult):start+len(kResult)+36]
        else:
            foundName =	inName
 
        self.response.out.write("%s:%s" % (foundName, key))
 
 
application = webapp.WSGIApplication(
    [('/', MainPage)],
    debug = True)
 
def main():
    run_wsgi_app(application)
 
if __name__ == "__main__":
    main()
