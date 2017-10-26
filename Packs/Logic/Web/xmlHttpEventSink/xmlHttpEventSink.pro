% Copyright Prolog Development Center SPB

implement xmlHttpEventSink

facts
    refCount_V : integer := 1.
    completedEvent_V : event := erroneous.
    xmlHttpRequest_V:serverXmlHTTP60:=erroneous.
    continuation_V : core::predicate := erroneous.

clauses
    new(XMLHttpRequest, invokeEvent(Event)) :-
        !,
        xmlHttpRequest_V := XMLHttpRequest,
        completedEvent_V := Event.
    new(XMLHttpRequest, invokePredicate(Predicate)) :-
        !,
        xmlHttpRequest_V := XMLHttpRequest,
        continuation_V := Predicate.
    new(_XMLHttpRequest, _Invoker) :-
        exception::raise_User("Unexpected alternative").

clauses
    queryInterface(iUnknown::iid, uncheckedConvert(iUnknown, This)) = winErrors::s_ok :-
        !,
        _ = addRef().
    queryInterface(iDispatch::iid, uncheckedConvert(iUnknown, This)) = winErrors::s_ok :-
        !,
        _ = addRef().
    queryInterface(_InterfaceID, uncheckedConvert(iUnknown, ::null)) =  winErrors::e_nointerface.

clauses
    addRef() = uncheckedConvert(unsigned, Counter) :-
        memory::threadAttachCurrent(),
        Counter = multiThread_native::interlockedIncrement(fact_address(refCount_V)).

clauses
    release() = Counter :-
        memory::threadAttachCurrent(),
        C = multiThread_native::interlockedDecrement(fact_address(refCount_V)),
        Counter = uncheckedConvert(unsigned, C),
        if 0 = refCount_V then
            completedEvent_V := erroneous,
            continuation_V := erroneous,
            xmlHttpRequest_V := erroneous
        end if.

clauses
    getTypeInfoCount(0) = winErrors::e_notimpl.

clauses
    getTypeInfo(_TypeInfoIndex, _LocaleID, uncheckedConvert(iTypeInfo_native, ::null)) = winErrors::e_notimpl.

clauses
    getIDsOfNames(_InterfaceID, _Names, _NamesCount, _LocaleID, _DispId) = winErrors::e_notimpl.

clauses
    invoke(_DispIdMember, _InterfaceID, _LocaleID, _Flags, _DispParams, _VarResult, _ExcepInfo, _ArgumentError) = winErrors::s_ok :-
        memory::threadAttachCurrent(),
        onReadyStateChange().

predicates
    onReadyStateChange: ().
clauses
    onReadyStateChange():-
        ReadyState = xmlHttpRequest_V:readyState,
        if ReadyState = 4 then
            if not(isErroneous(completedEvent_V)) then
                completedEvent_V:setSignaled(true)
            elseif not(isErroneous(continuation_V)) then
                continuation_V()
            else
                exception::raise_User("The reactor is not set")
            end if
        end if.

end implement xmlHttpEventSink