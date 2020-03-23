%

implement frontEnd
    open core, pfc\log
    open coreIdentifiers, edf

facts
    eventManager_P:eventManager:=erroneous.

facts
    lastFolder_P:string:=directory::getCurrentDirectory().
    currentDirectory_P:string:=directory::getCurrentDirectory().
    ribbonStartup_P:string:="default".
    lastLanguage_P:string:="".
    useMenu_P:string:=useMenuNo_C.
    exchangeDataFormat_P:string:="edf". %Alternative is "json"
%    exchangeDataFormat_P:string:="json". %Alternative is "edf"

clauses
    new(EventManager, Service, HttpClient):-
        pzl::register(string::concat(toString(This),fe_HttpClient_C), HttpClient),
        initComponents(EventManager, Service),
        succeed().

clauses
    new(EventManager, Service):-
        initComponents(EventManager, Service).

predicates
    initComponents:(eventManager EventManager,appHead Service).
clauses
    initComponents(EventManager, Service):-
        eventManager_P:=EventManager,
        Tasks=fe_CoreTasks::new(This),
        pzl::register(string::concat(toString(This),fe_CoreTasks_C), Tasks),
        pzl::register(string::concat(toString(This),fe_Tasks_C), fe_Tasks::new(This)),
        pzl::register(string::concat(toString(This),fe_Tests_C), fe_Tests::new(This)),
        pzl::register(string::concat(toString(This),be_Responses_C),be_Responses::new(This)),
        pzl::register(string::concat(toString(This),fe_Dictionary_C),fe_Dictionary::new(This)),
        MainWindow=Service:createMainWindow(This),
        pzl::register(string::concat(toString(This),fe_AppWindow_C), MainWindow),
        if appHead::isHttpClient = true then
            Tasks:startCheckBackEndAlive()
        end if,
        Tasks:getFrontEndOptions(a([s(lastFolder_C),s(currentLanguage_C),s(useDictionary_C),s(useMenu_C)])),
        MainWindow:initContent(This).

end implement frontEnd