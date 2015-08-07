// :CATEGORY:Animation Stand
// :NAME:MultiPoseScript
// :AUTHOR:Teddy Wishbringer
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:58
// :ID:545
// :NUM:742
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// MultiPoseScript.lsl
// :CODE:

// Animation Stand (Stand Script)
// by Teddy Wishbringer
   // 
   // Thanks go to Argent Stonecutter for assistance in streamlining and bug squishing. :)
   //
   // Allows owner to cycle through all the animations stored within the stand by
   // clicking on BACK and NEXT buttons. This script goes in the stand, which
   // should be the root prim in the linkset.  Linkset requires two additional
   // prim buttons (forward and backward) with each named 'next' and 'back' respectively.
   //
   // NOTE: This script is made free, and may be destributed as long as you
   // do not charge for it, the comments remain untouched and this script
   // remains end-user modifiable.
   
   
   // User adjustable settings
   
vector animation_offset = <0,0,1.5>; // Animation offset from stand
string base_float_text = "Now playing animation: "; // Float text prefix
vector color_float_text = <1,1,1>; // Floating text colour
float alpha_float_text = 1.0; // Floating text alpha transparency
   
   // System settings - Do Not Change Anything Below!
   
   integer animation_qty; // Number of animations available
   integer animation_current; // Inventory number of current animation
   string animation_name; // Name of current animation
   string new_animation_name; // Name of next animation.
   string float_text; // Used when we evaluate the entire floating text message
   key avatar; // Key of the avatar who's sitting on me
   
update_inventory()
   {
       llSetText("Updating animation list...", color_float_text,alpha_float_text);
       animation_qty = llGetInventoryNumber(INVENTORY_ANIMATION); // Check how many anims we have?
       if (animation_qty > 0)
       {
           llWhisper(0, "Total animations loaded in this stand: " + (string)animation_qty);
           set_anim(0);
       }
       else
       {
           llSetText("No Animations Found.. Offline", color_float_text,alpha_float_text);
       }
   }
   
   // Set the next animation available as the active one
   set_anim(integer inventory_number)
   {
       // Get the name of the animation is inventory position (inventory_number)
       new_animation_name = llGetInventoryName(INVENTORY_ANIMATION,inventory_number);
       // Update the floating text to display new animation, and the number out of total available
       float_text = base_float_text + new_animation_name + "\n(" + (string)(animation_current + 1) + " of " + (string)animation_qty + ")";
       llSetText(float_text, color_float_text,alpha_float_text);
           
       // Get the key of the avatar on the stand (or if none is present)
       avatar = llAvatarOnSitTarget();
       
       if (avatar != NULL_KEY) // Is avatar is still posing, if so then..
       {
           llStopAnimation(animation_name); // Stop current animation
           llStartAnimation(new_animation_name); // Start next animation
       }
       // Set the new animation name as the current
       animation_name = new_animation_name;
   }
   
   default
   {
   
       on_rez(integer num)
       {
           llResetScript(); // Reset the script
       }
   
       state_entry()
       {
           update_inventory(); // Perform an inventory update and determine how many animations we have
   
           if (animation_qty > 0)
           {
               llSetSitText("Pose");
               llSitTarget(animation_offset,ZERO_ROTATION);
               animation_name = llGetInventoryName(INVENTORY_ANIMATION, 0);
               set_anim(animation_current);
           }
                
       }
     
         // If touched, detect touch location and do the right thing
         touch_start(integer num)
         {
                 // Get the name of the prim touched
                 string where = llGetLinkName(llDetectedLinkNumber(0));
   
           if (where == "next") // The next button was pressed
           {
               animation_current++; // Increment the animation inventory pointer
               if ((animation_current + 1) > animation_qty) // Have we reached the last animation in the object?
               {
                   animation_current = 0; // We have, so wrap around back to the first one
               }
               set_anim(animation_current);
           }
           else if (where == "back") // The back button was pressed
           {
               animation_current--; // Decrement the animation inventory pointer
               if (animation_current < 0) // Have we reached the first animation in the object?
               {
                   animation_current = animation_qty - 1; // We have, so wrap around to the last one
               }
   
               set_anim(animation_current); // Update the animation played by the stand
           }
       }
   
       changed(integer change)
       {
           if (change & CHANGED_INVENTORY) // Test for a changed inventory
           {
               update_inventory();
           }
           
           // The object's sit target has been triggered
           if (change & CHANGED_LINK) // Test for a changed link
           {
               avatar = llAvatarOnSitTarget();
               if(avatar != NULL_KEY) // Is that changed link an avatar?
               {
                   llRequestPermissions(avatar,PERMISSION_TRIGGER_ANIMATION);
               }
               else
               {
                   if (llGetPermissionsKey() != NULL_KEY)
                   {
                       llStopAnimation(animation_name);
                   }
               }
           }
       }
       
       run_time_permissions(integer perm)
       {
           if (perm & PERMISSION_TRIGGER_ANIMATION)
           {
               llStopAnimation("sit");
               llStartAnimation(animation_name);
           }  // other permission checks would follow 
       }
   } 


// END //
