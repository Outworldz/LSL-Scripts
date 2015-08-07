// :CATEGORY:Tour Guide
// :NAME:Valentines_Day_tour_bird
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2011-02-04 22:42:15.247
// :EDITED:2014-03-11
// :ID:946
// :NUM:1602
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
The scripts for this tour were made by  Ferd Frederix he is a great scripter who believes in opensource wich is great for us poor sobs,
You can download the scripts// <a href="http://www.free-lsl-scripts.com/cgi/freescripts.plx?ID=946">here</a>.
There is a post about how to make a pretty tour swan ride at <a href="http://www.free-lsl-scripts.com/Secondlife/Posts/Valentine-Tour/"> this spot</a>.

// :CODE:

There are a few scripts:

file # 1. Valentines_Day_tour_bird_main.lsl  

Is the main script, you put this in a prim with face 0 facing forward, this should be the root prim for your build.
You make a prim root by selecting it last before you link your build.
You also make a notecard and put it in the contents of the root, the notecard should be named Route

file # 3. Valentines_Day_tour_bird_poseball.lsl 

The poseball script, you make as many poseballs you wish and put this script in each together with a pose named sit
Edit your poseballs so they look nice on your build before adding the main script ( or set the script to not running) becouse the build will start to move after 10 seconds witch makes the editing of your poseballs impossible to do.
!!!!!
IMPORTANT! when you tried your seats with the main script running and stand up again your build will poof after a minute, so before doing this i suggest you take a copy to inventory, Do this whenever you made changes minor or major!
!!!!!

file # 4. Valentines_Day_tour_bird_recorder.lsl 

This script you put in a prim, when you touch this prim it will tell the waypoints ( we come to those later ) 

The cube gives you the waypoints in chat, and you need to copy those and paste them into the notecard we made earlier in the root prim called Route.

Example of how your note should look:

[19:28] Tour recorder: |10|24.088040|48.962760|54.082320|
[19:28] Tour recorder: |20|18.274350|53.096180|56.138620|
[19:28] Tour recorder: |30|19.203230|77.231740|38.415370|
[19:28] Tour recorder: |40|18.877440|77.295090|39.746290|
[19:28] Tour recorder: |50|37.810330|78.505890|40.247760|


file # 5. Valentines_Day_tour_bird_rezzer.lsl 

This is a rezzer for your build, 
You make a prim and put your build in and this script.
in line 13 of the script you change the name to your builds name:
string aname = "tourboat"; ( mine is called tourboat )
i suggest you rez a build once and see there it goes. then rotate the prim with the rez script in it so the build is rezzed with the right rotation.
Trail and error here.
in line 51 you can set the position of the build when it rezzes.
        llRezObject(aname, llGetPos() + <0.0,0.0,0.0>,  <0.0,0.0,0.0>, rezrot, 0);
        
Play with the numbers in the first  <0.0,0.0,0.0> you can do a -  before a number too to make it go the other way.
Trial and error, just play and rez a few times.

file # 6. Valentines_Day_tour_bird_wings.lsl 

Is a script to make prims flexi ( the wings) , i did not use that.

file # 7. Valentines_Day_tour_bird_ten prim.lsl 

This is an interesting one.
Put this script in a prim and name the prim 10
you will use this prim to mark your route.
Rez the prims along the way, when you make a sharp turn rez a few there to make the ride look better.
These prims will rename them selves when you rez them the first will stay 10 the second will name itself 20 etc.
A handy feature is you can make your build say stuff in chat when it reaches a certain waypoint.
To do this you write your text in the description of the prim on that waypoint.
By default the description has the text ( no description) remove that from your number 10 prim before you start rezzing your waypoints or all points will chat ( no description) 
Handy tip:  also set your prim named 10 phantom, this way you can test your tour and leave the prims in the route and edit them a bit and re record.

Ferd also build in a handy feature to make the waypoint prims go away, shout " /300 die"  without the quotes of course... i think shout reaches 96 meter so you might have to repeat on a few places.

Good luck making your tour! i had a lot of fun doing it.

Greetings,
burt Artis

