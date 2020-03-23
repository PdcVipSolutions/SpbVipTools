%
%

interface be_Tests
    open core, edf

predicates
    fe_Request : (integer RequestID, edf_D RequestData, object TaskQueue).

predicates % Test-Demo Purposes
    testCall_1:(edf_D MessageFromFE,object TaskQueueObj).
    testCall_2:(edf_D MessageFromFE,object TaskQueueObj).
    testCall_3:(edf_D MessageFromFE,object TaskQueueObj).
    testCall_4:(edf_D MessageFromFE,object TaskQueueObj).
    testCall_5:(edf_D MessageFromFE,object TaskQueueObj).
    testCall_6:(edf_D MessageFromFE,object TaskQueueObj).

end interface be_Tests
