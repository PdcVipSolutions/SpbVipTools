% SPBrSolutions

implement eventManager
    open core, edf

facts
    eventMsg_P:event2{integer EventID,edf_D EventParameters}:=erroneous.
    eventTaskCall_P:event3{integer EventID,edf_D Parameters,object TaskQueueObj}:=erroneous.
    appEvent_P:event1{integer MessageID}:=erroneous.

clauses
    new():-
        eventMsg_P:=event2::new(),
        eventTaskCall_P:=event3::new(),
        appEvent_P:=event1::new().

end implement eventManager