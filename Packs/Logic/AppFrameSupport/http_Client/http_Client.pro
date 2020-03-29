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
    defaultTimeOut_P:unsigned:=3.

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
    requestViaHttp(MethodID,RequestID,EventParameters,ExchangeDataFormat):-
        requestViaHttp(MethodID,RequestID,EventParameters,ExchangeDataFormat,defaultTimeOut_P).

    requestViaHttp(MethodID,RequestID,EventParameters,ExchangeDataFormat,TimeOut):-
        transactionID:=transactionID+1,
        requestViaHttp2(0,transactionID,MethodID,RequestID,EventParameters,ExchangeDataFormat,TimeOut).

predicates
    requestViaHttp2:(integer TryCounter,integer TransactionID,notifyMethod_D MethodID,integer RequestID,edf_D EventParameters,string ExchangeDataFormat,unsigned TimeOut).
clauses
    requestViaHttp2(TryCounter,TransactionID,MethodID,RequestID,EventParameters,ExchangeDataFormat,TimeOut):-
        JSON = jsonObject::new(),
        JSON:set_integer(messageID_ParameterName_P, RequestID),
        JSON:set_integer(transactionID_P, TransactionID),
        JSON:set_string(dataFormatID_C, ExchangeDataFormat),
        if MethodID=methodDo then MethodStr=methodDo_P
        elseif MethodID=methodRequest then MethodStr=methodRequest_P
        elseif MethodID=methodChain then MethodStr=methodChain_P
        else MethodStr=methodNext_P
        end if,
        if ExchangeDataFormat="edf" then
            JSON:set_string(parameters_ParameterName_P, toString(EventParameters))
        else
            edf::setValue(JSON,parameters_ParameterName_P,EventParameters)
        end if,
        RequestObject = jsonRpcRequest::newNextId(),
        RequestObject:method := MethodStr,
        RequestObject:params := some(json::o(JSON)),
        RequestString = RequestObject:asString(),
        httpPost2(server_Url_P,RequestString,
            { (XmlHttp) :- onServerResponse(TryCounter,TransactionID,MethodID,ExchangeDataFormat,XmlHttp,TimeOut)},
            TimeOut,
            tuple(TransactionID,MethodID,RequestID,ExchangeDataFormat,TryCounter)).

predicates
    httpPost2 : (string Url, string RequestString,predicate{xmlHTTP60},unsigned TimeOut,tuple{integer TransactionID,notifyMethod_D MethodID,integer RequestID,string ExchangeDataFormat,integer TryCounter}).
clauses
    httpPost2(URL, RequestString,OnResp,TimeOut,RequestDetails) :-
        XmlHttp=xmlHTTP60::new(),
        OnReadyEvt= event::create(false, false),
        ReadyEvtSink= xmlHttpEventSink::new(),
        RequestDetails=tuple(TransactionID,MethodID,RequestID,ExchangeDataFormat,TryCounter),
        try
            ReadyEvtSink:onResponse  := {:- if 4 = XmlHttp:readyState then OnReadyEvt:setSignaled(true) end if},
            XmlHttp:onreadystatechange := ReadyEvtSink,
            XmlHttp:open_predicate("POST", URL, comDomains::boolean(true), comDomains::null, comDomains::null),
            XmlHttp:setRequestHeader("Content-Type", "application/json-rpc; charset=UTF-8"),
            XmlHttp:send(comDomains::string(RequestString)),
            R = msgWaitEvent(OnReadyEvt, TimeOut),
            if true = R then
                OnResp(XmlHttp)
            else
                XmlHttp:abort(),
                XmlHttp:release(),
                memory::releaseHeap(ReadyEvtSink),
                ErrorMessage=string::format("url [%]\n method [%]\nTransactionID [%]\n Request [%]\nTimeOut [%]", Url,MethodID,TransactionID,RequestString,TimeOut),
                eventManager_V:eventMsg_P:notify(be_Timeout_C, av("be_error",a(
                    [av("short",s(string::format("BackEnd Error: [%]","TimeOut while the Request handling"))),
                    av("detailed",s(ErrorMessage)),
                    av("params",a([
                        av("url",s(Url)),
                        av("method",s(toString(MethodID))),
                        av("requestid",i(RequestID)),
                        av("transaction",i(TransactionID)),
                        av("edf",s(ExchangeDataFormat)),
                        av("request",s(RequestString)),
                        av("trycounter",i(TryCounter)),
                        av("timeout",u(TimeOut))
                        ]))
                    ])))
            end if
        catch TraceId do
            XmlHttp:release(),
            memory::releaseHeap(ReadyEvtSink),
            OnReadyEvt:close(),
            ExceptionInfo=exceptionHandlingSupport::new(),
            tuple(ShortInfo,DetailedInfo)=ExceptionInfo:getExceptionInfo(TraceID),
            eventManager_V:eventMsg_P:notify(be_NonResponsiveServer_C, av("be_error",a(
                [av("short",s(ShortInfo)),
                av("detailed",s(DetailedInfo)),
                av("params",a([
                    av("url",s(Url)),
                    av("method",s(toString(MethodID))),
                    av("requestid",i(RequestID)),
                    av("transaction",i(TransactionID)),
                    av("edf",s(ExchangeDataFormat)),
                    av("request",s(RequestString)),
                    av("trycounter",i(TryCounter)),
                    av("timeout",u(TimeOut))
                    ]))
                ])))
        end try.

