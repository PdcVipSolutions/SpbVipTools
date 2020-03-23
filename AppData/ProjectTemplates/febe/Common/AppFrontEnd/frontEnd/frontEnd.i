%

interface frontEnd
    open core

constants
    basicNS_C="basic".
    baseLanguage_C="eng".

constants
    fe_HttpClient_C="fe_HttpClient".
    fe_AppWindow_C="fe_AppWindow".
    be_Responses_C="be_Responses".
    fe_CoreTasks_C="fe_CoreTasks".
    fe_Tasks_C="fe_Tasks".
    fe_Tests_C="fe_Tests".
    fe_Dictionary_C="fe_Dictionary".
    fe_CheckAlive_C="fe_CheckAlive".
    fe_Extensions_C="fe_Extensions".

properties
    eventManager_P:eventManager.

properties
    lastFolder_P:string.
    currentDirectory_P:string.
    ribbonStartup_P:string.
    lastLanguage_P:string.
    exchangeDataFormat_P:string.
    useMenu_P:string.

end interface frontEnd