integer age;
integer looking_for_female;

key father;
key mother;

integer preg_time;

default
{
    link_message(integer sender, integer num, string str, key id)
    {
        if (num == 800) {
            state running;
        }
    }
}

state running
{
    state_entry()
    {
        age = 0;
    }
    
    link_message(integer sender, integer num, string str, key id)
    {
        if (num == 932) {
            if (str == "1") {
                state male;
            } else {
                state female;
            }
        } else
        if (num == 940) {
            age += (integer)str;
        } else
        if (num == 5000) {
            preg_time = (integer)str;
            if (preg_time != 0) {
                state pregnant;
            } else {
                state female;
            }
        }
    }
}

state male
{
    state_entry()
    {
        looking_for_female = 0;
        
        mother = NULL_KEY;
        father = NULL_KEY;
        
        llMessageLinked(LINK_SET, 942, "", "");        
        
        if (age >= 7) {
            llSetTimerEvent(10800.0);            
        }
    }
    link_message(integer sender, integer num, string str, key id)
    {
        if (num == 943) {
            age = (integer)str;
            if (age >= 7) {
                llSetTimerEvent(10800.0);
            }            
        } else
        if (num == 940) {
           
            age += (integer)str;
            if (age >= 7) {
                llSetTimerEvent(10800.0);
            }
        } else
        if (num == 963) {
            if (looking_for_female == 1) {
                looking_for_female = 0;
                mother = id;
                father = llGetKey();
                llMessageLinked(LINK_SET, 964, "", mother);       
            }
        } else
        if (num == 967) {
            if (mother != NULL_KEY) {
                llMessageLinked(LINK_SET, 968, "", mother);
            }
        } else
        if (num == 969) {
            state male;
        }
    
    }
    
    timer()
    {
        looking_for_female = 1;
        // look for an eligible female.
        llWhisper(0, llGetObjectName() + " gets a gleam in his eye.");
        llMessageLinked(LINK_SET, 960, "", "");
    }
}

state female
{
    state_entry()
    {
        mother = NULL_KEY;
        father = NULL_KEY;
        
        if (age == 0) {
            llMessageLinked(LINK_SET, 942, "", "");
        }
    }
    
    link_message(integer sender, integer num, string str, key id)
    {
        if (num == 940) {
            age += (integer)str;
        } else
        if (num == 961) {
            // signal I am eligible
            if (age >= 7 && father == NULL_KEY) {
                llWhisper(0, llGetObjectName() + " blushes then bobs her head up and down.");
                llMessageLinked(LINK_SET, 962, "", "");
            }
        } else
        if (num == 965) {
            // male on the way, rest for 20m
            llSetTimerEvent(900.0);
            father = id;
            mother = llGetKey();
            llMessageLinked(LINK_SET, 911, "1200", "");
        } else
        if (num == 972) {
            // pregnant
            llSetTimerEvent(0);
            preg_time = 0;
            state pregnant;
        } else
        if (num == 969) {
            llSetTimerEvent(0);
            state female;
        } else
        if (num == 943) {
            age = (integer)str;
        } else
        if (num == 5000) {
            preg_time = (integer)str;
            if (preg_time != 0) {
                state pregnant;
            }
        }

    }
    
    timer()
    {
        llSetTimerEvent(0);
        // fail
        llMessageLinked(LINK_SET, 971, "", father);
        state female;
    }
}

state pregnant
{
    state_entry()
    {
        if (preg_time != 0) {
            llSetTimerEvent(172800.0 - (float)(llGetUnixTime() - preg_time));
        } else {
            llSetTimerEvent(172800.0);
        }
    }
    timer()
    {
        // lay egg.
        llSetTimerEvent(0);
        llMessageLinked(LINK_SET, 970, "", "");
        state female;
    }   
}