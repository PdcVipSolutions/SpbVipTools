%

interface fe_CoreTasks
    supports event0
    supports fe_HandleResponse_async

    open core, pfc\asynchronous\
    open edf, coreIdentifiers

constants
    handleByTasks_C:integer*=
        [
            be_Alive_C,
            be_TakeDictionary_C,
            be_EditOptions_C,
            be_TakeFrontEndOptions_C,
            be_TakeUILanguageList_C,
            be_TakeIconByID_C,
            be_TakeRibbonAttributes_C,
            be_TakeRibbonScriptFiles_C,
            be_SaveFileContent_C,
            be_TakeCoreDictionaryInitResponse_C,
            be_TakeStartUpRibbonScripts_C
        ].

% FE invokes
properties
    backEndAlive_P:boolean.
    checkAliveInterval_P:integer. % seconds

predicates
    startCheckBackEndAlive:().
    stopCheckBackEndAlive:().

predicates
    getUILanguageList:()->future{edf::edf_D}.

predicates
    add_DictionaryNameSpace:(string NameSpace,string DictionaryXmlFile).

predicates
    initCoreDictionary:(coreDictionary CoreDictionary).

predicates
    setNewLanguage:(string NewUILanguageID).

predicates
    remove_DictionaryNameSpace:(string NameSpace).

predicates
    getDictionary:().

predicates
    getDictionary:(string NameSpace).

predicates
    getFrontEndOptions:(edf_D OptionsIDList).

predicates
    getLastRibbonLayout:()->tuple{ribbonControl::layout LastLayout,ribbonControl::layout SrcLayout,gmtTimeValue ScriptModifiedTime}.

predicates
    saveFrontEndOptions:(edf_D OptionsList).

predicates
    saveFrontendParameters:(edf_D Parameters).

predicates
    editOptions:().

% BE initiated
predicates
    editOptions:(edf_D PerformParams).

predicates
    setFrontEndOptions:(edf_D PerformParams).

predicates
    saveOptions:().

predicates
    readFile_binary:(string FileName)->binary BinaryContent.

predicates
    getRibbonScriptFiles:().

predicates
    createOrModifyDictionaryFile:(boolean TrueIfFrontEndFile,string ScriptFileName,string NameSpace,string DictionaryFile,boolean ModifySource).

predicates
    saveFileContent:(edf_D FileContent).

predicates
    expandRibbon:(string FileName,binary BinContent).

predicates
    getRibbonStartUpScripts_async:()->future {edf_D}.

predicates
    getIconByID:(string IconID)->binary IconAsBinary.

predicates
    addExtension:(command Command).

predicates
    addExtension:().

predicates
    runHiddenPerformer:(command Command).

predicates
    runPlugin:(command Command).

end interface fe_CoreTasks