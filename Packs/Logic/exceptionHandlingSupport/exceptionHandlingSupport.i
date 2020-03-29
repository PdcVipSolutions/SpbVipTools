% Copyright

interface exceptionHandlingSupport
    open core

predicates
    getExceptionInfo:(exception::traceID TraceID)-> tuple{string ShortInfo,string DetailedInfo}.

end interface exceptionHandlingSupport
