/*****************************************************************************
Copyright (c) 2006-2016 PDCSPB

Author: Виктор Юхтенко/WIN-5L3MH3V6R7Q
******************************************************************************/
#requires @"..\components\monoPzl_$$(Project.Name)\monoPzl_$$(Project.Name).pack"

#include @"pfc\core.ph"
#include @"pfc\gui\gui.ph"
#include @"packs\logic\pzlSystem\openPzl\packs\pzlComponent\pzlComponent.ph"
#include @"Interfaces\logic\PzlRun.i"

% exported interfaces
#include @"..\components\monoPzl_$$(Project.Name)\monoPzl_$$(Project.Name).i"

#if iPzlConfig::useMonoPzl_$$(Project.Name)Original_C=true #then
% publicly used packages

% exported classes
    #include @"..\components\monoPzl_$$(Project.Name)\monoPzl_$$(Project.Name).cl"
#else
    #include @"..\components\monoPzl_$$(Project.Name)\monoPzl_$$(Project.Name)Proxy.cl"
#endif
