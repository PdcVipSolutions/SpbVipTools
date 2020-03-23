%

interface $$(Source.NameFull)
    open core, edf

predicates
    fe_Request:(integer RequestID, edf_D RequestData,object TaskQueue).

predicates % User Purposes
    userTask:(edf_D MessageFromFE,object TaskQueueObj).

end interface $$(Source.Name)