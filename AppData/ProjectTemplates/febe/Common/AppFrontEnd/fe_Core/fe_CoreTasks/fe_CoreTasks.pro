% Copyright PDCSPB

implement fe_CoreTasks
    inherits fe_Connector
    inherits event0

    open core, vpiDomains, pfc\asynchronous, pfc\log
    open frontEnd, edf, coreIdentifiers, eventManager, defaultDictionary

clauses
    new(FrontEnd):-
        fe_Connector::new(FrontEnd).

/*CheckAlive checks the status of the BackEnd asking once in two seconds the responce from the server (BackEnd)*/
facts
    backEndAlive_P:boolean:=true.
    timeOutBlocked_V:boolean:=false.
    checkAliveInterval_P:integer:=2.

clauses
    startCheckBackEndAlive():-
        checkServerAlive(),
        fail.
    startCheckBackEndAlive():-
        TimerTick=timerTick::new(),
        pzl::register(string::concat(fe_CheckAlive_C,toString(frontEnd_P)),TimerTick),
        TimerTick:tickInterval_P:=checkAliveInterval_P*1000*10000,
        TimerTick:tickActor_P:=checkServerAlive,
        TimerTick:run().

predicates
    checkServerAlive:predicate.
clauses
    checkServerAlive():-
        timeOutBlocked_V=true,
        !.
    checkServerAlive():-
        _F=be_Responses():createResponseReciever_async(be_Alive_C):map(
        {(_Data)=unit:-
            backEndAlive_P:=true,
            fe_AppWindow():showBackEndStatus(true)
            }
        ),
        request(methodRequest,fe_IsBackEndAlive_C,edf::n),
        succeed().

clauses
    stopCheckBackEndAlive():-
        timeOutBlocked_V:=true,
        TimerTickObj=pzl::getObjectByName_nd(fe_CheckAlive_C),
        !,
        TimerTick=convert(timerTick,TimerTickObj),
        TimerTick:stop().
    stopCheckBackEndAlive().

clauses
    mapPromise(Promise,be_TakeDictionary_C,BeResponces):-
        !,
        % be_TakeDictionary_C dictionary (and similar) may be the chain of events invoked
        % by single request from FE (client)
       _=Promise:map({(NS_Dictionary)=core::unit:-
            fe_Dictionary():setDictionary(NS_Dictionary),
            _NewPromice=BeResponces:createResponseReciever_async(be_TakeDictionary_C)
            }).
    mapPromise(Promise,be_SaveFileContent_C,BeResponces):-
        !,
        _=Promise:map({(File_Name_Content)=unit:-
            saveFileContent(File_Name_Content),
            _NewPromice=BeResponces:createResponseReciever_async(be_SaveFileContent_C)
            }).
    mapPromise(_Promise,_ResponseID,_BeResponces).

