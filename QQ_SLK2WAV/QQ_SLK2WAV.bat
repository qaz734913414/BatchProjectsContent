@echo off
set path=%path%;%~dp0
set version=20160316
title QQ_SLK2WAV QQ��Ƶ�ļ�slkתwav���������� ^| F_Ms - %version% ^| f-ms.cn

REM �ж����л���
if "%~1"=="" (
	echo=#���
	echo=		 QQ_SLK2WAV
	echo=
	echo=     ��Ѷqq������Ƶ�ļ�slkתwav����������
	echo=  ���ߣ�F_Ms ^| ���ͣ�f-ms.cn ^| �汾��%version%
	echo=
	echo=#ʹ�÷�����
	echo=	��Ҫת����QQ������Ƶ�ļ�^(.slk^)���ļ���
	echo=	   �϶����������ļ��ϼ���^(�Ǳ�����^)
	pause>nul
	exit/b
) else if not exist "%~1" if not exist "%~1\" (
	echo=#���
	echo=		 QQ_SLK2WAV
	echo=
	echo=     ��Ѷqq������Ƶ�ļ�slkתwav����������
	echo=  ���ߣ�F_Ms ^| ���ͣ�f-ms.cn ^| �汾��%version%
	echo=
	echo=#���棺
	echo=	ָ���ļ����ļ��в�����
	pause>nul
	exit/b
)
set folderFile=

color 0a
echo=
echo=#���
echo=
echo=		 QQ_SLK2WAV
echo=
echo=     ��Ѷqq������Ƶ�ļ�slkתwav����������
echo=
echo=	  -ʹ�õ��ĵ����������й���-
echo=	      split(textutils)
echo=	  SilkDecoder(��ԭ������Ϣ)
echo=	  FFmpeg (FFmpegDevelopers)
echo=	             ����
echo=
echo=  ���ߣ�F_Ms ^| ���ͣ�f-ms.cn ^| �汾��%version%
echo=
echo=#ת����ʼ
echo=
REM echo=#ת����ʼ

if not exist "%~1\" call:convert "%~1"&goto converEnd

set folderFile=Yes
for /r "%~1\" %%a in (*) do if exist "%%~a" call:convert "%%~a"

:converEnd
echo=#ת������
echo=
REM echo=#ת������
pause>nul



goto end
REM �ӳ�������
:begin

REM ���ӳ��� call:convert "��ת���ļ�"
:convert
cd /d "%~dp1"
set/p=^|	����ת��: "%~1" ^> <nul
call:VarCSH "%~1" "%folderFile%"
REM �ļ�ǰ�ڴ���

call:fileSizeTrue 50 "%~1"
if "%errorlevel%"=="0" (
	echo= #���ļ�,������
	if defined convertFailFileList echo=���ļ�: "%~1">>"%convertFailFileList%"
	exit/b 1
)

call:checkFileHeader "%~1"
if "%errorlevel%"=="0" (
	set tempFileSlk2Pcm=%~1
	set tempFilePcm2Wav=%~1.pcm
	goto passSplit
) else if "%errorlevel%"=="1" (
	echo= #�ļ�ͷ��Ϣ����,������
	if defined convertFailFileList echo=�ļ�ͷ��Ϣ���� "%~1">>"%convertFailFileList%"
	exit/b 1
) else if "%errorlevel%"=="2" (
	echo= # AMR��ʽΪͨ�ø�ʽ,������
	if defined convertFailFileList echo=ͨ����Ƶ��ʽ "%~1">>"%convertFailFileList%"
	exit/b 1
)
REM �ü������ļ�ͷ
call:GetFileSplitSize "%yuanFile%"
if not "%errorlevel%"=="0" (
	echo= #ת��ʧ��,�����ļ�Ȩ�޲���
	if defined convertFailFileList echo=�޷���Ȩ�� "%~1">>"%convertFailFileList%"
)
:passSplit

REM slk2pcmת��
call:slk2pcm "%tempFileSlk2Pcm%" "%tempFilePcm2Wav%"
if not "%errorlevel%"=="0" (
	set kbps=16000
	set tempFilePcm2Wav=%yuanFile%
	goto passSlk2Pcm
)
REM pcm2wavת��
set kbps=
set kbps=44100
:passSlk2Pcm
if not exist "%newWavFilePath%" md "%newWavFilePath%"
call:pcm2wav %kbps% "%tempFilePcm2Wav%" "%newWavFilePath%\%newWavFileName%"
if not "%errorlevel%"=="0" (
	echo= #ת��ʧ��,����ָ���ļ��������ʹ���
	if defined convertFailFileList echo=�ļ�������� "%~1">>"%convertFailFileList%"
	call:DeleteTempFile
	exit/b 1
)

