% Copyright (c) Prolog Development Center SPb

implement http_Client
    open core, pfc\log
    open coreIdentifiers,/*dataExchangeIdentifiers*/ eventManager, edf

facts
    server_Url_P:string:=erroneous.
    methodRequest_P:string:="". % "request".
    methodDo_P:string:="". %justdo
    methodChain_P:string:="". % "requestChain".
    methodNext_P:string:="". % "next"
    messageID_ParameterName_P:string:="". %"eventID".
    parameters_ParameterName_P:string:="". %"evParams".
    eventManager_V:eventManager:=erroneous.

    transactionID_P:string:="". %"transID".
    sleepInterval_P:integer:=0.
    maxNoOfCyclingRequests_P:integer:=0.

clauses
    new(EventManager):-
        /*No output stream initialized here, no write of Debug operations available here*/
        eventManager_V:=EventManager.

facts
    transactionID:integer:=0.

clauses
    notifyViaHttp(MethodID,RequestID,EventParameters,ExchangeDataFormat):-
        transactionID:=transactionID+1,
        notifyViaHttp(transactionID,MethodID,RequestID,EventParameters,ExchangeDataFormat).

predicates
    notifyViaHttp:(integer TransactionID,notifyMethod_D MethodID,integer RequestID,edf_D EventParameters,string ExchangeDataFormat).
clauses
    notifyViaHttp(TransactionID,methodDo,RequestID,EventParameters,ExchangeDataFormat):-
        !,
        notifyViaHttp2(TransactionID,methodDo_P,RequestID,EventParameters,ExchangeDataFormat),
        foreach % just to make it procedure, while we need retract
            retract(httpExchangeData_F(TransactionID,ResponseID,Parameters_out)),
            ResponseID=be_Error_C
        do
            eventManager_V:eventMsg_P:notify(ResponseID, Parameters_out)
        end foreach.
    notifyViaHttp(TransactionID,methodChain,RequestID,EventParameters,ExchangeDataFormat):-
        !,
        notifyViaHttp2(TransactionID,methodChain_P,RequestID,EventParameters,ExchangeDataFormat),
        requestDataChain(0,RequestID,TransactionID,ExchangeDataFormat).
    notifyViaHttp(TransactionID,methodRequest,RequestID,EventParameters,ExchangeDataFormat):-
        !,
        notifyViaHttp2(TransactionID,methodRequest_P,RequestID,EventParameters,ExchangeDataFormat),
        waitForResponse(0,TransactionID).

predicates
    requestDataChain:(integer TryCounter, integer RequestID, integer TransactionID,string ExchangeDataFormat).
clauses
    requestDataChain(TryCounter,_RequestID,_TransactionID,_ExchangeDataFormat):-
        TryCounter>maxNoOfCyclingRequests_P,
        !.
    requestDataChain(TryCounter,RequestID,TransactionID,ExchangeDataFormat):-
        notifyViaHttp2(TransactionID,methodNext_P,RequestID,edf::n,ExchangeDataFormat),
        retract(httpExchangeData_F(TransactionID,ResponseID,Parameters_out)),
        not(ResponseID=be_EndOfData_C),
        !,
        if ResponseID=be_WillFollow_C then
            programControl::sleep(TryCounter*sleepInterval_P),
            requestDataChain(TryCounter+1,RequestID,TransactionID,ExchangeDataFormat)
        else
            eventManager_V:eventMsg_P:notify(ResponseID, Parameters_out),
            requestDataChain(0,RequestID,TransactionID,ExchangeDataFormat)
        end if.
    requestDataChain(_TryCounter,_EventID,_TransactionID,_ExchangeDataFormat).

predicates
    waitForResponse:(integer TryCounter, integer TransactionID).
clauses
    waitForResponse(TryCounter,_TransactionID):-
        TryCounter>maxNoOfCyclingRequests_P,
        !.
    waitForResponse(_TryCounter,TransactionID):-
        retract(httpExchangeData_F(TransactionID,ResponseID,Parameters_out)),
        !,
        eventManager_V:eventMsg_P:notify(ResponseID, Parameters_out).
    waitForResponse(TryCounter,TransactionID):-
        !,
        programControl::sleep(TryCounter*sleepInterval_P),
        waitForResponse(TryCounter+1,TransactionID).

predicates
    notifyViaHttp2:(integer TransactionID,string Method,integer RequestID,edf_D EventParameters,string ExchangeDataFormat).
