// :CATEGORY:FootBall
// :NAME:Football
// :AUTHOR:Niklas Waller
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:53
// :ID:331
// :NUM:444
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Here's a small script for a football. The ball can be kicked by just walking against it. Touching it causes the ball to bounce up in the air a couple of feet. You can also talk to it by saying "kick" which causes the ball to move with a certain vector strength and direction. "High kick" makes the ball going forward up in the air.
// :CODE:

default {
state_entry () {
llListen (0, "", "","");
// Make sure that Physical is turned on
llSetStatus (1, TRUE);
}

collision_start (integer total_number) {
// Get the vector that points from the kicker to the ball
vector diff = llGetPos() - llDetectedPos(0);

// Force the z coordinate up
diff.z = .1;

// Scale the vector to a fixed length
vector kick_vector = llVecNorm(diff)*5;

// Apply the kick vector to the ball
llApplyImpulse(kick_vector, FALSE);
}

listen (integer channel, string name, key id, string message) {
if (message == "kick") {
// Get the vector that points from the kicker to the ball
vector diff = llGetPos() - llDetectedPos(0);

// Force the z coordinate up
diff.z = .1;

// Scale the vector to a fixed length
vector kick_vector = llVecNorm(diff)*10;

// Apply the kick vector to the ball
llApplyImpulse(kick_vector, FALSE);
}
else if (message == "high kick") {
// Get the vector that points from the kicker to the ball
vector diff = llGetPos() - llDetectedPos(0);

// Set the z-coordinate high up
diff.z =500;

// Scale the vector to a fixed length
vector kick_vector = llVecNorm(diff)*25;

// Apply the kick vector to the ball
llApplyImpulse(kick_vector, FALSE);
}
}

touch_start (integer total_number) {
// Create a manual kick vector where only the z-coordinate has a value separate from zero
vector kick_vector = <0.0,0.0,0.0>;

// Apply the kick vector to the ball
llApplyImpulse(kick_vector, FALSE);
}
}
