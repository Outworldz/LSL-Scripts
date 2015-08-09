// :CATEGORY:Database
// :NAME:DBMS__Virtual_Machine
// :AUTHOR:Very Keynes
// :CREATED:2010-11-18 20:48:39.110
// :EDITED:2013-09-18 15:38:51
// :ID:224
// :NUM:310
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// DBMS__Virtual_Machine
// :CODE:
//Very Keynes - 2008 - 2009
//
// Version: OpenSimulator Server  0.6.1.7935  (interface version 2) 
//
// 2009-01-06, 19:30 GMT
//
//------------------Begin VK-DBMS-VM----------------------------\\
//--------------------Introduction------------------------------\\
//
// Very Keynes - DBMS - Virtual Machine
//
//        Implements a core set of registers and root functions
//        to create and manage multi-table database structures as
//        an LSL list. Although intended to under pin higher level
//        database management tools such as VK-SQL it is usable as
//        a small footprint database facility for system level
//        applications.
//
//
//    Naming Conventions and Code Style
//
//        This Code is intended to be included as a header to user generated
//        code. As such it's naming convention was selected so that it would
//        minimise the possibility of duplicate names in the user code portion
//        of the application. Exposed Functions and Variables are prefixed db.
//
//      A full User Guide and Tutorial is availible at this URL:
//
//          http://docs.google.com/Doc?id=d79kx35_26df2pbbd8
//
//
//    Table Control Registers
//
integer th_;     // Table Handle / Index Pointer
integer tc_;     // Columns in Active Table
integer tr_;     // Rows in Active Table
integer ts_;     // Active Table Start Address
//
list _d_ = [];    // Database File
list _i_ = [0];    // Index File
//
//    Exposed Variables
//
integer dbIndex;    // Active Row Table Pointer
list       dbRow;    // User Scratch List
string  dbError;    // System Error String
//
// Temporary / Working Variables
//
integer t_i;
string  t_s;
float     t_f;
list     t_l;
//
//    System Functions
//
string dbCreate(string tab, list col)
{     
    if(dbOpen(tab))
    {
        dbError = tab + " already exists"; 
        return "";
    }
    tc_ = llGetListLength(col);
    _i_ += [tab, tc_, 0, 0, 0];
    th_= 0; 
    dbOpen(tab); 
    dbInsert(col); 
    return tab; 
}


integer dbCol(string  col)
{
    return llListFindList(dbGet(0), [_trm(col)]);
}


integer dbDelete(integer ptr)
{
    if(ptr > 0 && ptr < tr_)
    {
        t_i = ts_ + tc_ * ptr;
        _d_ = llDeleteSubList(_d_, t_i, t_i + tc_ - 1); 
        --tr_;
        return tr_ - 1;
    }
    else 
    {
        dbError = (string)ptr + " is outside the Table Bounds"; 
        return FALSE;
    }
}


integer dbDrop(string tab)
{
    t_i = llListFindList(_i_, [tab]);
    if(-1 != t_i)
    {     
        dbOpen(tab);
        _d_ = llDeleteSubList(_d_, ts_, ts_ + tc_ * tr_ - 1);
        _i_ = llDeleteSubList(_i_, th_, th_ + 4);
        th_= 0;
        return TRUE;     
    }
    else 
    {
        dbError = tab + " : Table name not recognised"; 
        return FALSE;
    }
}


integer dbExists(list cnd)
{     
    for(dbIndex = tr_ - 1 ; dbIndex > 0 ; --dbIndex)
    {
        if(dbTest(cnd)) return dbIndex;
    }
    return FALSE;
}


list dbGet(integer ptr)
{
    if(ptr < tr_ && ptr >= 0)
    {
        t_i = ts_ + tc_ * ptr;
        return llList2List(_d_, t_i, t_i + tc_ - 1);
    }
    else 
    {
        dbError = (string) ptr + " is outside the Table Bounds";
        return [];
    }
}


integer _idx(integer hdl)
{
    return (integer)llListStatistics(6, llList2ListStrided(_i_, 0, hdl, 5));
}


integer dbInsert(list val)
{
    if(llGetListLength(val) == tc_)
    {
        dbIndex = tr_++;
        _d_ = llListInsertList(_d_, val, ts_ + tc_ * dbIndex);
        return dbIndex;
    }
    else
    {
        dbError = "Insert Failed - too many or too few Columns specified"; 
        return FALSE;
    }
}


