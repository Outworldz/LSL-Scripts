// :CATEGORY:Animal
// :NAME:Breedable_Animal_Pets_Script
// :AUTHOR:Xundra Snowpaw
// :CREATED:2011-07-25 13:48:33.917
// :EDITED:2013-09-18 15:38:49
// :ID:115
// :NUM:167
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// FoodBowl: xs_foodbowl_anim.lsl
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
