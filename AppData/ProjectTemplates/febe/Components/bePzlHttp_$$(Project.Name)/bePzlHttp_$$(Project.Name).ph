/*****************************************************************************
Copyright (c) PDCSPB

Author: Victor Yukhtenko
******************************************************************************/
#requires @"..\components\bePzlHttp_$$(Project.Name)\bePzlHttp_$$(Project.Name).pack"

#include @"pfc\core.ph"
#include @"packs\logic\pzlSystem\openPzl\packs\pzlComponent\pzlComponent.ph"

% exported interfaces
#include @"..\components\bePzlHttp_$$(Project.Name)\bePzlHttp_$$(Project.Name).i"
#include @"Interfaces\logic\PzlRun.i"

#if iPzlConfig::usebePzlHttp_$$(Project.Name)Original_C=true #then
% publicly used packages
#include @"appHead\appHead.ph"
% exported classes
    #include @"..\components\bePzlHttp_$$(Project.Name)\bePzlHttp_$$(Project.Name).cl"
#else
    #include @"..\components\bePzlHttp_$$(Project.Name)\bePzlHttp_$$(Project.Name)Proxy.cl"
#endif
