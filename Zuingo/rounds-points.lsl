list lSides = [3, 7, 4, 6, 1];
list lOffsets = [
        <-0.380, 0.45, 0.0>,
        <-0.450, 0.45, 0.0>,
        <-0.100, 0.45, 0.0>,
        <-0.452, 0.45, 0.0>,
        <-0.515, 0.45, 0.0>
        ];


ssSetSide(integer roundNum, integer side) {
    float x; float y;
    vector offset = (vector)llList2String(lOffsets, side);
    roundNum;
    
    
    x = (roundNum % 10) / 10.0 + offset.x;
    y = offset.y - (roundNum / 10) / 10.0;
    
    if (x < -1.0) x += 1.0;
    if (y < -1.0) y += 1.0;
    
    llOffsetTexture(x, y, llList2Integer(lSides, side));
    
}

default {
    state_entry() {
        llSetAlpha(0.0, 7);
        integer n = lSides != [];
        while(n--) {
            vector offset = (vector)llList2String(lOffsets, n);
            llOffsetTexture(offset.x, offset.y, llList2Integer(lSides, n));
        }
    }

    link_message(integer sender, integer num, string msg, key id) {
        if (msg == "currentround") ssSetSide(num, 0);
        if (msg == "playerPoints") {
            string points = (string)num;
            while(llStringLength(points) < 6) points = "0" + points;
            
            ssSetSide((integer)llGetSubString(points, 4, 5), -1);
            ssSetSide((integer)llGetSubString(points, 2, 3), -2);
            ssSetSide((integer)llGetSubString(points, 0, 1), -3);
        }
    }
}