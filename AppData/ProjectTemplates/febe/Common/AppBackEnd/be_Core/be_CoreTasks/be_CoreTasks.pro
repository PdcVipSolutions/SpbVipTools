%

implement be_CoreTasks inherits be_Connector
    open core, pfc\log
    open edf, coreIdentifiers

clauses
    new(BackEnd) :-
        be_Connector::new(BackEnd).

clauses
    answerToClient(EventID,EventParameters,TaskQueueObj):-
        response(EventID,EventParameters,TaskQueueObj).

clauses
    fe_Request(fe_GetUILanguageList_C, edf::n,TaskQueue):-
        !,
        getUILanguageList(TaskQueue).
    fe_Request(fe_AddDictionaryNameSpace_C,av(NameSpace,s(FileName)),TaskQueue):-
        !,
        add_Dictionary(NameSpace,FileName,TaskQueue).
    fe_Request(fe_AddCoreDictionaryNameSpace_C,av(NameSpace,s(FileName)),TaskQueue):-
        !,
        add_CoreDictionary(NameSpace,FileName,TaskQueue).
    fe_Request(fe_CreateCoreDictionary_C,av(NameSpace,av(FileName,a(ItemList))),TaskQueue):-
        !,
        create_CoreDictionary(NameSpace,FileName,ItemList,TaskQueue).
    fe_Request(fe_RemoveDictionaryNameSpace_C,s(NameSpace),TaskQueue):-
        !,
        remove_Dictionary(NameSpace,TaskQueue).
    fe_Request(fe_GetDictionary_C,s(NameSpace),TaskQueue):-
        !,
        getDictionary(NameSpace,TaskQueue).
    fe_Request(fe_GetDictionary_C,edf::n,TaskQueue):-
        !,
        getDictionary(TaskQueue). % methodChain
    fe_Request(fe_CreateModifyDictionary_C, TaskData,TaskQueue):-
        !,
        createOrModifyDictionary(TaskData,TaskQueue).

    fe_Request(fe_GetFrontEndOptions_C, RequesData,TaskQueue):-
        !,
        getFrontEndOptions(RequesData,TaskQueue).
    fe_Request(fe_SetFrontEndOptions_C, FEOptionsList,_TaskQueue):-
        !,
        setFrontEndOptions(FEOptionsList). % methodDo
    fe_Request(fe_UpdateUILanguage_C, NewUILanguage,TaskQueue):-
        !,
        updateUILanguage(NewUILanguage,TaskQueue). % methodChain
    fe_Request(fe_EditOptions_C, edf::n,TaskQueue):-
        !,
        getSettings(TaskQueue).
    fe_Request(fe_GetStartUpRibbonScripts_C, edf::n,TaskQueue):-
        !,
        getRibbonScripts(TaskQueue).
    fe_Request(fe_GetIconByID_C, edf::s(IconID),TaskQueue):-
        !,
        getIconByID(IconID,TaskQueue).
    fe_Request(fe_GetRibbonAttributes_C, edf::n,TaskQueue):-
        !,
        getLastRibbonLayout(TaskQueue).
    fe_Request(fe_SaveOptions_C, edf::n,_TaskQueue):-
        !,
        be_Options():saveOptions().
    fe_Request(fe_ExpandRibbon_C, edf::av("ribbon-extension-file",s(RibbonFileName)),_TaskQueue):-
        !,
        expandRibbon(RibbonFileName).
    fe_Request(fe_getRibbonScriptFiles_C, edf::n,TaskQueue):-
        !,
        getRibbonScriptFiles(TaskQueue).
    fe_Request(fe_removeExtraLanguagesFromDictionaries_C, edf::n,TaskQueue):-
        !,
        removeExtraLanguagesFromAllDictionaries(TaskQueue).
    fe_Request(_RequstID, _RequestData,_TaskQueue).

clauses
    getTaskQueues()=taskQueues_P.

clauses
    getUILanguageList(TaskQueueObj):-
        SupportedLanguageList=be_Options():getSupportedLanguagesList(),
        LanguageList=[av(LanguageID,av(LanguageTitle,s(LanguageFlag)))||
            tuple(LanguageID,LanguageTitle,LanguageFlag) in SupportedLanguageList
            ],
        response(be_TakeUILanguageList_C,av("UILanguageList",a(LanguageList)),TaskQueueObj).

clauses
    getDictionary(TaskQueueObj):-
        try
            foreach NS_DictionaryItemList=be_Dictionary():getDictionary_nd() do
                response(be_TakeDictionary_C, NS_DictionaryItemList,TaskQueueObj)
            end foreach,
            response(be_EndOfDictionaryList_C, edf::n,TaskQueueObj)
        catch TraceID do
            tuple(ShortInfo,DetailedInfo)=exceptionHandlingSupport::new():getExceptionInfo(TraceID),
            log::write(log::error,ShortInfo),
            response(be_Error_C, av("be_error",a([av("short",s(ShortInfo)),av("detailed",s(DetailedInfo))])),TaskQueueObj)
        end try,
        response(be_EndOfChain_C, edf::i(be_TakeDictionary_C),TaskQueueObj).

