%

implement ribbonLoader
    open core, xmlNavigate, ribbonControl, pfc\log

facts
    xmlData_V : xmlDocument.
    host_V:window:=erroneous.

facts % properties
    xmlDataFile_P:string:=erroneous.

constants
    cmdAttributeNames_C:string*=[label_C,run_C,cmdstyle_C,menu_label_C,enabled_C,visible_C,changeEvent_C,category_C,badge_C].
    customAttributeNames_C:string*=[factory_C,width_C,height_C].
    menuAttributeNames_C:string*=[style_C,layout_C,label_C,enabled_C,cmdstyle_C].

predicates
    defaultRunner : (command).
clauses
    defaultRunner(_Command).

predicates
    defaultCustomFactory : ()->control.
clauses
    defaultCustomFactory()=TextCtl:-TextCtl=editControl::new(),TextCtl:setText("NoControl!").

predicates
    defaultStateHandler : (command).
clauses
    defaultStateHandler(_Command).

predicates
    defaultTooltipRender : ()->string TootipText.
clauses
    defaultTooltipRender()="Default Tooltip Text".

constants
    noNameBitMap_C:binary=#bininclude(@"appData\Res\NoName.bmp").
predicates
    defaultMenuRender : ()->menuCommand::menuItem* MenuItemList.
clauses
    defaultMenuRender()=MenuItemList:-
        Command = command::new(host_V,"Undefined!"),
        Command:ribbonLabel:="Undefined!",
        Command:tipTitle:=toolTip::tip("Undefined!"),
        Command:icon:=some(icon::createFromImages([bitmap::createFromBinary(noNameBitMap_C)])),
        MenuItemList=[menuCommand::cmd(Command)].

facts
    baseDir_F:(string BaseDirID,string BaseDirPath).

clauses
    new(Host):-
        host_V:=Host,
        xmlData_V := xmlDocument::new(ribbon_layout_C),
        xmlData_V:codePage_P:=utf8,
        xmlData_V:indent_P:=true,
        xmlData_V:xmlStandalone_P:=xmlLite::yes.

clauses
    tryLoadXmlDataFile():-
        if not(isErroneous(xmlDataFile_P)),
            file::existExactFile(xmlDataFile_P)
        then
            XmlData = inputStream_file::openFile(xmlDataFile_P, stream::binary),
            spbXmlLigntSupport::read(XmlData, xmlData_V),
            XmlData:close()
        else
            log::write(log::info,"Ribbon-xmlScript file not found or it is not set"),
            fail
        end if.

clauses
    loadXmlData(Binary):-
            BinStream=inputStream_binary::new(Binary),
            spbXmlLigntSupport::read(BinStream, xmlData_V),
            BinStream:close().

