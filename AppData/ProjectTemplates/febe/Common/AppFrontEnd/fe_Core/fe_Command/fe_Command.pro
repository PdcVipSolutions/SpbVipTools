%

implement fe_Command
    inherits fe_Connector

    open core, ribbonControl, pfc\log, command, vpiDomains
    open edf, coreIdentifiers

facts - command_FB
    mainWindow_V : window:=erroneous.

clauses
    new(MainWindow,FrontEnd):-
        mainWindow_V:=MainWindow,
        _Token=gdiplus::startup(),
        fe_Connector::new(FrontEnd),
        fe_CoreTasks():addListener(updateRibbonLabels),
        MainWindow:addMenuItemListener(menuListener).

predicates
    startupRule:(string UseDictionary,string NewLanguage,string OldLanguage) -> boolean UpdateLanguage multi.
clauses
    startupRule("no",_NewLanguage,_OldLanguage)=false.
    startupRule("yes",Language,Language)=false.
    startupRule(_UseDictionary,_NewLanguage,_OldLanguage)=true.

facts
    exceptionalSituation_V:boolean:=false.
clauses
    initRibbon(_TrueIfAsScript):-
        fe_CoreTasks():backEndAlive_P=false,
        Message="The backend supporting server is not responsive. Please find the way to start it!",
        if exceptionalSituation_V=true then
        else
            runExceptionalSituation(Message),
            exceptionalSituation_V:=true
        end if,
        fe_AppWindow():showBackEndStatus(false),
        convert(window,fe_AppWindow()):delayCall(3,{:-vpiCommonDialogs::note(Message)}),
        !.
    initRibbon(TrueIfAsScript):-
        exceptionalSituation_V:=false,
        fe_CoreTasks():getFrontEndOptions(a([s(ribbonStartup_C),s(lastLanguage_C)])),
        startupRule(fe_Dictionary():useDictionary_P, fe_Dictionary():currentLanguage_P,frontEnd_P:lastLanguage_P)=UpdateLanguage,!,
        Startup=frontEnd_P:ribbonStartup_P, % defined while requested frontEndOptions above
        ContextObj=cmdPerformers::new(),
        setCommonPerformers(ContextObj),
        try
            if Startup=ribbonStartupEmbedded_C then
                Ribbon=fe_RibbonScriptEmbedded::new(frontEnd_P),
                Ribbon:setRibbonContext(ContextObj),
                InitialLayout=[]
            elseif Startup=ribbonStartupLoadable_C then
                Ribbon=fe_RibbonScriptLoadable::new(frontEnd_P),
                Ribbon:setRibbonContext(ContextObj),
                InitialLayout=[]
            else % Startup=ribbonStartupDefault_C
                DefaultRibbon=fe_RibbonDefault::new(frontEnd_P),
                DefaultRibbon:setRibbonContext(ContextObj),
                InitialLayout=DefaultRibbon:getRibbonLayout(mainWindow_V,ContextObj)
            end if,
            tuple(ExtendedLayout,NewLayoutTime)=createRibbon(InitialLayout,ContextObj),
            if TrueIfAsScript=true then
                NewLayout=ExtendedLayout
            else
                tuple(OldLayout,SrcLayout,SrcLayoutTime)=fe_CoreTasks():getLastRibbonLayout(),
                NewLayout=defineLayout(OldLayout,SrcLayout,SrcLayoutTime,ExtendedLayout,NewLayoutTime),
                !
            end if,
            fe_CoreTasks():saveFrontendParameters(a([
                av(srcRibbonLayout_C,s(toString(ExtendedLayout))),
                av(lastRibbonLayout_C,s(toString(NewLayout))),
                av(ribbonChangedTime_C,s(toString(NewLayoutTime)))
                ])),
            fe_AppWindow():ribbonControl_P:layout := NewLayout,
            if UpdateLanguage=true then
                updateRibbonLabels()
            end if
        catch TraceID do
            if not(Startup=ribbonStartupDefault_C) then
                exceptionHandlingSupport::new():getExceptionInfo(TraceID)=tuple(ShortInfo,DetailedInfo),
                ErrorMessage=string::format("Unsuccessful ribonScript load. Startup=[%]\nShort:[%]\nDetailed:[%] ",Startup,ShortInfo,DetailedInfo),
                runExceptionalSituation(ErrorMessage),
                vpiCommonDialogs::error(ErrorMessage)
            end if
        end try.

