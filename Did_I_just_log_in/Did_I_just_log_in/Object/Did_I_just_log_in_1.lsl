// :CATEGORY:Attachment
// :NAME:Did_I_just_log_in
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-03-05 13:12:16.960
// :EDITED:2013-09-18 15:38:51
// :ID:236
// :NUM:324
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// This is a basic test of whether a prim rezzed at about the same time as the avatar.  
// :CODE:
// Based on a post by Innula Zenovka
// Copyright Linden Lab
// 

vector v;

default
{
    state_entry()
    {
       // in case you need to do something when reset
    }

    on_rez(integer p){
        v = llGetAgentSize(llGetOwner());
        if (v.z == 1.9){//almost certainly just logged in
            llSetTimerEvent(1.0);
        }
        else {
           // The prim was rezzed or attached.
        }
    }
    

    
    timer(){
        v = llGetAgentSize(llGetOwner());
        if(v.z!=1.9){
            llSetTimerEvent(0.0);
            // the prim was rezzed when attached to an avatar
        }
    }
}