clauses
    tryHandleRespondedData(be_EndOfDictionaryList_C,_EdfData):-
        !,
        notify().
    tryHandleRespondedData(be_Non200Status_C,av("be_error",a(DescrList))):-
        backEndAlive_P:=false,
        fe_AppWindow():showBackEndStatus(false),
        log::write(log::error,"Non200Status ",DescrList),
        !.
    tryHandleRespondedData(be_RpcError_C,av("be_error",a(DescrList))):-
        log::write(log::error,"RpcError ",DescrList),
        if convert(window,fe_AppWindow()):isShown then
            Message="The Rpc Error. Please see Details!",
            convert(window,fe_AppWindow()):delayCall(3,{:-vpiCommonDialogs::note(Message)})
        end if,
        !.
    tryHandleRespondedData(be_NonResponsiveServer_C,av("be_error",a(DescrList))):-
        backEndAlive_P:=false,
        fe_AppWindow():showBackEndStatus(false),
        log::write(log::error,"NonResponsiveServer ",DescrList),
        !.
    tryHandleRespondedData(be_Timeout_C,av("be_error",a(DescrList))):- % To avoid the repetitions the log
        av("params",a(Params)) in DescrList,
        av("requestid",i(fe_IsBackEndAlive_C)) in Params,
        backEndAlive_P=false,
        !.
    tryHandleRespondedData(be_Timeout_C,av("be_error",a(DescrList))):-
        av("params",a(Params)) in DescrList,
        av("requestid",i(fe_IsBackEndAlive_C)) in Params,
        !,
        log::write(log::error,"TimeOut CheckAlive",DescrList),
        backEndAlive_P:=false,
        if convert(window,fe_AppWindow()):isShown then
            Message="The backend supporting server is not responsive. Please find the way to start it!",
            convert(window,fe_AppWindow()):delayCall(3,{:-vpiCommonDialogs::note(Message)})
        end if,
        fe_AppWindow():showBackEndStatus(false).
    tryHandleRespondedData(be_Timeout_C,av("be_error",a(DescrList))):-
        av("params",a(Params)) in DescrList,
        av("requestid",i(RequestID)) in Params,
        not(RequestID=fe_IsBackEndAlive_C),
        av("short",s(ShortMessage)) in DescrList,
        av("detailed",s(DetailedData)) in DescrList,
        !,
        log::write(log::error,"TimeOut Other then CheckAlive",DescrList),
        if convert(window,fe_AppWindow()):isShown then
            spbExceptionDialog::displayMsg(convert(window,fe_AppWindow()),ShortMessage,DetailedData)
        end if.
    tryHandleRespondedData(be_Error_C,av("be_error",a(DescrList))):-
        av("short",s(ShortMessage)) in DescrList,
        av("detailed",s(DetailedData)) in DescrList,
        !,
        log::write(log::error,"Be_Error",DescrList),
        if convert(window,fe_AppWindow()):isShown then
            spbExceptionDialog::displayMsg(convert(window,fe_AppWindow()),ShortMessage,DetailedData)
        end if.
    tryHandleRespondedData(be_NoEndOfChainError_C,av("be_error",a(DescrList))):-
        av("short",s(ShortMessage)) in DescrList,
        av("detailed",s(DetailedData)) in DescrList,
        !,
        spbExceptionDialog::displayMsg(convert(window,fe_AppWindow()),ShortMessage,DetailedData).

clauses
    onTimeOut(RequestId,TraceId):-
        if ParentWindow=tryConvert(window,fe_AppWindow()) then
        spbExceptionDialog::displayError(ParentWindow,TraceID,string::format("TimeOut Event. Context=[%]",RequestId))
        end if.

/*initiated by FE (requested from BE)*/
clauses
    getUILanguageList()=FutureOut:-
        Future=be_Responses():createResponseReciever_async(be_TakeUILanguageList_C),
        request(methodRequest,fe_GetUILanguageList_C, edf::n),
        FutureOut=Future.

clauses
    initCoreDictionary(CoreDictionary):-
        Future=be_Responses():createResponseReciever_async(be_TakeCoreDictionaryInitResponse_C),
        request(methodRequest,fe_AddCoreDictionaryNameSpace_C, av(CoreDictionary:nameSpace_P,s(CoreDictionary:fileName_P))),
        _F=Future:map(
            {(Response)=unit:-
                if Response=edf::av("create-update-dictionaryFile",s(_DictionaryXmlFile)) then % TODO put msg to Log
                    ItemList=[av(ItemID,a([s(ItemString),s(Meaning)]))||CoreDictionary:getItem(ItemID,ItemString,Meaning)],
                    request(methodDo,fe_CreateCoreDictionary_C,edf::av(CoreDictionary:nameSpace_P,edf::av(CoreDictionary:fileName_P,edf::a(ItemList))))
                end if,
                request(methodRequest,fe_GetDictionary_C,edf::s(CoreDictionary:nameSpace_P))
            }).

clauses
    add_DictionaryNameSpace(NameSpace,DictionaryXmlFileName):-
        request(methodDo,fe_AddDictionaryNameSpace_C, av(NameSpace,s(DictionaryXmlFileName))),
        request(methodRequest,fe_GetDictionary_C,s(NameSpace)).

clauses
    remove_DictionaryNameSpace(NameSpace):-
        request(methodRequest,fe_RemoveDictionaryNameSpace_C, s(NameSpace)).

