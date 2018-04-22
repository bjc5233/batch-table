@echo off& call load.bat _strlen2 _getLF _isOddNum& call loadF.bat _params _errorMsg _help& call loadE.bat CurS& setlocal enabledelayedexpansion
%CurS% /crv 0
:::说明
:::  绘制表格
:::参数
:::  [-b borderStyle] [-a alignStyle] [-l linePrefixLen] dataFile
:::      borderStyle - 表格样式(1[┌┬┐├┼┤└┴┘]  2[┏┳┓┣╋┫┗┻┛] 3[╔╦╗╠╬╣╚╩╝] 4[┼┼┼├┼┤┼┼┼] 5[···├┼┤···] 6[·········]), 默认为·········
:::      alignStyle - 表格对齐方式[left middle right], 默认为middle
:::      linePrefixLen - 绘制的表格左右空白宽度, 默认为10
:::      dataFile - 传入数据文件地址,为空时,展示demo数据
:::  [-h help]
:::      help - 打印注释信息
:::TODO
:::  基于object方格的创建表格版本
:::    call table.bat new table
:::    %table.setAlignStyle% left
:::    %table.add(1,2,3)%
:::    %table.draw%;

::========================= set default param =========================
set dataFile=data/data.txt
set borderStyle=·········
set alignStyle=middle
set linePrefixLen=10
call %_params% %*


::========================= set user param =========================
if defined _param-h (call %_help% "%~f0"& goto :EOF)
if defined _param-help (call %_help% "%~f0"& goto :EOF)
if defined _param-b (
    set borderStyle=%_param-b%& set flag=0
    if "!borderStyle!"=="1" set flag=1& set borderStyle=┌┬┐├┼┤└┴┘
	if "!borderStyle!"=="2" set flag=1& set borderStyle=┏┳┓┣╋┫┗┻┛
	if "!borderStyle!"=="3" set flag=1& set borderStyle=╔╦╗╠╬╣╚╩╝
	if "!borderStyle!"=="4" set flag=1& set borderStyle=┼┼┼├┼┤┼┼┼
	if "!borderStyle!"=="5" set flag=1& set borderStyle=···├┼┤···
	if "!borderStyle!"=="6" set flag=1& set borderStyle=·········
	if !flag!==0 (call %_errorMsg% %0 "-b=!borderStyle! MUST BE AN INTEGER BETWEEN 1 AND 6")
    
)
if defined _param-a (set alignStyle=%_param-a%)
if defined _param-l (set linePrefixLen=%_param-l%)
if defined _param-0 (set dataFile=%_param-0%)
if not exist "!dataFile!" (call %_errorMsg% %0 "!dataFile! FILE NOT EXIST")


::========================= read data =========================
set vIndex=1
for /f "delims=" %%x in (!dataFile!) do (
	set lineStr=%%x& set hIndex=1
	for /l %%y in (1,1,20) do (
		for /f "tokens=1* delims=#" %%i in ("!lineStr!") do (
			set tempStr=%%i& (%_call% ("tempStr len") %_strlen2%)
			set len.h!hIndex!.v!vIndex!=!len!& set h!hIndex!.v!vIndex!=%%i& set lineStr=%%j
			
			(%_call% ("len") %_isOddNum%) && set /a len+=1
			if defined len.h!hIndex! (
				for %%z in (!hIndex!) do if !len! GTR !len.h%%z! set len.h%%z=!len!
			) else (
				set len.h!hIndex!=!len!
			)
			set /a hIndex+=1	
		)
	)
	set /a vIndex+=1
)
set /a hMax=hIndex-1, vMax=vIndex-1


::========================= init =========================
set borderStyle.11=!borderStyle:~0,1!& set borderStyle.21=!borderStyle:~1,1!& set borderStyle.31=!borderStyle:~2,1!
set borderStyle.12=!borderStyle:~3,1!& set borderStyle.22=!borderStyle:~4,1!& set borderStyle.32=!borderStyle:~5,1!
set borderStyle.13=!borderStyle:~6,1!& set borderStyle.23=!borderStyle:~7,1!& set borderStyle.33=!borderStyle:~8,1!
for /l %%h in (1,1,50) do set borderStr=!borderStr!─
for /l %%h in (1,1,50) do set blankStr=!blankStr! 
set linePrefixBlank=& for %%i in (!linePrefixLen!) do set linePrefixBlank=!blankStr:~0,%%i!
::计算每一列的border字符串
set /a screenWidth=linePrefixLen*2+hMax*2+2, screenHeight=1+vMax*2+7
for /l %%h in (1,1,!hMax!) do (
	set /a screenWidth+=len.h%%h
	set /a len=len.h%%h/2& for %%i in (!len!) do set border.h%%h=!borderStr:~0,%%i!
)
mode !screenWidth!,!screenHeight!


::========================= draw =========================
title 表格:!dataFile!
::第一行边框
set "drawStr=!LF!!LF!!linePrefixBlank!!borderStyle.11!"
for /l %%h in (1,1,!hMax!) do (
	if %%h EQU !hMax! (
		set "drawStr=!drawStr!!border.h%%h!!borderStyle.31!!LF!"
	) else (
		set "drawStr=!drawStr!!border.h%%h!!borderStyle.21!"
	)
)

::数据行
for /l %%v in (1,1,!vMax!) do (
	set "drawStr=!drawStr!!linePrefixBlank!│"
	for /l %%h in (1,1,!hMax!) do (
		set /a blankLen=len.h%%h-len.h%%h.v%%v
		if !alignStyle! EQU left (
			for %%i in (!blankLen!) do set "drawStr=!drawStr!!h%%h.v%%v!!blankStr:~0,%%i!│"
		) else if !alignStyle! EQU right (
			for %%i in (!blankLen!) do set "drawStr=!drawStr!!blankStr:~0,%%i!!h%%h.v%%v!│"
		) else if !alignStyle! EQU middle (
			set /a blankLen2=blankLen/2, blankLen3=blankLen-blankLen2
			for %%i in (!blankLen2!) do for %%j in (!blankLen3!) do set "drawStr=!drawStr!!blankStr:~0,%%i!!h%%h.v%%v!!blankStr:~0,%%j!│"
		)
	)
	
	if %%v EQU !vMax! (
		set "drawStr=!drawStr!!LF!!linePrefixBlank!!borderStyle.13!"
		for /l %%h in (1,1,!hMax!) do (
			if %%h EQU !hMax! (
				set "drawStr=!drawStr!!border.h%%h!!borderStyle.33!!LF!"
			) else (
				set "drawStr=!drawStr!!border.h%%h!!borderStyle.23!"
			)
		)
	) else (
		set "drawStr=!drawStr!!LF!!linePrefixBlank!!borderStyle.12!"
		for /l %%h in (1,1,!hMax!) do (
			if %%h EQU !hMax! (
				set "drawStr=!drawStr!!border.h%%h!!borderStyle.32!!LF!"
			) else (
				set "drawStr=!drawStr!!border.h%%h!!borderStyle.22!"
			)
		)
	)
)
echo !drawStr!& pause>nul& goto :EOF