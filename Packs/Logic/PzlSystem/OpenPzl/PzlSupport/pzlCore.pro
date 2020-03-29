/*****************************************************************************
Copyright (c) 2002-2008 Prolog Development Center SPb

Author: Victor Yukhtenko
******************************************************************************/
implement pzlCore
    inherits pzlRegistry
    inherits notificationAgency

    open core
    open exception
    open stdIO
    open pfc\log\

constants
    executable_C = "pzlPort".

clauses % This Class constructor.
    new(ExecutableComponentID):-
        exe_V:=ExecutableComponentID.

clauses
    finalize():-
        dll_F(_ClassUID,DllObject,_ComponentID),
            not(DllObject=uncheckedConvert(useDll,0)),
            DllObject:unload(),
        fail.
    finalize().

class facts - dll_fb
    reg_F:(string ClassAlias,pzlDomains::entityUID_D ClassUID,booleanInt TrueIfRunable,string DLLName).

class facts - cPzlPortIni_FB
    dll_F:(pzlDomains::entityUID_D ClassUID,useDll DllObject,pzlSys ComponentID).
    initialized_V:boolean:=false.
    pzlComponentsRegisterFileName_V: pzlDomains::pzlComponentsRegisterFileName_D :=erroneous.
    exe_V:pzlSys :=erroneous.
    pzlLog_V:pzlLog:=erroneous.
    componentRegisterFileLoaded_V:boolean:=false.

clauses
    pzlLog_P()=pzlLog_V.

clauses
    init():-
        pzlLog_V:=pzlLog::new(),
        log::write(log::info, "InitPort"),
        tryInitPort(),
        !,
        pzlComponentsRegisterFileName_V:=pzlDomains::pzlRegistryFileNameNotInUse,
        initialized_V:=true.
    init():-
        log::write(log::info, "Port already initialized").

class predicates
    tryInitPort:() determ ().
clauses
    tryInitPort():-
        initialized_V=false,
        PzlSys = pzlSys::new(),
        PzlCore = pzlCore::new(PzlSys),
        pzlSys::setPort(PzlCore),
        loadPortComponentsInfo(PzlCore).

clauses
    isInitialized():-
        initialized_V=true.

clauses
    isPort(exe_V).

class predicates
    loadPortComponentsInfo:(pzlCore).
clauses
    loadPortComponentsInfo(PzlCore):-
        ComponentList=PzlCore:getContainerContentList(executable_C),
        _=[""||
            pzlDomains::pzlComponentInfo(ClassAlias,ClassUID,RunAble,_UserInfo) in ComponentList,
                log::write(log::info, string::format("allias: [%] uid: [%]",ClassAlias,ClassUID)),
                assert(reg_F(ClassAlias,ClassUID,RunAble,executable_C))
            ].

/* OutPut Stream support */
clauses
    getStdOutputStream()=OutputStream:-
        try
            OutputStream=stdIO::outputStream
        catch _TraceID do
            OutputStream=uncheckedConvert(outputStream,null)
        end try.

clauses
    setStdOutputStream(OutputStream):-
        stdIO::outputStream:=OutputStream,
        dllRef_F(_DllNameSrc,_DllName,DllObj),
            setStdOutputStream(DllObj,OutputStream),
        fail.
    setStdOutputStream(_OutputStream).

class predicates
    setStdOutputStream:(useDll DllObj,outputStream OutputStream).
clauses
    setStdOutputStream(DllObj,OutputStream):-
        dll_F(_ClassUID,DllObj,PzlContainer),
        !,
        PzlContainer:setStdOutputStream(OutputStream).
    setStdOutputStream(_DllObj,_OutputStream).

