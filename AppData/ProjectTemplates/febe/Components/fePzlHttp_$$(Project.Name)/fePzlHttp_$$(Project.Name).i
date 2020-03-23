/*****************************************************************************
Copyright (c) 2006-2016 PDCSPB

Author: Виктор Юхтенко/WIN-5L3MH3V6R7Q
******************************************************************************/
interface ifePzlHttp_$$(Project.Name)
    supports pzlComponent
    supports pzlRun

open core

constants
    componentDescriptor_C:pzlDomains::pzlComponentInfo_D=pzlDomains::pzlComponentInfo
                (
                componentAlias_C,
                componentID_C,
                componentRunAble_C,
                componentMetaInfo_C
                ).
    componentID_C:pzlDomains::entityUID_D=pzlDomains::str("fePzlHttp_$$(Project.Name)ID").
    componentAlias_C="fePzlHttp_$$(Project.Name)".
    componentRunAble_C=b_True.
    componentVersion_C="1.0".
    componentPublicName_C="My Component".
    componentMetaInfo_C:namedValue_List=[].

end interface ifePzlHttp_$$(Project.Name)