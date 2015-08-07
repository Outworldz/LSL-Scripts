// :CATEGORY:Rezzers
// :NAME:Rezzer_with_extended_menu
// :AUTHOR:anonymous
// :CREATED:2011-08-24 17:27:34.490
// :EDITED:2013-09-18 15:39:01
// :ID:706
// :NUM:962
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Rezzer_with_extended_menu
// :CODE:
//start of script

// Global constants - should be changed if there are any other holo-emitters in the sim, both here and in all other scripts
integer delete_channel = -1110020;
integer menu_channel   = -2220020;
integer HE_channel     = -3330020;
// Global variables

integer menu_listen;
integer menuPosition;

key Avatar; // the last person who touched this;

clear_scene()
{
    llRegionSay(delete_channel, "delete"); // Sends a "delete" message to the entire sim on the delete_channel
}

Menu()
{
     // Generate the menu of scenes by scanning the holo-emitter's inventory
     list options = ["Clear"]; // even if there are no scenes in the holo-emitter, one option is always to clear the scene

    integer num_scenes = llGetInventoryNumber(INVENTORY_OBJECT); // = number of objects in the holo-emitter's inventory
    if (menuPosition >=  9)        // add a back button if we are past the 1st menu
        options += "<<<";
    else
        options += "-";

    if (num_scenes > menuPosition+9)    // add a forward button if there are more scene
        options += ">>>";
    else
        options += "-";

    if (num_scenes>0)
    {
        integer scene_nbr = menuPosition;
        for ( ; scene_nbr<num_scenes; scene_nbr++)
        {
            options = options + [llGetInventoryName(INVENTORY_OBJECT, scene_nbr)]; // appends another scene to the list of options
        }
    }
    options = llDeleteSubList(options,12,999);    // kill off the ends
    
    llDialog(Avatar, "Select the scene you would like to see:", options, menu_channel);


}

default
{
    state_entry()
    {
        llSay(0,"Ready");
        llListen(HE_channel,"",NULL_KEY,"ping");
        menuPosition = 0;
        menu_listen = llListen(menu_channel, "", "", "");    
    }

    touch_start(integer total_number)
    {
        Avatar = llDetectedKey(0);
        Menu();
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if ((channel==HE_channel) && (message=="ping"))
        {
            //llSay(0,"I heard a ping, so I'm replying with my position now (on the HE_channel).");
            vector HE_pos = llGetPos(); // = holo-emitter position <x,y,z>
            string str = (string)HE_pos.x+","+(string)HE_pos.y+","+(string)HE_pos.z;
            llRegionSay(HE_channel, str);
            //llSay(0,"My position string is "+str);
        }
        else if (channel==menu_channel)
        {
            if (message=="Clear")
            {
                clear_scene();
                Menu();
            }
            else if (message=="<<<")
            {
                menuPosition -= 9;
                if (menuPosition <0)
                    menuPosition  = 0;
                Menu();
            }
            else if (message==">>>")
            {
                menuPosition += 9;
                Menu();
            }
            else // message = the name of the scene-container to rez
            {
                clear_scene();
                llRezAtRoot(message, <0.0,0.0,9.0>+llGetPos(), ZERO_VECTOR, ZERO_ROTATION, 1);
            }
        }
    }
}





