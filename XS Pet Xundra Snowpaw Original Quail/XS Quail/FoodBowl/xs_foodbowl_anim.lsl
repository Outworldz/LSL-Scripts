// :CATEGORY:XS Pet
// :NAME:XS Pet Xundra Snowpaw Original Quail
// :AUTHOR:Xundra Snowpaw
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:11
// :ID:989
// :NUM:1482
// :REV:1
// :WORLD:Second Life, Opensim
// :DESCRIPTION:
// Original Pet Quail
// :CODE:



integer UNITS_OF_FOOD = 168;

integer food_left;

default
{
    state_entry()
    {
        food_left = UNITS_OF_FOOD;
    }
    
    link_message(integer sender, integer number, string str, key id)
    {
        if (number == 100) {
            // its a decrease message
            integer amount = (integer)str;
            
            food_left = food_left - amount;
            
            // do the pie slice thing
            float cut_amount = ((float)food_left / (float)UNITS_OF_FOOD) * 0.95;
            llSetPrimitiveParams([PRIM_TYPE, PRIM_TYPE_CYLINDER, PRIM_HOLE_DEFAULT, <0, cut_amount, 0>, 0.0, <0, 0, 0>, <1.0, 1.0, 0.0>, <0,0,0>]);
        }
    }
}

