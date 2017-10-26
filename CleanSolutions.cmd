chcp 866
if exist dd.bat del dd.bat
chcp 1251
dir /s/b vip7*.dll >>dd.bat
dir /s/b *.obj >>dd.bat
dir /s/b *.exe >>dd.bat
dir /s/b boostRegex.dll >>dd.bat
dir /s/b SciLexer.dll >>dd.bat
dir /s/b vipRes.dll >>dd.bat
dir /s/b vipVpi.dll >>dd.bat
dir /s/b vipKernel.dll >>dd.bat
dir /s/b vipRun.dll >>dd.bat
dir /s/b *.map >>dd.bat
dir /s/b *.bro >>dd.bat
dir /s/b *.rlt >>dd.bat
dir /s/b *.obj.options >>dd.bat
dir /s/b *.res >>dd.bat
dir /s/b *.rc >>dd.bat
dir /s/b *.deb >>dd.bat
dir /s/b *.scope >>dd.bat
dir /s/b *.scopeinfo >>dd.bat
dir /s/b *.tmp >>dd.bat
dir /s/b $*.* >>dd.bat
dir /s/b @*.* >>dd.bat
dir /s/b capdos.* >>dd.bat
dir /s/b dd.* >>dd.bat
..\SPBrSolutions\Bin\delfiles.exe dd.bat
del dd.bat
pause