/* Registry FileName support */
clauses
    setComponentRegisterFileName(DllRegisterFileName):-
        fileName::getPathAndName(DllRegisterFileName,Path,Name),
        try
        	file::existExactFile(DllRegisterFileName)
        catch Err do
        	pzlComponentsRegisterFileName_V := pzlDomains::pzlRegistryFileNameWronglyDefined,
            MSG = string::format("System Error while checking the PZR file %(%) existence", Name,Path),
            continue_User(Err, MSG)
        end try,
        !,
        pzlComponentsRegisterFileName_V:=pzlDomains::pzlRegistryFileName(DllRegisterFileName).
    setComponentRegisterFileName(DllRegisterFileName):-
        fileName::getPathAndName(DllRegisterFileName,Path,Name),
        pzlComponentsRegisterFileName_V:=pzlDomains::pzlRegistryFileNameWronglyDefined,
        MSG=string::format("Not found PZR File %(%)",Name,Path),
        raise_User(MSG).

clauses
    getComponentRegisterFileName()=pzlDomains::pzlRegistryFileNameNotInUse:-
        isErroneous(pzlComponentsRegisterFileName_V),
        !.
    getComponentRegisterFileName()=pzlComponentsRegisterFileName_V.

class predicates
    loadComponentRegister:() procedure ().
clauses
    loadComponentRegister():-
        isErroneous(pzlComponentsRegisterFileName_V),
        !.
    loadComponentRegister():-
        pzlComponentsRegisterFileName_V=pzlDomains::pzlRegistryFileNameNotInUse,
        !.
    loadComponentRegister():-
        componentRegisterFileLoaded_V=false,
        pzlComponentsRegisterFileName_V=pzlDomains::pzlRegistryFileName(ComponentsRegisterFileName),
        fileName::getPathAndName(ComponentsRegisterFileName,Path,Name),
        try
        	file::consult(ComponentsRegisterFileName, dll_fb)
        catch Err do
        	Msg = string::format("Can not load the PZL register %(%)",Name,Path),
            pzlComponentsRegisterFileName_V := pzlDomains::pzlRegistryFileNameWronglyDefined,
            continue_User(Err, Msg)
        end try,
        !,
        componentRegisterFileLoaded_V:=true.
    loadComponentRegister().

clauses
    newByID(ClassUID,Container)=InterfaceRef:-
        InterfaceRef = newInstance(ClassUID,Container),
        notify(This,none,none),
        succeed().

clauses
    newByName(ComponentName,ContainerObj)=InterfaceRef:-
        loadComponentRegister(),
        ClassUID=getComponentID(ComponentName),
        InterfaceRef = newInstance(ClassUID,ContainerObj),
        notify(This,none,none),
        succeed().

predicates
    newInstance:(pzlDomains::entityUID_D ClassUID,object Container) -> object procedure (i,i).
clauses
    newInstance(ClassUID,_Container)=_:- % cancel unload request if the same class is to be activated
        dll_F(ClassUID,_DllObject,PzlContainer),
            removeUnloadRequest(PzlContainer),
%            log::write(log::info, string::format("removing unload request for container [%]  for class uid [%]",PzlContainer,ClassUID)),
        fail.
    newInstance(_ClassUID,_Container)=_:-
%        log::write(log::info, "releasing unused containers"),
        releaseInactiveContainers(), % unload containers ready to be unloaded for streamTrue/False
        releaseInactiveContainers(), % ... same for streamFalse/True
%        log::write(log::info, "unused containers released"),
        fail.
    newInstance(ClassUID,Container)=InterfaceRef:- % Container is currently in use
        try
            dll_F(ClassUID, _DllObj, PzlContainer),
%           log::write(log::info, string::format("container [%] currently in use",PzlContainer)),
           succeed()
        catch Err do
        	continue_User(Err, string::format("Fatal Error:%", toString(Err)))
        end try,
        !,
%        log::write(log::info, string::format("creating instance [%] in active container [%]",ClassUID,PzlContainer)),
        InterfaceRef = PzlContainer:newInstance(ClassUID,Container),