clauses
    getLayout(ContextObj)=Layout:-
        if Root = xmlData_V:getNode_nd([root()]),! then
            checkFormatAndVersion(Root)
        else
            exception::raise_User("Unexpected alternative")
        end if,
        foreach  BaseDirNode = xmlData_V:getNode_nd([root(),child(basedir_C, {(_)})]) do
            if
                DirID=BaseDirNode:attribute(id_C),
                xmlElement::text(DirPath)=BaseDirNode:tryGetItem(xmlElement::text, 1)
            then
                assert(baseDir_F(DirID,DirPath)),
                log::writef(log::info,"declared baseDir [%] as [%]",DirPath,DirID)
            else
                NoBaseDirIDMessage="The baseDir must have BaseDirID and the Path",
                log::write(log::error,NoBaseDirIDMessage),
                exception::raise_User(NoBaseDirIDMessage)
            end if
        end foreach,
        if
            DictionaryNode = xmlData_V:getNode_nd([root(),child(dictionary_C, {(_)})]),!,
            NameSpace=DictionaryNode:attribute(namespace_C),
            DictionaryFile=DictionaryNode:attribute(file_C),
            DictionaryFileFullName=tryMakeRealFileName(DictionaryFile) %TODO make different reactions
        then
            ContextObj:dictionary_P:initDictionary(NameSpace,DictionaryFileFullName)
        else
            NoNameSpaceDefined="No NameSpace defined",
            log::write(log::info,NoNameSpaceDefined),
            NameSpace=noNameSpace_C
        end if,
        Layout=
            [
                section(SectID,SectLabel,SectionObj:tooltip_P,SectionObj:icon_P,SectionObj:blockList_P)||
                SectionNode = xmlData_V:getNode_nd([root(),child(section_C, {(_)})]),
                if
                    SectID=string::concat(NameSpace,@"\",SectionNode:attribute(id_C)),
                    if DefaultSectLabel=SectionNode:attribute(label_C) then
                    else DefaultSectLabel=undefined_C
                    end if,
                    SectLabel=defineLabel(ContextObj,DefaultSectLabel,SectID)
                then
                    SectionObj=sectionTmp::new(),
                    SectionObj:id_P:=SectID,
                    foreach
                        SubSection=SectionNode:getNode_nd([self({(_)}),child("*", {(_)})]),
                        tryHandleSubSection(ContextObj,NameSpace,SubSection:name_P,SectionObj,SubSection)
                    do
                    end foreach
                else
                    NoIdMessage="The Section has no ID or Label",
                    log::write(log::error,NoIdMessage),
                    exception::raise_User(NoIdMessage)
                end if
            ],
        if Layout=[] then
                NoSectionMessage="The xmlRibbonScript has no Sections. Must have at least one",
                log::write(log::error,NoSectionMessage),
                exception::raise_User(NoSectionMessage)
        end if.

predicates
    checkFormatAndVersion:(xmlElement RootNode).
clauses
    checkFormatAndVersion(Root):-
        if not(Root:name_P=ribbon_layout_C) then
            Message="The xmlRibbonScript\'s Root must have the name \"ribbon-layout\"",
            log::write(log::error,Message),
            exception::raise_User(Message)
        else
            fail
        end if.
    checkFormatAndVersion(Root):-
        if Root:attribute(version_C)=XmlScriptVersion
        then
            if XmlScriptVersion=xmlRibbonScriptVersion_C
            then
            else
                Message=string::format("The xmlRibbonScript version [%] is invalid.\n Must correspond to [%]",XmlScriptVersion, xmlRibbonScriptVersion_C),
                log::write(log::error,Message),
                exception::raise_User(Message)
            end if
        else
            Message="The xmlRibbonScript version must be declared as the root attribute \"version\"",
            log::write(log::error,Message),
            exception::raise_User(Message)
        end if.

predicates
    tryHandleSubSection:(cmdPerformers ContextObj,string NameSpace,string NodeName,sectionTmp SectionObj,xmlElement SectionNode) determ.
clauses
    tryHandleSubSection(ContextObj,_NameSpace,icon_C,SectionObj,IconNode):-
        SectionObj:icon_P:=getIcon(ContextObj,IconNode).
    tryHandleSubSection(ContextObj,NameSpace,tooltip_C,SectionObj,ToolTipNode):-
        SectionObj:tooltip_P:=getTooltip(ContextObj,NameSpace,string::concat(SectionObj:id_P,".tooltip"),ToolTipNode).
    tryHandleSubSection(ContextObj,NameSpace,block_C,SectionObj,BlockNode):-
        BlockObj=blockTmp::new(),
        foreach
            SubBlock=BlockNode:getNode_nd([self({(_)}),child("*", {(_)})]),
                tryHandleSubBlock(ContextObj,NameSpace,SubBlock:name_P,BlockObj,SubBlock)
        do
        end foreach,
        SectionObj:addBlock(BlockObj).

predicates
    tryHandleSubBlock:(cmdPerformers ContextObj,string NameSpace,string SubBlockName,blockTmp BlockObj,xmlElement SubBlock) determ.
clauses
    tryHandleSubBlock(_ContextObj,_NameSpace,separator_C,BlockObj,_SubBlock):-
        BlockObj:block_P:=separator.
    tryHandleSubBlock(ContextObj,NameSpace,row_C,BlockObj,RowNode):-
        RowObj=rowTmp::new(),
        foreach
            ItemNode=RowNode:getNode_nd([self({(_)}),child("*", {(_)})]),
                ItemObj=itemTmp::new(),
                tryHandleItem(ContextObj,NameSpace,ItemNode:name_P,ItemObj,ItemNode)
        do
            RowObj:addItem(ItemObj)
        end foreach,
        BlockObj:addRow(RowObj).

predicates
    tryHandleItem:(cmdPerformers ContextObj,string NameSpace,string ItemName,itemTmp ItemObj,xmlElement ItemNode) determ.
clauses
    tryHandleItem(_ContextObj,_NameSpace,separator_C,ItemObj,_ItemNode):-
        !,
        if ItemObj:item_P=itemTmp::undefined then
            ItemObj:item_P:=itemTmp::separator
        elseif
            ItemObj:item_P=itemTmp::menuCommand(MenuCommand),
            MenuCommand:layout=menuCommand::menuStatic(MenuItemList)
            then
                NewMenuItemList=list::append(MenuItemList,[menuCommand::separator]),
                MenuCommand:layout:=menuCommand::menuStatic(NewMenuItemList)
        end if.
    tryHandleItem(ContextObj,NameSpace,Item,ItemObj,CmdNode):-
        (Item=cmd_C or Item=custom_C),!,
        if CmdIDsrc=CmdNode:attribute(id_C) then
            CmdID=string::concat(NameSpace,@"\",CmdIDsrc)
        else
            exception::raise_User("Command Node must have ID")
        end if,
        if Item=cmd_C then
            Command=command::new(host_V,CmdID)
        else
            Command=customCommand::new(host_V,CmdID)
        end if,
        setCmdFeatures(Command,ContextObj,NameSpace,Item,ItemObj,CmdNode).
    tryHandleItem(ContextObj,NameSpace,menu_C,ItemObj,MenuNode):-
        if MenuID=MenuNode:attribute(id_C) then
            MenuCommand=menuCommand::new(host_V,string::concat(NameSpace,@"\",MenuID))
        else
            exception::raise_User("MenuCommand Node must have ID")
        end if,
        ItemObj:item_P:=itemTmp::menucommand(MenuCommand),
        foreach AttributeName in menuAttributeNames_C do
            if AttributeValue=MenuNode:attribute(AttributeName) then
                if  AttributeName=style_C then
                    if AttributeValue=popupmenu_C then Style=menuCommand::popupMenu
                    elseif AttributeValue=variantmenu_C then Style=menuCommand::variantMenu
                    elseif AttributeValue=toolmenu_C then Style=menuCommand::toolMenu
                    else
                        log::writef(log::info,@"Wrong name of the Style for MenuCommand=[%]. Set [toolMenu]",MenuCommand:id),
                        Style=menuCommand::toolMenu
                    end if,
                    MenuCommand:style:=Style
                elseif AttributeName=cmdstyle_C then
                    ItemObj:itemStyle_P:=getCmdStyle(string::toLowerCase(AttributeValue))
                elseif AttributeName=label_C then
                    MenuLabel=defineLabel(ContextObj,AttributeValue,MenuCommand:id),
                    MenuCommand:menuLabel:=MenuLabel
                elseif AttributeName=enabled_C then
                    MenuCommand:enabled:=booleanStr2Boolean(string::toLowerCase(AttributeValue))
                elseif AttributeName=layout_C then
                    if AttributeValue = render_C then
                        if
                            FunctionName=MenuNode:attribute(function_C),
                            MenuCommand:layout:=menuCommand::menuRender(ContextObj:tryGetMenuRender(FunctionName))
                        then
                        else
                            MenuCommand:layout:=menuCommand::menuRender(defaultMenuRender)
                        end if
                    elseif AttributeValue = static_C then
                        foreach
                            MenuSubNode=MenuNode:getNode_nd([self({(_)}),child("*", {(_)})]),
                            tryHandleItem(ContextObj,NameSpace,MenuSubNode:name_P,ItemObj,MenuSubNode)
                        do
                            succeed()
                        end foreach
                    else
                        WrongLayoutMessage=string::format("The wrong menuLayout value [%]",AttributeName),
                        log::write(log::error,WrongLayoutMessage),
                        exception::raise_User(WrongLayoutMessage)
                    end if
                else
                    log::writef(log::error,@"Unexpected attribute ID [%]",AttributeName),
                    exception::raise_User(string::format("Unexpected attribute ID [%]",AttributeName))
                end if
            end if
        end foreach,
        foreach
            MenuSubNode=MenuNode:getNode_nd([self({(_)}),child("*", {(_)})]),
            tryHandleSubNode(ContextObj,NameSpace,MenuSubNode:name_P,MenuCommand,MenuSubNode)
        do
        end foreach.

predicates
    setCmdFeatures:(object CommandObj,cmdPerformers ContextObj,string NameSpace,string Item,itemTmp ItemObj,xmlElement CmdNode).
clauses
    setCmdFeatures(CommandObj,ContextObj,NameSpace,Item,ItemObj,CmdNode):-
        if Item=custom_C then
            AttributeList=list::append(cmdAttributeNames_C,customAttributeNames_C)
        elseif Item=cmd_C then
            AttributeList=cmdAttributeNames_C
        else
            exception::raise_User("Unknown!")
        end if,
        Command=convert(command,CommandObj),
        if ItemObj:item_P=itemTmp::undefined then
            if Item=cmd_C then
                ItemObj:item_P:=itemTmp::command(Command)
            elseif Item=custom_C then
                ItemObj:item_P:=itemTmp::customCommand(convert(customCommand,CommandObj))
            else
                exception::raise_User("Unknown!")
            end if
        elseif
            ItemObj:item_P=itemTmp::menuCommand(MenuCommand),
            MenuCommand:layout=menuCommand::menuStatic(MenuItemList)
        then
                NewMenuItemList=list::append(MenuItemList,[menuCommand::cmd(Command)]),
                MenuCommand:layout:=menuCommand::menuStatic(NewMenuItemList)
        end if,
        foreach
            AttributeName in AttributeList,
            AttributeValue=CmdNode:attribute(AttributeName)
        do
            if  AttributeName=label_C then
                Command:ribbonLabel:=defineLabel(ContextObj,AttributeValue,Command:id)
            elseif AttributeName=run_C then
                if
                    Command:run:=ContextObj:tryGetRunner(AttributeValue)
                then
                else
                    Command:run:=defaultRunner
                end if
            elseif AttributeName=menu_label_C then
                Command:menulabel:=defineLabel(ContextObj,AttributeValue,string::concat(Command:id,".menulabel"))
            elseif AttributeName=cmdstyle_C then
                ItemObj:itemStyle_P:=getCmdStyle(AttributeValue)
            elseif AttributeName=enabled_C then
                Command:enabled:=booleanStr2Boolean(string::toLowerCase(AttributeValue))
            elseif AttributeName=visible_C then
                Command:visible:=booleanStr2Boolean(string::toLowerCase(AttributeValue))
            elseif AttributeName=changeEvent_C then
                if true=booleanStr2Boolean(string::toLowerCase(AttributeValue)) then
                    if
                        Command:stateChangeEvent:addListener(ContextObj:tryGetChangeStateHandler(AttributeValue))
                    then
                    else
                        Command:stateChangeEvent:addListener(defaultStateHandler)
                    end if
                end if
            elseif AttributeName=category_C then
                Command:category:=string::split(AttributeValue,",")
            elseif AttributeName=badge_C then
                Command:badge:=toTerm(AttributeValue)
            elseif
                AttributeName=width_C,
                tryConvert(customCommand,CommandObj):width:=toTerm(AttributeValue)
            then
            elseif
                AttributeName=height_C,
                tryConvert(customCommand,CommandObj):height:=toTerm(AttributeValue)
            then
            elseif
                AttributeName=factory_C,
                if
                    CustomFactoryFunction=ContextObj:tryGetCustomFactory(AttributeValue) ,
                    ControlType=CmdNode:attribute(control_type_C)
                then
                    try
                        if tryConvert(customCommand,CommandObj):factory:=CustomFactoryFunction(ControlType) then
                        end if
                    catch _TraceID do
                        log::writef(log::error,@"No Control Defined Properly: factoryName=[%], controlType=[%]",AttributeValue,ControlType)
                    end try
               else
                    if tryConvert(customCommand,CommandObj):factory:=defaultCustomFactory then end if
               end if
            then
            else
                log::writef(log::error,@"Unexpected attribute ID [%]",AttributeName),
                exception::raise_User(string::format("Unexpected attribute ID [%]",AttributeName))
            end if
        end foreach,
        foreach
            CmdSubNode=CmdNode:getNode_nd([self({(_)}),child("*", {(_)})]),
            tryHandleSubNode(ContextObj,NameSpace,CmdSubNode:name_P,Command,CmdSubNode)
        do
        end foreach.

predicates
    tryHandleSubNode:(cmdPerformers ContextObj,string NameSpace,string CmdSubNodeName,command Command,xmlElement CmdNode) determ.
clauses
    tryHandleSubNode(ContextObj,_NameSpace,icon_C,Command,IconNode):-
        Command:icon:=getIcon(ContextObj,IconNode),
        !.
    tryHandleSubNode(ContextObj,NameSpace,tooltip_C,Command,ToolTipNode):-
        !,
        Command:tipTitle:=getTooltip(ContextObj,NameSpace,string::concat(Command:id,".tooltip"),ToolTipNode).
    tryHandleSubNode(_ContextObj,_NameSpace,acceleratorkey_C,Command,AcceleratorKeyNode):-
        !,
        if KeyCode=AcceleratorKeyNode:attribute(keycode_C), KeyCodeInt=toTerm(KeyCode) then
            if KeyModifier=AcceleratorKeyNode:attribute(keymodifier_C) then
                KeyModifierLow=string::toLowerCase(KeyModifier),
                if KeyModifierLow=nothing_C then Modifier=vpiDomains::c_nothing
                elseif KeyModifierLow=shift_C then  Modifier=vpiDomains::c_shift
                elseif KeyModifierLow=control_C then  Modifier=vpiDomains::c_control
                elseif KeyModifierLow=alt_C then  Modifier=vpiDomains::c_alt
                elseif KeyModifierLow=shiftctl_C then  Modifier=vpiDomains::c_shiftCtl
                elseif KeyModifierLow=shiftalt_C then  Modifier=vpiDomains::c_shiftAlt
                elseif KeyModifierLow=ctlalt_C then  Modifier=vpiDomains::c_ctlAlt
                elseif KeyModifierLow=shiftctlalt_C then  Modifier=vpiDomains::c_shiftCtlAlt
                else
                    log::writef(log::info,"Wrong name of the KeyModifier for command=[%]. Set [Nothing]",Command:id),
                    Modifier=vpiDomains::c_nothing
                end if,
                Command:acceleratorKey:=vpiDomains::key(KeyCodeInt,Modifier)
            else
                Command:acceleratorKey:=vpiDomains::key(KeyCodeInt, vpiDomains::c_nothing)
            end if
        else
            Command:acceleratorKey:=vpiDomains::noAccelerator
        end if.

predicates
    getIcon:(cmdPerformers ContextObj,xmlElement IconNode)->optional{icon}.
clauses
    getIcon(ContextObj,IconNode)=Icon:-
        if FileName=IconNode:attribute(file_C) then
            if FullFileName=tryMakeRealFileName(FileName) then
                Icon=some(icon::createFromFile(FullFileName))
            else
                IconBmp=ContextObj:noIconRender_P(),
                Icon=some(icon::createFromImages([bitmap::createFromBinary(IconBmp)]))
            end if
        elseif BinaryData=IconNode:attribute(binary_C) then
            Icon=some(icon::createFromImages([bitmap::createFromBinary(toBinary(BinaryData))]))
        elseif IconID=IconNode:attribute(iconID_C) then
            if HandlerName=IconNode:attribute(functionID_C) then else HandlerName=default_C end if,
            if IconByIdFunction=ContextObj:tryGetIconByIDRender(HandlerName) then
                IconBmp=IconByIdFunction(IconID),
                log::writef(log::info,"icon bitmap by ID=[%] requested and resolved",IconID)
            else
                IconBmp=ContextObj:noIconRender_P()
            end if,
            Icon=some(icon::createFromImages([bitmap::createFromBinary(IconBmp)]))
        else
            Icon=some(icon::createFromImages([bitmap::createFromBinary(noNameBitMap_C)])),
            log::writef(log::info,"Wrong icon node [%] attribute",IconNode:name_P)
        end if.

predicates
    getTooltip:(cmdPerformers ContextObj,string NameSpace,string EntityID,xmlElement TooltipNode)->tooltip::tipText.
clauses
    getTooltip(ContextObj,_NameSpace,EntityID,TooltipNode)=Tooltip:-
        if TooltipText=ToolTipNode:attribute(text_C) then
            Label=defineLabel(ContextObj,TooltipText,EntityID),
            Tooltip=tooltip::tip(Label)
        elseif FunctionName=ToolTipNode:attribute(render_C) then
            if
                Tooltip=tooltip::tipRender(ContextObj:tryGetTooltipRender(FunctionName))
            then
            else
                Tooltip=tooltip::tipRender(defaultTooltipRender)
            end if
        else
            Tooltip=tooltip::notip
        end if.

predicates
    defineLabel:(cmdPerformers ContextObj,string DefaultLabel,string StringId)->string ActualLabel.
clauses
    defineLabel(ContextObj,DefaultLabel,ItemID)=ActualLabel:-
        ContextObj:useDictionary_P=true,
        ActualLabel=ContextObj:dictionary_P:getStringByKey(ItemId,DefaultLabel),
        not(ActualLabel=undefined_C),
        !.
    defineLabel(_ContextObj,DefaultLabel,_StringID)=DefaultLabel.

class predicates
    getCmdStyle:(string CmdStyleAsString)->ribbonControl::cmdStyle.
clauses
    getCmdStyle(imageOnly_C)=ribbonControl::imageOnly:-!.
    getCmdStyle(textOnly_C)=ribbonControl::textOnly:-!.
    getCmdStyle(imageAndTextVertical_C)=ribbonControl::imageAndText(vertical):-!.
    getCmdStyle(imageAndTextHorizontal_C)=ribbonControl::imageAndText(horizontal):-!.
    getCmdStyle(Style)=_:-
        Message=string::format("Wrong cmdStyle string representation [%]",Style),
        log::write(log::error,Message),
        exception::raise_User(Message).

class predicates
    booleanStr2Boolean:(string TrueOrFalse)->boolean BooleanValue.
clauses
    booleanStr2Boolean("true")=true:-!.
    booleanStr2Boolean("false")=false:-!.
    booleanStr2Boolean(Any)=_:-
        Message=string::format("Wrong boolean string representation [%]",Any),
        log::write(log::error,Message),
        exception::raise_User(Message).

predicates
    tryMakeRealFileName:(string FileNamePartlePathed)->string RelativePathedFileName determ.
clauses
    tryMakeRealFileName(FileName)=ResultFileName:-
        if %check if filename format has the form $(BaseDir)\FileNameWithExt
            string::hasPrefix(FileName,"$(",Rest),
            [PathName,SourceFileName|_]=string::split(Rest,")")
        then
            if baseDir_F(PathName,BaseDir),! then
                filename::getPathAndName(SourceFileName,Path,_Name),
                if Path=@"\" or Path=""  then
                    Dir=BaseDir
                else
                    Dir=string::concat(BaseDir,Path)
                end if,
                ResultFileName=filename::setPath(SourceFileName,Dir)
            else
                Message=string::format("No BaseDir [%] found for the file [%]",PathName,SourceFileName),
                log::write(log::error,Message),
                exception::raise_User(Message)
            end if
        else
            ResultFileName=FileName
        end if,
        file::existExactFile(ResultFileName).

end implement ribbonLoader

/*Item Obj*/
class itemTmp:itemTmp
end class
interface itemTmp
    open core
domains
    item_D=
        undefined;
        separator;
        command(command);
        customCommand(customCommand);
        menucommand(menucommand).
properties
    item_P:item_D.
    itemStyle_P:ribbonControl::cmdStyle.
end interface itemTmp
implement itemTmp
    open core
facts
    item_P:item_D:=undefined.
    itemStyle_P:ribbonControl::cmdStyle:=ribbonControl::textOnly.
end implement itemTmp

/*Row Obj*/
class rowTmp:rowTmp
end class
interface rowTmp
    open core
properties
    itemList_P:ribbonControl::item*.
predicates
    addItem:(itemTmp).
end interface rowTmp
implement rowTmp
    open core,ribbonControl,pfc\log
facts
    itemList_P:ribbonControl::item*:=[].
clauses
    addItem(ItemObj):-
        if ItemObj:item_P=itemTmp::command(Command) then
            Item=cmd(Command:id,ItemObj:itemStyle_P)
        elseif ItemObj:item_P=itemTmp::customCommand(CustomCommand) then
            Item=cmd(CustomCommand:id,ItemObj:itemStyle_P)
        elseif ItemObj:item_P=itemTmp::menuCommand(MenuCommand) then
            Item=cmd(MenuCommand:id,ItemObj:itemStyle_P)
        elseif ItemObj:item_P=itemTmp::separator then
            Item=separator
        else
            Msg=string::format("Unexpected Alternative in ItemObj [%]",ItemObj:item_P),
            log::write(log::error,Msg),
            exception::raise_User(Msg)
        end if,
        itemList_P:=list::append(itemList_P,[Item]).
end implement rowTmp

/*Block Obj*/
class blockTmp:blockTmp
end class
interface blockTmp
    open core,ribbonControl
properties
    block_P:block.
predicates
    addRow:(rowTmp RowObj).
end interface blockTmp
implement blockTmp
    open core,ribbonControl
facts
    block_P:block:=block([]).
clauses
    addRow(RowObj):-
        block_P=block(RowList),
        !,
        block_P:=block(list::append(RowList,[RowObj:itemList_P])).
    addRow(_RowObj).
end implement blockTmp

/*Section Obj*/
class sectionTmp:sectionTmp
end class
interface sectionTmp
    open core,ribbonControl
properties
    id_P:string.
    label_P:string.
    tooltip_P:tooltip::tipText.
    icon_P:optional{::icon Icon}.
    blockList_P:block*.
predicates
    addBlock:(blockTmp).
end interface sectionTmp
implement sectionTmp
    open core,ribbonControl
facts
    id_P:string:=erroneous.
    label_P:string:="".
    tooltip_P:tooltip::tipText:=tooltip::noTip.
    icon_P:optional{::icon Icon}:=core::none.
    blockList_P:block*:=[].
clauses
    addBlock(BlockObj):-
        blockList_P:=list::append(blockList_P,[BlockObj:block_P]).
end implement sectionTmp
