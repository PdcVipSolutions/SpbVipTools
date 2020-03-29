/*****************************************************************************

Copyright (c) Victor Yukhtenko

******************************************************************************/

interface pzlCore
    supports pzlRegistry
    supports notificationAgency

open core

constants
    initComponent_C = "_pzl".

properties
    pzlLog_P:pzlLog (o).

predicates
    newByID:(pzlDomains::entityUID_D ClassID,object Container)->object procedure (i,i).
    newByName:(string ComponentName,object Container)->object procedure (i,i).

    setStdOutputStream:(outputStream).
    getStdOutputStream:()->outputStream.
    release:(pzlSys PzlContainer) procedure (i).
    isPort:(pzlSys PzlContainer) determ (i).
    getComponentRegisterFileName:()->pzlDomains::pzlComponentsRegisterFileName_D ComponentRegisterFileName procedure ().
    getContainerContentList:(string ContainerFileName)->pzlDomains::pzlContainerContentInfo_D ContainerInfo procedure (i).
    releaseInactiveContainers:().
    getContainerActivity_nd:(string FileName,unsigned RefCounter) nondeterm (o,o).
    getContainerToBeUnloaded_nd:(string FileName) nondeterm (o).

end interface pzlCore