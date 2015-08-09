// :CATEGORY:Owner Key
// :NAME:Name2Key
// :AUTHOR:Takat Su
// :CREATED:2011-10-16 19:28:26.180
// :EDITED:2013-09-18 15:38:58
// :ID:551
// :NUM:751
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// app.yaml file  - not needed unless you want to make your own app engine
// :CODE:
application: name2key
version: 1
runtime: python
api_version: 1
 
handlers:
- url: .*
  script: name2key.py
