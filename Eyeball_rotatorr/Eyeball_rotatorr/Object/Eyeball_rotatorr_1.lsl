// :CATEGORY:Eyeballs
// :NAME:Eyeball_rotatorr
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:52
// :ID:293
// :NUM:391
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// oog script onder.lsl
// :CODE:

rotation close = <0.66154, 0.72626, -0.16707, 0.08362>;



rotation open = <0.58685, 0.67261, -0.34808, 0.28645>;




default
{
    
    
state_entry()
    {
        llOwnerSay((string)llGetLocalRot());
        
//example parameters

//      a         b        c        d    
//<-0.19025, 0.62123, 0.59892, -0.46816>;          
      


//    d         c         b        a
//<0.46819, 0.59887, 0.62126, 0.19024>;  A and d revers sign    
        
        
        
        
    }    
    
    
    link_message(integer sender_num, integer num, string str, key id) 
{
    
  
    
    
if(str == "blink" || str == "blink_outer")     
  
{
llSetLocalRot(close);               // close eye 
      
llSleep(0.15);
      



llSetLocalRot(open);               // open eye
            
      
      

return;      
    }

if(str == "eye_close" || str == "eye_close_upper"){
llSetLocalRot(close);
return;
}

if(str == "eye_open" || str == "eye_open_upper"){
llSetLocalRot(open);
return;
}




}


}
// END //
