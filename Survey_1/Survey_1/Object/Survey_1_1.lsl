// :CATEGORY:Survey
// :NAME:Survey_1
// :AUTHOR:Eloise Pasteur
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:05
// :ID:851
// :NUM:1181
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Survey 1.lsl
// :CODE:

//=============================================================
//SL SURVEY, 1.1
//Gathers survey responses via dialog, emails results from Second Life
//Copyright (C) 2006  Eloise Pasteur and Jeremy Kemp
//=============================================================
//SETTING UP THE OBJECT ===============
//Create an object, its name will be the "From" field in the results email
//Include the script and a questions notecard
//The notecard name will be listed in the body of the results email
//Enter questions on one line, answers on the next, alternating lines
//Denote separate options in the answer line with a | pipe character
//You may need to fiddle a little with the order of your answers - there is no way to automatically adjust them irrespective of the number of answers you have that will also allow you to ask a reasonable number of questions. The dialog box displays as follows:
    //10, 11, 12
    //7, 8, 9
    //4, 5, 6
    //1, 2, 3
//Example:
//What color is the sky?
//blue|orange|green|red
//This will display the answers as:
    //red
    //blue, orange, green
//On the buttons.

//No line can be more than 255 characters
//Answers are truncated at 8 characters - they can be up to 24 characters but there is only space for 8 characters to display on the buttons.

//LAUNCHING THE SURVEY ===============
//Upon resing, the script will request an email address for results - or you can enter your email directly into the script in the first non-orange line below in the format string address="example@aol.com";
//The script will take longer to setup with more questions
//Changes to the card after a survey is started require a manual reset of the script

string address;         //The email address. email is a restricted word in lsl - it's an event name. - if you don't want to set these each time you can enter your email directly here - the script will automatically adjust and not ask you for your email.
integer pointer=0;      //Where we are in the various cycles - reading notecards, asking questions etc.
list questions;         //The questions we've read in
list answers;           //The answers in raw form (still in one string per answer set)
integer listenID;       //So we can turn listeners on and off - less lag that way.
key owner;              //So I can listen to only the owner, and potentially add some admin functions off a touch (not implemented but the code is there).
integer chan;           //Channel for  the silent email registration - required in state_entry AND listen, hence a global.
string card;            //Name of the notecard you're using.
key questionnaire;      //Key of the person taking the questionnaire
string totalq;          //Total number of questions
string responses;       //The actual answers given, plus querent's name and card name.
float timePerQuestion=60.0;  //Although there is a sensor to detect crashed etc. people it's not 100% reliable according to some. This lets you set a time (in seconds) per question (so it's currently 1 minute per question) so that if they take too long they time out. For tricky questions you might want to have some more time...


setQuestions()          //A function - we need to access this from a couple of places, hence putting it in as a function
{
    string question=llList2String(questions, pointer);                                  //Raw question
    question=llDumpList2String(llParseString2List(question, ["|"], []), "\n");          //Swaps | for /n (new line)
    if(llStringLength(question)!=0)
    {
        llDialog(questionnaire, question, llParseString2List(llList2String(answers, pointer), ["|"], []), -1001);   //Asks the questions in a dialog box.
    }
}

default         //Set everything up
{
    state_entry()
    {
        llSetText("Setting up", <1.0, 1.0, 1.0>, 1.0);      //Show what we're doing.
        owner=llGetOwner();                                 //Grab the owner's key for lower down
        //chan=(integer)("0x"+llGetSubString((string)owner, 0, 1));   //Set up a channel (not 0) based on the key (1-255) so there's silent entry.
        if(address=="")                                     //They've not entered their email address in the script.
        {
            chan=0;
            listenID=llListen(0, "", llGetOwner(), "");              //Listen only to the owner as well.
            llOwnerSay("To what email shall I send responses?");   //Tell them what to say - revised for v0.9.3
        } else
        {
                if(llGetInventoryNumber(INVENTORY_NOTECARD)!=1) //there's not 1 notecard, so I'm not sure which one to use. Complain!
                {
                    llOwnerSay("You must put exactly one card in me with the questions and answers on it before I can set up!");    //Complain politely...
                } else                                          //There is only one, so we'll assume (however rashly) it's the right one.
                {
                    card=llGetInventoryName(INVENTORY_NOTECARD, 0); //Get the card's name
                    pointer=0;                                      //reset the pointer (this is paranoia, but it doesn't hurt) 
                    llGetNotecardLine(card, pointer);               //Start reading the card (handled in the dataserver event).
                }
          }
    }
    listen(integer cha, string name, key id, string msg)    //Listen event - grab their details and make sure it's all OK.
    {
        if(cha==chan)
        {
            address=msg;
            llListenRemove(listenID);                   //Tidy up the listen, just in case.
            listenID=llListen(-1001, "", owner, "");
            llDialog(owner, "The email address for results is "+msg+". Is that correct?", ["Yes", "No"], -1001);    //Check the email address is right
        } else if(cha=-1001)
        {
            if(msg=="Yes")      //Email is OK, so...
            {
                llListenRemove(listenID);
                if(llGetInventoryNumber(INVENTORY_NOTECARD)!=1) //there's not 1 notecard, so I'm not sure which one to use. Complain!
                {
                    llOwnerSay("You must put exactly one card in me with the questions and answers on it before I can set up!");    //Complain politely...
                } else                                          //There is only one, so we'll assume (however rashly) it's the right one.
                {
                    card=llGetInventoryName(INVENTORY_NOTECARD, 0); //Get the card's name
                    pointer=0;                                      //reset the pointer (this is paranoia, but it doesn't hurt) 
                    llGetNotecardLine(card, pointer);               //Start reading the card (handled in the dataserver event).
                }
            } else  //They put their email address in wrong
            {   
                llResetScript();    //Well we've not really done anything. We could cycle back to ask again if we'd done more.
            }
        }
    }
    dataserver(key id, string data)     //This handles various things - this time it's reading data from a notecard.
    {
        if(data!=EOF)                   //It's real data, not the end of the file.
        {
            if(llStringLength(data)==0)
            {
                llSay(0, "CAUTION! Line "+(string)pointer+"of the notecard is blank! This may cause errors, questions to display out of sync with their answers etc.");
            }
            if(pointer%2)               //is it an odd numbered line
            {
                answers+=data;          //if so, it's an answer line
            } else
            {
                questions+=data;        //else it's even (0 first remember) - so it's a question
            }
            pointer++;                  //Advance the pointer
            llGetNotecardLine(card, pointer);   //Get the next line.
        } else                          //It IS the end of the file, so we've grabbed it all...
        {
            totalq=(string)llGetListLength(questions);  //Get the number of questions
            state ready;                                //Go into a ready state, so we can take answers.
        }
    }
    changed(integer change)
    {
        if((change & CHANGED_OWNER) || (change & CHANGED_INVENTORY))    //They've changed the contents, or the owner, so reset it - probably a new card after all.
        {
            llResetScript();
        }
    }
}

