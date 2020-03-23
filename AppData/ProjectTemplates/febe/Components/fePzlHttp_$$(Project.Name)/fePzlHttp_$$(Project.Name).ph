/*****************************************************************************
Copyright (c) 2006-2016 PDCSPB

Author: Виктор Юхтенко/WIN-5L3MH3V6R7Q
******************************************************************************/
#requires @"..\Components\fePzlHttp_$$(Project.Name)\fePzlHttp_$$(Project.Name).pack"

#include @"pfc\core.ph"
#include @"pfc\gui\gui.ph"
#include @"packs\logic\pzlSystem\openPzl\packs\pzlComponent\pzlComponent.ph"
#include @"Interfaces\logic\PzlRun.i"

% exported interfaces
#include @"..\Components\fePzlHttp_$$(Project.Name)\fePzlHttp_$$(Project.Name).i"

#if iPzlConfig::usefePzlHttp_$$(Project.Name)Original_C=true #then
% publicly used packages
#include @"appHead\appHead.ph"
#include @"pfc\log\Log.ph"

% exported classes
    #include @"..\Components\fePzlHttp_$$(Project.Name)\fePzlHttp_$$(Project.Name).cl"
#else
    #include @"..\Components\fePzlHttp_$$(Project.Name)\fePzlHttp_$$(Project.Name)Proxy.cl"
#endif