%        log::write(log::info, string::format("created instance [%] of class [%] in active container [%]",InterfaceRef, ClassUID,PzlContainer)),
        succeed().
    newInstance(ClassUID,Container)=InterfaceRef:- % if Class is in the executable Application (not DLL)
        ComponentID=getContainerName(ClassUID,ContainerName),
        ContainerName=executable_C,       % this is the special predefined mark of the executable application
        not(isErroneous(exe_V)),
        InterfaceRef = exe_V:newInstance(ClassUID,Container),
        assertz(dll_F(ComponentID,uncheckedConvert(useDll,0),exe_V)),
%        log::write(log::info, string::format("created instance [%] in pzlPort",InterfaceRef)),
        !.
    newInstance(ClassUID,Container)=InterfaceRef:- % Component is in the known Container
        ComponentID=getContainerName(ClassUID,DLLName),
        dllRef_F(_DllNameSrc,string::toLowerCase(DLLName),DLLObject),
        dll_F(_ClassUID,DLLObject,PzlContainer),
        !,
        assertz(dll_F(ComponentID,DllObject,PzlContainer)),
        InterfaceRef=PzlContainer:newInstance(ClassUID,Container),
%        log::write(log::info, string::format("created instance [%] of [%] in known container [%]",InterfaceRef,ComponentID,PzlContainer)),
        succeed().
    newInstance(ClassUID,Container)=InterfaceRef:-
        ComponentID=getContainerName(ClassUID,DLLNameSrc),
        tuple(PzlContainer,DllObject)=initPzlContainer(DLLNameSrc),
        checkCompatibility(DLLNameSrc,PzlContainer,DllObject),
        assertz(dll_F(ComponentID,DllObject,PzlContainer)),
        assertz(dllRef_F(DllNameSrc,string::toLowerCase(DLLNameSrc),DllObject)),
        InterfaceRef = PzlContainer:newInstance(ClassUID,Container),
%        log::write(log::info, string::format("created instance [%] of [%] in new container [%]",InterfaceRef,ClassUID,PzlContainer)),
        succeed().

predicates
    getComponentID:(string ComponentAlias)->pzlDomains::entityUID_D ClassUID.
clauses
    getComponentID(ComponentName)=ClassUID:-
        reg_F(RegNameAnyCase,ClassUID,_RunAble,_DLLName),
            string::equalIgnoreCase(ComponentName,RegNameAnyCase),
        !.
    getComponentID(ComponentName)=convertToPzlUid(ComponentIDstr):-
        core::string(ComponentIDstr) = registry::tryGetValue(registry::currentUser(), string::format(@"%\%", pzlDomains::registryVPPuZzleAtLocalUser_C, ComponentName), ""),
        !.
    getComponentID(ComponentName)=convertToPzlUid(ComponentIDstr):-
        core::string(ComponentIDstr) = registry::tryGetValue(registry::classesRoot(), string::format(@"%\%", pzlDomains::registryVPPuZzleAtGlobal_C, ComponentName), ""),
        !.
    getComponentID(ComponentName)=_:-
        raise_User(string::format("The Component % not registered in the PzlSystem",ComponentName)).

predicates
    checkCompatibility:(string DllName,pzlSys ContainerSystem,useDll DllObject) procedure (i,i,i).
clauses
    checkCompatibility(DllName,ContainerSystem,DllObject):-
        try
        	checkSystemCompatibility(DllName, ContainerSystem)
        catch Err1 do
        	unloadExceptional(Err1, DLLName, DllObject)
        end try.

predicates
    checkSystemCompatibility:(string DllName,pzlSys ContainerSystem) procedure (i,i).
clauses
    checkSystemCompatibility(_DllName,ContainerSystem):-
        PortSystemVersion=exe_V:getPzlSystemVersion(),
        PortSystemVersion=ContainerSystem:getPzlSystemVersion(),
        !.
    checkSystemCompatibility(DllName,_ContainerSystem):-
        fileName::getPathAndName(DllName,Path,Name),
        Msg=string::format("The PzlContainer %(%) and PzlPort created by incompatioble VipVersions.\nContainer is to be unloaded",Name,Path),
        raise_User(Msg).

