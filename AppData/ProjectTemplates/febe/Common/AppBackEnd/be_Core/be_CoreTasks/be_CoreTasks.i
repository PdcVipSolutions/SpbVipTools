%

interface be_CoreTasks
    open core, edf

predicates
    answerToClient:(integer EventID,edf_D EventParameters,object TaskQueueObj).

predicates
    fe_Request:(integer RequestID, edf_D RequestData,object TaskQueue).

predicates
    getUILanguageList:(object TaskQueueObj).
    updateUILanguage : (edf_D FrontEndOptions,object TaskQueueObj).
    getDictionary:(string NameSpace,object TaskQueueObj).
    getDictionary:(object TaskQueueObj).
    add_Dictionary:(string NameSpace,string FileName,object TaskQueue).
    createOrModifyDictionary:(edf_D TaskData,object TaskQueueObj).
    add_CoreDictionary:(string NameSpace,string FileName,object TaskQueue).
    create_CoreDictionary:(string NameSpace,string FileName, edf_D* ItemList,object TaskQueue).
    remove_Dictionary:(string NameSpace,object TaskQueue).
    removeExtraLanguagesFromAllDictionaries:(object TaskQueue).

predicates
    getLastRibbonLayout:(object TaskQueueObj).
    getIconByID:(string IconID,object TaskQueueObj).

predicates
    getSettings:(object TaskQueueObj).
    getFrontEndOptions:(edf_D,object TaskQueueObj).
    setFrontEndOptions : (edf_D FrontEndOptions).

predicates
    getRibbonScripts:(object TaskQueueObj).
    getRibbonScriptFiles:(object TaskQueue).
    expandRibbon:(string RibbonFileName).

predicates
    getTaskQueues:()->tsMapM_redBlack{integer TaskKey, monitorQueue{tuple{integer,edf::edf_D}} TaskQueue}.

end interface be_CoreTasks