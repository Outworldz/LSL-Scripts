// :CATEGORY:Sculpt
// :NAME:SL_Sculpt_to_PHP_script
// :AUTHOR:Falados Kapuskas 
// :CREATED:2012-09-18 15:38:34.433
// :EDITED:2013-09-18 15:39:03
// :ID:790
// :NUM:1079
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// OpenLoft - Description
// :CODE:
==Introduction==
Thanks for Downloading OpenLoft!

This tool is designed to help builders create sculpted prims in world. This readme should
give you a rough idea of how to get up and running with open loft.

==Quick Start Guide==

===Step 1===
The first thing you must do is get online web space. Now this isn't as difficult as it sounds. A lot of places have some free limited web space, but you need to be picky about which one you get. The on I used is [http://www.x10hosting.com/] and they've been very good so far.  You must apply for their Intermediate PHP version, which they usually accepts without question. This version will give you access to the required php functions that are otherwise restricted.

A list of other sites can be found here which have a lot of specifications:
    [http://www.free-webhosts.com/free-php-webhosting.php]
    
You'll need the ability to write files with PHP and also the GD library so that PHP can also construct images (the backbone of the sculpt rendering system)

===Step 2===
Rez the Open Loft Tool object.

===Step 3===
Put the URL of the vertext2sculpt.php file in the OpenLoft URL notecard.
--Example--
http://example.com/example_site/vertex2sculpt.php

===Step 4===
Take a copy of the Open Loft Tool object. This is so that you have a copy readily available with the URL already inside of it.

===Step 5===
Click on the Open Loft Tool to bring up a menu and start sculpting

==The Open Loft Tool Menu==

There are eleven buttons that will come up in the open loft menu.

===RENDER===
This will render the current sculpt on your server.  This sends all the verticies to the server
and the php script constructs the image. When the sculpt is successfully created, you will
be notified by an inworld message (Owner Say) denoting the URL of your image.

Click this URL to load the image in your web browser.
Save this image and upload it to Second Life (10L). 
Be sure to use LOSSLESS COMPRESSION, otherwise your sculpt will be distorted

===REZ===
Rezes all of the disks that will help you sculpt.  This is a simple rez that 
puts all of the discs one on top of the other in a column or cylinder

===POLYREZ===
PolyRez or Polynomial Rezing will rez the discs along a curve defined in the Polyrez Parameters
A polynomial you may recognize from algebra, and takes the form  p[0] + p[1]x^1 + p[2]x^2 ... p[n]x^n
The parameters in this notecard define the coeficients of the polynomial.  Depending on the number 
of P values specified, you can rez the discs along a curve that is linear, quadradic, cubic, etc... 

===SHOW===
Shows all the disks if they were previously hidden

===HIDE===
Hides all the disks by making them transparent.  This also hides the nodes from each disk of the nodes
were visible

===VERTS===
Causes all the discs to detach their verticies from the central disc, allowing you to hand-place each vertex manually

===RESIZE===
Resizes all the disks to fit all their detached nodes. Only works if the nodes of the disk are detached.

===ATTACH===
Attaches all the previously detached nodes back to the disc.  The disc now contains node data and can be scaled, moved, and rotated. Thiese operations will result in modifying the nodes internally. The disks will change color indicating that there is node-data stored inside.

If for instance, you had arranged your nodes into a straight line, scaling the disk will also scale that line

===CSEC===
Instructs all detached nodes to attempt a cross-section of physical objects.  The nodes will inch towards the center
of the disc until they either reach the center, or hit a physical object.  If they do not hit a physical object, they will retry this process three times until it ultimately fails, then they will return to the position before the CSECT command.

===ENCLOSE===
The OpenLoftTool will attempt to enclose all nodes/discs of the sculpture. 
USE THIS COMMAND BEFORE THE RENDER COMMAND.

Auto-encloser maximizes the size of the sculpture and ensures that no space is wasted.
If you want to hav very small sculptures you can scale the OpenLoftTool bigger than the discs inside, which will make the resulting sculpture smaller than normal.

===SMOOTH===
Allows you to pick from three different vertex smoothing algorithms.
LINNEAR: Blurs the resulting images slightly, which removes fine detail
GAUSSIAN: Selectively blurs the image, has a tendancy to keep some finer detail
NONE: No bluring at all, a perfect repreduction of the verticies.

==Disk Tool Menu==

Clicking on the Disk tool will give you several options.

===DETACH VERT===
Detach the internal nodes or verticies from the disk, allowing you to edit
them individually.

===Make Point===
Converts the disk into a single point, essentially bringing all verticies
together into the center. The disk will change shape into a small sphere.

===Reset Verts===
Internally, the verticies will be reset to their default position
which is: spaced evenly around the perimeter of the disk.

==Disk Tool Menu: Detached Verticies==

When the verticies of a disk are detached, there will be different
options presented to you when you click on that disk.

===Attach Verts===
This will attach the verticies to the disk again, storing their positions.
The disk will change color indicating that there is node-data stored inside.

===Cross Section===
Instructs all detached nodes to attempt a cross-section of physical objects.  The nodes will inch towards the center
of the disc until they either reach the center, or hit a physical object.  If they do not hit a physical object, they will retry this process three times until it ultimately fails, then they will return to the position before the CSECT command.


==Disk Tool Menu: Linked Disks==
When you link disks together, you make invoke operations on the entire
set of disks.  

NOTE: The order of linking matters.  Please link each node from start to finish
selecting each and every disk individually.  Once they are selected, link them
together.  Click the root node to invide the Linked Disk Menu.

===Copy Verts===
Copys the verticies stored in the root node into every other node
in the link set.

===Clear Set===
Performes the 'Reset Verts' function on each disk in the set

===Resize Set==
Resizes each disk to match the scale of the root node

===Interpolate===

Brings up a menu allowing you to automatically generate steps inbetween the Root Link and the last link. Interpolation is the reason why the order of the links matters.

If you don't know what interpolation means: 
http://en.wikipedia.org/wiki/Interpolation

====Scale====
Interpolates the scale of each disk from Root to End

====Rotation====
Interpolates the rotation of each disk from Root to End

====Node Data====
Each disk has internal node data stored inside of  it.  This
function tries to interpolate each disks node data between the first disk
and the last disk.

Essentially, this produces a shape that appears to transform itself
gradually from the first disk into the last disk.

===Notes About Linking===
Be sure to unlink your disks after you are done playing
with the link set.  The Open Loft Tool menu doesn't 
work too well when the disks are linked together.
