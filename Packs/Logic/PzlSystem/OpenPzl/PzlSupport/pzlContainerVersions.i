/****************************************************************
Copyright (c) 2004-2008 Prolog Development Center SPb Ltd.

****************************************************************/
interface pzlContainerVersions
    open core

constants %License Levels
    pzlOpenPzl_C:pzlDomains::pzlLicenseNo_D = pzlDomains::str("openPzl").

constants  %system Versions
% Initial version  (ZERO)
    pzlSystemDemoZero_C:pzlDomains::pzlSystem_D = pzlDomains::uid(0xBB8447BF,0x6F75,0x42E4,0xA6,0xBA,0xA0,0x76,0x54,0x8B,0x43,0xC7).
    pzlSystemProductionZero_C:pzlDomains::pzlSystem_D = pzlDomains::uid(0xFC9832B1,0x6EEA,0x4DC0,0x9A,0x15,0x99,0xA6,0xFD,0xB7,0xF4,0xF9).


end interface pzlContainerVersions
