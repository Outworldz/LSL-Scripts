// :CATEGORY:Music
// :NAME:HUD_Music_player_with_trigger
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2012-10-09 15:42:19.730
// :EDITED:2013-09-18 15:38:55
// :ID:394
// :NUM:547
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// The Sensor Script - put this script and your 10 second wav file clips into a prim.  Anyone approaching this prim will trigger the music to play for just that avatar./ The avatar must wear a headset or HUD prim with the player script.
// :CODE:
// general purpose avatar sensor for the music playert
// When someone gets in range, this starts the music sequence
// if used in HUD mode, only the avatar wearing the HUD and also in range of some location can hear the sounds/music.
// When used in PRIM mode, anyone standing near will trigger the sound.

// 10-09-2012 by Fred Beckhusen (Ferd Frederix)

// This work is licensed under a Creative Commons Attribution-NonCommercial 3.0 Unported License.
// http://creativecommons.org/licenses/by-nc/3.0/deed.en_US
// This script cannot be sold even as part of another object, it must always remain free and fully modifiable.



// Tuneable thing:
float range = 5.0;     // how far a avatar has to be before sound plays, in meters
float howoften = 5.0;  // how often we look for avatars.  Average time before it detects is half this.
// The longer you make this, the less lag it causes.

// for a HUD, put the player in the HUD and put the sensor somewhere in-world to trigger the HUD

// best to leave these bits alone
integer secret_channel = 9876;    // just a magic number
list playingKeys;        // a list of all avatars that have been controlled
list sensedKeys;         // a list of avatars within range.
integer debugflag = FALSE;    // set to true to see it as it works

DEBUG (string msg)
{
    if (debugflag) llOwnerSay(msg);
}

// send a list of UUIDs to a player
Send(key id)
{
    integer i;
    integer j = llGetInventoryNumber(INVENTORY_SOUND);
    llSay(secret_channel,(string) id + "^" + "stop" + "^" );
    for (i = 0; i < j; i++) {
        string name = llGetInventoryName(INVENTORY_SOUND,i);
        key soundKey = llGetInventoryKey(name);    // get key of named sound
        llSay(secret_channel,(string) id + "^" + "queue" + "^" + (string) soundKey + "^" + name + "^");
    }
    llSay(secret_channel,(string) id + "^" + "play" + "^" );
}

default
{
    state_entry()
    {
        llSensorRepeat("","",AGENT,range, PI, howoften);
    }

    sensor(integer total_number)
    {

        integer i;
        sensedKeys = [];
        for (i = 0; i < total_number; i++)
        {
            key id = llDetectedKey(i); // get every avatars key that is near us
            if (llListFindList(playingKeys,[id]) == -1)        // if not in the list of HUD's that are playing ...
            {
                playingKeys += id;    // add them to the playing list
                Send(id);
            }
            sensedKeys += id; // add them to the current list of nearby listeners
        }

        // now check to see if anyone has left the vicinity and issue a stop command to them
        i = 0;
        while (i < llGetListLength(playingKeys))
        {
            DEBUG("i=" + (string) i);
            key id = llList2Key(playingKeys,i);
            if (llListFindList(sensedKeys,[id]) == -1)  // if not in sensed, stop them
            {
                llSay(secret_channel,(string) id + "^" + "stop");
                playingKeys = llDeleteSubList(playingKeys,i,i);    // remove this person, no longer playing
            } else {
                    DEBUG((string) id + " is nearby");
                i++;    // look at next person, as this one was still nearby
            }
        }
    }

    no_sensor()
    {
        integer i;
        integer j = llGetListLength(playingKeys);
        for (i = 0; i < j; i++)
        {
            key id = llList2Key(playingKeys,i);
            llShout(secret_channel,(string) id + "^" + "stop");
        }
        playingKeys = [];

    }

    on_rez(integer p)
    {
        llResetScript();
    }
}
