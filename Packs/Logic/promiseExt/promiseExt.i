%

interface promiseExt {@Type}
    supports promise {@Type}
    open core, pfc\asynchronous\, edf

properties
    timeOutTime_P:integer.
    timeOutActor_P:predicate{promiseExt {@Type},edf::edf_D}.
    timeOutContext_P:edf_D.

predicates
    initTimeout:().
    stopTimeout:().

end interface promiseExt