clauses
    setNewLanguage(NewLanguageID):-
        request(methodChain,fe_UpdateUILanguage_C, s(NewLanguageID)),
        fe_Dictionary():currentLanguage_P:=NewLanguageID,
    % change here text titles for active user-defined elements of the UI
        succeed().

clauses
    getDictionary(NameSpace):-
        request(methodRequest,fe_GetDictionary_C,s(NameSpace)).

clauses
    getDictionary():-
        backEndAlive_P=false,
        !,
        DefaultDictionary=defaultDictionary::new(),
        DictionaryItemList=[av(ItemID ,s(ItemString))||DefaultDictionary:getItem(ItemID ,ItemString ,_Meaning)],
        fe_Dictionary():setDictionary(av(frontEnd::basicNS_C,a(DictionaryItemList))).
    getDictionary():-
        request(methodChain,fe_GetDictionary_C,edf::n).

clauses
% lastFolder_C,
% ribbonStartup_C,lastRibbonLayout_C,lastUsedstartup_C,ribbonUseLast_C
% currentLanguage_C,use_dictionary_C,lastLanguage_C
    saveFrontEndOptions(a(OptionsList)) :-
        !,
        FEOptions =
        [
        av(Name, s(Value)) || s(Name) in OptionsList,
                if lastFolder_C = Name then
                    Value=frontEnd_P:lastFolder_P
                elseif ribbonStartup_C = Name then
                    Value = frontEnd_P:ribbonStartup_P
                elseif lastRibbonLayout_C = Name then
                    Value = toString(fe_AppWindow():ribbonControl_P:layout)
                elseif currentLanguage_C = Name then
                    Value = fe_Dictionary():currentLanguage_P
                elseif lastLanguage_C = Name then
                    Value = fe_Dictionary():currentLanguage_P
                elseif useDictionary_C = Name then
                    Value = fe_Dictionary():useDictionary_P
                else
                    ribbonState_C = Name,
                    StateList = getRibbonStateList(),
                    Value = toString(StateList)
                end if
         ],
        request(methodDo,fe_SetFrontEndOptions_C, a(FEOptions)).
    saveFrontEndOptions(OptionList) :-
        Msg=string::format("Wrong OptionsIDList format [%]. Must Look like a([s(Id1),...,s(IdN)])",OptionList),
        log::write(log::error,Msg),
        exception::raise_User(Msg).

clauses
    getFrontEndOptions(OptionsIDList):-
        _F=be_Responses():createResponseReciever_async(be_TakeFrontEndOptions_C):map(
        {(Options)=unit:-setFrontEndOptions(Options)}
        ),
        request(methodRequest,fe_GetFrontEndOptions_C,OptionsIDList).

clauses
    getLastRibbonLayout()=tuple(LastLayout,SrcLayout,RibbonScriptUpdatedTime):-
        F=be_Responses():createResponseReciever_async(be_TakeRibbonAttributes_C),
        request(methodRequest,fe_GetRibbonAttributes_C,edf::n),
        RibbonLastLayout=F:get(),
        if RibbonLastLayout=a(DataList) then
            if av(lastRibbonLayout_C,s(LastLayoutStr)) in DataList then
                LastLayout=toTerm(ribbonControl::layout,LastLayoutStr)
            else
                LastLayout=[]
            end if,
            if av(srcRibbonLayout_C,s(SrcLayoutStr)) in DataList then
                SrcLayout=toTerm(SrcLayoutStr)
            else
                SrcLayout=[]
            end if,
            if av(ribbonChangedTime_C,s(RibbonScriptUpdatedTimeStr)) in DataList then
                RibbonScriptUpdatedTime=toTerm(RibbonScriptUpdatedTimeStr)
            else
                RibbonScriptUpdatedTime=0
            end if
        else
            Msg=string::format("Wrong RibbonLastLayout format [%]. Must Look like a([av(A1,s(...)),av(A2,s(...))])",RibbonLastLayout),
            log::write(log::error,Msg),
            exception::raise_User(Msg)
        end if.

clauses
    saveFrontendParameters(AttrValueList):-
        request(methodDo,fe_SetFrontEndOptions_C, AttrValueList).

