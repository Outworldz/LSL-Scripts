// :CATEGORY:Particles
// :NAME:Special_Particle_Sensor_Instruction
// :AUTHOR:Ama Omega
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:05
// :ID:820
// :NUM:1130
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Special Particle Sensor Instructions [NOTECARD] .lsl
// :CODE:

 Special Sensor Apparatus: Points and emits particles at a target. 
Hello everyone! 
In responce from popular demand in this thread, I created an apparatus to point at and emit particles at a sensed target. This is useful if you want to easily find an object via a visual cue. 

This apparatus requires 17 objects, one brain object, the parent of the linked set, and 16 pointer objects. 

See the attachment for an example of the setup. (The white cube is the brain, the cones are the pointers). 

Scripts 

The Brain Script: 
=======
See: Special Particle Sensor "Brain"
=======

The pointers' script: 
(put one of these in every pointer) 
=======
See: Special Particle Sensor "Pointer"
=======
To activate the apparatus: 

Say 

#find <objectName> 

Examples: 
#find Object 
Emits particles and points at all things within range named "Object". 

#find Christopher Omega 
Emits particles and points at all things within range named "Christopher Omega" 

Say: 
#reset 
To reset the particle emitters to their default rotations, and turn off their particle systems. 

Enjoy  

==Chris
// END //
