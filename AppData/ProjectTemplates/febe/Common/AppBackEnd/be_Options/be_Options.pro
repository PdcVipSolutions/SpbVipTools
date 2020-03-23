%

implement be_Options
    inherits be_Connector
    open core, pfc\log
    open edf, coreIdentifiers, xmlNavigate

constants
    optionsFile_C = @"$$(Project.Name)AppData\options.xml".

facts
    xmlOptions_V : xmlDocument.
    currentLanguage_P:string:="eng".

constants
    optionsTemplate_C=#bininclude(@"..\Common\AppBackEnd\be_Options\OptionsTemplate.xml").

clauses
    new(BackEnd):-
        be_Connector::new(BackEnd),
        xmlOptions_V:=xmlDocument::new("appHead_options"),
        xmlOptions_V:codePage_P:=utf8,
        xmlOptions_V:indent_P:=true,
        xmlOptions_V:xmlStandalone_P:=xmlLite::yes,
        if file::existExactFile(optionsFile_C) then
            XmlOptions = inputStream_file::openFile(optionsFile_C, stream::binary)
        else
            XmlOptions = inputStream_binary::new(optionsTemplate_C),
            saveOptions()
        end if,
        spbXmlLigntSupport::read(XmlOptions, xmlOptions_V),
        XmlOptions:close(),
        setCurrentLanguage().

predicates
    setCurrentLanguage : ().
clauses
    setCurrentLanguage():-
        if
            tuple(Path,AttributeName)=tryMapAttribute2NodeName(currentLanguage_C),
            LngNode = xmlOptions_V:getNode_nd([root(),child(fe_OptionsNode_C, {(_)})|Path]),!,
            CurrentLng = LngNode:attribute(AttributeName)
        then
            currentLanguage_P:=CurrentLng
        end if.

clauses
    saveOptions():-
        OutputStream = outputStream_file::create(optionsFile_C, stream::binary),
        xmlOptions_V:saveXml(OutputStream).

% FrontEnd Options
    getFrontEndOptions(a(FE_OptionIdList))=a(OptionsList):-
        !,
        OptionsList=[av(AttrName, s(AttrValue))
            ||
            s(AttrName) in FE_OptionIdList,
                tuple(XmlPath,AttributeName)=tryMapAttribute2NodeName(AttrName),
                if AttributeName=emptyString_C then
                    Node = xmlOptions_V:getNode_nd([root(),child(fe_OptionsNode_C,{(_)})|XmlPath]),
                    xmlElement::text(AttrValue)=Node:tryGetItem(xmlElement::text,1)
                else
                    Node = xmlOptions_V:getNode_nd([root(),child(fe_OptionsNode_C,{(_)})|XmlPath]),
                        AttrValue=Node:attribute(AttributeName)
                end if
            ].
    getFrontEndOptions(FE_OptionIdList)=_:-
        Msg=string::format("WrongOptions request format [%]. must be a([s(Option1),...s(OptionN)])",FE_OptionIdList),
        log::write(log::error,Msg),
        exception::raise_User(Msg).

clauses
    getFrontEndOptions() =OptionsList:-
        FE_OptionIdList=a([s(lastFolder_C), s(currentLanguage_C), s(use_dictionary_C), s(useMenu_C),s(ribbonStartup_C), s(ribbonUseLast_C)]),
        OptionsList=getFrontEndOptions(FE_OptionIdList).

clauses
    getSupportedLanguagesList()=LanguageDescriptors:-
        tuple(XmlPath,_AttributeName)=tryMapAttribute2NodeName(supportedLanguage_C),
        !,
        LanguageDescriptors=[tuple(LanguageName,LanguageTitle,LanguageFlagId)||
        Node = xmlOptions_V:getNode_nd([root(),child(fe_OptionsNode_C,{(_)})|XmlPath]),
            LanguageName=Node:attribute(id_C),
            LanguageTitle=Node:attribute(languageTitle_C),
            LanguageFlagId=Node:attribute(languageFlagID_C)
            ].
    getSupportedLanguagesList()=[tuple(baseLanguage_C,baseLanguageTitle_C,baseLanguageFlagId_C)].

clauses
    expandRibbon(RibbonExpansionFile):-
        ExpansionFile=filename::reduceToShort(RibbonExpansionFile,directory::getCurrentDirectory()),
        if
            getFrontEndOptions(a([s(ribbonStartup_C)]))=a([av(_AttrName, s(RibbonStarter))]),
            tuple(XmlPath,_AttributeName)=tryMapAttribute2NodeName(RibbonStarter),
            Node = xmlOptions_V:getNode_nd([root(),child(fe_OptionsNode_C,{(_)})|XmlPath]),!
        then
            ExtNode = xmlElement::new("ext",Node),
            Node:addNode(ExtNode),
            ExtNode:addText(ExpansionFile)
        else
            Msg=("Ribbon Starter not found"),
            log::write(log::error,Msg),
            exception::raise_User(Msg)
        end if.

facts
    lastChanged_V:gmtTimeValue:=erroneous.
