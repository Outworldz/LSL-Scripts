// :CATEGORY:Sculpt
// :NAME:SL_Sculpt_to_PHP_script
// :AUTHOR:Falados Kapuskas 
// :CREATED:2012-09-18 15:38:34.433
// :EDITED:2013-09-18 15:39:03
// :ID:790
// :NUM:1093
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Change  Log
// :CODE:
#summary Change Log for Open Loft
==v2.0==
*Completely Redone*

 * Fixed many bugs
 * Support for Oblong Sculpts (eg: 16x64 , 8x128 , 4x256 )
 * Removed Sculpt Preview (No longer works for oblong sculpts)
 * Removed PolyRez
   * Disks are positioned by Bezier Curves
   * Can add/remove anchor/control points
   * Bezier can be turned on/off with the menu buttons
 * Changed Default Menu
 * Extracted functions into duplicateable Tools
   * Encloser Tool
   * Mirror Tool
     * Mirror position around and combination of x/y/z axes
   * Copy Tool
     * Copy ranges of disks onto other ranges
     * Mirror ranges of disks onto other ranges
     * Interpolate Scale / Position / Rotation / Node Data

==v1.3==
 * Added a work-around for image convolution (Smoothing functions) on PHP versions < 5.10
 
==v1.2==
 * Added Sculpt Preview
    This object allows you to view and save your sculpty in-world without the assistance of a webserver
    Rez the object next to your completed sculpture, press the green button at the top. 
    Now when you press RENDER, the sculpt preview object will draw the texture on the surface.
    To save this texture, simply sit on the orb and configure your SNAPSHOP window.
    You save this texture to your harddrive and play with it outside of SL, or upload it right away for 10L
==v1.1==
 * Added color to each node and row indicating their LOD.
   * RED = LOD Low
   * GREEN = LOD Medium
   * BLUE = LOD High
 * Increased the threshold that resets nodes when they are stuck trying to collide with a physical object
 * Added utility script to make and object physical and keep it in place
 * Fixed vertex2sculpt.php
    It now creates the directories that it previously was missing
 * Added reminder to replace the URL in the Open Loft Tool object
 * Added reminder to ENCLOSE a sculpt before RENDER
