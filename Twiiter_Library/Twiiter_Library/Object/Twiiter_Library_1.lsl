// :CATEGORY:Twitter
// :NAME:Twiiter_Library
// :AUTHOR:Babbage Linden
// :CREATED:2011-01-01 18:22:11.100
// :EDITED:2013-09-18 15:39:08
// :ID:926
// :NUM:1330
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Using the Twitter OAuth Library// // The Twitter OAuth Library allows scripted objects in Second Life to update the Twitter status streams of residents in Second Life interacting with the objects. A dance machine might send an update saying that a resident is dancing at at a particular location in Second Life, a vendor might send an update saying that a resident has bought a particular item, an arena might say that a resident has won or lost a game. These status updates can be seen by the resident's followers on Twitter and can include SLURLs back in to Second Life, allowing followers on Twitter to jump in to Second Life, whether they are a resident or not.// By using OAuth, the Twitter OAuth Library avoids the need for residents to share their Twitter username and password with anyone other than twitter.com (the password anti-pattern) and gives them fine grained control over which Second Life objects are able to send updates to twitter. The Twitter OAuth Library also uses the HTTP-In and HTTP-Out facilities to communicate directly with Twitter, avoiding the need to use a web server to intermediate communication between Second Life and Twitter. If you have an object in Second Life, you can use theTwitter OAuth library to make it send updates to Twitter. A video of the Twitter OAuth Library in use is here: http://www.youtube.com/watch?v=_19cl8qOZKA
// 
// The Twitter OAuth Library is designed to be easy to integrate with existing Second Life objects even for those with little scripting experience. To add Twitter integration to your Second Life object, follow these instructions:
// Setting Up Your Twitter Application
// 
//    1. Set up a Twitter account and log in to Twitter.
   2. Go to http://twitter.com/oauth_clients
//    3. Click the Register a new application link.
//    4. Set Default access type to "Read & Write".
//    5. Set Application Type to "Browser".
   6. Set callback URL to http://example.com/we-use-dynamic-urls/
//    7. Leave use Twitter for login unchecked.
//    8. Make sure you fill the rest of the form in or you application may not work.
//    9. Once you have successfully registered your application, Twitter will take you to the Application Details page for your new application. 
// 
// Setting Up The Twitter OAuth Library
// 
//    1. Get a copy of the Twitter OAuth Library from Ambleside or Xstreet.
//    2. Drag the Twitter OAuth Library in from your inventory on to your land.
//    3. Right click on the Twitter OAuth Library, edit it and click on the Content tab.
//    4. Drag the scripts from the Twitter OAuth Library box to your inventory.
//    5. Rez your second life object in world.
//    6. Right click on your object edit it and click on on the Content tab.
//    7. Drag the Twitter OAuth scripts from your inventory in to your second life object.
//    8. Double click on the TwitterOAuthClient script to edit it.
//    9. Replace YOUR CONSUMER KEY HERE with the Consumer key from your Twitter Application Details page.
//   10. Replace YOUR CONSUMER SECRET HERE with the Consumer secret from your Twitter Application Details page.
//   11. Replace I did something amazing in Second Life here with the message you would like to send from your Second Life object.
//   12. Click the save button, close the script editor and close the edit floater. 
// 
// Testing The Twitter OAuth Library
// 
//    1. Touch your second life object to test your Twitter application settings.
//    2. A popup should appear asking you to "Authorise Twitter access", click the "Go to page button".
//    3. You should be directed back to a page on Twitter saying "An application would like to connect to your account".
//    4. Fill in your Twitter user name and password if your are not already signed in to Twitter (note these details only go to twitter.com) then click the green "Allow" button.
//    5. Check your Twitter stream now contains the message you wanted to send followed by a SLURL from your twitter application.
//    6. Once you have authorized the application to use Twitter, touching the box again will send a new update to Twitter (but be aware, multiple identical status updates will not appear).
//    7. If the test fails at any point, touch the Twitter OAuth Library box again to retry. 
// 
// Next Steps
// 
Rather than sending updates to Twitter every time your object is touched, you will probably want to send updates when other interactions take place. To do this, just copy the first part of TwitterOAuthClient script up to "// STOP COPYING HERE" to the top of your script, then call TwitterOAuthInit when your script is initialized in state_entry and on_rez and TwitterOAuthUpdateStatus whenever you want your script to send an update to Twitter. Note that you should always ask a resident whether it's OK to post an update to Twitter before calling TwitterOAuthUpdateStatus. Although the Twitter OAuth library is designed to talk to Twitter out of the box, it is a fully compliant OAuth 1.0a consumer library and so can be easily modified to talk to any web service that supports OAuth integration.
// Twitter OAuth Example Client
// :CODE:
//////////////////////////////////////////////////////////////////////////////////////
//
//    Twitter OAuth Client 1.0: An example client that uses the LSL OAuth 1.0a 
//    Library for Twitter by Babbage Linden. 
//
//    Released under the Creative Commons Creative Commons Attribution-Share Alike 3.0 
//    license http://creativecommons.org/licenses/by-sa/3.0/
//    
//////////////////////////////////////////////////////////////////////////////////////
 
// Application constants generated by Twitter.
// Set up a new Twitter application here: http://twitter.com/oauth_clients
string TWITTER_OAUTH_CONSUMER_KEY = "YOUR CONSUMER KEY HERE";
string TWITTER_OAUTH_CONSUMER_SECRET = "YOUR CONSUMER SECRET HERE";
 
// Message constants defined by Twitter OAuth library.
integer TWITTER_OAUTH_SET_CONSUMER_KEY = 999000;
integer TWITTER_OAUTH_SET_CONSUMER_SECRET = 999001;
integer TWITTER_OAUTH_SET_MAX_RETRIES = 999002;
integer TWITTER_OAUTH_UPDATE_STATUS = 999003;
 
TwitterOAuthInit()
{
    // Set up Twitter OAuth library, using application consumer key and secret generated by Twitter.
    llMessageLinked(LINK_THIS, TWITTER_OAUTH_SET_CONSUMER_KEY, TWITTER_OAUTH_CONSUMER_KEY, NULL_KEY);
    llMessageLinked(LINK_THIS, TWITTER_OAUTH_SET_CONSUMER_SECRET, TWITTER_OAUTH_CONSUMER_SECRET, NULL_KEY);
    llMessageLinked(LINK_THIS, TWITTER_OAUTH_SET_MAX_RETRIES, "10", NULL_KEY);
}
 
string TwitterOAuthGetSLURL()
{
    string globe = "http://maps.secondlife.com/secondlife";
    string region = llGetRegionName();
    vector pos = llGetPos();
    string posx = (string) llRound(pos.x);
    string posy = (string) llRound(pos.y);
    string posz = (string) llRound(pos.z);
    return globe + "/" + llEscapeURL(region) +"/" + posx + "/" + posy + "/" + posz;
}
 
string TwitterOAuthBuildMessage()
{
    // Example message, change this as appropriate.
    return "I did something amazing in Second Life here " + TwitterOAuthGetSLURL() + " #inSL";
}
 
TwitterOAuthUpdateStatus(string message, key avatar)
{
    llMessageLinked(LINK_THIS, TWITTER_OAUTH_UPDATE_STATUS, message, avatar);
}
 
// STOP COPYING HERE
 
default
{
    state_entry()
    {
        TwitterOAuthInit();
    }
 
    on_rez(integer param)
    {
        TwitterOAuthInit();
    }
 
    touch_start(integer total_number)
    {
        TwitterOAuthUpdateStatus(TwitterOAuthBuildMessage(), llDetectedKey(0));   
    }
}
