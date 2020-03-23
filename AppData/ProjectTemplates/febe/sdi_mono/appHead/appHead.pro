%

implement appHead
    open core, string
    open frontEnd

facts
    frontEnd_P:frontEnd:=erroneous.
    mainWindow_P : fe_Form := erroneous.

clauses
    new():-
        EventManager=eventManager::new(),
        _BackEnd=backEnd::new(EventManager),
        frontEnd_P:=frontEnd::new(EventManager,This),
        frontEnd_P:eventManager_P:appEvent_P:addListener(closeApplication),
        succeed().

clauses
    createMainWindow(FrontEnd)=mainWindow_P:-
        mainWindow_P:=fe_Form::new(FrontEnd).

clauses
    run(ParentWindow):-
        mainWindow_P:setParent(ParentWindow),
        mainWindow_P:show(),
        succeed().

predicates
    closeApplication:event1{integer EventID}::listener.
clauses
    closeApplication(_EventID):-
        Fe_Tasks=convert(fe_CoreTasks,pzl::getObjectByName_nd(concat(toString(frontEnd_P),fe_CoreTasks_C))),
        Fe_Tasks:stopCheckBackEndAlive(),
        Be_Responces=pzl::getObjectByName_nd(string::concat(toString(frontEnd_P),be_Responses_C)),
        convert(be_Responses,Be_Responces):timeOutBlocked_P:=true,
        !,
        frontEnd_P:eventManager_P:appEvent_P:removeAllListeners(),
        pzl::unRegisterAllByNamePrefix(toString(frontEnd_P)),
        mainWindow_P := erroneous,
        frontEnd_P:=erroneous.
    closeApplication(_EventID).

end implement appHead