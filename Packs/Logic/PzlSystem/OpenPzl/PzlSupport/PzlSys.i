/*****************************************************************************

Copyright (c) Victor Yukhtenko

 Written by: Victor Yukhtenko
******************************************************************************/

interface pzlSys

predicates
    newInstance:(pzlDomains::entityUID_D ClassUID,object Container) -> object.

predicates
    setStdOutputStream:(outputStream OutputStream).

predicates
    getPzlSystemVersion:()->pzlDomains::pzlSystem_D.

predicates
    getPzlLicenseLevel:()-> pzlDomains::pzlLicenseLevel_D.

predicates
    getPzlLicenseNo:()-> pzlDomains::pzlLicenseNo_D.

predicates
    getRefStatus:()->unsigned RefStatus.

predicates
    getContainerContentInfo:()->pzlDomains::pzlContainerContentInfo_D.

end interface pzlSys