if "%PROCESSOR_ARCHITECTURE%"=="AMD64" set _VIPREGKEY_="HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\PDC\Visual Prolog"
if not "%PROCESSOR_ARCHITECTURE%"=="AMD64" set _VIPREGKEY_="HKEY_LOCAL_MACHINE\SOFTWARE\PDC\Visual Prolog"

echo %PROCESSOR_ARCHITECTURE%

reg query %_VIPREGKEY_% /v VipPath 1>nul 2>nul

if errorlevel 1 echo Visual Prolog is not installed properly goto :end

for /f "skip=2 delims=?" %%i in ('reg query %_VIPREGKEY_% /v VipPath') do call :SET_VIPDIR %%i
set VipDir=%REGVIPDIR%
set REGVIPDIR=
set _VIPREGKEY_=

if "%PROCESSOR_ARCHITECTURE%"=="AMD64" set _HCU_VIPTOOLS_="HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Prolog Development Center\Visual Prolog6\settings\toolsDirList"
if not "%PROCESSOR_ARCHITECTURE%"=="AMD64" set _HCU_VIPTOOLS_="HKEY_LOCAL_MACHINE\SOFTWARE\Prolog Development Center\Visual Prolog6\settings\toolsDirList"

for /f "skip=2 delims=?" %%i in ('reg query %_HCU_VIPTOOLS_% /v SpbSolutions') do call :SET_SPBS %%i
set SpbSolutions=%REGSPBSOLUTIONS%
set LIBMAKER=%SpbSolutions%\3P_Tools\MsTools\lib.exe

set REGSPBSOLUTIONS=
set _HCU_VIPTOOLS_=
goto :end

:SET_VIPDIR
if not "%1" == "VipPath" goto :end
shift
shift
set REGVIPDIR=%1
:concatVipDir
shift
if "%1" == "" goto :end
set REGVIPDIR=%REGVIPDIR% %1
goto :concatVipDir

:SET_SPBS
if not "%1" == "SpbSolutions" goto :EOF
shift 
shift
set REGSPBSOLUTIONS=%1
:concat
shift
if "%1" == "" goto :end
set REGSPBSOLUTIONS=%REGSPBSOLUTIONS% %1
goto :concat

:end