clauses
    getDictionary(NameSpace,TaskQueueObj):-
        try
            DictionaryItemList=be_Dictionary():getDictionary(NameSpace),
            response(be_TakeDictionary_C, av(NameSpace,DictionaryItemList),TaskQueueObj)
        catch TraceID do
            tuple(ShortInfo,DetailedInfo)=exceptionHandlingSupport::new():getExceptionInfo(TraceID),
            log::write(log::error,ShortInfo),
            response(be_Error_C, av("be_error",a([av("short",s(ShortInfo)),av("detailed",s(DetailedInfo))])),TaskQueueObj)
        end try.

clauses
    getFrontEndOptions(RequestData,TaskQueueObj) :-
        if RequestData = edf::n then
            ResponseData = be_Options():getFrontEndOptions()
        elseif RequestData=a(_OptionsID_list) then
            ResponseData = be_Options():getFrontEndOptions(RequestData)
        else
            Message=string::format("Invalid data format [%]. Must be a([s(OptionId_1),...,s(OptionID_N)])",RequestData),
            log::write(log::error,Message),
            ResponseData=av("be_error",a([av("short",s("Can not send FrontEnd Options")),av("detailed",s(Message))]))
        end if,
        response(be_TakeFrontEndOptions_C, ResponseData,TaskQueueObj).

clauses
    getSettings(TaskQueueObj):-
        response(be_EditOptions_C, edf::n,TaskQueueObj).

clauses
    setFrontEndOptions(FEOptionsList):-
        be_Options():setFrontEndOptions(FEOptionsList).


clauses
    getLastRibbonLayout(TaskQueueObj):-
        OptionsList=be_Options():getFrontEndOptions(a([s(lastRibbonLayout_C),s(srcRibbonLayout_C),s(ribbonChangedTime_C)])),
        response(be_TakeRibbonAttributes_C, OptionsList,TaskQueueObj).

clauses
    getIconByID("open",TaskQueueObj):-
        !,
        IconAsBinary=file::readBinary(@".\$$(Project.Name)AppData\pdcVipIcons\actions\document-open.ico"),
        response(be_TakeIconByID_C,b(IconAsBinary),TaskQueueObj).
    getIconByID("new",TaskQueueObj):-
        !,
        IconAsBinary=file::readBinary(@".\$$(Project.Name)AppData\pdcVipIcons\actions\document-new.ico"),
        response(be_TakeIconByID_C,b(IconAsBinary),TaskQueueObj).
    getIconByID("save",TaskQueueObj):-
        !,
        IconAsBinary=file::readBinary(@".\$$(Project.Name)AppData\pdcVipIcons\actions\document-save.ico"),
        response(be_TakeIconByID_C,b(IconAsBinary),TaskQueueObj).
    getIconByID("undo",TaskQueueObj):-
        !,
        IconAsBinary=file::readBinary(@".\$$(Project.Name)AppData\pdcVipIcons\actions\edit-undo.ico"),
        response(be_TakeIconByID_C,b(IconAsBinary),TaskQueueObj).
    getIconByID("redo",TaskQueueObj):-
        !,
        IconAsBinary=file::readBinary(@".\$$(Project.Name)AppData\pdcVipIcons\actions\edit-redo.ico"),
        response(be_TakeIconByID_C,b(IconAsBinary),TaskQueueObj).
    getIconByID("copy",TaskQueueObj):-
        !,
        IconAsBinary=file::readBinary(@".\$$(Project.Name)AppData\pdcVipIcons\actions\edit-copy.ico"),
        response(be_TakeIconByID_C,b(IconAsBinary),TaskQueueObj).
    getIconByID(Any,TaskQueueObj):-
        IconAsBinary=file::readBinary(@".\$$(Project.Name)AppData\pdcVipIcons\status\image-missing.ico"),
        log::writef(log::error,"No IconBy ID [%] found",Any),
        response(be_TakeIconByID_C,b(IconAsBinary),TaskQueueObj).

clauses
    add_Dictionary(NameSpace,DictionaryXmlFile,TaskQueueObj):-
        try
            be_Dictionary():tryAdd_DictionaryNameSpace(NameSpace,DictionaryXmlFile)
        catch TraceID do
            tuple(ShortErrorMsg,DetailedErrorMsg)=exceptionHandlingSupport::new():getExceptionInfo(TraceID),
            log::write(log::error,ShortErrorMsg),
            response(be_Error_C, av("be_error",a([av("short",s(ShortErrorMsg)),av("detailed",s(DetailedErrorMsg))])),TaskQueueObj)
        end try,
        !.
    add_Dictionary(_NameSpace,_DictionaryXmlFile,_TaskQueueObj).