REM �ж��Ƿ�����ִ�гɹ�
set wavEmptyFileSize=40000
call:fileSizeTrue %wavEmptyFileSize% "%newWavFilePath%\%newWavFileName%"
if "%errorlevel%"=="0" if "%kbps%"=="44100" (
	set kbps=16000
	set tempFilePcm2Wav=%yuanFile%
	goto passSlk2Pcm
)
if "%errorlevel%"=="0" (
	if exist "%newWavFilePath%\%newWavFileName%" del /f /q "%newWavFilePath%\%newWavFileName%"
	echo= #ת��ʧ��,δ֪����
	if defined convertFailFileList echo=δ֪���� "%~1">>"%convertFailFileList%"
	call:DeleteTempFile
	exit/b 1
)

echo= ת���ɹ�
call:DeleteTempFile
exit/b 0



REM ��ʼ�������� call:VarCSH "%file%"
:VarCSH
for %%a in (yuanFile tempFile newWavFileName newWavFilePath fileKuoZhanName) do set %%a=
set yuanFile=%~1
for /f "delims=" %%a in ("%yuanFile%") do (
	set newWavFileName=%%~na.wav
	set tempFile=%%~na
	set newWavFilePath=%%~dpa
	set fileKuoZhanName=%%~xa
)
set tempFile=%tempFile: =%
if not "%~2"=="" for /f "delims=" %%a in ("%newWavFilePath:~0,-1%") do (
	set newWavFilePath=%%~dpa%%~nxa_ת����
	set convertFailFileList=%%~dpa%%~nxa_ת��ʧ���ļ��б�.txt
)
exit/b 0

REM ����ļ��ļ�ͷ���Ƿ�ΪQQ�����ļ� call:checkFileHeader file
REM 	����ֵ��1 - ָ���ļ�����, 2 - AMR�ļ�, 3 - slk��Ҫ�����ֽ� 0 - slk��������ֽ�
:checkFileHeader
set fileHeaderTemp=
set /p fileHeaderTemp=<"%~1"
if not defined fileHeaderTemp exit/b 1
if /i "%fileHeaderTemp:~0,5%"=="#!AMR" exit/b 2
if /i "%fileHeaderTemp:~0,10%"=="#!SILK_V3" exit/b 3
if /i "%fileHeaderTemp:~0,9%"=="#!SILK_V3" exit/b 0
exit/b 1


REM �ļ�ǰ�ڴ���(ȥ���׸��ֽ�) call:GetFileSplitSize "%yuanFile%"
:GetFileSplitSize
REM ��ȡ�ļ����ڲü�����
set fileSize=0
for  %%a in ("%~1") do set /a fileSize=%%~za+1
set tempFileSlk2Pcm=%tempFile%_ab
set tempFilePcm2Wav=%tempFile%_ab.pcm

REM �����ļ�Ϊ˫���ĳ���
copy "%~1" "%~1_2" 0>nul 1>nul 2>nul
if not "%errorlevel%"=="0" exit/b %errorlevel%
copy /b "%~1"+"%~1_2" "%~1_3" 0>nul 1>nul 2>nul
if not "%errorlevel%"=="0" exit/b %errorlevel%
split -b %fileSize% "%~1_3" %tempFile%_ 0>nul 1>nul 2>nul
if not "%errorlevel%"=="0" exit/b %errorlevel%
exit/b 0

REM �жϽ���Ƿ�Ϊ���ļ� call:fileSizeTrue size file
REM   ����ֵ��0 - ��, 1 - �ǿ�
:fileSizeTrue
if not exist "%~2" exit/b 0
for %%a in ("%~2") do (
	if %%~za leq %~1 exit/b 0
)
exit/b 1

REM ɾ����ʱ�ļ� call:DeleteTempFile
:DeleteTempFile
for %%a in ("%yuanFile%_2","%yuanFile%_3","%tempFile%_aa" "%tempFile%_ab" "%tempFile%_ab.pcm" "%yuanFile%.pcm") do if exist "%%~a" del /f /q "%%~a"
exit/b 0

REM slk2pcmת�� call:slk2pcm inputFile outputFile
:slk2pcm
slk2pcm.exe "%~1" "%~2" -Fs_API 44100 0>nul 1>nul 2>nul
exit/b %errorlevel%

REM pcm2wavת�� call:pcm2wav ������ inputFile outputFile
:pcm2wav
if exist "%~3" del /f /q "%~3"
pcm2wav.exe -f s16le -ar %~1 -ac 1 -i "%~2" -ar 44100 -ac 2 -f wav "%~3" 0>nul 1>nul 2>nul
exit/b %errorlevel%

:end