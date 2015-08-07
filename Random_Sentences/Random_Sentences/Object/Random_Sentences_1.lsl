// :CATEGORY:Random
// :NAME:Random_Sentences
// :AUTHOR:Davy Maltz
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:00
// :ID:680
// :NUM:923
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Random_Sentences
// :CODE:
list verbs = ["shanked","burned","deleted","killed","punched","washed","ate","raped","shot","stole","craped on","cut 
up","electrocuted","bled on","has a fetish for","laughs at","would like to have sexual relations with"];
list nouns = ["toenails","pants","computer","doctor","mother","couch","donkey","toilet","knife","cake","password",
"penguin","keyboard","lightbulb","pillow"];
integer verb;
integer noun;
integer agent_1;
integer agent_2;
default
{
    state_entry()
    {
        llSetTimerEvent(40);
    }
    touch_start(integer total_number)
    {
        llSensor("","",AGENT,20,PI);
    }
    timer()
    {
        llSensor("","",AGENT,20,PI);
    }
    sensor(integer num_detected)
    {
        if(num_detected > 1)
        {
            verb = (integer)llFrand(llGetListLength(verbs));
            noun = (integer)llFrand(llGetListLength(nouns));
            agent_1 = (integer)llFrand(num_detected);
            agent_2 = (integer)llFrand(num_detected);
            if(agent_1 == agent_2)
            {
                agent_1 = agent_1 - 1;
                if(agent_1 < 0)
                {
                    agent_1 = agent_1 + 2;
                }
            }
            string name_1 = llDetectedName(agent_1);
            string name_2 = llDetectedName(agent_2);
            string sentence = name_1+" "+llList2String(verbs,verb)+" "+name_2+"'s "+llList2String(nouns,noun)+".";
            llSay(0,sentence);
            llSetText(sentence+"\n . "+"\n . "+"\n . "+"\n . ",<1,1,1>,1.0);  
        }
        else
        {
            llSetText("Not Enough Agents Detected...",<1,0,0>,1.0);
        }
    }
}