clauses
    add_CoreDictionary(NameSpace,DictionaryXmlFile,TaskQueueObj):-
        try
            OptionsList=be_Options():getFrontEndOptions(a([s(refreshDictionary_C)])),
            not(OptionsList=a([av("refresh-dictionary", s("yes"))])),
            be_Dictionary():tryAdd_DictionaryNameSpace(NameSpace,DictionaryXmlFile),
            response(be_TakeCoreDictionaryInitResponse_C, edf::n,TaskQueueObj)
        catch TraceID do
            tuple(ShortErrorMsg,DetailedErrorMsg)=exceptionHandlingSupport::new():getExceptionInfo(TraceID),
            log::write(log::error,ShortErrorMsg),
            response(be_Error_C, av("be_error",a([av("short",s(ShortErrorMsg)),av("detailed",s(DetailedErrorMsg))])),TaskQueueObj)
        end try,
        !.
    add_CoreDictionary(_NameSpace,DictionaryXmlFile,TaskQueueObj):-
        response(be_TakeCoreDictionaryInitResponse_C, av("create-update-dictionaryFile",s(DictionaryXmlFile)),TaskQueueObj).

clauses
    create_CoreDictionary(NameSpace,FileName, ItemList,_TaskQueueObj):-
        TupleItemList=[tuple(ItemID,ItemString,Meaning)||av(ItemID,a([s(ItemString),s(Meaning)])) in ItemList],
        be_Dictionary():create_CoreDictionary(NameSpace,FileName, TupleItemList).

clauses
    remove_Dictionary(NameSpace,TaskQueueObj):-
        try
            be_Dictionary():remove_DictionaryNameSpace(NameSpace)
        catch TraceID do
            tuple(ShortInfo,DetailedInfo)=exceptionHandlingSupport::new():getExceptionInfo(TraceID),
            log::write(log::error,ShortInfo),
            response(be_Error_C, av("be_error",a([av("short",s(ShortInfo)),av("detailed",s(DetailedInfo))])),TaskQueueObj)
        end try.

clauses
    updateUILanguage(s(NewLanguageID),TaskQueueObj):-
        !,
        try
            be_Options():updateUILanguage(NewLanguageID),
            foreach NS_DictionaryItemList=be_Dictionary():getDictionary_nd() do
                response(be_TakeDictionary_C, NS_DictionaryItemList,TaskQueueObj)
            end foreach
        catch TraceID do
            tuple(ShortInfo,DetailedInfo)=exceptionHandlingSupport::new():getExceptionInfo(TraceID),
            log::write(log::error,ShortInfo),
            response(be_Error_C, av("be_error",a([av("short",s(ShortInfo)),av("detailed",s(DetailedInfo))])),TaskQueueObj)
        end try,
        response(be_EndOfDictionaryList_C, edf::n,TaskQueueObj),
        response(be_EndOfChain_C, edf::i(be_TakeDictionary_C),TaskQueueObj).
    updateUILanguage(LanguageDescriptor,_TaskQueueObj):-
        WrongLanguageDescriptor=string::format("Wrong LanguageDescriptor format [%]. Must look like s(LanguageID)",LanguageDescriptor),
        log::write(log::error,WrongLanguageDescriptor),
        exception::raise_User(WrongLanguageDescriptor).

clauses
    expandRibbon(RibbonFileName):-
        be_Options():expandRibbon(RibbonFileName).

clauses
    createOrModifyDictionary(edf::av("createOrModifyDictionary",a([s(FileName),RibbonScriptContentEDF,s(NameSpace),s(DictionaryFileName),bl(ModifyScript)])),TaskQueueObj):-
        !,
        if RibbonScriptContentEDF=s(ScriptFileName) then RibbonScriptContent=string(ScriptFileName)
        elseif RibbonScriptContentEDF=b(ScriptBinaryData) then RibbonScriptContent=binary(ScriptBinaryData)
        else
            exception::raise_User("Unexpected Alternative")
        end if,
        LanguageList=be_Options():getSupportedLanguagesList(), %->tuple{string LanguageName,string LanguageTitle, string LanguageFlagId}*.
        Languages=[namedValue(LanguageID,string(LanguageTitle))||tuple(LanguageID,LanguageTitle,_LanguageFlagId) in LanguageList],
        Performer=dictionarySupport::new(RibbonScriptContent),
        Performer:nameSpace_P:=NameSpace,
        Performer:dictionaryFileName_P:=DictionaryFileName,
        Performer:languageList_P:=Languages,
        Performer:modifyScript_P:=ModifyScript,
        DataOut=Performer:doIt(),
        if
            DataOut=binary(ScriptBinContent),
            RibbonScriptContentEDF=b(SrcScriptBinContent),
            not(ScriptBinContent=SrcScriptBinContent)
        then
            response(be_SaveFileContent_C, edf::av(FileName,b(ScriptBinContent)),TaskQueueObj),
            response(be_EndOfChain_C, edf::i(be_SaveFileContent_C),TaskQueueObj)
        else
            response(be_EndOfChain_C, edf::i(be_SaveFileContent_C),TaskQueueObj)
        end if.
    createOrModifyDictionary(_Any,_TaskQueueObj):-
            exception::raise_User("Unexpected Alternative").

