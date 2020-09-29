
default {
    attach(key attached) {
        if (attached != NULL_KEY) {
            llRequestPermissions(attached, PERMISSION_TRIGGER_ANIMATION);
        } else {
            llStopAnimation(llGetInventoryName(INVENTORY_ANIMATION, 0));
        }
    }
    run_time_permissions(integer perms) {
        if(perms & (PERMISSION_TRIGGER_ANIMATION))
        {
            llStartAnimation(llGetInventoryName(INVENTORY_ANIMATION, 0));
		}
	}
}