clauses
    getContainerContentList(executable_C)=OutValue:-
        !,
        OutValue=exe_V:getContainerContentInfo().
    getContainerContentList(AskedMainApplication)=OutValue:-
        mainExe::getFileName(_Path,ThisFileName),
        CurrentPath=directory::getCurrentDirectory(),
        Main=fileName::reduce(AskedMainApplication,CurrentPath),
        ThisExe=fileName::reduce(ThisFileName,CurrentPath),
        string::toLowerCase(ThisExe)=string::toLowerCase(Main),
        !,
        OutValue=exe_V:getContainerContentInfo().
    getContainerContentList(DLLName)=OutValue:-
        CurrentPath=directory::getCurrentDirectory(),
        DllRequested=fileName::reduce(DLLName,CurrentPath),
        dllRef_F(_DllNameSrc,DLLNameStored,DllObject),
            DllStored=fileName::reduce(DLLNameStored,CurrentPath),
            string::toLowerCase(DllRequested)=string::toLowerCase(DllStored),
        dll_F(_ComponentID,DllObject,PzlContainer),
        !,
        OutValue=PzlContainer:getContainerContentInfo().
    getContainerContentList(DLLName)=OutValue:-
        tuple(PzlContainer,DllObject)=initPzlContainer(DLLName),
        OutValue=PzlContainer:getContainerContentInfo(),
        try
        	DllObject:unload(),
            succeed()
        catch Err do
            fileName::getPathAndName(DllName,Path,Name),
        	continue_User(Err, string::format("Can not unload Dll %(%)",Name,Path))
        end try.

predicates
    getContainerName:(pzlDomains::entityUID_D ClassUID,string DLLName)->pzlDomains::entityUID_D ComponentID procedure (i,o).
clauses
    getContainerName(_ClassUID,_)=_:-
        loadComponentRegister(),
        fail.
    getContainerName(ClassUID,DLLName)=ComponentUID:-
        reg_F(_ClassAlias,ComponentUID,_RunAble,DLLName),
        ComponentUID=ClassUID,
        !.
    getContainerName(ClassUID,DLLName)=ComponentUID:-
        try
        	ComponentUID = tryFindInCurrentUserRegistry(ClassUID, DLLName)
        catch _Err do
        	fail
        end try,
        !.
    getContainerName(ClassUID,DLLName)=ComponentUID:-
        try
        	ComponentUID = tryFindInSystemRegistry(ClassUID, DLLName)
        catch _Err do
        	fail
        end try,
        !.
    getContainerName(ClassUID,_DllName)=_:-
        Msg=string::format("The pzlContainer not found for the pzlComponent %",ClassUID),
        raise_User(Msg).

/*******************/

predicates
    tryFindInSystemRegistry:(pzlDomains::entityUID_D ClassUID,string DLLName)->pzlDomains::entityUID_D ComponentID determ (i,o).
clauses
    tryFindInSystemRegistry(ClassUID,DLLNameStr)=ClassUID:-
        ClassUIDstr=convertToPzlUIDString(ClassUID),
        RegistryPath=string::format("%\\%",pzlDomains::registryComponentsAtGlobal_C,ClassUIDstr),
        try
        	RegistryEntry = registry::getValue(registry::classesRoot(), RegistryPath, "")
        catch Err1 do
        	continue_User(Err1, string::format("Registry Entry by path % at ClassesRoot not found", RegistryPath))
        end try,
        RegistryEntry=core::string(RegistryEntryStr),
        try
        	DLLName = registry::getValue(registry::classesRoot(), RegistryEntryStr, pzlDomains::registryContainer_C)
        catch Err2 do
        	continue_User(Err2, string::format("DLL Name by path %/% at ClassesRoot not found", RegistryEntryStr, pzlDomains::registryContainer_C))
        end try,
        DLLName=core::string(DLLNameStr).

predicates
    tryFindInCurrentUserRegistry:(pzlDomains::entityUID_D ClassUID,string DLLName)->pzlDomains::entityUID_D ComponentID determ (i,o).
