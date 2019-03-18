// :CATEGORY:Prim Face Numbers
// :NAME:Put_a_number_on_all_faces_of_a_prim
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2010-05-01 09:55:26.000
// :EDITED:2013-09-18 15:39:00
// :ID:668
// :NUM:909
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Put_a_number_on_all_faces_of_a_prim
// :CODE:
display( integer value, integer face )
{
    float cell_width = 0.25;    // in this example the width
    float cell_height = 0.25;   // and height are the same

    llSetTexture("9e59ddf7-d7c3-5248-0894-00ce2154ee8e", face );
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
