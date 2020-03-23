%

implement promiseExt {@Type} inherits promise {@Type}
    open core, pfc\asynchronous\

facts
    interval_V:cancelableInterval:=erroneous.
    timeOutTime_P:integer:=1.
    timeOutActor_P:predicate{promiseExt {@Type},edf::edf_D}:=dummy.
    timeOutContext_P:edf::edf_D:=edf::n.

clauses
    initTimeout():-
        interval_V:=cancelableInterval::new(),
        interval_V:interval_P:=timeOutTime_P,
        interval_V:actor_P:=signal,
        interval_V:run().

predicates
    signal:predicate.
clauses
    signal():-
        raiseError("TimeOut happened. See TimeOut Context\n"),
        timeOutActor_P(This,timeOutContext_P).

predicates
    dummy:predicate{promiseExt {@Type},edf::edf_D}.
clauses
    dummy(_,_).

clauses
    stopTimeOut():-
        if not(isErroneous(interval_V)) then
            timeOutActor_P:=dummy,
            interval_V:stop,
            interval_V:=erroneous
        end if.

end implement promiseExt
