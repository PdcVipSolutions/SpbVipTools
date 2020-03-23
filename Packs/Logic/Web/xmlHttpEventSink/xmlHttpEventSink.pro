% Copyright Prolog Development Center SPB

implement xmlHttpEventSink

facts
    refCount_V : integer := 0.
    onResponse : core::predicate := erroneous.

clauses
    new(Predicate) :-
        onResponse := Predicate.

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
        Counter = multiThread_native::interlockedIncrement(fact_address(refCount_V)).

clauses
    release() = Counter :-
        C = multiThread_native::interlockedDecrement(fact_address(refCount_V)),
        Counter = uncheckedConvert(unsigned, C),
        if 0 = refCount_V then
            onResponse := erroneous
        end if.

clauses
    getTypeInfoCount(0) = winErrors::e_notimpl.

clauses
    getTypeInfo(_TypeInfoIndex, _LocaleID, uncheckedConvert(iTypeInfo_native, ::null)) = winErrors::e_notimpl.

clauses
    getIDsOfNames(_InterfaceID, _Names, _NamesCount, _LocaleID, _DispId) = winErrors::e_notimpl.

clauses
    invoke(_DispIdMember, _InterfaceID, _LocaleID, _Flags, _DispParams, _VarResult, _ExcepInfo, _ArgumentError) = winErrors::s_ok :-
       onResponse().

end implement xmlHttpEventSink