integer dbOpen(string tab)
{
    if(th_) 
    {
        _i_ = llListReplaceList(_i_, [tr_, dbIndex, tc_ * tr_], th_ + 2, th_ + 4);
    }
    t_i = llListFindList(_i_, [tab]);
    if(-1 == t_i)    //if tab does not exist abort
    {
        dbError = tab + " : Table name not recognised"; 
        return FALSE;
    }
    else if(th_ != t_i)
    {
        th_ = t_i++;
        ts_ = _idx(th_);
        tc_ = llList2Integer(_i_, t_i++);
        tr_ = llList2Integer(_i_, t_i++);
        dbIndex = llList2Integer(_i_, t_i);
    }
    return tr_ - 1;
}


integer dbPut(list val)
{
    if(llGetListLength(val) == tc_)
    {
        t_i = ts_ + tc_ * dbIndex;
        _d_ = llListReplaceList(_d_, val, t_i, t_i + tc_ - 1); 
        return dbIndex;
    }
    else 
    {
        dbError = "Update Failed - too many or too few Columns specified"; 
        return FALSE;
    }
}


integer dbTest(list cnd)
{ 
    if(llGetListEntryType(cnd,2) >= 3)
    {
        t_s = llList2String(dbGet(dbIndex), dbCol(llList2String(cnd, 0)));
        if     ("==" == llList2String(cnd, 1)){t_i =  t_s == _trm(llList2String(cnd, 2));}
        else if("!=" == llList2String(cnd, 1)){t_i =  t_s != _trm(llList2String(cnd, 2));}
        else if("~=" == llList2String(cnd, 1))
        {t_i = !(llSubStringIndex(llToLower(t_s), llToLower(_trm(llList2String(cnd, 2)))));}
    }
    else
    {
        t_f = llList2Float(dbGet(dbIndex), dbCol(llList2String(cnd, 0)));
        t_s = llList2String(cnd, 1);
        if     ("==" == t_s){t_i = t_f == llList2Float(cnd, 2);}
        else if("!=" == t_s){t_i = t_f != llList2Float(cnd, 2);}
        else if("<=" == t_s){t_i = t_f <= llList2Float(cnd, 2);}
        else if(">=" == t_s){t_i = t_f >= llList2Float(cnd, 2);}
        else if("<"  == t_s){t_i = t_f <  llList2Float(cnd, 2);}
        else if(">"  == t_s){t_i = t_f >  llList2Float(cnd, 2);}
    }
    if(t_i) return dbIndex; 
    else return FALSE;
}


string _trm(string val)
{
    return llStringTrim(val, STRING_TRIM);
}


dbTruncate(string tab)
{
    dbIndex = dbOpen(tab);
    while(dbIndex > 0) dbDelete(dbIndex--);
}


dbSort(integer dir)
{
    t_i = ts_ + tc_;
    _d_ = llListReplaceList(_d_, llListSort(llList2List(_d_, t_i, t_i + tc_ * tr_ - 2), tc_, dir), t_i, t_i + tc_ * tr_ - 2);
}


float dbFn(string fn, string col)
{
    t_i = ts_ + tc_;
    t_l = llList2List(_d_, t_i, t_i + tc_ * tr_ - 2);
    if(dbCol(col) != 0) t_l = llDeleteSubList(t_l, 0, dbCol(col) - 1);
    return llListStatistics(llSubStringIndex("ramimaavmedesusqcoge", llGetSubString(llToLower(fn),0,1)) / 2,
    llList2ListStrided(t_l, 0, -1, tc_));
}
//
//--------------------------- End VK-DBMS-VM ---------------------------\\
//
default
{
    state_entry()
    {
        dbCreate("DMSolo", ["uuid", "inst", "anim", "mode"]);
        dbInsert([llGetOwner(), llKey2Name(llGetOwner()), "testing", 1234]);
    }
     
    touch_start(integer total_number)
    {
        if(dbExists(["uuid", "==", llDetectedKey(0)]))
        {
            dbRow = dbGet(dbIndex);
            llSay(0, "Hello " + llList2String(dbRow, 1));
        }
        else llSay(0, "Sorry you are not on my list");
    }
}
