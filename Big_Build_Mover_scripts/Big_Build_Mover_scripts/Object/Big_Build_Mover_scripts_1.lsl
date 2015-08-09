// :CATEGORY:Building
// :NAME:Big_Build_Mover_scripts
// :AUTHOR:Poppet McGimsie
// :CREATED:2010-11-18 20:51:48.930
// :EDITED:2013-09-18 15:38:48
// :ID:89
// :NUM:121
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// INSTRUCTIONS// // If you have a complex build that is assembled from a rez box in SL, the scripts described here will allow you to store information about the components of the build on the components themselves. Then once the components of the build are transferred from SL to another grid, you can use the scripts described here in a rez box to reassemble the complex build on the new grid.// // DISCLAIMERS// 
// As of this writing (November 2008), not all content will transfer completely between SL and other grids. For example, the contents of objects (scripts, objects, animations, sounds, etc.) will not always transfer successfully, even when those contents are in the root prim of the linkset being transferred. Futhermore, contents of child prims of linksets will not be transferred at all. It is best therefore to "clean" any build you want to transfer by removing all contents from all prims in the linked sets you will be moving.
// 
// You must have full permissions on the rezz box you are using, as well as all of the build components, in order to move the build from SL to a new grid.
// 
// This export/import system is meant for experienced builders who have complex builds in SL that they want to move to new grids. You will need to be fairly comfortable with rezzers like Builders' Buddy in the LSL Library, or its clones (Rez Foo, Rez Faux, etc.). Please do not contact me for support in using this system. However, if you find bugs, please let me know.
// 
// NOTE: the scripts in the box have been set to "not running." Set the scripts to running before trying to use them.
// 
// INSTRUCTIONS
// 
// 1) Get build ready for export. (use BUILD EXPORTER described below)
// 
// - take out your rezz box and rez your build.
// 
// - clean out the contents of the build components, if yous wish, since they won't transfer correctly anyhow. Clean out the contents of the rezz box.
// 
// - place the BIG BUILD EXPORTER COMPONENT script in the root prim of each of the components.
// 
// - place the BIG BUILD EXPORTER BASE script in the rezz box.
// 
// -LEFTCLICK the rezzbox
// 
// 
// 
// Your components are now ready to be exported. NOTE: you will see that the process has resulted in replacing the name and decription fields of the components with information about their positions and rotations in SL. DO NOT change that information!
// 
// -take each component of the build into your inventory individually (rightclick each linkset and choose "Take"). Make sure they are still "full perms" (rightclick inventory entry and pick "properties" and set them to full perms) and there has been a bug sometimes that results in resetting permissions when items are taken into inventory.
// 
// You can now delete the rezz box.
// 
// 2) Save build components to hard drive. (use SECOND INVENTORY or similar utility)
// 
// 3) Upload build components from hard drive to new grid. (use SECOND INVENTORY or similar utility)
// 
// 4) Restore build on new grid.
// 
// You'll need to make copies of the importer scripts on the grid where you want to use them. Edit the scripts in SL, select all and copy the script. Paste into a text file if you can't have both SL and the other client running at the same time, or paste directly into a new script on the new grid. Save the script and rename it so that it matches the name in SL to avoid confusion. NOTE: copies of these scripts are also available in the Wright Plaza freebie garden on the OSgrid.
// 
// -Rez each component of the build individually on the new grid, and place the "BIG BUILD IMPORTER COMPONENT" script in the root prim. Take component back into inventory. Probably best to place the components in a new folder so you don't get them mixed up with the ones that don't have a script in them.
// 
// -Rez a cube to use as a rez box. Place the "BIG BUILD IMPORTER BASE" script within the rez box. Place the components containing the importer script inside the rez box with the importer base script.
// 
// -Leftclick the rez box and select BUILD to assemble the components. To move the build, leftclick rez box and select CLEAN then move the rez box and re-rezz the build. When you are done, leftclick rez box and pick DONE to remove the component scripts from the components.
// :CODE:
// SL side exporter script

//BIG BUILD EXPORTER BASE SCRIPT

//This script is made available for free use, and it must remain that way. Poppet McGimsie, November 2008.

//for SL side: Place this script in the rez box of the build to be exported from SL (clear out any scripts in the rez box first to avoid interference).

integer PRIMCHAN = 111;


default {



touch_start (integer total_number)
{



llShout(PRIMCHAN, llDumpList2String([ llGetPos(), llGetRot() ], "|"));

}
}
