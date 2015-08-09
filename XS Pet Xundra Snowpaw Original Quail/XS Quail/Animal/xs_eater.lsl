// :CATEGORY:XS Pet
// :NAME:XS Pet Xundra Snowpaw Original Quail
// :AUTHOR:Xundra Snowpaw
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:10
// :ID:989
// :NUM:1474
// :REV:1
// :WORLD:Second Life, Opensim
// :DESCRIPTION:
// Original Pet Quail
// :CODE:

integer SECONDS_BETWEEN_FOOD_NORMAL = 14400;
integer SECONDS_BETWEEN_FOOD_HUNGRY = 3600;

integer hunger_amount;
integer seconds_elapsed_normal;
integer seconds_elapsed_hungry;

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
        hunger_amount = 0;
        seconds_elapsed_normal = 0;
        seconds_elapsed_hungry = 0;
        llSetTimerEvent(1.0);
    }
    
    timer()
    {
        integer do_message = 0;

        if (hunger_amount > 0) {
            if (seconds_elapsed_hungry == SECONDS_BETWEEN_FOOD_HUNGRY) {
                do_message = 1;
                seconds_elapsed_hungry = 0;
            } else {
                seconds_elapsed_hungry++;
            }
        }
                        
        if (seconds_elapsed_normal == SECONDS_BETWEEN_FOOD_NORMAL) {
            hunger_amount++;
            seconds_elapsed_normal = 0;
        } else {
            seconds_elapsed_normal++;
        }
        
        if (do_message == 1) {
            llMessageLinked(LINK_SET, 903, (string)hunger_amount, "");
        }
    }
    
    link_message(integer sender, integer num, string str, key id)
    {
        if (num == 901) {
            hunger_amount --;
        } else
        if (num == 904) {
            hunger_amount = (integer)str;
        }
    }
}

