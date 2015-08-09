// :CATEGORY:Lists
// :NAME:Multidimensional_Array_API
// :AUTHOR:Christopher Omega
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:57
// :ID:533
// :NUM:718
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// This script allows you to store data in lists as you would in a C++ or Java multidimensional array. It is a bit more flexible than those language's arrays, since it allows you to dynamically resize each dimension; You don't have to define the size of the array before you use it. If you ever ran into the "Runtime Error: Lists cannot contain lists" message and really needed a list within another, this is what you can use.// // For example, say you had a chessboard with each square a different color. Your script can refer to each color using a two-dimensional array; one number for the row another for the column of the particular color.
// :CODE:
default {
    state_entry() {
        integer SQUARES_ON_SIDE = 12;
        // Randomly assign colors to each square:
        list colorArray;
        integer row;
        integer col;
        for (row = 0; row < SQUARES_ON_SIDE; ++row) {
            for (col = 0; col < SQUARES_ON_SIDE; ++col) {
                vector color = <llFrand(1), llFrand(1), llFrand(1)>;
                colorArray = setArray(colorArray, [row, col], [color]);
            }
        }
        
        // Get the color of the square at row 1, column 2:
        vector squareColor = (vector) llList2String(getArray(colorArray, [0, 1]), 0); // Note that arrays, like LSL's lists, are 0-based; they start counting at 0, not 1.
        // ...

        // Get the colors of all the squares in row 4:
        list rowColors = getArray(colorArray, [3]);
        // ...
    }
}
