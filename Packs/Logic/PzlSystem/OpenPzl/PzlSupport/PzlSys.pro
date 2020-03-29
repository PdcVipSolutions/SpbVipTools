/*****************************************************************************
Copyright (c) Prolog Development Center SPb

Author: Victor Yukhtenko
******************************************************************************/
implement pzlSys
    open core,exception, pfc\log

class facts - lifeTime_FB
    life_V:unsigned:=0.
    thisObject_V:pzlSys:=erroneous.
    pzlPort_V:pzlCore:=erroneous.

clauses
    pzlLog()=pzlPort_V:pzlLog_P.

clauses
    new():-
        thisObject_V:=This.

clauses
    setStdOutputStream(OutputStream):-
        stdIO::outputStream:=OutputStream.

clauses
    setOutputStream(OutputStream):-
        pzlPort_V:setStdOutputStream(OutputStream).

clauses
    getRefStatus()=life_V.

clauses
    newInstance():-
        pzlPort_V:isPort(thisObject_V),
        !.
    newInstance():-
        life_V:=life_V+1.

clauses
    newByID(ClassID,Container)=Object:-
        Msg=string::format("Can not create the instance of the class with the ID=%.",toString(ClassID)),
        try
        	Object = pzlPort_V:newByID(ClassID, Container)
        catch Err do
        	continue_User(Err, Msg)
        end try.

clauses
    newInstance(ClassID,Container)=IMain:-
        Msg=string::format("The instance of the class with the ID=% can not be created.",toString(ClassID)),
        try
        	IMain = pzlConfig::new(ClassID, Container)
        catch Err do
        	continue_User(Err, Msg)
        end try.

clauses
    newByName(Alias,Container)=Object:-
        Msg=string::format("The instance of the class with the Name=% can not be created.",Alias),
        try
        	Object = pzlPort_V:newByName(Alias, Container)
        catch Err do
        	continue_User(Err, Msg)
        end try.

clauses
    release():-
        pzlPort_V:isPort(thisObject_V),
        !.
    release():-
        life_V:=life_V-1,
        life_V=0,
        !,
        pzlPort_V:release(thisObject_V).
    release().

clauses
    setPort(ComponentManager):-
        pzlPort_V:=convert(pzlCore,ComponentManager),
        pzlConfig::init().

/*
constants % compatibility versions
    pzlSystemVersion_C:pzlDomains::pzlLicenseNo_D = pzlDomains::str("pzlSystem 1.0").
*/
clauses
    getPzlSystemVersion()=pzlSystemVersion::pzlSystemVersion_C.

clauses
    getPzlLicenseLevel()=pzlDomains::str("openPzl").

clauses
    getPzlLicenseNo()=pzlDomains::str("openPzl").

clauses
    getContainerVersion()=pzlConfig::getContainerVersion().

clauses
    getContainerName()=FullFileName:-
            FullFileName = memory::allocStringBuffer(fileSystem_native::maxPath, memory::contextType_application),
            _  = exe_native::getModuleFileName
                (
                mainExe::getCurrentHinstance(),
                FullFileName,
                fileSystem_native::maxPath
                ).

clauses
    getComponentRegisterFileName()=pzlPort_V:getComponentRegisterFileName().

clauses
    getLicenseLevel()="Unknown".

clauses
    getContainerContentInfo()=NamedValue_List:-
        NamedValue_List=pzlConfig::getComponentIDInfo().

clauses
    getContainerContentList(ContainerFileName)=ContentInfo:-
        ContentInfo=pzlPort_V:getContainerContentList(ContainerFileName).

clauses
    subscribe(NotificationListener):-
        pzlPort_V:subscribe(NotificationListener,none).

clauses
    unSubscribe(NotificationListener):-
        pzlPort_V:unSubscribeFiltered(NotificationListener).

clauses
    releaseInactiveContainers():-
        pzlPort_V:releaseInactiveContainers().

clauses
    getContainerActivity_nd(FileName,RefCounter):-
        pzlPort_V:getContainerActivity_nd(FileName,RefCounter).

clauses
    getContainerToBeUnloaded_nd(FileName):-
        pzlPort_V:getContainerToBeUnloaded_nd(FileName).

/* System Registry */
clauses
    register(ObjectName,ReferenceToObject):-
        pzlPort_V:register(ObjectName,ReferenceToObject).

clauses
    registerMulti(ObjectName,ReferenceToObject):-
        pzlPort_V:registerMulti(ObjectName,ReferenceToObject).

clauses
    getNameAndObject_nd(ObjectName,ReferenceToObject):-
        pzlPort_V:getNameAndObject_nd(ObjectName,ReferenceToObject).

clauses
    getObjectByName_nd(ObjectName)=Object:-
        Object=pzlPort_V:getObjectByName_nd(ObjectName).

clauses
    getNameByObject_nd(Object)=ObjectNameLow:-
        ObjectNameLow=pzlPort_V:getNameByObject_nd(Object).

clauses
    unRegister(ObjectName,Object):-
        pzlPort_V:unRegister(ObjectName,Object).

clauses
    unRegisterByName(ObjectName):-
        pzlPort_V:unRegisterByName(ObjectName).

clauses
    unRegisterAllByNamePrefix(ObjectNamePrefix):-
        pzlPort_V:unRegisterAllByNamePrefix(ObjectNamePrefix).

clauses
    unRegisterByObject(Object):-
        pzlPort_V:unRegisterByObject(Object).

clauses
    unRegisterAll():-
        pzlPort_V:unRegisterAll().

end implement pzlSys
