/*****************************************************************************
Copyright (c) Victor Yukhtenko

Author: Victor Yukhtenko
******************************************************************************/
class pzl

predicates % LifeTime support
    newInstance:().
    release:() procedure ().

predicates
    getLogAppenders:()->object*.

predicates % creation by ID
    newByID:(pzlDomains::entityUID_D,object Container)->object procedure (i,i).

predicates % creation by Name
    newByName:(string Name,object Container)->object Object procedure (i,i).

predicates % This Container and pzl-system Info
    getContainerName:()->string ThisContainerName procedure ().
    getContainerVersion:()->string ThisContainerVersion procedure ().
    getLicenseLevel:()->string PZLUserLicenseLevel procedure ().
    getComponentRegisterFileName:()->pzlDomains::pzlComponentsRegisterFileName_D ComponentRegisterFileName procedure ().
    getContainerContentList:(string ContainerFileName)->pzlDomains::pzlContainerContentInfo_D ContainerInfo procedure (i).
    setStdOutputStream:(outputStream OutputStream).

predicates
    subscribe:(notificationAgency::notificationListenerFiltered NotificationListener).
    unSubscribe:(notificationAgency::notificationListenerFiltered NotificationListener).
    releaseInactiveContainers:().
    getContainerActivity_nd:(string FileName,unsigned RefCounter) nondeterm (o,o).
    getContainerToBeUnloaded_nd:(string FileName) nondeterm (o).

predicates % Object registration
    register:(string ObjectName,object Object) procedure (i,i).
    registerMulti:(string ObjectName,object Object) procedure (i,i).
    getObjectByName_nd:(string ObjectName)->object Object nondeterm (i).
    getNamebyObject_nd:(object Object)->string ObjectNameLow nondeterm (i).
    getNameAndObject_nd:(string ObjectName,object Object) nondeterm (o,o).
    unRegister:(string ObjectName,object Object) procedure (i,i).
    unRegisterByName:(string ObjectName) procedure (i).
    unRegisterByObject:(object Object) procedure (i).
    unRegisterAll:() procedure ().

end class pzl