predicates
    msgWaitEvent : (event Event, unsigned TimeOutSeconds)-> boolean.
clauses
    msgWaitEvent(Event, TimeOut) = R :-
        T = waitableTimer::create(false),
        if  TimeOut > 0 then
            Duration = duration::new(0, 0, 0, TimeOut):get(),
            T:setTimer(-Duration, 0, false)
        end if,
        Array = memory::allocHeap(2*sizeOfDomain(handle)),
        memory::setHandle(Array, Event:handle, NextElem),
        memory::setHandle(NextElem, T:handle),
        R = msgWaitHandle(2, Array),
        T:close(),
        Event:close(),
        memory::releaseHeap(Array).

class predicates
    msgWaitHandle : (unsigned ArraySize, pointer Array) -> boolean.
clauses
    msgWaitHandle(Size, Array) = Ret :-
        R = gui_native::msgWaitForMultipleObjects(Size, Array, b_false, multiThread_native::infinite_timeout, gui_native::qs_allinput),
        if multiThread_native::wait_object_0 = R then
            Ret = true
        elseif multiThread_native::wait_object_0 +1 = R then
            Ret = false
        else
        _ = vpi::processEvents(),
            Ret = msgWaitHandle(Size, Array)
        end if.

predicates
    onServerResponse : (integer TryCounter,integer TransactionIDSrc,notifyMethod_D MethodID,string ExchangeDataFormat,xmlHTTP60 XmlHttp,unsigned TimeOut).
clauses
    onServerResponse(TryCounter,TransactionIDSrc,MethodID,ExchangeDataFormat,XmlHttp,TimeOut) :-
        StatusCode = XmlHTTP:status,
        if 200 = StatusCode then
            ResponseText = XmlHttp:responseText,
            handleResponse(TryCounter,TransactionIDSrc,MethodID,ExchangeDataFormat,ResponseText,TimeOut),
            XmlHttp:release()
        else % 200 <> StatusCode
            StatusText = XmlHttp:statusText,
            XmlHttp:release,
            ErrorMessage=string::format("Error response: method [%] status code [%]  status text: [%] ",MethodID,StatusCode, StatusText),
            eventManager_V:eventMsg_P:notify(be_Non200Status_C, av("be_error",a(
                [av("short",s("Server not responded or responded with the Error")),
                av("detailed",s(ErrorMessage)),
                av("params",a([
                    av("method",s(toString(MethodID))),
                    av("transaction",i(TransactionIDSrc)),
                    av("edf",s(ExchangeDataFormat)),
                    av("trycounter",i(TryCounter)),
                    av("timeout",u(TimeOut))
                    ]))
                ])))
        end if.

predicates
    handleResponse:(integer TryCounter,integer TransactionIDSrc,notifyMethod_D Method,string ExchangeDataFormatSrc,string  ResponseText,unsigned TimeOut).
