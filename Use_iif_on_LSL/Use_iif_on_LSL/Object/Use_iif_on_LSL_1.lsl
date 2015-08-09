// :CATEGORY:Useful Subroutines
// :NAME:Use_iif_on_LSL
// :AUTHOR:vittorio.vais
// :CREATED:2011-08-13 12:45:58.903
// :EDITED:2013-09-18 15:39:08
// :ID:939
// :NUM:1349
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// example: // integer x = iif( z<0 , -1 , +1 );// string hello = iif( sex == "M", "Man.", "Woman" );
// :CODE:
// include this lines in your scripts
integer iif(integer _cond, integer _true, integer _false){ if(_cond) return _true; else return _false; }

float iif( integer _cond, float _true, float _false){ if(_cond) return _true; else return _false; }

vector iif( integer _cond, vector _true, vector _false){ if(_cond) return _true; else return _false; }

list iif( integer _cond, list _true, list _false){ if(_cond) return _true; else return _false; }

string iif( integer _cond, string _true, string _false){ if(_cond) return _true; else return _false; }

rotation iif( integer _cond, rotation _true, rotation _false){ if(_cond) return _true; else return _false; }

key iif( integer _cond, key _true, key _false){ if(_cond) return _true; else return _false; }
