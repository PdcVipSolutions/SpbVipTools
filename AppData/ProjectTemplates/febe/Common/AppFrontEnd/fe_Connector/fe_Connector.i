%

interface fe_Connector
    open core, eventManager

predicates
    request:(notifyMethod_D,integer EventID,edf::edf_D EventParameters).
    request:(notifyMethod_D,integer EventID,edf::edf_D EventParameters,unsigned TimeOut).

properties
    frontEnd_P : frontEnd.

predicates
    fe_AppWindow:()->fe_MainWindow.
    fe_CoreTasks:()->fe_CoreTasks.
    fe_Tasks:()->fe_Tasks.
    fe_Tests:()->fe_Tests.
    be_Responses:()->be_Responses.
    fe_Dictionary:()->fe_Dictionary.
    mainEventManager:()->eventManager.

end interface fe_Connector