clauses
    handleResponse(TryCounter,TransactionIDSrc,MethodID,ExchangeDataFormatSrc,ResponseText,TimeOut):-
        JsonRespObject = jsonObject::fromString(ResponseText),
        if ErrorObj = JsonRespObject:tryGet_object(error_name) then
            if Code = ErrorObj:tryGet_integer(code_name) then else Code=32000 end if,
            if Msg = ErrorObj:tryGet_string(message_name) then else Msg="noMessage" end if,
            if Data = ErrorObj:tryGet_string(data_name) then else Data="noData" end if,
            ErrorMessage=string::format("Error Code [%], Msg [%] TrId [%] TrC [%] Mthd [%] Data [%]",Code, Msg,TransactionIDSrc,TryCounter,MethodID, Data),
            log::write(log::error,ErrorMessage),
            eventManager_V:eventMsg_P:notify(be_RpcError_C, av("be_error",a(
                [av("short",s(string::format("BackEnd Error: [%]",Msg))),
                av("detailed",s(Data)),
                av("params",a([av("code",i(Code)),av("data",s(Data)),av("transaction",i(TransactionIDSrc)),av("method",s(toString(MethodID))),av("trycounter",i(TryCounter))]))
                ]))),
            succeed()
        elseif JsonObj = JsonRespObject:tryGet_Object(result_name) then
            if json::s(ExchangeFormat)=JsonObj:map:tryGet(dataFormatID_C) then
            else
                ExchangeFormat=ExchangeDataFormatSrc
            end if,
            if TransactionID=JsonObj:tryGet_integer(transactionID_C) then
            else
                TransactionID=TransactionIDSrc
            end if,
            if MethodID=methodChain then
                handleResult(TryCounter,TransactionID,MethodID,0,edf::n,ExchangeFormat,TimeOut)
            else
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
                        handleResult(TryCounter,TransactionID,MethodID,toTerm(Key),Parameters,ExchangeFormat,TimeOut)
                    end if
                end foreach
            end if
        else
            UnexpectedResponse=string::format("Error: unexpected response [%]",ResponseText),
            log::write(log::error,UnexpectedResponse)
        end if.

predicates
    handleResult:(integer TryCounter,integer TransactionID,notifyMethod_D MethodID,integer ResponseID,edf_D ResponseParams,string ExchangeDataFormat,unsigned TimeOut).
clauses
    handleResult(_TryCounter,_TransactionID,methodDo,ResponseID,ResponseParams,_ExchangeDataFormat,_TimeOut):-
        !,
        eventManager_V:eventMsg_P:notify(ResponseID, ResponseParams).
    handleResult(_TryCounter,_TransactionID,methodRequest,ResponseID,ResponseParams,_ExchangeDataFormat,_TimeOut):-!,
            eventManager_V:eventMsg_P:notify(ResponseID, ResponseParams).
    handleResult(_TryCounter,TransactionID,methodChain,_Any,ResponseParams,ExchangeDataFormat,TimeOut):-!,
        requestViaHttp2(0,TransactionID,methodNext,0,ResponseParams,ExchangeDataFormat,TimeOut).
    handleResult(_TryCounter,_TransactionID,methodNext,be_EndOfChain_C,ResponseParams,_ExchangeDataFormat,_TimeOut):-
        eventManager_V:eventMsg_P:notify(be_EndOfChain_C, ResponseParams),
        !.
    handleResult(TryCounter,TransactionID,methodNext,_Be_WillFollow_C,_ResponseParams,_ExchangeDataFormat,_TimeOut):-
        TryCounter>maxNoOfCyclingRequests_P,
        !,
        ErrorMessage=string::format("No EndOfChain recieved for the Chain operation. TrId [%] TrC [%] ",TransactionID,TryCounter),
        log::write(log::error,ErrorMessage),
        eventManager_V:eventMsg_P:notify(be_NoEndOfChainError_C, av("be_error",a(
            [av("short",s(string::format("BackEnd Error: [%]","No EndOfChain recieved for the Chain operation"))),
            av("detailed",s(ErrorMessage)),
            av("params",a([av("transaction",i(TransactionID)),av("method",s(toString(methodNext))),av("trycounter",i(TryCounter))]))
            ]))).
    handleResult(TryCounter,TransactionID,methodNext,be_WillFollow_C,_ResponseParams,ExchangeDataFormat,TimeOut):-!,
        programControl::sleep(TryCounter*sleepInterval_P),
        requestViaHttp2(TryCounter+1,TransactionID,methodNext,0,edf::n,ExchangeDataFormat,TimeOut).
    handleResult(_TryCounter,TransactionID,methodNext,ResponseID,ResponseParams,ExchangeDataFormat,TimeOut):-
        !,
        eventManager_V:eventMsg_P:notify(ResponseID, ResponseParams),
        requestViaHttp2(0,TransactionID,methodNext,0,edf::n,ExchangeDataFormat,TimeOut).

end implement http_Client

