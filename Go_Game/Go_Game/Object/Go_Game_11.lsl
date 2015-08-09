// :CATEGORY:Games
// :NAME:Go_Game
// :AUTHOR:Jonathan Shaftoe
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:54
// :ID:357
// :NUM:490
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// And finally, here's some documentation I did for myself on the many link messages used. If you're going to try to figure out how it all works or change the code, this will probably be invaluable!
// :CODE:
// Messages
// 0. From MainScript to Button, Sensor - sets current player, black or white, and resets Sensor to zoom1
// 1. From MainScript, to JoinButton, Button. Sets SIZE
// 2. From MainScript, to ?. Sets SIZE and gGameSize (depricated?)
// 1 & 2 From JoinButton to MainScript - sets who's playing black/white
// 3. From MainScript, to Tile, Sensor, sets gGameSize, gX/YSensors and SIZE, sent with set_size
// 4. From Sensor to Logic, turn attempt made, coordinates passed.
// 5. From Sensor to Sensor. coordinates of zoom from zoom1 to zoom2.
// 10. From Button, to Logic, player pressed 'pass'
// 11. From Button to Main, player pressed 'done'
// 12. From Button to Main, player pressed 'reset'
// 13. From Button to Main, player pressed 'resign'
// 14. From Button to Main, player pressed 'info' 
// 15. From Logic, to Tile, endgame disputed, reset tile to previous state
// 20. From Sensor to Sensor, go to waiting state, move attempted
// 21. From Logic to Sensor, go back from waiting state to zoom2, attempt to move failed.
// 100. From Main to Logic, sets gGameSize and SIZE, sent with every set_size
// 101. From Logic, to Main, sets whose turn and whether we're in endgame.
// 102. From Logic to Main, entering endgame after two passes
// 103. From Main to Logic, sets current player/endgame state
// 104. From Main to Logic, whether player disputes endgame/dead groups or not
// 105. From Logic to Main and Sensors, doing scoring (so sensors hide)
// 106. From Logic to Main, from scoring to gameover
// 201. From Logic to Tile, display piece, x, y, colour (1, 2) passed (displays immediately) or 0 to remove (doesn't display until ..).
// 202. From Logic to Tile, display result of removes from 201 messages.
// 203. From Logic to Tile, clears backup states (for endgame disputes) as agreed.
// 301. From Tile to TileFace, do actual display for given state.
// 400. From Logic to Main, send new captures done by given player for score update
// 500. From Logic to Main, turn played, so do message and do sound
// 999. From Main, to JoinButton, Sensors, Tile, Logic - game reset.

// Main sends: 0, 1, 2, 3, 100, 103, 104, 999
// Main receives: 1, 2, 11, 12, 13, 14, 101, 102, 105, 106, 400, 500

// TileFace sends: none
// TileFace receives: 301

// Tile sends: 301
// Tile receives: 3, 15, 201, 202, 203, 999

// Logic sends: 15, 21, 101, 102, 105, 106, 201, 202, 203, 400, 500
// Logic receives: 4, 10, 100, 103, 104, 999

// Button sends: 10, 11, 12, 13, 14
// Button receives: 0, 1

// Sensor sends: 4, 5, 20
// Sensor receives: 0, 3, 5, 20, 21, 105, 999

// JoinButton sends: 1, 2
// JoinButton receives: 1, 999
