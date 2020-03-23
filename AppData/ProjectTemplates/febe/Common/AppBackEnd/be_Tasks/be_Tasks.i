% Copyright (c) Prolog Development Center SPb
%

interface be_Tasks
    open core, edf

predicates
    fe_Request : (integer RequestID, edf_D RequestData, object TaskQueue).

predicates % User Tasks
    userTask : ().

end interface be_Tasks