predicates
    defineLayout:(layout OldLayout,layout SrcLayout,gmtTimeValue SrcLayoutTime,layout ExtendedLayout,gmtTimeValue NewLayoutTime)->layout LayoutToUse multi.
clauses
    defineLayout([],_SrcLayout,_SrcLayoutTime,ExtendedLayout,_ExtendedLayoutTime)=ExtendedLayout.
    defineLayout(OldLayout,_SrcLayout,LayoutTime,ExtendedLayout,LayoutTime)=OldLayout:-
        nameSpacesSorted(toString(ExtendedLayout))=nameSpacesSorted(toString(OldLayout)),
        !.
    defineLayout(OldLayout,SrcLayout,SrcLayoutTime,ExtendedLayout,ExtendedLayoutTime)=OldLayout:-
        ExtendedLayoutTime>SrcLayoutTime,
        compareLayout(SrcLayout,ExtendedLayout)=equal().
    defineLayout(_OldLayout,_SrcLayout,_SrcLayoutTime,ExtendedLayout,_NewLayoutTime)=ExtendedLayout.
%    defineLayout(OldLayout,SrcLayout,SrcLayoutTime,ExtendedLayout,ExtendedLayoutTime)=Layout.

predicates
    nameSpacesSorted:(string LayoutAsString)->string* ListOfNameSpacesSorted.
clauses
    nameSpacesSorted(LayoutAsString)=list::sort(CmdNSlist,descending):-
        SectionList=string::split_delimiter(LayoutAsString,"section(\""),
            CmdNSlist=[CmdNS||Section in SectionList,
                string::splitStringBySeparators(Section,"\\",_SectNS,_Char,SlashPlusCommands),
                string::frontChar(SlashPlusCommands,_,Commands),
                CmdList=string::split_delimiter(Commands,"cmd(\""),
                Cmd in CmdList,
                    string::splitStringBySeparators(Cmd,"\\",CmdNS)
            ].

predicates
    compareLayout:comparator{layout SrcLayout, layout NewLayout}.
clauses
    compareLayout(Layout, Layout)=equal():-
    !.
    compareLayout(_SrcLayout, _NewLayout)=greater().

predicates
    runExceptionalSituation:(string ExceptionMessage).
clauses
    runExceptionalSituation(ExceptionMessage):-
        Ribbon=fe_RibbonDefault::new(frontEnd_P),
        log::write(log::error,ExceptionMessage),
        ContextObj=cmdPerformers::new(),
        setCommonPerformers(ContextObj),
        Layout=Ribbon:getRibbonLayout(mainWindow_V,ContextObj),
        convert(fe_MainWindow,mainWindow_V):ribbonControl_P:layout := Layout.

predicates
    updateRibbonLabels:event0::listener.
clauses
    updateRibbonLabels():-
        updateRibbonLabels1().

clauses
    updateRibbonLabels1():-
        fe_Dictionary():useDictionary_P=useDictionaryNo_C,
        !.
    updateRibbonLabels1():-
        RibbonControl=convert(fe_MainWindow,mainWindow_V):ribbonControl_P,
        NewLayout=[section(SectionId, NewSectionLabel, tooltip::tip(NewSectionTooltip), Icon, Blocks)||
            section(SectionId, Label, _TipText, Icon, Blocks) in RibbonControl:layout,
                NewSectionLabel=fe_Dictionary():getStringByKey(SectionId,Label),
                NewSectionTooltip=fe_Dictionary():getStringByKey(string::concat(SectionId,".tooltip"),Label),
                updateCommandLabels(RibbonControl,Blocks)],
        fe_AppWindow():ribbonControl_P:layout := NewLayout,
        setMenu().

