%

implement appHead

open core
open frontEnd, http_Client

constants
    backEndServiceIP_C="http://localhost:5558".
%    backEndServiceIP_C="http://localhost/SpbHostDemo/appHead_BE".
    backEndServicePath_C="jsonrpc".
% to connect as component

facts
    frontEnd_P:frontEnd:=erroneous.
    mainWindow_P : taskWindow := erroneous.

clauses
    new():-
        EventManager=eventManager::new(),
        HttpClient=http_Client::new(EventManager),
        HttpClient:messageID_ParameterName_P:="eventID",
        HttpClient:parameters_ParameterName_P:="evParams",
        HttpClient:sleepInterval_P:=5,
        HttpClient:transactionID_P:="transID",
        HttpClient:maxNoOfCyclingRequests_P:=80,
        HttpClient:server_Url_P:=string::format("%s/%s",backEndServiceIP_C,backEndServicePath_C),
        HttpClient:methodRequest_P:=methodRequest_C,
        HttpClient:methodChain_P:=methodChain_C,
        HttpClient:methodDo_P:=methodDo_C,
        HttpClient:methodNext_P:=methodNext_C,
        frontEnd_P:=frontEnd::new(EventManager,This,HttpClient),
        succeed(). % just as the point for debug trace

clauses
    createMainWindow(FrontEnd)=mainWindow_P:-
        mainWindow_P:=taskWindow::new(FrontEnd).

clauses
    run():-
        mainWindow_P:show(),
        succeed().

predicates
    closeApplication:event1{integer EventID}::listener.
clauses
    closeApplication(_EventID):-
        frontEnd_P:eventManager_P:appEvent_P:removeAllListeners(),
        foreach ObjectID in  [fe_AppWindow_C, fe_CoreTasks_C, fe_Tasks_C, be_Responses_C,fe_Dictionary_C,fe_HttpClient_C] do
            pzl::unRegisterByName(string::concat(ObjectID,toString(frontEnd_P)))
        end foreach,
        frontEnd_P:=erroneous,
        mainWindow_P := erroneous.

end implement appHead