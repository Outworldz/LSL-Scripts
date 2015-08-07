// :CATEGORY:Music
// :NAME:MOAP
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:57
// :ID:518
// :NUM:702
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Music on a prim
// :CODE:

// 09/2/2012  v2 auto pop face

// Which side of the prim to show the player.   for cubes,could be 0 to 5
integer side = 0;

// the URL to play. This one will play any file with 'Alien; in the name, once
string url = "http://www.outworldz.com/cgi/mp4.plx?ID=https://sites.google.com/site/phazedemesnes/mp3&Loop=yes";

// do not modify below this point

list rules = [
    PRIM_MEDIA_AUTO_PLAY ,1,
    PRIM_MEDIA_PERMS_INTERACT, PRIM_MEDIA_PERM_NONE,
    PRIM_MEDIA_PERMS_CONTROL,PRIM_MEDIA_PERM_OWNER,
    PRIM_MEDIA_CONTROLS, PRIM_MEDIA_CONTROLS_MINI,
    PRIM_MEDIA_AUTO_SCALE, FALSE,
    //PRIM_MEDIA_WIDTH_PIXELS , 800,
    //PRIM_MEDIA_HEIGHT_PIXELS , 600,
    PRIM_MEDIA_CURRENT_URL ];


default
{
    state_entry()
    {
        list web_rules = rules + url;
        llSetPrimMediaParams(side,web_rules);
    }
    
    on_rez(integer p)
    {
        llResetScript();
    }
}