predicates
    updateCommandLabels:(ribbonControl RibbonControl, block* Blocks).
clauses
    updateCommandLabels(RibbonControl,Blocks):-
        foreach Block in Blocks do
            if Block=block(Rows) then
                foreach Row in Rows do
                    foreach Item in Row do
                        if Item = cmd(CommandID,_Style) then
                             if RibbonControl:isShown() then
                                Commands=RibbonControl:getEffectiveCmdList(CommandId),
                                foreach Command in Commands do
                                    if MenuCommand=tryConvert(menuCommand,Command) then
                                        if MenuCommand:layout=menuCommand::menuStatic(MenuItemList) then
                                            foreach MenuItem in MenuItemList do
                                                if MenuItem=menuCommand::cmd(MenuCmd) then
                                                    MenuCmdID=MenuCmd:id,
                                                    updateCommandAttributes(MenuCmd,MenuCmdID,MenuCmd:menuLabel)
                                                end if
                                            end foreach
                                        end if
                                    end if,
                                    updateCommandAttributes(Command,CommandID,Command:ribbonLabel)
                                end foreach
                            end if
                        end if
                    end foreach
                end foreach
            end if
        end foreach.

predicates
    updateCommandAttributes:(command Command,string CommandID,string DefaultValue).
clauses
    updateCommandAttributes(Command,CommandID,DefaultValue):-
        CmdLabel=fe_Dictionary():getStringByKey(CommandID,DefaultValue),
        CmdTooltip=fe_Dictionary():getStringByKey(string::concat(CommandID,".tooltip"),DefaultValue),
        CmdMenuLabel=fe_Dictionary():getStringByKey(string::concat(CommandID,".menulabel"),DefaultValue),
        Command:ribbonLabel:=CmdLabel,
        Command:menuLabel:=CmdMenuLabel,
        if Command:tipTitle=toolTip::tip(_CmdTooltip) then
            Command:tipTitle:=toolTip::tip(CmdTooltip)
        end if.

facts
    lngwCmd_F:(string CommandId,command CommandObj).
