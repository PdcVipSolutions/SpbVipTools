% SPBrSolutions
implement be_Responses
    inherits fe_Connector
    open core,  pfc\asynchronous\, redBlackTree
    open eventManager, edf, coreIdentifiers

facts
    dataMessage_V:redBlackTree::tree{integer, promiseExt{edf_D}}:=redBlackTree::emptyUnique().

facts
    timeOutBlocked_P:boolean:=false.

clauses
    new(FrontEnd):-
        fe_Connector::new(FrontEnd),
        mainEventManager():eventMsg_P:addListener(be_Response),
        ResponseIDList=list::append(fe_CoreTasks:: handleByTasks_C,fe_Tasks:: handleByTasks_C,fe_Tests:: handleByTasks_C),
        foreach ResponseID in ResponseIDList do
            _Promice=createResponseReciever_async(ResponseID)
        end foreach,
        succeed().

clauses
    createResponseReciever_async(ResponseID)=createResponseReciever_async(ResponseID,0).

    createResponseReciever_async(ResponseID,Timeout)=Promise:-
        Promise=promiseExt{edf_D}::new(),
        if TimeOut>0 then
            Promise:timeOutTime_P:=TimeOut,
            Promise:timeOutActor_P:=onTimeOut,
            Promise:timeOutContext_P:=edf::i(ResponseID),
            Promise:initTimeOut()
        end if,
        dataMessage_V:=insert(dataMessage_V,ResponseID,Promise),
        if ResponseID<=4000 then
            fe_CoreTasks():mapPromise(Promise,ResponseID,This)
        elseif  ResponseID<=8000 then
            fe_Tests():mapPromise(Promise,ResponseID,This)
        else
            fe_Tasks():mapPromise(Promise,ResponseID,This)
        end if.

predicates
    be_Response:event2{integer ResponseID, edf_D EdfData}::listener.
clauses
    be_Response(ResponseID, EdfData):- % here the waiting promise stores the response
        Promise=tryLookUp(dataMessage_V, ResponseID),
        !,
        Promise:stopTimeOut(),
        Promise:success(EdfData). % Data is successfully recieved, but it may be also an error message.
    be_Response(be_EndOfChain_C, i(ResponseID)):-
        Promise=tryLookUp(dataMessage_V, ResponseID),
        !,
        Promise:stopTimeOut().
    be_Response(ResponseID, EdfData):- % NonAsync responses handling xxTasks modules
        if ResponseID<=4000 then
            fe_CoreTasks(): tryHandleRespondedData(ResponseID, EdfData)
        elseif ResponseID<=8000 then
            fe_Tests(): tryHandleRespondedData(ResponseID,  EdfData)
        else
            fe_Tasks(): tryHandleRespondedData(ResponseID, EdfData)
        end if,
        !.
    be_Response(_ResponseID, _EdfData).

clauses
    onTimeOut(Promise,Context):-
        if
            fe_CoreTasks():backEndAlive_P=true,
            futureDomains::error_(TraceID)=Promise:getResult(),
            Context=edf::i(ResponseID)
        then
            dataMessage_V:=delete(dataMessage_V, ResponseID,Promise),
            if ResponseID<=4000 then
                fe_CoreTasks(): onTimeOut(ResponseID, TraceID)
            elseif ResponseID<=8000 then
                fe_Tests(): onTimeOut(ResponseID, TraceID)
            else
                fe_Tasks(): onTimeOut(ResponseID, TraceID)
            end if
        end if.

end implement be_Responses