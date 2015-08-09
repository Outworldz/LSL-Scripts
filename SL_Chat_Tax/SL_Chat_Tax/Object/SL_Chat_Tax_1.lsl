// :CATEGORY:Chat
// :NAME:SL_Chat_Tax
// :AUTHOR:Max Case 
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:03
// :ID:782
// :NUM:1070
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Originally deployed on New York Law School's Democracy Island, this tool may assist creating a more reflective classroom experience. Students pay money into the object and then are "taxed" a Linden for each character they type. This sounds counterintuitive, right? Of course you want students to speak up and contribute. But when used in combination with some other incentive to contribute in a meaningful' way, this script may keep the chatter down and the students focused on the subject. The term "signal to noise ratio" has some relevance here! On the other hand, this may be stultifying and Orwellian. Your call.
// :CODE:
//=============================================================

//SL CHAT TAX, 0.3

//Calculates chat participation by the character and
// TODO: debits funds on account for each participant

//Copyright (C) 2006 Max Case

//=============================================================

 

//LICENSE ===============

//This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA. See: http://www.gnu.org/licenses/licenses.html

//SETTING UP THE OBJECT ===============
//Currently people can pay off their debt.
// Host can insist they pay into the pot.
//
// Some variables to play with at the top. Most are self explanitory - wordcost, charcost
// Nice thing is, it deals with fractions of lindens.
//TODO - Have host do refund of left over money at end of event.
//Let me know what other factors you would find useful. Maybe Time of event as multiplier?
//


float wordcost = .02; //Cost per word
float charcost = .001; //Cost per character- someone use longer words?

float gf_running_total; //Tracks running total of all outstanding.
                       
                        //This list holds money owned, name of debtor.
list lg_owed_name = []; //0 = total owed , +1 = Name 

//   fn_check_list
//  Checks if name on list, if no, return -1, else returns index #
integer fn_check_list( list to_check, string name)
{
    // dump the name into a temp list, since we will use list functions on this info
    list new_name_temp = [name];
    integer indexReturn = llListFindList(to_check, new_name_temp);
    return indexReturn;
}

//Adds a name to a list :), in this case, our master list.
//just a utility function
fn_add_to_list( string name )
{
    // dump the name into a temp list, since we will use this to add to the list.
    list new_name_temp = [0.0, name];
   
    //add name to list.
    lg_owed_name += new_name_temp ;
}


//this calculates charge
//TODO - Ability to charge more for words on 'hit list'
fn_calc_charge(string name,key id, string msg)
{
    list number = llParseString2List(msg, [" "], []);
   
    float owed = ((float)llGetListLength(number) ) * wordcost + ( (float)llStringLength(msg) * charcost) ;
   
    integer checkList = fn_check_list( lg_owed_name, name ) ;
   
    //Check if they have already spoken
    if( checkList  == -1 )
    { //never voted before?
        fn_add_to_list( name);
        checkList = fn_check_list( lg_owed_name, name ) ;
    }
      
    fn_process_speech(checkList,owed, id );  

}

//Here's where update charges on list
fn_process_speech(integer speaker_id, float charge, key id)
{
    integer speakerIndex = speaker_id; //where the name is.
    integer owedIndex = speakerIndex - 1; //where the votes are in list
   
    float current_owed = llList2Float(lg_owed_name, owedIndex )  ;
   
    list tempadd = [ charge + current_owed ] ;
    lg_owed_name = llListReplaceList(lg_owed_name, tempadd, owedIndex, owedIndex);
}

//Says the current charges. Used in Touch event below
//mode sets it to SETTEXT mode(1) or SAY mode(0) or ownersay 2
fn_report(integer mode)
{
    integer i;
    integer looplength = ( (llGetListLength(lg_owed_name) )/2 );
   
    llSay(0, "Speech Taxation System BETA Update");
  
    string reportmessage;
   
    list tempsort = llListSort(lg_owed_name, 2, FALSE);
    for (i = 0; i < looplength; i++)
    {
        string towed = llList2String(tempsort, i*2);
        if(mode == 1) reportmessage = "";
        reportmessage = reportmessage + llDeleteSubString(towed , llSubStringIndex(towed,".")+3, -1)+ "$L :";
        reportmessage = reportmessage  +  llList2String(tempsort, ((i*2)+1));
        if(mode == 0)
        {
           llSay(0, reportmessage);
        }
        else if(mode == 2)
        {
            llOwnerSay(reportmessage);
        }
        else if(mode == 1)
        {
            reportmessage += "\n" ;
        }

    }
   
    if(mode == 1)
    {
        llSetText( reportmessage, <1,1,1>, 1.0);
    }
}

default
{
    state_entry()
    {
        //Turn on the listen...
        llListen(0, "", NULL_KEY,"");
   
        llSay(0, llGetObjectName()+" Online");
        llSetText(llGetObjectName()+" Online", <1,1,1>, .5);      
    }

    listen(integer channel, string name, key id, string msg)
    {
        //Check if it's Object talking
        if ( llGetAgentSize(id) == ZERO_VECTOR ) return;
        
        //This calculated cost, then processes (updates) the list...
       fn_calc_charge(name, id, msg);  
        fn_report(1);
    }

    //Someone wants to pay their debt...
    money(key id, integer amount)
    {
        //We flip the amount, so it gives person credit
        float owed = (float)(-amount) ;
       
        integer checkList = fn_check_list( lg_owed_name, llKey2Name(id)) ;
       
        //Check if they have already spoken
        if( checkList  == -1 )
        { //never voted before?
            fn_add_to_list( llKey2Name(id));
            checkList = fn_check_list( lg_owed_name, llKey2Name(id)) ;
        }
       
        fn_process_speech(checkList, owed, id ); 
        
        llSay(0, llKey2Name(id) + " pays their debt to society.");
         
        fn_report(1);       
    }

    on_rez(integer foo)
    {
       // llResetScript();  
    }

    touch_start(integer total_number)
    {   //you can wear as HUD - this checks - if HUD, won't other telling to pay into it.
       if( llGetAttached() < 31)
       {   
           llSay(0, "Pay Into Machine To Pay Speech Tax. Speech Ain't Free You Know.");
       }
       fn_report(2);
    }
}
