// :CATEGORY:Building
// :NAME:Identify_Faces
// :AUTHOR:Jake Cellardoor
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:55
// :ID:397
// :NUM:553
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Identify Faces uses this texture for Open SIm users. SL users can use the script as-is.// // <img src="/images/texturenumbers.jpg">
// :CODE:


display( integer value, integer face )
{
    float cell_width = 0.25;    // in this example the width
    float cell_height = 0.25;   // and height are the same

    llSetTexture("d57a4d7d-5cd4-9f12-56a9-a92a68cfc13a", face );
    llScaleTexture( cell_width, cell_height, face );
    if ( value == 0 )
        llOffsetTexture( -1.5 * cell_width, 1.5 * cell_height, face );
    else if ( value == 1 ) 
        llOffsetTexture( -0.5 * cell_width, 1.5 * cell_height, face );
    else if ( value == 2 ) 
        llOffsetTexture( 0.5 * cell_width, 1.5 * cell_height, face );
    else if ( value == 3 ) 
        llOffsetTexture( 1.5 * cell_width, 1.5 * cell_height, face );
    else if ( value == 4 ) 
        llOffsetTexture( -1.5 * cell_width, 0.5 * cell_height, face );
    else if ( value == 5 ) 
        llOffsetTexture( -0.5 * cell_width, 0.5 * cell_height, face );
    else if ( value == 6 ) 
        llOffsetTexture( 0.5 * cell_width, 0.5 * cell_height, face );
    else if ( value == 7 ) 
        llOffsetTexture( 1.5 * cell_width, 0.5 * cell_height, face );
    else if ( value == 8 ) 
        llOffsetTexture( -1.5 * cell_width, -0.5 * cell_height, face );
    else if ( value == 9 ) 
        llOffsetTexture( -0.5 * cell_width, -0.5 * cell_height, face );
    else if ( value == 10 )
        llOffsetTexture( 0.5 * cell_width, -0.5 * cell_height, face );  
    else if ( value == 11 )
        llOffsetTexture( 1.5 * cell_width, -0.5 * cell_height, face );
    else if ( value == 12 )
        llOffsetTexture( -1.5 * cell_width, -1.5 * cell_height, face ); 
    else if ( value == 13 )
        llOffsetTexture( -0.5 * cell_width, -1.5 * cell_height, face );
    else if ( value == 14 )
        llOffsetTexture( 0.5 * cell_width, -1.5 * cell_height, face );
    else if ( value == 15 )
        llOffsetTexture( 1.5 * cell_width, -1.5 * cell_height, face );
}

default
{
    state_entry()
    {
        integer i;
        
        for ( i = 0; i < llGetNumberOfSides(); i++ )
            display( i, i );
    }
    
    changed( integer changed_flag )
    {
        if ( (changed_flag == CHANGED_SHAPE) ||
             (changed_flag == CHANGED_SCALE)    )
            llResetScript();
    }
}
      
// END //