clauses
    tryFindInCurrentUserRegistry(ClassUID,DLLNameStr)=ClassUID:-
        ClassUIDstr=convertToPzlUIDString(ClassUID),
        RegistryPath=string::format("%\\%",pzlDomains::registryComponentsAtLocalUser_C,ClassUIDstr),
        try
        	RegistryEntry = registry::getValue(registry::currentUser(), RegistryPath, "")
        catch Err1 do
        	continue_User(Err1, string::format("Registry Entry by path % at CurrentUser not found", RegistryPath))
        end try,
        RegistryEntry=core::string(RegistryEntryStr),
        try
        	DLLName = registry::getValue(registry::currentUser(), RegistryEntryStr, pzlDomains::registryContainer_C)
        catch Err2 do
        	continue_User(Err2, string::format("DLL Name by path %/% at CurrentUser not found", RegistryEntryStr, pzlDomains::registryContainer_C))
        end try,
        DLLName=core::string(DLLNameStr).

/*******************/
class facts - dllName_dllObj_FB
    dllRef_F:(string DllNameSrc,string DllNameInLowerCase,useDll DllObj).

domains
    initContainer = (object PzlPort) ->pzlSys PzlContainer procedure (i) language stdCall.
predicates
    initPzlContainer:(string DLLName)->tuple{pzlSys PzlContainer,useDLL} procedure.
clauses
    initPzlContainer(DLLName)=tuple(PzlContainer,DllObject):-
%        log::write(log::info, string::format("init dll [%]",DLLName)),
        filename::getPathAndName(DLLName,Path,Name),
        try
        	DllObject = useDll::load(DLLName)
        catch Err1 do
            Msg1=string::format("Can not load PZL Container % (%)",Name,Path),
        	continue_User(Err1, Msg1)
        end try,
        try
        	PredicateHandle = DllObject:getPredicateHandle(initComponent_C)
        catch Err2 do
        	unloadExceptional(Err2, DLLName, DllObject)
        end try,
        InitContainer = uncheckedConvert(initContainer,PredicateHandle),
        try
        	PzlContainer = InitContainer(This)
        catch Err3 do
            Msg2=string::format("Can not initialize PZL Container % (%)",Name,Path),
        	continue_User(Err3, Msg2)
        end try.

predicates
    unloadExceptional:(exception::traceID ErrorCode,string DLLName,useDll DllObject) erroneous (i,i,i).
clauses
    unloadExceptional(ErrorCode,DLLName,DllObject):-
        filename::getPathAndName(DLLName,Path,Name),
        try
        	DLLObject:unload()
        catch Err do
        	continue_User(Err, string::format("Can not unload DLL (%) %",Name,Path))
        end try,
        Msg1=string::format("Invalid Predicate handle <%> \nPZL container <%(%)>unloaded",initComponent_C,Name,Path),
        continue_User(ErrorCode,Msg1).

/************************
  Release containers mechanizm

************************/
class facts
    semaphore_V:boolean:=true.
    streamTrue_F:(pzlSys ContainerRepresentative).
    streamFalse_F:(pzlSys ContainerRepresentative).
%    cs : criticalSection := criticalSection::new() [immediate].

predicates
    release_safe:(pzlSys PzlContainer).
clauses
    release(PzlContainer):-
        release_safe(PzlContainer).

    release_safe(PzlContainer):-
   %     log::write(log::info, string::format("semafore [%]",semaphore_V)),
        semaphore_V=true,
        !,
%        log::write(log::info, string::format("set streamFalse [%]",toString(PzlContainer))),
        assert(streamFalse_F(PzlContainer)),
%        semaphore_V:=false,
        succeed().
    release_safe(PzlContainer):-
%        log::write(log::info, string::format("semafore [%]",semaphore_V)),
        semaphore_V=false,
        !,
%        log::write(log::info, string::format("set streamTrue [%]",toString(PzlContainer))),
        assert(streamTrue_F(PzlContainer)),
%        semaphore_V:=true,
        succeed().
    release_safe(_PzlContainer):-
        raise_User("unexpected alternative").

