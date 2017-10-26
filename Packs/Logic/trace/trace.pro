% Copyright

implement trace
    open core

class facts
    traces_V : mapM{string TraceName, trace TraceObj} := mapM_redBlack::new() [immediate].

clauses
    set(Name,TraceObj):-
        traces_V:set(Name,TraceObj).

clauses
    get(Name)=TraceObj:-
        TraceObj=traces_V:tryGet(Name),
        !.
    get(Name)=TraceObj:-
        Message=string::format("TRACE: nothing to get (%), created now",Name),
        TraceObj=trace::start(Message),
        set(Name,TraceObj).

clauses
    kill(Name):-
        try
            traces_V:removeKey(Name)
        catch _TraceID do
            stdio::writef("TRACE: nothing to Kill (%)\n",Name)
        end try.

facts
    counter_P:integer:=0.

clauses
    start(...):-
        counter_P:=1,
        stdio::write(counter_P,": start: "),
        stdio::write(...),
        stdio::write("\n").

clauses
    w(...):-trace(...).
    trace(...):-
        counter_P:=counter_P+1,
        stdio::write(toString(counter_P),": "),
        stdio::write(...),
        stdio::write("\n").

clauses
    wf(Format, ...):-tracef(Format, ...).
    tracef(Format,...):-
        counter_P:=counter_P+1,
        stdio::write(toString(counter_P),": "),
        stdio::writef(Format,...),
        stdio::write("\n").

end implement trace