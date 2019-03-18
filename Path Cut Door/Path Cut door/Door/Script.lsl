// :CATEGORY:Door
// :NAME:Path Cut Door
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2014-04-19 15:57:26
// :EDITED:2014-04-19
// :ID:1035
// :NUM:1611
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// A round door made by a path cut
// :CODE:

vector cut = < 0, 0.25 , 0 >;
float step = .015;
integer cycles ;

default {
    touch_start(integer total_number) {
          cycles = 50;
          while (cycles--) {
             cut.x += step;
            llSetPrimitiveParams([PRIM_TYPE, PRIM_TYPE_CYLINDER, PRIM_HOLE_DEFAULT, //hole_shape
                          cut,    // cut
                          0.95,    // hollow
                          < 0.0, 0.0, 0.0 >,    // twist
                          < 1.0, 1.0, 0.0 >,    // top_size
                        < 0.0, 0.0, 0.0 >]);

                   // llSay(0,(string) cut);
        };
        step *= -1;
    }
}
