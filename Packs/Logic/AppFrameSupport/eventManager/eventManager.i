% SPBrSolutions

interface eventManager
    open core, edf

properties
    eventTaskCall_P:event3{integer EventID,edf_D EventParameters,object TaskQueueObj}.
    eventMsg_P:event2{integer EventID,edf_D EventParameters}.
    appEvent_P:event1{integer EventID}.

end interface eventManager