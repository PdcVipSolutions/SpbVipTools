%

implement appHead
open core
open http_Client

constants
    backEndServiceIP_C="http://localhost:5558".
%    backEndServiceIP_C="http://localhost/SpbHostDemo/appHead_BE".
    backEndServicePath_C="jsonrpc".
% to connect as component
% [namedValue("beHost",string("http://localhost:5558")),namedValue("bePath",string("jsonrpc"))]


facts
    mainWindow_P : fe_Form := erroneous.
    frontEnd_P:frontEnd:=erroneous.

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
        mainWindow_P:=fe_Form::new(FrontEnd).

clauses
    run():-
        mainWindow_P:setParent(gui::getScreenWindow()),
        mainWindow_P:show(),
        !,
        messageLoop::run(),
        pzl::unRegisterAllByNamePrefix(toString(frontEnd_P)).

end implement appHead