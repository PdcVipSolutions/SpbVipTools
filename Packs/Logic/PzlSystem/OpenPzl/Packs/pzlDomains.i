/*****************************************************************************
Copyright (c) Victor Yukhtenko

Written by: Victor Yukhtenko
******************************************************************************/

interface pzlDomains
    open core

domains
    pzlComponentsRegisterFileName_D=
        pzlRegistryFileName(string FileName);
        pzlRegistryFileNameWronglyDefined;
        pzlRegistryFileNameNotInUse.

domains
    entityUID_D =
        str(string);
        uid(
        unsigned Unsigned,
        core::unsigned16 Short1,
        core::unsigned16 Short2,
        core::unsigned8 Byte1,
        core::unsigned8 Byte2,
        core::unsigned8 Byte3,
        core::unsigned8 Byte4,
        core::unsigned8 Byte5,
        core::unsigned8 Byte6,
        core::unsigned8 Byte7,
        core::unsigned8 Byte8).

    pzlContainerContentInfo_D = pzlComponentInfo_D*.
    pzlComponentInfo_D=pzlComponentInfo
        (
        string Alias,
        entityUID_D ComponentID,
        booleanInt Runable,
        core::namedValue_List UserDefinedInfo
        ).

    pzlSystem_D = entityUID_D.
    pzlLicenseLevel_D = entityUID_D.
    pzlLicenseNo_D = entityUID_D.

constants
    nullObject_C:object=uncheckedConvert(object,0).

% System registry KeyWords
constants
    registryVPPuZzleAtGlobal_C = "vp_PuZzle".
    registryComponentsAtGlobal_C = "vp_PuZzle\\pzlComponents".

    registryVPPuZzleAtLocalUser_C = "SOFTWARE\\vp_PuZzle".
    registryComponentsAtLocalUser_C = "Software\\vp_PuZzle\\pzlComponents".

    registryContainer_C = "pzlContainer".
    registryRunAble_C = "RunAble".
    registryRunAbleTrue_C="True".
    registryRunAbleFalse_C="False".

end interface pzlDomains