clauses
    getStartUpRibbonBinScripts()=a([av("scripts",a(BinFileDataList)),av("lastchanged",tg(lastChanged_V))]):-
        ExecutableFileName=mainExe::getFilename(),
        file::getFileProperties(ExecutableFileName,_ExeAttributes,_ExeSize,_ExeCreation,_ExeLastAccess,ExecLastChange),
        lastChanged_V:=ExecLastChange,
        if
            tuple(XmlStartUpPath,_)=tryMapAttribute2NodeName(ribbonStartup_C),
            RibbonNode = xmlOptions_V:getNode_nd([root(),child(fe_OptionsNode_C,{(_)})|XmlStartUpPath]),!,
            StartUpName=RibbonNode:attribute("startup")
        then
            ExtFileNames=[ExtFileName||RibbonNode:getNode_nd([child(StartUpName,{(_)}),child("ext",{(_)})]):tryGetItem(xmlElement::text,1)=xmlElement::text(ExtFileName)],
            if
                StartUpName="loadable",
                StartupScript=RibbonNode:getNode_nd([child(StartUpName,{(_)})]):attribute("script")
            then
                FileNameList=[StartupScript|ExtFileNames]
            else
                FileNameList=ExtFileNames
            end if,
            XmlBinDataList=[b(XmlBinData)||FileName in FileNameList,
                file::existExactFile(FileName),
                XmlBinData = file::readBinary(FileName),
                file::getFileProperties(FileName,_Attributes,_Size,_Creation,_LastAccess,LastChange),
                if lastChanged_V>=LastChange then
                else
                    lastChanged_V:=LastChange
                end if,
                succeed
                ],
            if StartUpName="embedded" then
                if lastChanged_V>=ExecLastChange then
                else
                    lastChanged_V:=ExecLastChange
                end if,
                BinFileDataList=[b(embeddedRibbonXml_C)|XmlBinDataList]
            else
                BinFileDataList=XmlBinDataList
            end if
        else
            BinFileDataList=[]
        end if.

clauses
    getRibbonExtensionsList()=FileNameList:-
        if
            tuple(XmlStartUpPath,_)=tryMapAttribute2NodeName(ribbonStartup_C),
            RibbonNode = xmlOptions_V:getNode_nd([root(),child(fe_OptionsNode_C,{(_)})|XmlStartUpPath]),!,
            StartUpName=RibbonNode:attribute("startup")
        then
            CurrentDir=directory::getCurrentDirectory(),
            ExtFileNames=
                [ExtFileName||
                    RibbonNode:getNode_nd([child(StartUpName,{(_)}),child("ext",{(_)})]):
                    tryGetItem(xmlElement::text,1)=xmlElement::text(FileName),
                    ExtFileNameFull=file::trySearchFileInPath(string::toLowerCase(FileName)),
                    ExtFileName=filename::reduceToShort(ExtFileNameFull,CurrentDir)
                ],
            if
                StartUpName="loadable",
                StartupScriptSrc=RibbonNode:getNode_nd([child(StartUpName,{(_)})]):attribute("script"),
                StartupScript=file::trySearchFileInPath(string::tolowerCase(StartupScriptSrc))
            then
                FileNameList=[fileName::reduceToShort(StartupScript,CurrentDir)|ExtFileNames]
            else
                if
                    ExistsFile=file::trySearchFileInPath(string::tolowerCase(embeddedFileName_C))
                then
                    FileNameList=[fileName::reduceToShort(ExistsFile,CurrentDir)|ExtFileNames]
                else
                    FileNameList=ExtFileNames
                end if
            end if
        else
            FileNameList=[]
        end if.

clauses
    setFrontEndOptions(OptionsList):-
        if OptionsList=a(FrontEndOptions) then
        elseif OptionsList=av(_,_) then
            FrontEndOptions=[OptionsList]
        else
            fail
        end if,
        !,
        foreach
            av(AttrName, s(Value)) in FrontEndOptions,
            tuple(XmlPath,AttributeName)=tryMapAttribute2NodeName(AttrName)
        do
            if AttributeName=emptyString_C then
                if
                    Node = xmlOptions_V:getNode_nd([root(),child(fe_OptionsNode_C,{(_)})|XmlPath]),
                    !
                then
                    set_NodeContent(Node,Value)
                else
                    NewNode=createNodePath([child(fe_OptionsNode_C,{(_)})|XmlPath],xmlOptions_V:root_P),
                    NewNode:addText(Value)
                end if
            else
                if Node = xmlOptions_V:getNode_nd([root(),child(fe_OptionsNode_C,{(_)})|XmlPath]),! then
                    set_NodeAttribute(Node,AttributeName,Value)
                else
                    LastNode=createNodePath([child(fe_OptionsNode_C,{(_)})|XmlPath],xmlOptions_V:root_P),
                    LastNode:addAttribute(AttributeName,Value)
                end if
            end if
        end foreach.
    setFrontEndOptions(_AnyOther):-
        Message="Wrong Data Format",
        log::write(log::error,Message),
        exception::raise_User(Message).

