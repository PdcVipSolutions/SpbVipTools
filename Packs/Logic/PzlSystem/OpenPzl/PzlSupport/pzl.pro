/*****************************************************************************
Copyright (c) 2003-2006 Prolog Development Center SPb

Author: Victor Yukhtenko
******************************************************************************/
implement pzl
    open core, exception

clauses
    log()=pzlSys::pzlLog().

clauses
    newByName(Name,Container)=Object:-
        Msg=string::format("The instance of the Component with the Name=% can not be created",Name),
        try
        	Object = pzlSys::newByName(Name, Container)
        catch Err do
        	continue_User(Err, Msg)
        end try.

clauses
    newByID(ClassID,Container)=Object:-
        Msg=string::format("The instance of the Component with the ID=% can not be created",toString(ClassID)),
        try
        	Object = pzlSys::newByID(ClassID, Container)
        catch Err do
        	continue_User(Err, Msg)
        end try.

clauses
    newInstance():-
        pzlSys::newInstance().

clauses
    release():-
        pzlSys::release().

clauses
    setStdOutputStream(OutputStream):-
        pzlSys::setOutputStream(OutputStream).

clauses
    getContainerVersion()=pzlConfig::getContainerVersion().

clauses
    getContainerName()=pzlSys::getContainerName().

clauses
    getComponentRegisterFileName()=pzlSys::getComponentRegisterFileName().

clauses
    subscribe(NotificationListener):-
        pzlSys::subscribe(NotificationListener).

clauses
    unSubscribe(NotificationListener):-
        pzlSys::unSubscribe(NotificationListener).

clauses
    getLicenseLevel()=pzlSys::getLicenseLevel().

clauses
    getContainerContentList(ContainerFileName)=ContentInfo:-
        ContentInfo=pzlSys::getContainerContentList(ContainerFileName).

clauses
    releaseInactiveContainers():-
        pzlSys::releaseInactiveContainers().

clauses
    getContainerActivity_nd(FileName,RefCounter):-
        pzlSys::getContainerActivity_nd(FileName,RefCounter).

clauses
    getContainerToBeUnloaded_nd(FileName):-
        pzlSys::getContainerToBeUnloaded_nd(FileName).

/* System Registry */
clauses
    register(ObjectName,ReferenceToObject):-
        pzlSys::register(ObjectName,ReferenceToObject).

clauses
    registerMulti(ObjectName,ReferenceToObject):-
        pzlSys::registerMulti(ObjectName,ReferenceToObject).

clauses
    unRegister(ObjectName,ReferenceToObject):-
        pzlSys::unRegister(ObjectName,ReferenceToObject).

clauses
    getNameAndObject_nd(ObjectName,ReferenceToObject):-
        pzlSys::getNameAndObject_nd(ObjectName,ReferenceToObject).

clauses
    getObjectByName_nd(ObjectName)=Object:-
        Object=pzlSys::getObjectByName_nd(ObjectName).

clauses
    getNameByObject_nd(Object)=ObjectNameLow:-
        ObjectNameLow=pzlSys::getNamebyObject_nd(Object).

clauses
    unRegisterByName(ObjectName):-
        pzlSys::unRegisterByName(ObjectName).

clauses
    unRegisterAllByNamePrefix(ObjectNamePrefix):-
        pzlSys::unRegisterAllByNamePrefix(ObjectNamePrefix).

clauses
    unRegisterByObject(Object):-
        pzlSys::unRegisterByObject(Object).

clauses
    unRegisterAll():-
        pzlSys::unRegisterAll().

end implement pzl
