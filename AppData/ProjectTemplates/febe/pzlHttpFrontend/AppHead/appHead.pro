%

implement appHead

open core, string
open frontEnd, http_Client

facts
    mainWindow_P : fe_Form := erroneous.
    frontEnd_P:frontEnd:=erroneous.

    backEndServiceIP_P:string:=erroneous.
    backEndServicePath_P:string:=erroneous.

clauses
    run(ParentWindow):-
        EventManager=eventManager::new(),
        HttpClient=http_Client::new(EventManager),
        HttpClient:messageID_ParameterName_P:="eventID",
        HttpClient:parameters_ParameterName_P:="evParams",
        HttpClient:sleepInterval_P:=5,
        HttpClient:transactionID_P:="transID",
        HttpClient:maxNoOfCyclingRequests_P:=80,
        HttpClient:server_Url_P:=string::format("%s/%s",backEndServiceIP_P,backEndServicePath_P),
        HttpClient:methodRequest_P:=methodRequest_C,
        HttpClient:methodChain_P:=methodChain_C,
        HttpClient:methodDo_P:=methodDo_C,
        HttpClient:methodNext_P:=methodNext_C,
        frontEnd_P:=frontEnd::new(EventManager,This,HttpClient),
        mainWindow_P:setParent(ParentWindow),
        mainWindow_P:show(),
        mainWindow_P:addDestroyListener(onDestroy),
        succeed().

clauses
    createMainWindow(FrontEnd)=mainWindow_P:-
        mainWindow_P:=fe_Form::new(FrontEnd).

predicates
    onDestroy:window::destroyListener.
clauses
    onDestroy(_Source):-
        Fe_Tasks=convert(fe_CoreTasks,pzl::getObjectByName_nd(concat(toString(frontEnd_P),fe_CoreTasks_C))),
        Fe_Tasks:stopCheckBackEndAlive(),
        Be_Responces=pzl::getObjectByName_nd(string::concat(toString(frontEnd_P),be_Responses_C)),
        convert(be_Responses,Be_Responces):timeOutBlocked_P:=true,
        !,
        frontEnd_P:eventManager_P:appEvent_P:removeAllListeners(),
        pzl::unRegisterAllByNamePrefix(toString(frontEnd_P)),
        mainWindow_P := erroneous,
        frontEnd_P:=erroneous.
    onDestroy(_Source).


end implement appHead