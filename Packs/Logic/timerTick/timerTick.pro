% Copyright (c) Victor Yukhtenko

implement timerTick
    open core

facts
    tickName_P:string:="".
    tickInterval_P:integer:=1000. %milliceconds
    tickOnce_P:boolean:=false.
    tickActor_P:predicate:=erroneous.
    isRunning_P:boolean:=false.
    waitableTimer_P:waitableTimer:=erroneous.

facts
    tickThread_V : thread := erroneous.

clauses
    run():-
        tickInterval_P<0,
        !,
        isRunning_P:=true,
        tickThread_V := thread::start({  :- loop() }).
    run() :-
        isRunning_P:=true,
        tickThread_V := thread::start({  :- trun() }),
        succeed().

predicates
    loop:().
clauses
    loop():-
        (isRunning_P=false),
        !.
    loop() :-
        tickActor_P(),
        loop().

clauses
    stop():-
        isRunning_P:=false,
        if not(isErroneous(tickThread_V)) then
            tickThread_V:=erroneous
        end if.

class predicates
    callActor:multiThread_native::timerAPCProc.
clauses
    callActor(P,_L,_H):-
        TicActor=uncheckedConvert(timerTick,P),
        TicActor:tickActor_P(),
        if TicActor:tickOnce_P=false then
            TicActor:waitableTimer_P:setTimer(-TicActor:tickInterval_P, 0, callActor, uncheckedConvert(pointer,TicActor), true)
        else
            TicActor:stop()
        end if.

predicates
    trun:().
clauses
    trun():-
        waitableTimer_P := waitableTimer::create(false),
        waitableTimer_P:setTimer(-tickInterval_P, 0, callActor, uncheckedConvert(pointer,This), true),
        makeAlertableState().

predicates
    makeAlertableState : ().
clauses
    makeAlertableState():-
        (isRunning_P=false),
        !.
    makeAlertableState() :-
        _ = multiThread_native::sleepEx(multiThread_native::infinite_timeout, b_true),
        makeAlertableState().

end implement timerTick