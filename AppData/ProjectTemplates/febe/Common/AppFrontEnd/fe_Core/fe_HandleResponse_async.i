%

interface fe_HandleResponse_async

    open core, pfc\asynchronous\
    open edf%, coreIdentifiers

predicates
    mapPromise:(promiseExt{edf_D},integer ResponseId, be_Responses).
predicates
    tryHandleRespondedData:(integer ResponseId, edf_D Result) determ.
predicates
    onTimeOut:(integer RequestID, exception::traceID TraceID).

end interface fe_HandleResponse_async