state ready             //Waiting for victims to answer questions.
{
    state_entry()
    {
        llSetText("Touch to start survey\n"+card+" - "+totalq+" ?s.", <0.0, 1.0, 0.0>, 1.0);   //Tell punters what to do
    }
    changed(integer change)
    {
        if((change & CHANGED_OWNER) || (change & CHANGED_INVENTORY))    //They've changed the contents, or the owner, so reset it - probably a new card after all.
        {
         llResetScript();
        }
    }
        touch_start(integer num)        //Process the touch
    {
        key temp=llDetectedKey(0);
        if(temp==owner)                 //No admin built in, but it's available as an option
        {
            //offer some options
            questionnaire=temp;
            state running;
        } else                          //It's a punter - start the questionnaire.
        {
            questionnaire=temp;
            state running;
        }
    }
}

state running       //We're actually asking questions
{
    state_entry()
    {
        llSetTimerEvent(timePerQuestion * (float)totalq);       //This is a timer to clean up people that don't finish but the sensor doesn't catch for some reason.
        llSetText(llKey2Name(questionnaire)+" is taking the questionnaire, please wait!", <0.0, 0.0, 1.0>, 1.0);    //Tell the world so!
        listenID=llListen(-1001, "", questionnaire, "");        //Only listen to the answers, stops spamming
        llSensorRepeat("", questionnaire, AGENT, 60, PI, 30.0); //Keep checking they're still there - they might have got bored and wondered off, crashed etc.
        pointer=0;                                              //reset the pointer (recycling variables is good)
        setQuestions();                                         //Ask the first question (see function above)
    }
    listen(integer chan, string name, key id, string msg)       //Listen for the answers.
    {
        if(pointer==0)                                          //First answer, so say what's happening.
        {
            responses=name+"'s answers to the questionnaire on notecard "+card+".\n";
        }
        responses+="Q"+(string)(pointer+1)+": "+msg+"\n";       //Add their answer to this question to the email.
        pointer++;
        if(pointer==(integer)totalq)                            //Got to last question.
        {
            llSay(0, "Thank you for taking this questionnaire. Please wait whilst I send the results before starting.");    //Tell them they're done.
            llSetText("Sending results, please wait.\nThis should take about 20s.", <1.0, 0.0, 0.0>, 1.0);                  //Tell others they're done too, and to wait a bit
            llEmail(address, "Questionnaire answers", responses);                                                           //Send the email.
            state ready;                                                                                                    //Back to the ready state
        } else
        {
            setQuestions();                                                                                                 //Ask the next question
        }
    }
    no_sensor()                                                                                                             //The person's left, so send their partial answers
    {
        llSensorRemove();                                                                                                   //Tidy up
        llEmail(address, "Questionnaire answers", responses);                                                               //Send email
        state ready;                                                                                                        //Back to ready state
    }
    timer()
    {
        llSensorRemove();                                                                                                   //Tidy up - slow sensor repeats aren't THAT laggy, but are a bit
        llSetTimerEvent(0.0);                                                                                               //Tidies up the timer to stop it firing
        llEmail(address, "Questionnnaire answers", responses);                                                              //Send their answers
        state ready;                                                                                                        //Back to ready state
    }
}// END //