clauses
    notifyViaHttp2(TransactionID,Method,RequestID,EventParameters,ExchangeDataFormat):-
        JSON = jsonObject::new(),
        JSON:set_integer(messageID_ParameterName_P, RequestID),
        JSON:set_integer(transactionID_P, TransactionID),
        JSON:set_string(dataFormatID_C, ExchangeDataFormat),
        if ExchangeDataFormat="edf" then
            JSON:set_string(parameters_ParameterName_P, toString(EventParameters))
        else
            edf::setValue(JSON,parameters_ParameterName_P,EventParameters)
        end if,
        httpPOST(Method, JSON).

predicates
    httpPost : (string Method, jsonObject JSON).
clauses
    httpPost(Method, JSON) :-
        RequestObject = jsonRpcRequest::newNextId(),
        RequestObject:method := Method,
        RequestObject:params := some(json::o(JSON)),
        RequestString = RequestObject:asString(),
        httpPost2(server_Url_P,Method,RequestString).

predicates
    httpPost2 : (string Url, string Method,string RequestString).
clauses
    httpPost2(URL, Method, RequestString) :-
        XmlHttp_P=serverXMLHTTP60::new(),
        try
            XmlHttp_P:open_predicate("POST", URL, comDomains::boolean(false), comDomains::null, comDomains::null),
            XmlHttp_P:setRequestHeader("Content-Type", "application/json-rpc; charset=UTF-8"),
            XmlHttp_P:send(comDomains::string(RequestString)),
            handleResponse(Method,XmlHttp_P)
        catch TraceId do
            if ComException = exception::tryGetDescriptor(TraceId, exceptionHandling_exception::genericComException)
                and unsigned(0x800C0005) = exception::tryGetExtraInfo(ComException, exceptionHandling_exception::hResult_parameter)
            then
                succeed()
            else
                ExtraInfo = [namedValue("request", string(RequestString)), namedValue("url", string(Url))],
                exception::continueDetailed(TraceId, exception::unknown, ExtraInfo)
            end if
        end try.

facts
    httpExchangeData_F:(integer TransactionID,integer ResponseID,edf_D Parameters).

predicates
    handleResponse : (string Method,serverXMLHTTP60 XmlHttp).
clauses
    handleResponse(Method,XmlHttp_P) :-
        StatusCode = XmlHttp_P:status,
        if 200 = StatusCode then
            Resp = XmlHttp_P:responseText,
            if
                Method=methodChain_P,
                Resp=""
            then
                succeed()
            else
                JsonResp = jsonObject::fromString(Resp),
                if Error = JsonResp:tryGet_object(error_name) then
                    if Code = Error:tryGet_integer(code_name) then
                    else Code=32000
                    end if,
                    if Msg = Error:tryGet_string(message_name) then
                    else Msg="noMessage"
                    end if,
                    if Data = Error:tryGet_string(data_name) then
                    else Data="noData"
                    end if,
                    ErrorMessage=string::format("Error Code [%], Msg [%], Data [%]",Code, Msg, Data),
                    log::write(log::error,ErrorMessage),
                    succeed()
                elseif JsonObj = JsonResp:tryGet_Object(result_name) then
                    if json::s(ExchangeFormat)=JsonObj:map:tryGet(dataFormatID_C) then
                    else
                        ExchangeFormat="edf"
                    end if,
                    if TransactionID=JsonObj:tryGet_integer(transactionID_C) then
                    else
                        TransactionID=0
                    end if,
                    foreach Key=JsonObj:map:getKey_nd() do
                        if not(Key=transactionID_C), not(Key=dataFormatID_C) then
                            if ExchangeFormat="edf" then
                                EdfDataAsString=JsonObj:get_String(Key),
                                Parameters=toTerm(edf_D,EdfDataAsString)
                            else
                                JsonValue=JsonObj:map:get(Key),
                                Parameters=edf::fromJson(JsonValue),
                                succeed()
                            end if,
                            assertz(httpExchangeData_F(TransactionID,toTerm(Key),Parameters))
                        end if
                    end foreach
                else
                    UnexpectedResponse=string::format("Error: unexpected response [%]",Resp),
                    log::write(log::error,UnexpectedResponse),
                    stdio::write(UnexpectedResponse,"\n")
                end if
            end if
        else % 200 <> StatusCode
            StatusText = XmlHttp_P:statusText,
            log::writef(log::error,"fail response: method [%] status code [%]  status text: [%]\n", Method,StatusCode, StatusText)
        end if,
        XmlHttp_P:release.

end implement http_Client

