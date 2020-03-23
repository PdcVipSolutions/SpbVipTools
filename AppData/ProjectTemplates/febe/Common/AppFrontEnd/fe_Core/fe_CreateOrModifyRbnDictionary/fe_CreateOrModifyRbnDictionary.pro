%

implement fe_CreateOrModifyRbnDictionary
    inherits fe_Connector
    open core, edf, coreIdentifiers

clauses
    new(FrontEnd):-
        fe_Connector::new(FrontEnd).

clauses
    onCreateOrModifyRbnDictionary():-
        Dlg=createOrModifyRbnDictionaryDlg::new(convert(window,fe_AppWindow()),frontEnd_P,This),
        Dlg:dictionary_P:=fe_Dictionary(),
        fe_CoreTasks():initCoreDictionary(Dlg:coreDictionary_P),
        setRibbonScriptFilesAndNameSpace(Dlg),
        Dlg:show().

predicates
    setRibbonScriptFilesAndNameSpace:(createOrModifyRbnDictionaryDlg Dlg).
clauses
    setRibbonScriptFilesAndNameSpace(Dialog):-
        Future=be_Responses():createResponseReciever_async(be_TakeRibbonScriptFiles_C),
        fe_CoreTasks():getRibbonScriptFiles(),
        av("scripts-data",a(ScriptFilesList))=Future:get(),
        !,
        foreach
            ScriptDescriptor in ScriptFilesList
        do
            ScriptDescriptorNVL=edf::toNamedValueList(ScriptDescriptor),
            if FileName=namedValue::tryGetNamed_string(ScriptDescriptorNVL,"file") then else FileName="NoScript" end if,
            if NameSpace=namedValue::tryGetNamed_string(ScriptDescriptorNVL,"namespace") then else NameSpace="" end if,
            if DictionaryFile=namedValue::tryGetNamed_string(ScriptDescriptorNVL,"dictionary-file") then else DictionaryFile="" end if,
            Dialog:setFileCandidates(tuple(FileName,NameSpace,DictionaryFile))
        end foreach,
        Dialog:initData(),
        succeed().
    setRibbonScriptFilesAndNameSpace(_Dialog).

clauses
    performTask(TrueIfFrontEndFile,ScriptFileName,NameSpace,DictionaryFile,ModifySource):-
        fe_CoreTasks():createOrModifyDictionaryFile(TrueIfFrontEndFile,ScriptFileName,NameSpace,DictionaryFile,ModifySource).

end implement fe_CreateOrModifyRbnDictionary