clauses
    editOptions():-
        _F=be_Responses():createResponseReciever_async(be_EditOptions_C):map(
        {(Options)=unit:-editOptions(Options)}
        ),
        request(methodRequest,fe_EditOptions_C,edf::n).

clauses
    saveOptions():-
        request(methodDo,fe_SaveOptions_C,edf::n).

clauses
    getRibbonStartUpScripts_async()=Future:-
        Future=be_Responses():createResponseReciever_async(be_TakeStartUpRibbonScripts_C),
        request(methodRequest,fe_GetStartupRibbonScripts_C,edf::n).

clauses
    getIconByID(IconID)=IconAsBinary:-
        Future=be_Responses():createResponseReciever_async(be_TakeIconByID_C),
        request(methodRequest,fe_GetIconByID_C,edf::s(IconID)),
        b(IconAsBinary)=Future:get(),
        !.
    getIconByID(IconID)=_IconAsBinary:-
        exception::raise_User(string::format("Invalid IconRequest via ID [%]",IconID)).

/*Invoked by BE*/
predicates
    getRibbonStateList : () -> edf_D.
clauses
    getRibbonStateList() =a([]).

clauses
    setFrontEndOptions(a(FEOptionsList)):-
        !,
        foreach av(OptionName, s(OptionValue)) in FEOptionsList do
            setOption(OptionName,OptionValue),!
        end foreach.
    setFrontEndOptions(FEOptionsList):-
        Msg=string::format("Wrong OptionsList format [%]. Must Look like a([av(Id1,s(V1)),...,s(IdN,s(VN))])",FEOptionsList),
        log::write(log::error,Msg),
        exception::raise_User(Msg).

predicates
    setOption:(string OptionId,string OptionValue) multi.
clauses
    setOption(lastFolder_C,OptionValue):-
        not(OptionValue=""),
        frontEnd_P:lastFolder_P := OptionValue.
    setOption(useDictionary_C,OptionValue):-fe_Dictionary():useDictionary_P := OptionValue.
    setOption(currentLanguage_C,OptionValue):-
        if OptionValue = "" then
            CurrentLanguage=frontEnd::baseLanguage_C
        else
            CurrentLanguage=frontEnd::baseLanguage_C
        end if,
        fe_Dictionary():currentLanguage_P := CurrentLanguage.

    setOption(ribbonStartup_C,OptionValue):-frontEnd_P:ribbonStartup_P:=OptionValue.
    setOption(useMenu_C,OptionValue):-frontEnd_P:useMenu_P:=OptionValue.
    setOption(lastLanguage_C,OptionValue):-
        if OptionValue = "" then
            LastLanguage=frontEnd::baseLanguage_C
        else
            LastLanguage=frontEnd::baseLanguage_C
        end if,
        frontEnd_P:lastLanguage_P:=LastLanguage.

    setOption(_AnyId,_AnyValue).

clauses
    editOptions(PerformParams):-
        Dialog=fe_Options::new(convert(window,fe_AppWindow()),frontEnd_P,PerformParams),
        Dialog:dictionary_P:=fe_Dictionary(),
        initCoreDictionary(Dialog:coreDictionary_P),
        Dialog:initData(),
        Dialog:show().

clauses
    expandRibbon(FileName,BinContent):-
        request(methodDo,fe_ExpandRibbon_C,edf::av("ribbon-extension-file",s(FileName))),
        fe_AppWindow():fe_Command_P:expandRibbon(BinContent).

clauses
    saveFileContent(av(FileName,b(BinaryContent))):-
        !,
        file::writeBinary(FileName,BinaryContent).
    saveFileContent(av(FileName,s(StringContent))):-
        !,
        file::writeString(FileName,StringContent).
    saveFileContent(AnyOther):-
        WrongDataFormat=string::format("Wrong data Format [%]",AnyOther),
        log::write(log::error,WrongDataFormat),
        exception::raise_User(WrongDataFormat).

