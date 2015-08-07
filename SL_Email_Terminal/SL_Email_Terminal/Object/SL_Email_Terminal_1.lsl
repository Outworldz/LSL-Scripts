// :CATEGORY:Email
// :NAME:SL_Email_Terminal
// :AUTHOR:Doc Nerd
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:03
// :ID:784
// :NUM:1072
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Instructions// //     * Open your inventory//     * Choose New Script and rename it email script//     * Copy the script below, doubleclick the email script in SL and paste//     * Click Build on the bottom bar and the Create in the menu
//     * Use your magic wand to place an object on the ground
//     * Right click the object and choose Edit
//     * Rename the object My Emailer
//     * Drag your email script into the object
//     * Right click the object and choose Take
//     * Just drag the My Emailer object out and touch it to send emails 
// :CODE:
//...........One Way Email Terminal..........
//.......Originally written by Doc Nerd......
// This Script is distributed under the terms 
// of the modified BSD license, reproduced at 
// the end of the script. The license and
// acknowledgments listed must be included if
// this script is redistributed in a 
// non-readable or non-modifiable form.


//..........Variable Block..........
key senderKey;
string senderName;
string eMail;
string subject;
string bodyText;
list sendButtons = ["Yes", "No"];
list writeButtons;
string removeButton;
integer i;


//..........Modules Block..........

//..........Modules for writing each part of email..........
writeAddress()
{
    llListen(0, "", senderKey, ""); //Listen to what the user says.
    llSay(0, "Please say the address of whom you are sending your email."); //Tell them what to say.
    llSetTimerEvent(30); //Give them 30 seconds to say it.
}

writeSubject()
{
    llListen(0, "", senderKey, ""); //Listen to what the user says.
    llSay(0, "Please say the subject of your email."); //Tell them what to say.
    llSetTimerEvent(30); //Give them 30 seconds to say it.
}

writeBody()
{
    llListen(0, "", senderKey, ""); //Listen to what the user says.
    llSay(0, "Please say the message you would like to send."); //Tell them what to say.
    llSetTimerEvent(120); //Give them 120 seconds (2 minutes) to say it.
}


//..........Modules to remove buttons already used in llDialog menu..........
removeAddress()
{
    i = llListFindList(writeButtons, ["Address"]); //Find "Address" button in list.
    writeButtons = llDeleteSubList(writeButtons, i, i); //Remove it where it's found.
}

removeSubject()
{
    i = llListFindList(writeButtons, ["Subject"]); //Find "Subject" button in list.
    writeButtons = llDeleteSubList(writeButtons, i, i); //Remove it where it's found.

}

removeMessage()
{
    i = llListFindList(writeButtons, ["Message"]); //Find "Message" button in list.
    writeButtons = llDeleteSubList(writeButtons, i, i); //Remove it where it's found.
}


//..........Running script block..........
default
{
    state_entry()
    {
        llSetObjectName("Nerd Gadgets & Scripting Emailer 100"); //Makes sure the object is called the Nerd Gadgets Emailer 100.
        writeButtons = ["Address", "Subject", "Message"]; //Sets the llDialog buttons.
        llListen(67895, "", senderKey, "Yes"); //Activate listeners.
        llListen(67895, "", senderKey, "No");
    }

    touch_start(integer total_number)
    {
        senderKey = llDetectedKey(0); //Detects who's touching it, to get a raw key.
        senderName = llKey2Name(llDetectedKey(0)); //Detects who's touching it, to get a name.
        llDialog(senderKey, "Greetings " + senderName + ", would you like to send an email?", sendButtons, 67895); //Do you like me? Y/N
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if(message == "Yes") //Starts email writing process.
        {
            llSay(0, "Currently being used by " + senderName + "."); //Tells area who's using terminal.
            state emailer;
        }
        if(message == "No") //Thank you, come again.
        {
            llSay(0, "Thank you " + senderName + ", for using the " + llGetObjectName());
        }
    }
}