clauses
    languageList_Menu()=Result:get():-
        Future=fe_CoreTasks():getUILanguageList(),
        Result=Future:map(
            {(EdfData)=MenuItemList:-
                if
                    EdfData=av("UILanguageList",a(LanguageIDTitle_List))
                then
                    MenuItemList=[menuCommand::cmd(Command)||
                    av(LanguageID,av(LanguageTitle,s(FlagId))) in LanguageIDTitle_List,
                        CommandID=string::concat("language",@"\","ribbon.menu.language.cmd.",LanguageID),
                        if lngwCmd_F(CommandId,Command),! then
                        else
                            Command=command::new(convert(window,fe_AppWindow()),CommandID),
                            assert(lngwCmd_F(CommandId,Command)),
                            Command:run:=defaultHandler,
                            Command:icon:=some(icon::createFromFile(string::format(@"$$(Project.Name)AppData\pdcVipIcons\flags\flag-%.ico",FlagId)))
                        end if,
                        Command:ribbonLabel:=fe_Dictionary():getStringByKey(LanguageTitle,LanguageTitle),
                        Command:tipTitle:=toolTip::tip(fe_Dictionary():getStringByKey(string::concat(CommandID,".tooltip"),LanguageTitle)),
                        Command:menuLabel:=fe_Dictionary():getStringByKey(string::concat(CommandID,".menulabel"),LanguageTitle)
                    ]
            else
                exception::raise_User("Invalid Language List data")
            end if
            }).

predicates
    defaultHandler:(command RibbonCommand).
    defaultHandler:(string CommandID,string NameSpace,string RibbonCommand) multi.
clauses
    defaultHandler(RibbonCommand):-
        string::frontToken(RibbonCommand:id,NameSpace,CommandIDWithSlash),
        string::frontChar(CommandIDWithSlash,_,CommandID),
        defaultHandler(CommandID,NameSpace,RibbonCommand:id),
        !.
    defaultHandler(_RibbonCommand).

    defaultHandler("ribbon.cmd.design-ribbon",_NameSpace,_RibbonCommand):-
            designRibbonLayout().
    defaultHandler("ribbon.cmd.restore-ribbon-layout",_NameSpace,_RibbonCommand):-
        reloadRibbon().
    defaultHandler("ribbon.cmd.help",NameSpace,_RibbonCommand):-
            fe_Tasks():help(NameSpace).
    defaultHandler("ribbon.cmd.options",_NameSpace,_RibbonCmdID):-
        fe_CoreTasks():editOptions().
    defaultHandler("ribbon.cmd.about",NameSpace,_RibbonCmdID):-fe_Tasks():about(NameSpace).
    defaultHandler(CommandID,_NameSpace,_RibbonCmdID):-
        string::hasPrefixIgnoreCase(CommandID,"ribbon.menu.language.cmd.",Language),
        fe_CoreTasks():setNewLanguage(Language),
    % change here text titles for active user-defined elements of the UI
        succeed().
    defaultHandler(RibbonCommand,_NameSpace,_RibbonCmdID):-
        stdio::write(RibbonCommand,"\n"),
        succeed().

predicates
    tryBackEndAvailable:() determ.
clauses
    tryBackEndAvailable():-
        fe_CoreTasks():backEndAlive_P=true,
        !.
    tryBackEndAvailable():-
        vpiCommonDialogs::note("BackEnd is not active. No operaion available"),
        fail.

%predicates
%    getRibbonCommands_nd:()->tuple{command,control}*.
%clauses
%    getRibbonCommands_nd()=CustomControls:-
%        RibbonControl=convert(fe_MainWindow,mainWindow_V):ribbonControl_P,
%        CustomControls=[tuple(Command,Control)||
%            section(_SectionId, _Label, _TipText, _Icon, Blocks) in RibbonControl:layout,
%                Block in Blocks,
%                    Block=block(Rows),
%                        Row in Rows,
%                            Item in Row,
%                                Item = cmd(CommandID,_Style),
%                                    Commands=RibbonControl:getEffectiveCmdList(CommandId),
%                                    Command in Commands,
%                                        _CustomCommand=tryConvert(customCommand,Command),
%                                        Control=RibbonControl:tryGetCustomControl(Command:id)
%            ].

predicates
    setCommonPerformers:(cmdPerformers ContextObj).
clauses
    setCommonPerformers(ContextObj):-
            ContextObj:dictionary_P:=fe_Dictionary(),
            ContextObj:setRunner("default",defaultHandler),
            ContextObj:setRunner("test",fe_Tests():runTest),
            ContextObj:setRunner("add-extension",fe_CoreTasks():addExtension),
            ContextObj:setRunner("sleeping",fe_CoreTasks():runHiddenPerformer),
            ContextObj:setRunner("pzl-extention",fe_CoreTasks():runPlugin),
            ContextObj:setCustomFactory("test-factory",fe_Tests():controlFactory),
            ContextObj:setMenuRender("language-list",languageList_Menu),
            ContextObj:noIconRender_P:=noIconRender,
            ContextObj:setIconByIDRender("default",fe_CoreTasks():getIconByID),
            if fe_Dictionary():useDictionary_P=useDictionaryYes_C then
                ContextObj:useDictionary_P:=true
            else
                ContextObj:useDictionary_P:=false
            end if.

predicates
    noIconRender:()->binary IconBitmap.
clauses
    noIconRender()=file::readBinary(@".\$$(Project.Name)AppData\pdcVipIcons\status\image-missing.ico").

clauses
    designRibbonLayout():-
        MainWindow=fe_AppWindow(),
        DesignerDlg = ribbonDesignerDlg::new(convert(window,MainWindow)),
        DesignerDlg:cmdHost := convert(window,MainWindow),
        DesignerDlg:designLayout := MainWindow:ribbonControl_P:layout,
        DesignerDlg:predefinedSections := MainWindow:ribbonControl_P:layout,
        DesignerDlg:show(),
        if DesignerDlg:isOk() then
            NewLayout=DesignerDlg:designLayout,
            MainWindow:ribbonControl_P:layout := NewLayout,
            setMenu(),
            fe_CoreTasks():saveFrontendParameters(a([av(lastRibbonLayout_C,s(toString(NewLayout)))]))
        end if.

predicates
    createRibbon:(layout InitialLayout,cmdPerformers ContextObj)-> tuple{layout IntegratedLayout,gmtTimeValue NewLayoutTime}.
clauses
    createRibbon(Layout,ContextObj)=tuple(list::appendList([Layout|LayoutList]),ModifiedTime):-
        Future=fe_CoreTasks():getRibbonStartUpScripts_async(),
        Future:map(
            {(Data)=tuple(LayoutList,ModifiedTime):-
                if Data=av("ribbon-binscript-list",a(ScriptsEdf)),
                    av("scripts",a(ScriptBinList)) in ScriptsEdf,
                    av("lastchanged",tg(ModifiedTime)) in ScriptsEdf,
                    !
                then
                    LayoutList=[SubLayout||b(XmlBinaryData) in ScriptBinList,
                        try
                            RibbonLoader=ribbonLoader::new(mainWindow_V),
                            RibbonLoader:loadXmlData(XmlBinaryData),
                            SubLayout=RibbonLoader:getLayout(ContextObj),
                            succeed
                        catch TraceID do
                            tuple(ShortInfo,DetailedInfo)=exceptionHandlingSupport::new():getExceptionInfo(TraceID),
                            log::write(log::error,ShortInfo),
                            stdio::write(ShortInfo,"\n"),
                            exception::continue_User(TraceID,string::concat("Can not load valid RibbonScript.\t",ShortInfo,"\n",DetailedInfo))
                        end try
                    ]
                elseif Data=av("be_error",a([s(Short),s(Detailed)])) then
                    log::write(log::error,Short),
                    exception::raise_User(string::concat("Can not read valid RibbonScript.\t",Short,"\n",Detailed))
                else
                    exception::raise_User("Unexpected Alternative")
                end if
            }
            ):
            get()=tuple(LayoutList,ModifiedTime).

clauses
    expandRibbon(XmlBinaryData):-
        MainWindow=fe_AppWindow(),
        ContextObj=cmdPerformers::new(),
        setCommonPerformers(ContextObj),
        RibbonLoader=ribbonLoader::new(mainWindow_V),
        RibbonLoader:loadXmlData(XmlBinaryData),
        SubLayout=RibbonLoader:getLayout(ContextObj),
        RibbonControl=MainWindow:ribbonControl_P,
        RibbonControl:layout := list::appendList([RibbonControl:layout,SubLayout]),
        setMenu().

clauses
    reloadRibbon():-
        if tryBackEndAvailable() then
            foreach
                Command=mainWindow_V:getCommand_nd() do
                if
                    _CustomCommand=tryConvert(customCommand,Command),
                    Control=convert(fe_MainWindow,mainWindow_V):ribbonControl_P:tryGetCustomControl(Command:id)
                then
                    Control:destroy()
                end if,
                mainWindow_V:removeCommand(Command)
            end foreach,
            initRibbon(true),
            setMenu()
        end if.

clauses
    tryExtractCommandId(Command)=CommandID:-
        string::frontToken(Command:id,_NameSpace,ItemIDWithSlash),
        string::frontChar(ItemIDWithSlash,FrontChar,CommandID),
        FrontChar='\\'.

clauses
    tryExtractCommandSuffix(Command,Prefix)=CommandSuffix:-
        tryExtractCommandId(Command)=CommandID,
        string::hasPrefixIgnoreCase(CommandID,Prefix,CommandSuffix).

/*Predicates mkMenu(...) and below are borrowed from
PDC's Visual Prolog example ribbonMdiDemo related to ribbon*/
facts
    menuMap_V:map{menuTag MenuTag, command Cmd}:=erroneous.
clauses
    setMenu():-
        frontEnd_P:useMenu_P=useMenuNo_C,! or
        isComponent(),
        !.
    setMenu():-
        Layout=fe_AppWindow():ribbonControl_P:layout,
        convert(documentWindow,mainWindow_V):menuSet(dynMenu(mkMenu(Layout))),
        menuMap_V:=mkMenuMap(Layout),
        succeed().

predicates
    isComponent:() determ.
clauses
    isComponent():-
        ContainerFileName=pzl::getContainerName(),
        "pzl"=string::toLowerCase(filename::getExtension(ContainerFileName)).

predicates
    menuListener:window::menuItemListener.
clauses
    menuListener(_Window,_MenuTag):-
        isErroneous(menuMap_V),
        !.
    menuListener(_Window,MenuTag):-
        if Cmd = menuMap_V:tryGet(MenuTag) then
            Cmd:run(Cmd)
        end if.

predicates
    mkMenu : (layout Layout) -> menuItem* Menu.
clauses
    mkMenu(Layout) = [ SectionMenu|| S in Layout, try SectionMenu=mkMenu_section(MenuTagVar, S) catch _ do fail end try ] :-
        MenuTagVar = varM_integer::new(1).

predicates
    mkMenu_section : (varM_integer MenuTagVar, section Section) -> menuItem SectionMenu.
clauses
    mkMenu_section(MenuTagVar, section(_Id, Label, _TipText, _IconOpt, BlockList)) =
        vpiDomains::txt(MenuTagVar:inc(), Label, vpiDomains::noAccelerator, b_true, vpiDomains::mis_none,
            [ M || M = getMenu_nd_blockList(BlockList) ]).

predicates
    getMenu_nd_blockList : (block* BlockList) -> menuItem MenuItem nondeterm.
clauses
    getMenu_nd_blockList(BlockList) = MenuItem :-
        Block in BlockList,
        (
            Block=ribbonControl::separator and MenuItem = vpiDomains::separator
            or
            Block=block(Rows) and Row in Rows and Item in Row,
            (Item=ribbonControl::separator and MenuItem = vpiDomains::separator or Item=cmd(CmdId, _),
            Cmd=extractCmd_nd(CmdId),
            MenuItem = vpiDomains::txt(Cmd:menuTag, formatMenuLabel(Cmd), Cmd:acceleratorKey, b_true, vpiDomains::mis_none, []))
        ).

predicates
    extractCmd_nd:(string CmdId)->command Cmd nondeterm.
clauses
    extractCmd_nd(CmdId)=Cmd:-
        ItemCmd = convert(window,fe_AppWindow()):tryLookupCommand(CmdId),
        if MenuCommand=tryConvert(menuCommand,ItemCmd) then
            if MenuCommand:layout=menuCommand::menuStatic(MenuItemList), not(MenuItemList=[]) then
                menuCommand::cmd(Cmd) in MenuItemList
            elseif MenuCommand:layout=menuCommand::menuRender(Func) then
                MenuItemList=Func(),
                menuCommand::cmd(Cmd) in MenuItemList
            else
                exception::raise_User("")
            end if
        else
            Cmd=ItemCmd
        end if.

predicates
    formatMenuLabel : (command Cmd) -> string MenuLabel.
clauses
    formatMenuLabel(Cmd) = Label :-
        AccKeyStr = command::formatAcceleratorKey(Cmd:acceleratorKey),
        Suffix = if AccKeyStr <> "" then string::concat("\t", AccKeyStr) else "" end if,
        MenuLabel=fe_Dictionary():getStringByKey(Cmd:id,Cmd:menuLabel),
        Label = string::concat(MenuLabel, Suffix).

predicates
    mkMenuMap : (layout Layout) -> map{menuTag MenuTag, command Cmd}.
clauses
    mkMenuMap(Layout) = Map :-
        Map = mapM_redBlack::new(),
        foreach
            section(_Id, _Label, _TipText, _IconOpt, BlockList) in Layout
            and block(Rows) in BlockList and Row in Rows and cmd(CmdId, _) in Row,
            try Cmd=extractCmd_nd(CmdId) catch _ do fail end try,
            succeed()
        do
            Map:set(Cmd:menuTag, Cmd)
        end foreach.

end implement fe_Command