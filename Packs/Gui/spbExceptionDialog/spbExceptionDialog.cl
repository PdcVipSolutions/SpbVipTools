%

class spbExceptionDialog : spbExceptionDialog
    open core, exception

predicates
    displayError : (window Parent,traceId TraceID,string UserMEssage).
    displayMsg : (window Parent,string ShortInfo,string DetailedInfo).

constructors
    newMsg:(window Parent,string ShortDescription,string DetailedDescription).
    newError:(window Parent,traceID TraceID,string UserMessage).


end class spbExceptionDialog
