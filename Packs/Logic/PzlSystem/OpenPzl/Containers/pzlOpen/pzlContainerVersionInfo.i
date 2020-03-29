/*****************************************************************************
Copyright (c) Victor Yukhtenko.

******************************************************************************/

interface pzlContainerVersionInfo
    open core

constants % compatibility versions
    pzlLicenseLevel_C:pzlDomains::pzlLicenseNo_D =pzlContainerVersions::pzlPublic_C.
    pzlLicenseNo_C:pzlDomains::pzlLicenseNo_D = pzlDomains::str("").

end interface pzlContainerVersionInfo
