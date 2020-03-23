% Copyright (c) PDCSPB

implement be_Connector
    open core, pfc\log,  string
    open edf, backEnd

facts
    backend_V:backEnd:=erroneous.
    taskQueues_P : tsMapM_redBlack{integer TaskKey, monitorQueue{tuple{integer,edf_D}} TaskQueue} := tsMapM_redBlack::new() [immediate].

clauses
    new(BackEnd):-
        backend_V:=BackEnd.

clauses
    response(EventID,Parameters,TaskQueueObj):-
        if appHead::isHttpService=true then
            TaskQueue=convert(monitorQueue{tuple{integer,edf_D}},TaskQueueObj),
            TaskQueue:enqueue(tuple(EventID,Parameters))
        else
            backend_V:eventManager_P:eventMsg_P:notify(EventID,Parameters)
        end if.

clauses
    be_CoreTasks()=convert(be_CoreTasks,Object):-
        Object=pzl::getObjectByName_nd(concat(toString(backend_V),be_CoreTasks_C)),!.
    be_CoreTasks()=_:-
        ErrorMsg=string::format("Component % not Registered!",concat(toString(backend_V),be_CoreTasks_C)),
        log::write(log::error,ErrorMsg),
        exception::raise_User(ErrorMsg).

clauses
    be_Tests()=convert(be_Tests,Object):-
        Object=pzl::getObjectByName_nd(concat(toString(backend_V),be_Tests_C)),!.
    be_Tests()=_:-
        ErrorMsg=string::format("Component % not Registered!",concat(toString(backend_V),be_Tests_C)),
        log::write(log::error,ErrorMsg),
        exception::raise_User(ErrorMsg).

clauses
    be_Tasks()=convert(be_Tasks,Object):-
        Object=pzl::getObjectByName_nd(concat(toString(backend_V),be_Tasks_C)),!.
    be_Tasks()=_:-
        ErrorMsg=string::format("Component % not Registered!",concat(toString(backend_V),be_Tasks_C)),
        log::write(log::error,ErrorMsg),
        exception::raise_User(ErrorMsg).

clauses
    fe_Requests()=convert(fe_Requests,Object):-
        Object=pzl::getObjectByName_nd(concat(toString(backend_V),fe_Requests_C)),!.
    fe_Requests()=_:-
        ErrorMsg=string::format("Component % not Registered!",concat(toString(backend_V),fe_Requests_C)),
        log::write(log::error,ErrorMsg),
        exception::raise_User(ErrorMsg).

clauses
    be_Options()=convert(be_Options,Object):-
        Object=pzl::getObjectByName_nd(concat(toString(backend_V),be_Options_C)),!.
    be_Options()=_:-
        ErrorMsg=string::format("Component % not Registered!",concat(toString(backend_V),be_Options_C)),
        log::write(log::error,ErrorMsg),
        exception::raise_User(ErrorMsg).

clauses
    be_Dictionary()=convert(be_Dictionary,Object):-
        Object=pzl::getObjectByName_nd(concat(toString(backend_V),be_Dictionary_C)),!.
    be_Dictionary()=_:-
        ErrorMsg=string::format("Component % not Registered!",concat(toString(backend_V),be_Dictionary_C)),
        log::write(log::error,ErrorMsg),
        exception::raise_User(ErrorMsg).

clauses
    mainEventManager()=backend_V:eventManager_P.

end implement be_Connector