clauses
    getRibbonScripts(TaskQueueObj):-
        try
            BinScripts=be_Options():getStartUpRibbonBinScripts(),
            response(be_TakeStartUpRibbonScripts_C,av("ribbon-binscript-list",BinScripts),TaskQueueObj)
        catch TraceID do
            tuple(ShortInfo,DetailedInfo)=exceptionHandlingSupport::new():getExceptionInfo(TraceID),
            response(be_Error_C, av("be_error",a([av("short",s(ShortInfo)),av("detailed",s(DetailedInfo))])),TaskQueueObj)
        end try,
        succeed.

clauses
    getRibbonScriptFiles(TaskQueueObj):-
        AllFileDescriptorList=getAllRibbonScriptFiles(),
        FileDescriptorList=extractUnusedScripts(AllFileDescriptorList),
        if not(FileDescriptorList=[]) then
            response(be_TakeRibbonScriptFiles_C, av("scripts-data",a(FileDescriptorList)),TaskQueueObj)
        else
            log::write(log::error,"NoRibbon Script file found"),
            response(be_Error_C, av("be_error",a([av("short",s("NoRibbon Script file found")),av("detailed",s("NoRibbon Script file found"))])),TaskQueueObj)
        end if.

predicates
    getAllRibbonScriptFiles:()->edf_D* FileDescriptorList.
clauses
    getAllRibbonScriptFiles()=FileDescriptorList:-
        FileDescriptorList=[FileDescriptor||FileName=directory::getFilesInDirectoryAndSub_nd(@".\$$(Project.Name)AppData","*.xml"),
            try DocFile=createXmlDocFromFile("tmp",FileName),
                RootNode = DocFile:getNode_nd([xmlNavigate::root()]),
                "ribbon-layout"=RootNode:name_P,
                FileBinData = file::readBinary(FileName),
                if DictionaryNode = RootNode:getNode_nd([xmlNavigate::child("dictionary",{(_)})]) then
                    if NameSpace=DictionaryNode:attribute("namespace") then
                    else
                        NameSpace=""
                    end if,
                    if DictionaryFile=DictionaryNode:attribute("file") then
                    else
                        DictionaryFile=""
                    end if,
                    FileDescriptor=a([av("file",s(FileName)),av("file-bin",b(FileBinData)),av("namespace",s(NameSpace)),av("dictionary-file",s(DictionaryFile))])
                else
                    FileDescriptor=a([av("file",s(FileName)),av("file-bin",b(FileBinData)),av("namespace",s("")),av("dictionary-file",s(""))])
                end if
            catch _Trace do
                fail
            end try
        ].

predicates
    extractUnusedScripts:(edf_D* AllFileDescriptorList)->edf_D* UnUsedFiles.
clauses
    extractUnusedScripts(AllFileDescriptorList)=FileDescriptorList:-
        CurrentDir=directory::getCurrentDirectory(),
        FileNameList=be_Options():getRibbonExtensionsList(),
        FileDescriptorList=[a(FileDescriptor)||
            a(FileDescriptor) in AllFileDescriptorList,
                av("file",s(FileName)) in FileDescriptor,
                    ExtFileNameFull=file::trySearchFileInPath(string::tolowerCase(FileName)),
                    ExtFileNameReduced=fileName::reduceToShort(ExtFileNameFull,CurrentDir),
                    not(ExtFileNameReduced in FileNameList)
            ].

clauses
    removeExtraLanguagesFromAllDictionaries(_TaskQueueObj):-
        be_Dictionary():removeExtraLanguagesFromAllDictionaries().

predicates
    createXmlDocFromFile:(string DocName,string FileName)->xmlDocument TemDocument.
clauses
    createXmlDocFromFile(DocName,XmlFileName)=TmpDoc:-
        TmpDoc=xmlDocument::new(DocName),
        TmpDoc:codePage_P:=utf8,
        TmpDoc:indent_P:=true,
        TmpDoc:xmlStandalone_P:=xmlLite::yes,
        XmlFileAsBinary = inputStream_file::openFile(XmlFileName, stream::binary),
        spbXmlLigntSupport::read(XmlFileAsBinary, TmpDoc),
        XmlFileAsBinary:close().

end implement be_CoreTasks