state emailer
{
    state_entry()
    {
        if(writeButtons == []) //Check to see if there's anything left to write in the email.
        {
            state sendMail; //If not, move to sending module.
        }
        llListen(67895, "", senderKey, "Address"); //Activate listeners.
        llListen(67895, "", senderKey, "Subject");
        llListen(67895, "", senderKey, "Message");
        llSetTimerEvent(30); //Gives user 30 seconds to choose a part to write...
        llSay(0, "You have 30 seconds to choose."); //Informs user they have 30 seconds to choose.
        llSetText("In use, please wait.", <255,0,0>, .1); //Gives visual cue to others that no one else can use it right now.
        llDialog(senderKey, "What part of your message would you like to write?", writeButtons, 67895); //Selection button GUI.
    }
    
    listen(integer channgel, string name, key id, string message)
    {
        if(message == "Address") //Select "Address" button.
        {
            state addressWrite; //Enter address writing state.
        }
        else if(message == "Subject") //Select "Subject" button.
        {
            state subjectWrite; //Enter subject writing state.
        }
        else if(message == "Message") //Select "Message" button.
        {
            state messageWrite; //SEnter message writing state.
        }
    }
    
    timer() //After 30 seconds are up, time out, and return to default state.
    {
        llSetTimerEvent(0);
        llSay(0, "User has failed to select option in time. Unit is now available for use or retry.");
        llSetText("",<0,0,0>, 0); //Removes floating text.
        state default;
    }
        
}

state addressWrite
{
    state_entry()
    {
        writeAddress(); //Start address writing module.
    }
    
    listen(integer channel, string name, key id, string message)
    {
        eMail = message; //Save message user said.
        removeButton = "Address"; //Set variable for button removal.
        state remainButton; //Enter button removal process state.
    }
    
    timer() //After 30 seconds are up, time out, and return to selection state.
    {
        llSetTimerEvent(0);
        llSay(0, "User has failed to enter information quickly enough. Please try again.");
        state emailer;
    }
}

state subjectWrite
{
    state_entry()
    {
        writeSubject(); //Start subject writing module.
    }
    
    listen(integer channel, string name, key id, string message)
    {
        subject = message; //Save message user said.
        removeButton = "Subject"; //Set variable for button removal.
        state remainButton; //Enter button removal process state.
    }
    
    timer() //After 30 seconds are up, time out, and return to selection state.
    {
        llSetTimerEvent(0);
        llSay(0, "User has failed to enter information quickly enough. Please try again.");
        state emailer;
    }
}

state messageWrite
{
    state_entry()
    {
        writeBody(); //Start message writing module.
    }
    
    listen(integer channel, string name, key id, string message)
    {
        bodyText = message; //Save what the user said.
        removeButton = "Message"; //Set variable for button removal.
        state remainButton; //Enter button removal process state.
    }
    
    timer() //After 120 seconds (2 minutes) are up, time out, and return to selection state.
    {
        llSetTimerEvent(0);
        llSay(0, "User has failed to enter information quickly enough. Please try again.");
        state emailer;
    }
}

state remainButton //Removing buttons from a list SUCKS!
{
    state_entry()
    {
        if(removeButton == "Address") //Removes "Address" button.
        {
            removeAddress();
            state emailer;
        }
        else if(removeButton == "Subject") //Removes "Subject" button.
        {
            removeSubject();
            state emailer;
        }
        else if(removeButton == "Message") //Removes "Message" button.
        {
            removeMessage();
            state emailer;
        }        
    }
}

state sendMail
{
    state_entry()
    {
        llListen(67895, "", senderKey, "Yes"); //Starts listeners.
        llListen(67895, "", senderKey, "No");
        llSay(0, "Your email reads as the followed:"); //Spews out the actual email message.
        llSay(0, eMail);
        llSay(0, subject);
        llSay(0, bodyText);
        llDialog(senderKey, "Do you wish to send this message?", sendButtons, 67895); //Do you like me? Y/N
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if(message == "Yes") //You like me! You really like me!
        {
            llSay(0, "I hope you don't mind " + senderName + ", but I will have to assume your name for a moment to send this email."); //Tell user the terminal will change it's name for proper "From" headings in inbox.
            llSay(0, "Your email will be sent in 20 seconds."); //Tells user email will be sent in 20 seconds (delay of llEmail function call to script).
            llSay(0, "Thank you " + senderName + ", for using the " + llGetObjectName()); //Thank you, come again.
            llSetText("", <0,0,0>, 0); //Removes "busy signal".
            llSetObjectName(senderName); //Change to user's name.
            llEmail(eMail, subject, bodyText); //Send that damn thing already!
            state default; //Return to normal.
        }
        else if(message == "No") //You don't like me? *emo tear*
        {
            llSay(0, "Thank you " + senderName + ", for using the " + llGetObjectName()); //Thank you, come again.
            llSetText("", <0,0,0>, 0); //Removes "busy signal".
            state default; //Return to normal.
        }
    }
}


//Copyright (c) 2005, Doc Nerd & player
//All rights reserved.
//
//Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//    * Redistributions in modifiable form must retain the above copyright notice, this list of conditions and the following disclaimer.
//    * Redistributions in non-modifiable form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//    * Neither the name of Doc Nerd nor his player may be used to endorse or promote products derived from this software without specific prior written permission.
//
//THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
