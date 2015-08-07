// :CATEGORY:Tour
// :NAME:TourCopter
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:08
// :ID:909
// :NUM:1301
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Tour
// :CODE:

﻿// ______           _  ______            _           _
// |  ___|         | | |  ___|          | |         (_)
// | |_ ___ _ __ __| | | |_ _ __ ___  __| | ___ _ __ ___  __
// |  _/ _ \ '__/ _` | |  _| '__/ _ \/ _` |/ _ \ '__| \ \/ /
// | ||  __/ | | (_| | | | | | |  __/ (_| |  __/ |  | |>  <
// \_| \___|_|  \__,_| \_| |_|  \___|\__,_|\___|_|  |_/_/\_\
//
// fred@mitsi.com
// tour copter script
// blade strike sound
//
//Revisions:
// 1/28/2010 initial release


default
{
    on_rez(integer sparam)
    {
        llStopSound();
    }
    
    link_message(integer sender, integer num, string str, key id) {
        if (str == "start") {
            llSetTimerEvent(0.0);
            llTriggerSound("cdf81596-e724-7000-5d81-86ce1ae6998d", 1.0);
            llTriggerSound("cada5d30-d696-06e7-eb67-2778a640e8ef", 1.0);
           llSleep(9.30);
           llTriggerSound("8ba0f2ae-b0e0-56cc-90fc-c45526933bae", 1.0);
           // llTriggerSound("cdf81596-e724-7000-5d81-86ce1ae6998d", 1.0);
            
            llSetTimerEvent(0.01);
        } else if (str == "stop") {
            llSetTimerEvent(0.0);
            llStopSound();
            llTriggerSound("4689d0f2-d613-0d43-08e6-e0636ab9fa6a", 1.0);
            llTriggerSound("96ecbe0c-5050-da0b-8899-44751dc81ac3", 1.0);
            llStopSound();
        }
    }
    
    timer()
    {
        llLoopSound("ed7cb5e1-54d7-5578-7770-34f43a201c6f", 1.0);
        llSetTimerEvent(0.0);
    }
}

