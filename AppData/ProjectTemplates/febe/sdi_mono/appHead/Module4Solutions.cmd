if %1=="end" goto moduleEnd 
if not defined VipDir @echo off

if  not defined LocalCallCounter (set /A "LocalCallCounter=0") else set /A "LocalCallCounter=LocalCallCounter+1"
goto end

:moduleEnd
if %LocalCallCounter% goto end
if %LocalCallCounter% GTR 0 set /A "LocalCallCounter=LocalCallCounter-1"

:end
