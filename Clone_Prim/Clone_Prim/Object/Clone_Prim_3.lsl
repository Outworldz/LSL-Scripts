// :CATEGORY:Building
// :NAME:Clone_Prim
// :AUTHOR:Clarknova Helvetic
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:50
// :ID:183
// :NUM:256
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Tips & Ideas// // Warning: Bad chat lag will sometimes re-order your code for you. Increase the pause variable at the top of the script and try again. If that fails reduce your draw distance, move to a different sim and wait for SL to stop sucking.// // Tip: Comment out the PRIM_SIZE in the output script and drop it in a megaprim after you've built your scale model.// 
// Tip: Supports sculpties.
// 
// Tip: One neat thing you can do is have your prim cycle between objects. Just take the entire codeblock in state_entry() and stick it in a custom function thus: 
// :CODE:
shape_1()
{
      // Clone Prim codeblock
}
shape_2()
{
      // Clone Prim codeblock
}                      
shape_3()
{
     // Clone Prim codeblock
}
shape_4()
{
      // Clone Prim codeblock
}                                               
 
default
    {
      on_rez(integer p) { llResetScript(); }
      state_entry()
      {
         do
         {
           shape_1();
           llSleep(10.);
 
           shape_2();
           llSleep(10.);
 
           shape_3();
           llSleep(10.);
 
           shape_4();
           llSleep(10.);
 
       }while (1);
    }
}
