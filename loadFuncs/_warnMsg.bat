@echo off& call loadE eecho
::说明
::  打印警告信息
::参数
::  [来源] [警告信息]
%eecho% -b 0 -f 14 warnMsg[%~1]:
%eecho% -b 0 -f 14 "     %~2"
pause>nul