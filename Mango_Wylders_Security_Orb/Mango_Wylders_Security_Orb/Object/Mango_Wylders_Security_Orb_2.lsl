// :CATEGORY:Security
// :NAME:Mango_Wylders_Security_Orb
// :AUTHOR:mangowylder
// :CREATED:2012-09-10 21:15:15.873
// :EDITED:2013-09-18 15:38:57
// :ID:505
// :NUM:676
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Usage and instructions
// :CODE:
Mango Wylder's Security Orb

Heavily modified version of Security Orb script found here
http://www.outworldz.com/cgi/freescripts.plx?ID=1119

There is a major problem with this script.
It uses llSleep when an avi is detected.
Why is this a problem?
Well if you invite someone to your parcel and they are not allowed,
you can't do anything with the scanner once the avi is detected during the Warn Time period (sleep time)
i.e You can't turn it off for example.
The Avi will get booted then you will have to have to make changes to the Security Orb to
allow the visitor. 
You might ask why not just use a timer?
I'm using the timer to ensure no stray listens and to prevent writing to the wrong list in the
event of no user input.
I'm working on a major rewrite but for now it is what it is :)

Dialog Menu driven
Input is on chat channel /7
Avatar names are case sensitive

Features and Functions
- Multi-level code checking to ensure your neighbors won't be ejected regardless of how high the scanner range is set.
- Allows for up to 6 Administrators
- Allows for up to 25 ejected avis to be logged. When this limit is reached the newest ejected avi will be logged and the first  ejected avi will be deleted from the 

list.  This limit is imposed to keep memory usage down.
- Allows for up to 25 in the white list for the same reason as stated above. When this limit is reached you will be notified that if you want to add another avi you 

will have to delete one from the White List first.
- Ability for Owner/Admins to set ban time, warning time and scanner range and scan time interval. Ban time is set in hours. Warn time is set in seconds. Scan time 

interval is set in seconds - Suggested time is between 10 and 60 seconds.
  Scanner range is set in meters up to 96 meters.
- Turn scanner On/Off
- Scanner Status reports On/Off, current scanner range, current warning time current ban time and current scanner rate.
- Group Mode Protection On/Off. When on, any avi with the same active group as the security console will be ignored by the scanner.
- Add/Del White list - Owner/Admins
- Add/Del Admins - Owner Only
- Admins are auto added to White list and are displayed with Show White. 
- Admins can't delete other Admins or owner from either the White list or Admin list. Only the owner can do this. If they try they will get a warning. 
- Owner is IM'd when an avi is ejected.  
- Ejected avis are logged with a llDialog menu to report who has been ejected.
- Allows for Owner/Admins to add an avi that was previously ejected to the White list or Admin list, automatically removing them from ejected list and the ejected 

BanTime list.
- SetBanTime - Set Ban Time in hours. Adds avi's name to Ejected BanTime list based upon conditions listed below.
- If ejected avi tries to return they within BanTime they will be ejected again with a warning if they return again they will be teleported home with no warning.
- Options to show the Ejected list and remove avi's from the Ejected list or purge the Ejected list completely.
- Ejected BanTime list is self cleaning, i.e. if the avi returns after BanTime setting they will be automatically removed from the  Ejected BanTime list.  They will 

remain in the ejected list though.
- ShowBan Shows avi's that have been ejected during the BanTime setting
- PurgeBan - Purges all Avi's that have exceeded the Ban Time setting from the Ejected BanTime list. If Avi hasn't exceeded the BanTime setting they will remain in the 

BanTime list unless they are added to the White List or Admin list in which case they will be purged from Ejected BanTime List and Ejected list.
- DELBan - Purges the Ban list completely
        
- There is a 20 second timer to make changes.

If land is group owned you will need to deed the Security Orb to the group.  To deed the object to the group you will need to wearing the group tag that you want it 

deeded to. Then right click on the object and select edit. Click Group Set and select the group that is the same group tag you have active. This group must be the 

group that the land is deeded to.  Select the group and click ok. Next click Share with Group. The Deed button should turn active blue. Click on the Deed button and 

you are done.

If the land is privately owned and you want group protection, here is how you will need to activate it. Right click on the object and select edit. Click Group Set and 

select the group that is the same group tag you have active. Now once you enable Group Mode protection the scanner will ignore anyone that has the same active tag that 

you set the scanner to. There is no need to Deed the object to the group in this case.

--Glossary--
- Scan Range is the range the scanner will sweep to detect avatars from 1 meter to 96 meters.
- Scan Rate is the interval between sweeps. Recommend setting the scan rate between 5 and 60 seconds.
- Warn Time is the time in seconds that the avatar will have to leave before they get ejected after they are detected by the scanner. Recommend setting the Warn Time 

is between 5 and 60 seconds.
- Ban Time is the time in hours that an avatar once ejected will be ejected again with no warning if they return within Ban Time. I.e. there will be no Warn Time.
