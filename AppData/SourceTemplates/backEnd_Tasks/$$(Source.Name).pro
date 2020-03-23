%

implement $$(Source.NameFull) inherits be_Connector
    open core, pfc\log
    open dataExchangeIdentifiers, edf, coreIdentifiers

clauses
    new(BackEnd) :-
        be_Connector::new(BackEnd).

/*** UserTasks********/
clauses
    userTask(_TaskID, _FromFrontEndEDF,_TaskQueue).

end implement $$(Source.Name)
