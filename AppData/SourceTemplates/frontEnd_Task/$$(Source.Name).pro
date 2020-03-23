%

implement $$(Source.NameFull)
    inherits fe_Connector
    open core, vpiDomains, pfc\asynchronous, pfc\log
    open edf, coreIdentifiers, dataExchangeIdentifiers, /*frontEnd,*/ eventManager, febe_DefaultDictionary

clauses
    new(FrontEnd):-
        fe_Connector::new(FrontEnd).

clauses
    tryMapPromise(_Promice,0,_BeResponces).

clauses
    tryHandleRespondedData(0,_EdfData).

/*** User Tasks *********************/
clauses
    userTask(_EdfData).

end implement $$(Source.Name)
