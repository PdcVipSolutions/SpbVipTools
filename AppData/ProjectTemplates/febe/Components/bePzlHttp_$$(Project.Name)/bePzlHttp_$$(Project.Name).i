/*****************************************************************************
Copyright (c) PDCSPB

Author: Victor Yukhtenko
******************************************************************************/
interface ibePzlHttp_$$(Project.Name) 
    supports pzlComponent
    supports appHead
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
    componentID_C:pzlDomains::entityUID_D=pzlDomains::str("appHead_PzlBackend").
    componentAlias_C="appHead_PzlBackend".
    componentRunAble_C=b_True.
    componentVersion_C="1.0".
    componentPublicName_C="My Component".
    componentMetaInfo_C:namedValue_List=[].

end interface ibePzlHttp_$$(Project.Name) 