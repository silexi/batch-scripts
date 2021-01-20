@echo off
title Get Hashes From Full Directory
echo.
set /p hashtype=Enter the hash type you want to output ('MD5', 'SHA1', 'SHA2'):
set /p dizin=Enter the directory you want to get the %hashtype% hash as full path (access required):
dir "%dizin%" /s/b /a-d > diroutput.temp
echo -----------------------
echo All possible files are fetched..
echo -----------------------
for /f "tokens=*" %%a in (diroutput.temp) do (
	echo %%a
	)
setlocal
set CUR_YYYY=%date:~6,4%
	set CUR_MM=%date:~3,2%
	set CUR_DD=%date:~0,2%
	set CUR_HH=%time:~0,2%
	if %CUR_HH% lss 10 (set CUR_HH=0%time:~1,1%)
	set CUR_NN=%time:~3,2%
	set CUR_SS=%time:~6,2%
	set CUR_MS=%time:~9,2%
	set zaman=%CUR_YYYY%%CUR_MM%%CUR_DD%-%CUR_HH%%CUR_NN%%CUR_SS%
echo -----------------------
echo The %hashtype% hash of all the above files will be written to the "hashes-output-%zaman%.%hashtype%" file.
set /p eminMisin= Are you sure? (y/n):
if /i "%eminMisin%" neq "y" goto cancel
	echo -----------------------
	echo Receiving hashes, the process may increase according to directory size. Please wait...
	echo -----------------------
	for /f "tokens=*" %%a in (diroutput.temp) do (
		echo %%a
		certutil -hashfile "%%a" "%hashtype%" | findstr /V ":"
		echo.
	) >> hashes-output-"%zaman%"."%hashtype%"
	
	echo [101;42mProcess completed. Hashes saved in "hashes-output-%zaman%.%hashtype%" file.[0m
	goto continue
	:cancel
	echo The process has been canceled.
	:continue
	del diroutput.temp /s /f /q | echo.
endlocal
pause
