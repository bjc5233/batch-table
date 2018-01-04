@echo off& call loadE eecho
::说明
::  打印普通信息
::参数
::  [来源] [普通信息]
%eecho% -b 0 -f 11 infoMsg[%~1]:
%eecho% -b 0 -f 11 "     %~2"