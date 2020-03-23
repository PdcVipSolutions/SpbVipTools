% Copyright (c) Prolog Development Center SPb

implement fe_Connector
    open core,  pfc\log
    open eventManager, frontEnd, edf

facts
    frontEnd_P:frontEnd:=erroneous.
    httpClient_V:http_Client:=erroneous.

clauses
    new(FrontEnd):-
        frontEnd_P:=FrontEnd,
        if HttpClientObj=pzl::getObjectByName_nd(string::concat(toString(frontEnd_P),fe_HttpClient_C)),! then
            httpClient_V:=convert(http_Client,HttpClientObj)
        end if.

clauses
    request(NotyfyMethod,RequestID,Parameters):-
        request(NotyfyMethod,RequestID,Parameters,0).
    request(NotyfyMethod,RequestID,Parameters,TimeOut):-
        if appHead::isHttpClient=true then
            if fe_CoreTasks():backEndAlive_P=true or RequestID=coreIdentifiers::fe_IsBackEndAlive_C then
                if TimeOut>0 then
                    httpClient_V:requestViaHttp(NotyfyMethod,RequestID,Parameters,frontEnd_P:exchangeDataFormat_P,TimeOut)
                else
                    httpClient_V:requestViaHttp(NotyfyMethod,RequestID,Parameters,frontEnd_P:exchangeDataFormat_P)
                end if
            else
                ErrorMessage=string::format("method [%]\n requestID [%] TimeOut [%]", NotyfyMethod,RequestID,TimeOut),
                frontEnd_P:eventManager_P:eventMsg_P:notify(coreIdentifiers::be_Timeout_C, av("be_error",a(
                    [av("short",s("BackEnd is not active")),
                    av("detailed",s(ErrorMessage)),
                    av("params",a([
                        av("method",s(toString(NotyfyMethod))),
                        av("requestid",i(RequestID)),
                        av("timeout",u(TimeOut))
                        ]))
                    ])))
            end if
        else
            frontEnd_P:eventManager_P:eventTaskCall_P:notify(RequestID,Parameters,uncheckedConvert(object,nullHandle))
        end if.

clauses
    fe_CoreTasks()=convert(fe_CoreTasks,GuiTasks):-
        GuiTasks=pzl::getObjectByName_nd(string::concat(toString(frontEnd_P),fe_CoreTasks_C)),!.
    fe_CoreTasks()=_:-
        exception::raise_User(string::format("Component % not Registered!",fe_CoreTasks_C)).

clauses
    fe_Tasks()=convert(fe_Tasks,GuiTasks):-
        GuiTasks=pzl::getObjectByName_nd(string::concat(toString(frontEnd_P),fe_Tasks_C)),!.
    fe_Tasks()=_:-
        exception::raise_User(string::format("Component % not Registered!",fe_Tasks_C)).

clauses
    fe_Tests()=convert(fe_Tests,GuiTasks):-
        GuiTasks=pzl::getObjectByName_nd(string::concat(toString(frontEnd_P),fe_Tests_C)),!.
    fe_Tests()=_:-
        exception::raise_User(string::format("Component % not Registered!",fe_Tests_C)).

clauses
    be_Responses()=convert(be_Responses,WSFE_MSG):-
        WSFE_MSG=pzl::getObjectByName_nd(string::concat(toString(frontEnd_P),be_Responses_C)),!.
    be_Responses()=_:-
        exception::raise_User(string::format("Component % not Registered!",be_Responses_C)).

clauses
    fe_AppWindow()=convert(fe_MainWindow,WS_Form):-
        WS_Form=pzl::getObjectByName_nd(string::concat(toString(frontEnd_P),fe_AppWindow_C)),!.
    fe_AppWindow()=_:-
        exception::raise_User(string::format("Component % not Registered!",fe_AppWindow_C)).

clauses
    fe_Dictionary()=convert(fe_Dictionary,FeLanguage):-
        FeLanguage=pzl::getObjectByName_nd(string::concat(toString(frontEnd_P),fe_Dictionary_C)),!.
    fe_Dictionary()=_:-
        exception::raise_User(string::format("Component % not Registered!",fe_Dictionary_C)).

clauses
    mainEventManager()=frontEnd_P:eventManager_P.

end implement fe_Connector