% Copyright (c) PDCSPB

implement fe_Requests
    inherits be_Connector
    open core, pfc\log
    open coreIdentifiers, edf

clauses
    new(Backend):-
        be_Connector::new(Backend),
        mainEventManager():eventTaskCall_P:addListener(fe_Request).

predicates
    fe_Request:event3{integer CommandID, edf_D Parameters,object TaskQueue}::listener.
clauses
    fe_Request(fe_IsBackEndAlive_C,edf::n,TaskQueue):-
        !,
        response(be_Alive_C,edf::i(fe_IsBackEndAlive_C),TaskQueue).
    fe_Request(RequestID,RequestData,TaskQueue):-
        RequestID<=3000,
        be_CoreTasks():fe_Request(RequestID,RequestData,TaskQueue),
        !.
    fe_Request(RequestID,RequestData,TaskQueue):-
        RequestID<=5000,
        be_Tests():fe_Request(RequestID,RequestData,TaskQueue),
        !.
    fe_Request(RequestID,RequestData,TaskQueue):-
        RequestID>5000,
        be_Tasks():fe_Request(RequestID,RequestData,TaskQueue),
        !.
    fe_Request(_RequestID,_RequestData,_TaskQueue).

end implement fe_Requests