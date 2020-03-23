%
%

interface fe_Tests
    supports fe_HandleResponse_async

    open core, pfc\asynchronous\
    open dataExchangeIdentifiers%, edf

constants
    handleByTasks_C : integer* =
        [
        be_testResponse_1_C
        ].

/**** User Tasks *******/
predicates
    runTest:(command Command).

predicates
    controlFactory:(string)->function{control}.

end interface fe_Tests
