// :CATEGORY:Inventory Giver
// :NAME:Help_Station
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:54
// :ID:379
// :NUM:526
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Help Station.lsl
// :CODE:

//
//   Help Station
//
//   Gives a note card to a person clicking on it.  
//  
//   

vector touched_color = <1,0,0>;             //  The color when touched 
vector normal_color = <1,1,1>;              //  The normal color (when not touched)
string note_name = "Yadni s Domain";          //  The name of the notecard you want to give

default
{
    state_entry()
    {
        llSetColor(normal_color, -1);
    }

    touch_start(integer total_number)
    {
        //  Make sound and switch color when touched
        llPlaySound("Switch", 1.0);
        llSetColor(touched_color, -1);
        //  Find out who clicked, and give them a note card
        key giver;
        giver = llDetectedKey(0);  
        string name = llDetectedName(0);
        if (giver != NULL_KEY)
        { 
            llGiveInventory(giver, note_name);
            //llEmail("philip@lindenlab.com","Yadni s Domain", name);
        }
    }
    touch_end(integer total_number)
    {
        //  Change the color back when click released
        llSetColor(normal_color, -1);
    }
}// END //
