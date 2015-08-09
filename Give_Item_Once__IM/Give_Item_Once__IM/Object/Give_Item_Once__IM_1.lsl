// :CATEGORY:Inventory Giver
// :NAME:Give_Item_Once__IM
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:54
// :ID:352
// :NUM:475
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Give Item Once - IM.lsl
// :CODE:

integer owneronly = 0;
key owner;

list people;
 
// Functions
integer isNameOnList( string name )
{
    integer len = llGetListLength( people );
    integer i;
    for( i = 0; i < len; i++ )
    {
        if( llList2String(people, i) == name )
        {
            return TRUE;
        }
    }
    return FALSE;
}
 
 
 
 default
{
    state_entry()
    {
        owner = llGetOwner();        
    }

    touch_start(integer total_number)
    {
        integer i;
        for (i=0;i<total_number;i++)
        {
            key target = llDetectedKey(i);
        
            if ( (target != owner) && (owneronly == 1) )  // person clicking isn't owner and owneronly is set;
            {
                llInstantMessage(target,"Sorry, only the owner is allowed to get my contents.");
                return;
            }
            list inventory_types = [INVENTORY_BODYPART,INVENTORY_CLOTHING,INVENTORY_LANDMARK,INVENTORY_NOTECARD,INVENTORY_OBJECT,INVENTORY_SCRIPT,INVENTORY_SOUND,INVENTORY_TEXTURE];
            integer inventory_count = llGetListLength(inventory_types);
            integer j;
            integer k;
            integer type;
            integer typecount;
            string myname = llGetScriptName();
            string objectname;

            string name = llKey2Name(target);
            
            if (isNameOnList(  name ))
            {                            
                llSay(0,"Sorry, only one per avatar");
                return;
            }
            llInstantMessage(owner, name + " found " +  llGetObjectName( ));
            people += name;
            for (j=0; j<inventory_count;j++)
            {
                type = llList2Integer(inventory_types,j); // get the next inventory type from the list
                typecount = llGetInventoryNumber(type);  // how many of that kind of inventory is in the box?
                if (typecount > 0)
                {
                    for (k=0; k<typecount;k++)
                    {
                        objectname = llGetInventoryName(type,k);
                        if (objectname != myname)  // don't give self out so the user doesn't get fifty thousand copies.
                        {
                        
                                llGiveInventory(target,objectname);
                                 llRemoveInventory( objectname);
                           
                        }
                    }
                }            
            }
        }
    }
}
// END //