predicates
    createNodePath:(step_D* XmlPath,xmlElement ElementObject)->xmlElement FinalObject.
clauses
    createNodePath([],StartElement)=StartElement.
    createNodePath([Head|Tail],StartElement)=FinalObject:-
        if Node=xmlOptions_V:getNode_nd([current(StartElement),Head]),! then
            FinalObject=createNodePath(Tail,Node)
        elseif
            Head=child(Name,_)
        then
            NewElement=xmlElement::new(Name),
            StartElement:addNode(NewElement),
            FinalObject=createNodePath(Tail,NewElement)
        else
            FinalObject=StartElement % dummy way, just to keep procedure mode
        end if.

predicates
    set_NodeAttribute:(xmlElement Node,string AttributeName,string Value).
clauses
    set_NodeAttribute(Node,AttributeName,Value):-
            if _Value=Node:attribute(AttributeName) then
                Node:modifyAttribute(AttributeName,Value)
            else
                Node:addAttribute(AttributeName,Value)
            end if.

predicates
    set_NodeContent:(xmlElement Node,string Value).
clauses
    set_NodeContent(Node,Value):-
        _=Node:tryModifyItem(xmlElement::text,1,xmlElement::text(Value)),
        !.
    set_NodeContent(Node,Value):-
        Node:addText(Value).

class predicates
    tryMapAttribute2NodeName:(string AttrName) -> tuple{step_D* XmlPath,string AttributeName} determ.
clauses
    tryMapAttribute2NodeName(lastFolder_C)=tuple([],lastFolder_C).
    tryMapAttribute2NodeName(useMenu_C)=tuple([],useMenu_C).

    tryMapAttribute2NodeName(ribbonScript_C)=tuple([child(groupNode_C,{(O) :- O:attribute(id_C) = fe_AppWindow_C}),child(ribbonNode_C,{(_)}),child(loadable_C,{(_)})],script_C).

    tryMapAttribute2NodeName(default_C)=tuple([child(groupNode_C,{(O) :- O:attribute(id_C) = fe_AppWindow_C}),child(ribbonNode_C,{(_)}),child(default_C,{(_)})],emptyString_C).
    tryMapAttribute2NodeName(embedded_C)=tuple([child(groupNode_C,{(O) :- O:attribute(id_C) = fe_AppWindow_C}),child(ribbonNode_C,{(_)}),child(embedded_C,{(_)})],emptyString_C).
    tryMapAttribute2NodeName(loadable_C)=tuple([child(groupNode_C,{(O) :- O:attribute(id_C) = fe_AppWindow_C}),child(ribbonNode_C,{(_)}),child(loadable_C,{(_)})],emptyString_C).

    tryMapAttribute2NodeName(lastRibbonLayout_C)=tuple([child(groupNode_C,{(O) :- O:attribute(id_C) = fe_AppWindow_C}),child(ribbonNode_C,{(_)}),child(lastLayout_C,{(_)})],emptyString_C).
    tryMapAttribute2NodeName(srcRibbonLayout_C)=tuple([child(groupNode_C,{(O) :- O:attribute(id_C) = fe_AppWindow_C}),child(ribbonNode_C,{(_)}),child(sourceLayout_C,{(_)})],emptyString_C).
    tryMapAttribute2NodeName(ribbonChangedTime_C)=tuple([child(groupNode_C,{(O) :- O:attribute(id_C) = fe_AppWindow_C}),child(ribbonNode_C,{(_)}),child(sourceLayout_C,{(_)})],changeTime_C).

    tryMapAttribute2NodeName(ribbonStartup_C)=tuple([child(groupNode_C,{(O) :- O:attribute(id_C) = fe_AppWindow_C}),child(ribbonNode_C,{(_)})],startup_C).

    tryMapAttribute2NodeName(use_dictionary_C)=tuple([child(groupNode_C,{(O) :- O:attribute(id_C) = fe_AppWindow_C}),child(languageNode_C,{(_)})],useDictionary_C).
    tryMapAttribute2NodeName(currentLanguage_C)=tuple([child(groupNode_C,{(O) :- O:attribute(id_C) = fe_AppWindow_C}),child(languageNode_C,{(_)})],current_C).
    tryMapAttribute2NodeName(refreshDictionary_C)=tuple([child(groupNode_C,{(O) :- O:attribute(id_C) = fe_AppWindow_C}),child(languageNode_C,{(_)})],refresh_C).
    tryMapAttribute2NodeName(lastLanguage_C)=tuple([child(groupNode_C,{(O) :- O:attribute(id_C) = fe_AppWindow_C}),child(languageNode_C,{(_)})],lastUsedLanguage_C).
    tryMapAttribute2NodeName(supportedLanguage_C)=tuple([child(groupNode_C,{(O) :- O:attribute(id_C) = fe_AppWindow_C}),child(languageNode_C,{(_)}),child(support_C,{(_)})],emptyString_C).

clauses
    updateUILanguage(NewUILanguageID):-
        currentLanguage_P:=NewUILanguageID,
        setFrontEndOptions(a([av(currentLanguage_C, s(NewUILanguageID))])).

end implement be_Options