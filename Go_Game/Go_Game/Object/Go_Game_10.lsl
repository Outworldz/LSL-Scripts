// :CATEGORY:Games
// :NAME:Go_Game
// :AUTHOR:Jonathan Shaftoe
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:54
// :ID:357
// :NUM:489
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Here is the text of the Go Info notecard given out by the info button. This should be saved as a notecard called Go Info and dropped in the inventory of the go game prim.
// :CODE:
Hello and welcome to Jonathan's Go game.

Go is an ancient game from Asia with simple rules but complex gameplay. Two players, white and black, take turns to place a stone on a board. If a group of one colour is completely surrounded by a group of another, it is removed from the board. Note that stones are placed on the junctions of lines, not in the spaces between them, and that diagonals do not count. Once both players agree that there is no further advantage in playing any further stones, the one with the greatest score wins. 

A full description of the rules of Go is beyond the scope of a notecard. There are many websites with descriptions and tutorials, for example:

  http://www.britgo.org/
  
There are two types of scoring in common use,  Japanese or Territory scoring, and Chinese or Area scoring. I've implemented Territory scoring. In practice there is little difference between the two.

Though the basic rules are implemented, there are some unusual circumstances which aren't covered, for example triple ko or seki. In the unlikely event of these occuring, you'll have to sort out how to handle it between yourselves.

I have designed the board to be hopefully as intuitive to use as possible. Before starting a game, the size of the game board can be set by clicking anywhere on the board and selecting from the three commonly used sizes on offer. A 9x9 game can be played relatively quickly, but loses the deeper levels of strategy involved in a larger game. It is a good choice for beginners. A 19x19 game is a proper full sized game, and can take upwards of two hours to complete. 13x13 is a midpoint between the two. 

Join a game by clicking one of the two join buttons. Once two players have joined, the game will start, and only those two players will be able to use the board until the game is finished, or the board is reset. The board can only be reset if no move has been played for a certain amount of time (currently set to 10 minutes) - this prevents boards being left in a used state.

Place a stone on the board by clicking first on the coloured translucent square over the area you want to play in, then on the actual square over the point you want to play. This two step process is to conserve the prim usage of the board. If after the first click you change your mind, you can 'unzoom' by clicking anywhere else on the board. If you try to play somewhere illegal, due to ko or suicide for example, the board will tell you.

Once both players have passed consecutively, the board enters end-game. During this stage, each player in turn is invited to select which of his or her opponent's stones are 'dead' - that is stones whose capture is inevitable and unpreventable, generally all groups lacking two distinct 'eyes' (holes inside the group). Selecting a stone will remove all of the stones in that connected group. Once each player has signified that they have completed doing this, by pressing 'Done', the other is asked if they agree with the stones removed. If not, they can dispute the endgame and play resumes. It is essential to remove dead groups, as the automatic scoring cannot otherwise work.  

Once both players have selected their opponent's dead groups and had their selection confirmed, final scoring is calculated. This can take a while, depending on the size of board and size of territory to be counted. Unfortunately due to the limits of LSL in unusual circumtances, for example on a large board with a large area of territory, this can cause an out of memory error in the script. Please do not enter endgame scoring on a sparsely populated board, use the 'resign' button instead.

Enjoy!

Jonathan Shaftoe
