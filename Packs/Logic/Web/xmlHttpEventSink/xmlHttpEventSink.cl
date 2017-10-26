% Copyright Prolog Development Center SPB

class xmlHttpEventSink : xmlHttpEventSink

domains
    invoker_D=
        invokeEvent(event);
        invokePredicate(core::predicate).

constructors
    new:(serverXMLHttp60, invoker_D Performer).

end class xmlHttpEventSink