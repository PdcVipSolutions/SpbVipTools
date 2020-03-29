/*****************************************************************************

Copyright (c) Victor Yukhtenko

 Written by: Victor Yukhtenko
******************************************************************************/

interface pzl

    predicates
        newInstance:(pzlDomains::entityUID_D ClassUID) -> object procedure (i).

    predicates
        getPzlSystemVersion:()->pzlDomains::pzlSystem_D procedure ().

    predicates
        getPzlLicenseLevel:()-> pzlDomains::pzlLicenseLevel_D procedure ().

    predicates
        getPzlLicenseNo:()-> pzlDomains::pzlLicenseNo_D procedure ().

    predicates
        getContainerContentInfo:()->core::namedValue_List procedure().

end interface pzl