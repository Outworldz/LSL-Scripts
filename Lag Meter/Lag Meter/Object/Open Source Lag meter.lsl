//:AUTHOR: Chaser.Zaks

//Link two boxes then put the script inside.

//By Chaser.Zaks.
//Feel free to redistribute and use in projects(even in sold products, just keep it open source).
//DO NOT CLOSE SOURCE OR SELL ALONE.

//Configuration:
integer MeasureNonParcelPrims=FALSE;
//Variables, these are dynamically set, don't bother with them.
string region;
string sim;
vector color;
integer avatars;
integer lastrestart;
integer days;
integer hours;
integer minutes;
integer seconds;
integer lastrestartedcalc;
list same_params =[PRIM_SLICE, <0.5, 1.0, 0.0>,PRIM_FULLBRIGHT,ALL_SIDES,TRUE,PRIM_TEXTURE,ALL_SIDES,TEXTURE_BLANK,ZERO_VECTOR,ZERO_VECTOR,0];

default
{
    state_entry()
    {

        llSetObjectName("Open Source Lag Meter v3");
        llSetLinkPrimitiveParams(1,same_params+[PRIM_COLOR,ALL_SIDES,<0,0,0>,.4,PRIM_SIZE,<.5,.5,4>]);
        llSetLinkPrimitiveParams(2,same_params+[PRIM_COLOR,ALL_SIDES,<0,1,0>,1.,PRIM_SIZE,<.4,.4,3.8>,PRIM_POS_LOCAL,<0,0,.04>]);
        llSetText("Initalizing...",<1,1,0>, 1.0);
        //First start, Set some stuff.
        lastrestart = llGetUnixTime();
        llSetTimerEvent(0.5); //One second is too much checking. Let's not be a resource hog.
    }
    changed(integer change)
    {
        if(change & CHANGED_REGION_START)
            lastrestart = llGetUnixTime();
    }
    timer(){
        region = llGetRegionName();
        avatars = llGetListLength(llGetAgentList(AGENT_LIST_REGION, []));
        //Restart time
            lastrestartedcalc = llGetUnixTime()-lastrestart;
            days=0;
            hours=0;
            minutes=0;
            seconds=0;
            do{
                if(lastrestartedcalc>=86399){
                    days++;
                    lastrestartedcalc=lastrestartedcalc-86399;
                }else if(lastrestartedcalc>=3599){
                    hours++;
                    lastrestartedcalc=lastrestartedcalc-3599;
                }else if(lastrestartedcalc>=59){
                    minutes++;
                    lastrestartedcalc=lastrestartedcalc-59;
                }else{
                    seconds++;
                    lastrestartedcalc--;
                }
            }while(lastrestartedcalc>=0);
            float region_time_dilation=llGetRegionTimeDilation();
        if(region_time_dilation>=0.75)
            color=<0,1,0>;
        else if(region_time_dilation>=0.50)
            color=<1,1,0>;
        else 
            color=<1,0,0>;
        integer primsused=llGetParcelPrimCount(llGetPos(), PARCEL_COUNT_TOTAL, MeasureNonParcelPrims);
        integer maxprims=llGetParcelMaxPrims(llGetPos(), MeasureNonParcelPrims);
        llSetText(
        "Region: "+region+
        "\nAvatars: "+(string)avatars+
        "\nPrims left: "+(string)(maxprims-primsused)+" ("+(string)primsused+"/"+(string)maxprims+")"+
        "\nDilation: "+llGetSubString((string)((1.-region_time_dilation)*100.), 0, 3)+"%"+
        "\nFPS: "+llGetSubString((string)llGetRegionFPS(), 0, 5)+
        "\nLast restart:\n"+(string)days+" Days, "+(string)hours+" Hours, "+(string)minutes+" Minutes, and "+(string)seconds+" Seconds ago.",
        //"\nLast restart:\n"+(string)days+":"+(string)hours+":"+(string)minutes+":"+(string)seconds,
        color, 1.0);
        //llSetLinkPrimitiveParamsFast(2,[PRIM_SLICE,<0,(region_time_dilation),0>,PRIM_COLOR,ALL_SIDES,color,1]);
        llSetLinkPrimitiveParamsFast(2,[PRIM_SLICE, <0.5, 1., 0.0>,PRIM_SIZE,<0.4, 0.4, 3.80*region_time_dilation>,PRIM_COLOR,ALL_SIDES,color,1]);
    }
}