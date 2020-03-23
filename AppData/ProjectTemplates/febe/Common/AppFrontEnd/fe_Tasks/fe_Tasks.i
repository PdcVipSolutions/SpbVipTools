% Copyright (c) Prolog Development Center SPb
%

interface fe_Tasks
    supports fe_HandleResponse_async
    open core, pfc\asynchronous\
%    open edf, dataExchangeIdentifiers

constants
    handleByTasks_C : integer* = [].

/**********************************/
predicates
    about : (string NameSpace).
    help : (string NameSpace).

end interface fe_Tasks