predicates
    removeUnloadRequest_safe:(pzlSys PzlContainer).
    removeUnloadRequest:(pzlSys PzlContainer).
clauses
    removeUnloadRequest(PzlContainer):-
        removeUnloadRequest_safe(PzlContainer).

    removeUnloadRequest_safe(PzlContainer):-
        semaphore_V=false,
        retractall(streamTrue_F(PzlContainer)),
        fail.
    removeUnloadRequest_safe(PzlContainer):-
        semaphore_V=true,
        retractall(streamFalse_F(PzlContainer)),
        fail.
    removeUnloadRequest_safe(_PzlContainer).

predicates
    releaseInactiveContainers_safe:().
clauses
    releaseInactiveContainers():-
        releaseInactiveContainers_safe().

    releaseInactiveContainers_safe():-
        semaphore_V=true,
        retract(streamTrue_F(PzlContainer)),
%            log::write(log::info, string::format("streamTrue release container [%]",toString(PzlContainer))),
            unloadReleasedContainer(PzlContainer),
        fail.
    releaseInactiveContainers_safe():-
        semaphore_V=false,
        retract(streamFalse_F(PzlContainer)),
%            log::write(log::info, string::format("streamFalse release container [%]",toString(PzlContainer))),
            unloadReleasedContainer(PzlContainer),
        fail.
    releaseInactiveContainers_safe():-
        semaphore_V=true,
        !,
        semaphore_V:=false.
    releaseInactiveContainers_safe():-
        semaphore_V=false,
        !,
        semaphore_V:=true.
    releaseInactiveContainers_safe():-
        raise_User("unexpected alternative").


predicates
    unloadReleasedContainer_safe:(pzlSys PzlContainer).
    unloadReleasedContainer:(pzlSys PzlContainer).

clauses
    unloadReleasedContainer(PzlContainer):-
        unloadReleasedContainer_safe(PzlContainer).

    unloadReleasedContainer_safe(PzlContainer):-
        tuple(DLLObject,Name)=tryGetDllObjectToBeUnloaded(PzlContainer),
        !,
%        log::write(log::info, Name),
        retractall(dll_F(_,DLLObject,_)),
        retractall(dllRef_F(_,_,DLLObject)),
        try
%            log::write(log::info, string::format("unload container [%]",Name)),
            DLLObject:unload(),
%            log::write(log::info, string::format("unloaded [%]",Name)),
            succeed()
        catch Err do
%            log::write(log::error, string::format("can not unload [%]",Name)),
            continue_User(Err, string::format("Can not unload Dll %", Name))
        end try.
    unloadReleasedContainer_safe(_PzlContainer).

clauses
    getContainerToBeUnloaded_nd(FileName):-
        streamTrue_F(PzlContainer),
            tuple(_DLLObject,Name)=tryGetDllObjectToBeUnloaded(PzlContainer),
            FileName=fileName::getName(Name).
    getContainerToBeUnloaded_nd(FileName):-
        streamFalse_F(PzlContainer),
            tuple(_DLLObject,Name)=tryGetDllObjectToBeUnloaded(PzlContainer),
            FileName=fileName::getName(Name).

class predicates
    tryGetDllObjectToBeUnloaded:(pzlSys)->tuple{useDll DllObject,string DllNameSrc} determ.
clauses
    tryGetDllObjectToBeUnloaded(PzlContainer)=tuple(DllObject,DllNameSrc):-
        dll_F(_ClassUID,DllObject,PzlContainer),
            dllRef_F(DllNameSrc,_Name,DLLObject),
            !.

class predicates
    getRefCounter:(useDll DLLObject)->unsigned RefCounter.
clauses
    getRefCounter(DLLObject)=RefCounter:-
        dll_F(_ClassUID,DllObject,PzlContainer),
        !,
        RefCounter=PzlContainer:getRefStatus().
    getRefCounter(DLLObject)=_:-
        Msg=string::format("No info regarding DllObj [%] found",toString(DLLObject)),
        raise_User(Msg).

