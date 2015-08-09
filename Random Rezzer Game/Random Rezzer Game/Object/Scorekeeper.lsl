// :CATEGORY:Games
// :NAME:Random Rezzer Game
// :AUTHOR:Anonymous
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:00
// :ID:675
// :NUM:918
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// random game
// :CODE:

integer GIVE = TRUE; // if TRUE, give them a random prize

integer channel = -1234321; // some random integer rto talk with
integer maxCount = 100;  // Only keep the 100 top scores so we do not run out of RAM
list scores;// a list of scores (integers like 1,1,23, and avatar names. Wr number is first so we can sort on it for high scores.

default
{
    on_rez(integer start_param)
    {
        llResetScript();    // when you rez it, we have to start a listener
    }
    
    state_entry()
    {
        llListen(channel,"","","");    // listen on our secret channel for things that are touched.
    }

    listen(integer channel, string name, key id, string message)
    {

        list stuff = llParseString2List(message,["^"],[]); // look in message for aviName^aviKey
        string aviName = llList2String(stuff,0);         // get the name
        key aviKey = (key) llList2String(stuff,1);    // get the key
        llSay(0, "Prim " + name +  " caught by : " + aviName);

        // lets see of this person is in the list of people already played
        integer index = llListFindList(scores,[aviName]);  // get the number of the position of the name, the score is one less than this
        if (index  == -1)
        {
            // Nope, so we add them to the list
            scores += 1;    // they have one object;
            scores += aviName;
            llOwnerSay("Welcome, " + aviName + " .  This you your first time to play, so just keep watching for and clicking the objects and have fun");
        }
        else
        {
            // yes, they have played before, get their old score
            integer oldscore = llList2Integer(scores,index-1);
            oldscore++;        // add an object to the old score
            scores = llListReplaceList(scores,[oldscore],index-1, index-1);    // save it back in the score list
        }

        if (GIVE)
        {
            integer PrizeNum = llGetInventoryNumber(INVENTORY_OBJECT);    // get how many items are in this prim
            integer whichOne = llCeil(llFrand(PrizeNum)) -1 ;  //pick a prize, randomly
            llGiveInventory(aviKey, llGetInventoryName(INVENTORY_OBJECT,whichOne));
        }

        

        scores = llListSort(scores,2,FALSE); //sort from largest num to lowest

        scores = llDeleteSubList(scores, maxCount, maxCount+1); // delete the smallest score so we never get bigger than maxCount

        string scoreText;    // We need to calculate the highest scores for display
        integer i ;
        integer stop = 10;    // show top 10 scores
        if (llGetListLength(scores) < 10)    // is the list bigger than 10 yet?
        {
            stop = llGetListLength(scores);
        }

        // print out the top 10 scores, or fewer
        for (i = 0; i < stop; i+= 2)
        {
            scoreText += llList2String(scores,i+1) + " : " + (string) llList2String(scores, i) + "\n";
        }
        llSetText(scoreText,<1,1,1>,1.0);
        llOwnerSay(scoreText);


    }// end listen
}    // end default
