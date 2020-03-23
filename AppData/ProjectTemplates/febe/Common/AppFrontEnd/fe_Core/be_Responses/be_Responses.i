% SPBrSolutions

interface be_Responses
    open core, pfc\asynchronous\, edf

predicates
    createResponseReciever_async:(integer MessageID,integer Timeout)->promiseExt{edf_D}.
    createResponseReciever_async:(integer MessageID)->promiseExt{edf_D}.

properties
    timeOutBlocked_P:boolean.

predicates
    onTimeOut:predicate{promiseExt{edf_D},edf_D TimeOutContext}.

end interface be_Responses