clauses
    getContainerActivity_nd(FileName,RefCounter):-
        dllRef_F(DllNameSrc,_DllName,DLLObject),
            FileName=fileName::getName(DllNameSrc),
            RefCounter=getRefCounter(DLLObject).

/********************
pzlUid Conversions
*********************/
predicates
    convertToPzlUidString:(pzlDomains::entityUID_D PzlUid)->string PzlUidStr.
clauses
    convertToPzlUidString(pzlDomains::str(Name))=Name:-!.
    convertToPzlUidString(
        pzlDomains::uid
            (
            Unsigned,
            Short1,
            Short2,
            Byte1,
            Byte2,
            Byte3,
            Byte4,
            Byte5,
            Byte6,
            Byte7,
            Byte8
            ))=
            string::format("{%08X-%04X-%04X-%02X%02X-%02X%02X%02X%02X%02X%02X}",
                                Unsigned,
                                Short1,
                                Short2,
                                Byte1,
                                Byte2,
                                Byte3,
                                Byte4,
                                Byte5,
                                Byte6,
                                Byte7,
                                Byte8
                                ).
predicates
    convertToPzlUid:(string UIDStringPresentation)->pzlDomains::entityUID_D procedure (i).
clauses
    convertToPzlUid(UIDStringPresentation)=
        pzlDomains::uid
            (
            Unsigned,
            Short1,
            Short2,
            Byte1,
            Byte2,
            Byte3,
            Byte4,
            Byte5,
            Byte6,
            Byte7,
            Byte8
            ):-
        UidList=string::split_Delimiter(UIDStringPresentation,"-"),
        UidList=
            [
                LeftFigBracket_UnsignedStr,
                Short1Str,
                Short2Str,
                BytesStr_4,
                BytesStr_6_RightFigBracket
            ],
        string::frontChar(LeftFigBracket_UnsignedStr,LeftFigBracket,UnsignedStr),
        LeftFigBracket='{',
        try
        	[B4_1, B4_2] = string::split_Length(BytesStr_4, [2, 2])
        catch _Err1 do
        	fail
        end try,
        try
        	string::front(BytesStr_6_RightFigBracket, 12, BytesStr, RightFigBracket)
        catch _Err2 do
        	fail
        end try,
        RightFigBracket="}",
        try
        	[B6_1, B6_2, B6_3, B6_4, B6_5, B6_6] = string::split_Length(BytesStr, [2, 2, 2, 2, 2, 2])
        catch _Err3 do
        	fail
        end try,
        try
        	Unsigned = toTerm(string::concat("0x", UnsignedStr))
        catch _Err4 do
        	fail
        end try,
        try
        	Short1 = toTerm(string::concat("0x", Short1Str))
        catch _Err5 do
        	fail
        end try,
        try
        	Short2 = toTerm(string::concat("0x", Short2Str))
        catch _Err6 do
        	fail
        end try,
        try
        	Byte1 = toTerm(string::concat("0x", B4_1))
        catch _Err7 do
        	fail
        end try,
        try
        	Byte2 = toTerm(string::concat("0x", B4_2))
        catch _Err8 do
        	fail
        end try,
        try
        	Byte3 = toTerm(string::concat("0x", B6_1))
        catch _Err9 do
        	fail
        end try,
        try
        	Byte4 = toTerm(string::concat("0x", B6_2))
        catch _Err10 do
        	fail
        end try,
        try
        	Byte5 = toTerm(string::concat("0x", B6_3))
        catch _Err11 do
        	fail
        end try,
        try
        	Byte6 = toTerm(string::concat("0x", B6_4))
        catch _Err12 do
        	fail
        end try,
        try
        	Byte7 = toTerm(string::concat("0x", B6_5))
        catch _Err13 do
        	fail
        end try,
        try
        	Byte8 = toTerm(string::concat("0x", B6_6))
        catch _Err14 do
        	fail
        end try,
        !.
    convertToPzlUid(UIDStringPresentation)=pzlDomains::str(UIDStringPresentation).

end implement pzlCore
