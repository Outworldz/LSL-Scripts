// :CATEGORY:Spy
// :NAME:Mission_Spy
// :AUTHOR:Sparti Carroll
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:57
// :ID:514
// :NUM:698
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Some instructions for use
// :CODE:


Mission Spy 1.1

>> Supported Product <<
>> If you require any help or have feature requests or bug reports for Mission Spy please IM me <<

Please read through these instructions first in case your question is answered here, thank you !


Mission Spy has two roles:
1. It can report on visitors to an area, with a configurable range.
2. It can report conversations in an area.


PLEASE NOTE that misuse of either of these services could constitue contravention
of the terms of the Second Life SLA.  It is suggested that the Mission Spy is only
used in Combat Zones, or otherwise with the consent of those in the area - e.g. for
relaying conversations.


Mission Spy is discreet, you will hardly notice it's 0.01 x 0.01 x 0.01 full alpha sphere.

Mission Spy can be configured by chatting or shouting on a command channel, 55 by default, but this is configurable.  It only pays attention to the owner on the command channel.

All reporting to the owner is via llOwnerSay or llInstantMessage.  Instant message may not be suitable for heavy conversation areas and llOwnerSay is the default.


GETTING STARTED
1. Rez the Mission Spy Box on the ground
2. Touch the box... you will be given a Mission Spy Tools folder
3. Drag a Mission Spy object onto the ground and then use the commands to control it.
4. The object is copy so don't worry about losing it.
5. To clear up say "/55 die" - see below.


COMMANDS
Commands available in version 1.1 are:
/55 channel n
    Switch commands to channel n
/55 range n
    Set the avatar detection range to n, up to 100 (metres) is valid.
/55 owner n
/55 owner y
    Sets whether the owner will not "n", or will "y" be included in scans
/55 spy n
/55 spy y
    Sets whether Mission Spy is reporting conversations back to the owner
/55 useim n
/55 useim y
    Sets whether Mission Spy reports via llOwnerSay or llInstantMessage
    neither will cause particles to be displayed
/55 track PARTIALNAME
    Follow avatars matching PARTIALNAME (case insensitive) around the sim
    Essential for following conversations in a fast moving battle
    Will pickup and track again if the av. leaves and returns
    Eg. "/55 track sparti" would follow me around (!)
/55 report
    Report list of avs detected since last auto-reset
    Owner will receive IM individual as well
/55 reset
    Reset Mission Spy
/55 die
    Delete the Mission Spy object
    


Some parameters can be configured via notecard - to reduce the setup time or allow you to create a number of separate trackers.


Of course Mission Spy is supplied COPY (+MOD for the notecard).


NOTECARD CONFIGURATION
The commands which can be put into the notecard are:
time T
    Set time between scans to T seconds
range R
    Set avatar detection range
channel C
    Set command channel
owner O
    Set whether owner is detected
useim U
    Set whether instant messaging (or OwnerSay) is used
spy S
    Set whether conversations are reported



>> Supported Product <<
>> If you require any help or have feature requests or bug reports for Mission Spy please IM me <<
