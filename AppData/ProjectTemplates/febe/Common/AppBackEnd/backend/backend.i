%

interface backEnd
    open core

constants % object registration IDs
    be_CoreTasks_C="be_CoreTasks".
    be_Tasks_C="be_Tasks".
    be_Tests_C="be_Tests".
    be_Dictionary_C="be_Dictionary".
    fe_Requests_C="fe_Requests".
    be_Options_C="be_Options".

constants
    baseDictionaryFile_C = @"$$(Project.Name)AppData\$$(Project.Name)_Dictionary.xml".
    basicNS_C = "basic".

properties
    eventManager_P:eventManager.

predicates
    saveOptions:().

end interface backEnd