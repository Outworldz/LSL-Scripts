// :SHOW:
// :CATEGORY:ChatBot
// :NAME:NPC Chatbot for Opensim
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2016-07-27 16:14:00
// :EDITED:2016-07-27  15:14:00
// :ID:1108
// :NUM:1909
// :REV:1.0
// :WORLD:OpenSim
// :DESCRIPTION:
// Read me notecard
// :CODE:
This chatbot is for OpenSim Only. It only works on NPC's with  a modified All-In-One NPC script, which is also included.
Upload everything and put it in a prim.

Step 1:
Go to PersonalityForge.com. Get a free account at http://www.personalityforge.com.  The first 5,000 chats are free.

Get an API ID, and add it to the apiKey in the script "Chatbot Contoller.lsl". 
  
string apiKey = "BlahBlah";    // your supplied apiKey from your Chat Bot API subscription 
   
Add the domain for your OpenSim server or IP to the list of authorized domains at http://www.personalityforge.com/botland/myapi.php
 Add a checkmark to the "Enable Simple API" in your account.
 Click on the Simple API tab and pick a chatbot ID from the list of chatbots under the heading "Selecting A Chat Bot ID"
 for example, Countess Elvira is 99232.  Put that in chatBot ID below.

 Sex Bot Ciran is 100387. 
 754 is Liddora a sexy tart
  
Now look for  this and add that ID:

string chatBotID = "23958";    // the ID of the chat bot you're talking to

Save the script.

Step 2: 
You need to make the "Appearance" notecard with one to your liking.  Dress up however you want, take it all off and put it on again so the server has it recorded okay.  Now touch the box  and select "Appearance" to record  your shape.  The easy way is to just use a pre- recorded Avatar Appearance and switch back and forth in Firestorm.   The positions and what is worn only get saved to the server when you take them off.

Step 3:
Touch the box again, and make sure it is set to "Relative" and not "Absolute".  This is because of the numbers inside the Route notecard.   "Absolute" would be used for world positions, relative means relative to the control prim.  

Make sure that "Sensor" has been clicked.   No Sensor will leave the NPC in the world at all times. "Sensor" will remove it when no one is around.

Then click "Start".  You NPC should appear, walk 8 meters to one side, and stand there.  If you chat with it, the arms should move, and if you can convince it to be happy, it will laugh and animate the face with various emotions.

This NPC uses the All-In-One NPC controller.  So it has a Route notecard.   In that notecard is this, which you should probably edit to your liking:  

@spawn=Tinker@www.outworldz.com|<0.000000,0.000000,0.500000>
@walk=<0,-8,0.5>
@stop

This causes my little fairy chatbot "Tinker@www.outworldz.com" to appear 1/5 meter above the prim, walk 8 to the left, and stop.   Any animatons the fairy plays after that is based on her emotional states from the chatbot.

You can have your NPC do whatever you want, like walk around, drive a car, etc.
More info on this is at http://www.outworldz.com/opensim/posts/npc/

