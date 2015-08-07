// :CATEGORY:Rezzers
// :NAME:Simple_Casting
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:02
// :ID:758
// :NUM:1045
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Simple Casting.lsl
// :CODE:

//global variables
integer handle; //used to track a listener


//Methods
startup(){ //Method name. 
    llListenRemove(handle);                     //Removes any old listeners
    handle = llListen(0,"",llGetOwner(),"");    //Sets the wand to listen to the current owning agent
}

//States
default //The Default State.
{
    
    //Event that runs when the current state is entered.
    //In this case, whenever the script is resaved.
    state_entry(){
        startup(); //Startup to set listener if you change the script
    }
    
    //Event that runs when the object is rezzed
    //parameters (1) : an integer value passed by the rezzing object. 
    //If it is rezzed by dragging out of the inventory the value is 0.
    on_rez(integer para){
        startup(); //Startup for current owning agent
    }
    


    //Event that runs whenever a listener "hears" text
    //Parameters:
    //(1) channel: the channel that the text occured on
    //(3) id : the "key" of the agent/object that said the text
    //(4) message : the text that was said
    listen( integer channel, string name, key id, string message )
    {
        if(llGetInventoryType(message) == INVENTORY_OBJECT) { //Did the owning agent say a name of a spell

            //MATH BLOCK
            rotation rot = llGetRot(); //Get the holder's rotation
            vector fwd = llRot2Fwd(rot); //Figure out which direction is forward
            vector pos = llGetPos(); //what is the holder's location
            pos = pos + fwd; //Set the location a litte infront of them
            pos.z += 0.75; //Set the location a little bit up
            
            llRezObject(message,  pos, fwd * 10 , rot, 42); 
            //Rezzing parameters:
            //(1) message : rez the object named by the holder
            //(2) pos : rez the object at the location
            //(3) fwd * 10 : rez the object with a velocity of fwd * 10
            //(4) rot : rez the object facing rot
            //(5) send the value 42 to the object that is rezzed (useful in adv. spells)
            
        }
         
    }


}
// END //
