chcp 866
if exist dd.bat del dd.bat
chcp 1251
dir /s/b *.obj >>dd.bat
dir /s/b *.lib >>dd.bat
dir /s/b *.pzl >>dd.bat
dir /s/b *.scc >>dd.bat
dir /s/b *.sym >>dd.bat
dir /s/b *.map >>dd.bat
dir /s/b *.rlt >>dd.bat
dir /s/b *.rc >>dd.bat
dir /s/b *.deb >>dd.bat
dir /s/b *.vrf >>dd.bat
dir /s/b *.scope >>dd.bat
dir /s/b *.scopeinfo >>dd.bat
dir /s/b *.tmp >>dd.bat
dir /s/b *.res >>dd.bat
dir /s/b $*.* >>dd.bat
dir /s/b @*.* >>dd.bat
dir /s/b capdos.inp >>dd.bat
dir /s/b capdos.out >>dd.bat
dir /s/b dd.* >>dd.bat
pause
chcp 866
..\..\Bin\delfiles.exe dd.bat
pause
del dd.bat
pause
