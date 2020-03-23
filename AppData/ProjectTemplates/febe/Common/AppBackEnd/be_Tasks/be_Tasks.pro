% Copyright (c) Prolog Development Center SPb
%

implement be_Tasks inherits be_Connector
    open core, pfc\log
    open  %dataExchangeIdentifiers, edf, coreIdentifiers

clauses
    new(BackEnd) :-
        be_Connector::new(BackEnd).

clauses
    fe_Request(_RequestID, _RequestData, _TaskQueue).

clauses
    userTask().

end implement be_Tasks
