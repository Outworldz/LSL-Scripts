// :CATEGORY:Vendor
// :NAME:Multiitem_Multiauthor_vendor_BACK_B
// :AUTHOR:Apotheus Silverman
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:57
// :ID:537
// :NUM:723
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Multi-item, Multi-author vendor -BACK- By Apotheus Silverman.lsl
// :CODE:

//========== FOREWORD By Apotheus Silverman =========================
//
//the code I have here is for a vendor that rezzes display models. When someone purchases something the payment can be automatically divided between mulitiple people if desired.
//All the information about the items being sold and who gets paid reside in a note card.
//
//
//I have listed a multi-author vendor kit on SLExchange.com that anyone can use to get this vendor system up and running within a few minutes. Most people who have problems getting the scripts working find it to be of incredible value.
//
//The kit is fully open-source, just like the scripts themselves. It includes a working vendor, tutorial notecard and tools to help you along the way.
//
//You will find it HERE: http://www.slexchange.com/modules.php?name=Marketplace&file=item&ItemID=4081
//===================================================================





//    HOW TO USE By Ulrika Zugzwang
//    
//    * Create a vendor prim and put the vendor script in.
//    * Create a previous-button prim and put the previous-button (back-button) script in.
//    * Create a next-button prim and put the next-button script in.
//    * Link all three prims together making the vendor prim the parent prim.
//    * Make a model by rezing an object you want to sell, copy it, shrink it, and remove all contents.
//    * Place the display script inside this model.
//    * Rename the model.
//    * Place the model and the original object for sale into the vendor.
//    * Edit the "Item Data" notecard to include the following data: object name, model name, price, agent keys
////////////////////////////////////////////////////////////////////////////////////
//Sample "Item Data" notecard:
////////////////////////////////////////////////////////////////////////////////////
//Abbotts Float Plane v1.0.1, Float Plane Display Model - red stripe, 500, 
//d9bcb9e0-bfa2-4b8b-a8fc-9d996935ef51|0d994ae7-2d6a-4cd3-bdcf-81c82c35928b
//Abbotts Float Plane v1.0.1 black feathers, Float Plane Display Model - black feathers, 500, 
//d9bcb9e0-bfa2-4b8b-a8fc-9d996935ef51|0d994ae7-2d6a-4cd3-bdcf-81c82c35928b
//Abbotts Float Plane v1.0.1 red-yellow feathers, Float Plane Display Model - red feathers, 500, 
//d9bcb9e0-bfa2-4b8b-a8fc-9d996935ef51|0d994ae7-2d6a-4cd3-bdcf-81c82c35928b
//Abbotts Float Plane v1.0.1 stars stripes, Float Plane Display Model - stars stripes, 500, 
//d9bcb9e0-bfa2-4b8b-a8fc-9d996935ef51|0d994ae7-2d6a-4cd3-bdcf-81c82c35928b
/////////////////////////////////////////////////////////////////////////////////////






default {
    state_entry() {
    }

    touch_start(integer total_number) {
        llMessageLinked(LINK_ROOT, 0, "prev", NULL_KEY);
    }
} // END //
