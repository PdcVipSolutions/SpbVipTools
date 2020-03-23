%

interface be_Connector
    open core, edf

properties
    taskQueues_P : tsMapM_redBlack{integer TaskKey, monitorQueue{tuple{integer,edf_D}} TaskQueue}.

predicates
    response:(integer EventID,edf_D EventParameters,object TaskQueueObj).

predicates
    be_CoreTasks:()->be_CoreTasks.
    be_Tasks:()->be_Tasks.
    be_Tests:()->be_Tests.
    fe_Requests:()->fe_Requests.
    be_Options:()->be_Options.
    be_Dictionary:()->be_Dictionary.
    mainEventManager:()->eventManager.

end interface be_Connector