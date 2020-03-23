/*****************************************************************************
Copyright (c) PDCSPB

Author: Виктор Юхтенко/WIN-5L3MH3V6R7Q
******************************************************************************/
interface iMonoPzl_$$(Project.Name)
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
    componentID_C:pzlDomains::entityUID_D=pzlDomains::str("$$(Project.Name)_PzlMonoID").
    componentAlias_C="$$(Project.Name)_PzlMonoAlias".
    componentRunAble_C=b_True.
    componentVersion_C="1.0".
    componentPublicName_C="My Component".
    componentMetaInfo_C:namedValue_List=[].

constants
    position_C="position".
    size_C="size".

end interface iMonoPzl_$$(Project.Name)