clauses
    addExtension(_Command):-
        addExtension().

    addExtension():-
        Future=be_Responses():createResponseReciever_async(be_TakeRibbonScriptFiles_C),
        getRibbonScriptFiles(),
        Response=Future:get(),
        !,
        if Response=av("scripts-data",a(ScriptFiles)) then
            Dialog=chooseRibbonScriptFileDlg::new(convert(window,fe_AppWindow()),This),
            Dialog:dictionary_P:=fe_Dictionary(),
            initCoreDictionary(Dialog:coreDictionary_P),
            foreach
                ScriptDescriptor in ScriptFiles
            do
                ScriptDescriptorNVL=edf::toNamedValueList(ScriptDescriptor),
                if
                    FileName=namedValue::tryGetNamed_string(ScriptDescriptorNVL,"file"),
                    FileBinContent=namedValue::tryGetNamed_binary(ScriptDescriptorNVL,"file-bin")
                then
                    Dialog:setFileCandidates(FileName,FileBinContent)
                end if
            end foreach,
            Dialog:initData(),
            Dialog:show()
        else
        %TODO User must be informed if there is the ErrorResponse
        end if,
        succeed().

clauses
    getRibbonScriptFiles():-
        request(methodRequest,fe_getRibbonScriptFiles_C,edf::n).

clauses
    createOrModifyDictionaryFile(TrueIfFrontEndFile,ScriptFileName,NameSpace,DictionaryFileName,ModifySource):-
        if TrueIfFrontEndFile=true then
            BinaryFileContent=readFile_binary(ScriptFileName),
            FileContent=edf::b(BinaryFileContent)
        else
            FileContent=edf::s(ScriptFileName)
        end if,
        request(methodChain,fe_CreateModifyDictionary_C,edf::av("createOrModifyDictionary",a([s(ScriptFileName),FileContent,s(NameSpace),s(DictionaryFileName),bl(ModifySource)]))).

clauses
    readFile_binary(FileName)=BinaryFileContent:-
            file::existExactFile(FileName),
            !,
            BinaryFileContent = file::readBinary(FileName).
    readFile_binary(FileName)=_:-
            NoFileFound=string::format("Ribbon-xmlScript file [%] not found",FileName),
            log::write(log::error,NoFileFound),
            exception::raise_User(NoFileFound).

clauses
    runHiddenPerformer(Command):-
        CommandSuffix=fe_Command::tryExtractCommandSuffix(Command,"ribbon.cmd.hidden."),
        !,
        runPerformer(CommandSuffix,Command).
    runHiddenPerformer(Command):-
        Msg=string::format("Wrong hidden performer call [%].",Command:id),
        log::write(log::error,Msg),
        exception::raise_User(Msg).

predicates
    runPerformer:(string CommandSuffix,command Command).
clauses
    runPerformer("make-dictionary",_Command):-
        !,
        fe_CreateOrModifyRbnDictionary::new(frontEnd_P):onCreateOrModifyRbnDictionary().
    runPerformer("run-cookbook",Command):-
        string::fronttoken(Command:id,NameSpace,_Rest),
        !,
        mainExe::getFilename(BinPath, _),
        CookBookDefaultFileName = filename::createPath(BinPath, @"$$(Project.Name)AppData\AppFrameCookBookEn.chm"),
        CookBookDefinedFileName = fe_Dictionary():getStringByKey(string::concat(NameSpace,@"\",cookBookFile_C), CookBookDefaultFileName),
        shell_api::shellOpen(CookBookDefinedFileName).
    runPerformer("remove-extra-languages",_Command):-
        !,
        request(methodDo,fe_removeExtraLanguagesFromDictionaries_C,edf::n).
    runPerformer(CommandSuffix,Command):-
        Msg=string::format("No Sleeping performer [%] supported for the command [%]",CommandSuffix,Command:id),
        log::write(log::error,Msg),
        exception::raise_User(Msg).

clauses
    runPlugin(Command):-
        PluginID=fe_Command::tryExtractCommandSuffix(Command,"ribbon.cmd.plugin."),
        !,
        ComponentObj=pzl::newByName(PluginID,fe_AppWindow()),
        Component=convert(pzlRun,ComponentObj),
        Component:pzlRun(toString(Command:category)).
    runPlugin(Command):-
        Msg=string::format("Not pzl plugin invocation command [%]\n",Command:id),
        log::write(log::error,Msg),
        exception::raise_User(Msg).

end implement fe_CoreTasks