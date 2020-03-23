%

interface $$(Source.NameFull)
    open core, pfc\asynchronous\
    open edf

constants
    handleByTasks_C:integer*=
        [
        ].

predicates
    tryHandleRespondedData:(integer MessageID, edf_D EdfData) determ.

predicates
    tryMapPromise:(promiseExt{edf_D},integer MessageID, be_Responses) determ.

/**********************************/
predicates
	userTask:(edf_D).

end interface $$(Source.Name)
