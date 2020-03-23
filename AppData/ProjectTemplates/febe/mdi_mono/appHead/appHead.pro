%

implement appHead
    open core

facts
    frontEnd_P:frontEnd:=erroneous.
    mainWindow_P : taskWindow := erroneous.

clauses
    new():-
        EventManager=eventManager::new(),
        _BackEnd=backEnd::new(EventManager),
        frontEnd_P:=frontEnd::new(EventManager,This),
        frontEnd_P:eventManager_P:appEvent_P:addListener(closeApplication),
        succeed().

clauses
    createMainWindow(FrontEnd)=mainWindow_P:-
        mainWindow_P:=taskWindow::new(FrontEnd),
        pzl::register(coreConstants::applicationTaskWindow_C,mainWindow_P).

clauses
    run():-
        mainWindow_P:show(),
        succeed().

predicates
    closeApplication:event1{integer EventID}::listener.
clauses
    closeApplication(_EventID):-
        frontEnd_P:eventManager_P:appEvent_P:removeAllListeners(),
        pzl::unRegisterAllByNamePrefix(toString(frontEnd_P)),
        mainWindow_P := erroneous,
        frontEnd_P:=erroneous.

end implement appHead