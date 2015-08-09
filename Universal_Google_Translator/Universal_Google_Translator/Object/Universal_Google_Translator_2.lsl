// :CATEGORY:Translator
// :NAME:Universal_Google_Translator
// :AUTHOR:Hank Ramos
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:08
// :ID:934
// :NUM:1341
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
//  HTTP Handler// // Even though the name of this script is "HTTP Handler", it really just stores the requested translation traffic so that we can match incoming translations from Google with what was requested. Since this takes a lot of memory for storage, this information is kept out of the engine script. When an incoming HTTP response comes in, we fetch the data from here. If the requests didn't come back in a timely fashion, we remove it from the queue. 
// :CODE:
//HTTP Handler
//Copyright 2006-2009 by Hank Ramos
 
list requestedTranslations;
list requestedDetections;
 
default
{
    state_entry()
    {
        llSetTimerEvent(5);
    }
 
    timer()
    {
        integer x;
        list    newList;
        float timeElapsed; 
 
        for (x = 0; x < llGetListLength(requestedDetections); x += 2)
        {
            timeElapsed = llGetTime() - llList2Float(llCSV2List(llList2String(requestedDetections, x + 1)), 0);
            if (timeElapsed < 60.0) 
                newList += llList2List(requestedDetections, x, x + 1);
        }
        requestedDetections = newList;
        newList = [];
        for (x = 0; x < llGetListLength(requestedTranslations); x += 2)
        {
            timeElapsed = llGetTime() - llList2Float(llCSV2List(llList2String(requestedTranslations, x + 1)), 0);
            if (timeElapsed < 60.0) 
            {
                newList += llList2List(requestedTranslations, x, x + 1);
            }
        }
        requestedTranslations = newList;
    }
 
    link_message(integer sender_num, integer num, string str, key id)
    {
        integer listPos;
 
        if (num == 235365342)
        {
            //Translation
            requestedTranslations += [id, str];
        }
        else if (num == 235365343)
        {
            //Detection
            requestedDetections += [id, str];
        }
        else if (num == 345149624)
        {
            listPos = llListFindList(requestedTranslations, [id]);
            if (listPos >= 0)
            {
                llMessageLinked(LINK_THIS, 345149625, str, llList2String(requestedTranslations, listPos + 1));
                requestedTranslations = llDeleteSubList(requestedTranslations, listPos, listPos + 1);
                return;
            }
 
            listPos = llListFindList(requestedDetections, [id]);
            if (listPos >= 0)
            {
                llMessageLinked(LINK_THIS, 345149626, str, llList2String(requestedDetections, listPos + 1));
                requestedDetections = llDeleteSubList(requestedDetections, listPos, listPos + 1);
            }
        }
    }
}
