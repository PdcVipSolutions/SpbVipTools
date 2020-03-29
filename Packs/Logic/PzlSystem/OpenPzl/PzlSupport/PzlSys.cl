/*****************************************************************************

Copyright (c) Victor Yukhtenko

 Written by: Victor Yukhtenko
******************************************************************************/
class pzlSys : pzlSys

constructors
    new:().

predicates
    pzlLog:()->pzlLog.

predicates % PZL system privilaged
    newByID:(pzlDomains::entityUID_D,object Container)->object procedure.
    setPort:(object Port) procedure.

predicates % PZL system privilaged
    newInstance:().
    release:() procedure ().

predicates % Anonymous  Object creation
    newByName:(string Name,object Container)->object Object procedure.

predicates % This Container and pzl-system Info
    getContainerName:()->string ThisContainerName procedure.
    getContainerVersion:()->string ThisContainerVersion procedure.
    setOutputStream:(outputStream OutputStream).
    getLicenseLevel:()->string PZLUserLicenseLevel procedure.
    getComponentRegisterFileName:()->pzlDomains::pzlComponentsRegisterFileName_D ComponentRegisterFileName procedure.
    getContainerContentList:(string ContainerFileName)->pzlDomains::pzlContainerContentInfo_D ContainerInfo procedure.

predicates
    subscribe:(notificationAgency::notificationListenerFiltered NotificationListener).
    unSubscribe:(notificationAgency::notificationListenerFiltered NotificationListener).
    releaseInactiveContainers:().
    getContainerActivity_nd:(string FileName,unsigned RefCounter) nondeterm (o,o).
    getContainerToBeUnloaded_nd:(string FileName) nondeterm (o).

predicates % Object registration
    register:(string ObjectName,object Object) procedure.
    registerMulti:(string ObjectName,object Object) procedure.
    getObjectByName_nd:(string ObjectName)->object Object nondeterm.
    getNameByObject_nd:(object Object)->string ObjectNameLow nondeterm.
    getNameAndObject_nd:(string ObjectName,object Object) nondeterm (o,o).
    unRegister:(string ObjectName,object Object) procedure.
    unRegisterByName:(string ObjectName) procedure.
    unRegisterAllByNamePrefix:(string ObjectNamePrefix).
    unRegisterByObject:(object Object) procedure.
    unRegisterAll:() procedure.

end class pzlSys