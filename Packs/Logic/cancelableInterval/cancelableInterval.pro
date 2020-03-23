%

implement cancelableInterval
    open core

facts
    interval_P:integer:=1. %milliceconds
    actor_P:predicate:=erroneous.

facts
    thread_V : thread := erroneous.

clauses
    run() :-
        thread_V := thread::start({  :- trun() }),
        succeed().

clauses
    stop():-
        if not(isErroneous(timerStop_V)) then
            timerStop_V:setSignaled(true)
        end if,
        if not(isErroneous(thread_V)) then
            thread_V:=erroneous
        end if.

facts
    timerStop_V:event:=erroneous.
predicates
    trun : ().
clauses
    trun():-
        T = waitableTimer::create(true),
        if  interval_P > 0 then
            Duration = duration::new(0, 0, 0, interval_P):get(),
            T:setTimer(-Duration, 0, false)
        end if,
        timerStop_V:= event::create(false, false),
        Array = memory::allocHeap(2*sizeOfDomain(handle)),
        memory::setHandle(Array, timerStop_V:handle, NextElem),
        memory::setHandle(NextElem, T:handle),
        wait( Array),
        timerStop_V:close(),
        timerStop_V:=erroneous,
        T:close(),
        memory::releaseHeap(Array).

predicates
    wait : (pointer Array).
clauses
    wait(Array):-
        R = gui_native::msgWaitForMultipleObjects(2, Array, b_false, multiThread_native::infinite_timeout, gui_native::qs_allinput),
        if multiThread_native::wait_object_0 = R then
        elseif multiThread_native::wait_object_0 +1 = R then
            actor_P()
        else
        end if.

end implement cancelableInterval
