%

implement dictionarySupport
    open core, xmlNavigate%, xmlElement,

facts
    ribbonContent_V:value:=erroneous.

facts % properties
    languageList_P:namedValue_list:=[].
    nameSpace_P:string:=erroneous.
    dictionaryFileName_P:string:=erroneous.
    modifyScript_P:boolean:=false.
    saveDictionary_P:boolean:=false.

constants
    dictionaryTemplate_C:binary=#bininclude(@"Packs\Logic\appFrameSupport\dictionarySupport\template_Dictionary.xml").

clauses
    new(RibbonContent):-
        ribbonContent_V:=RibbonContent.

clauses
    doIt()=OutputData:-
        RibbonDoc=createXmlDoc("ribbon-layout",ribbonContent_V),
        if
            RibbonRootNode=RibbonDoc:getNode_nd([root()]),!,
            RibbonRootNode:name_P="ribbon-layout"
        then
            if file::existExactFile(dictionaryFileName_P) then
                DictionaryDoc=createXmlDoc("language",string(dictionaryFileName_P))
            else
                DictionaryDoc=createXmlDoc("language",binary(dictionaryTemplate_C))
            end if,
            DictionaryRootNode=DictionaryDoc:getNode_nd([root()]),
            setAttribute(DictionaryRootNode,"namespace",nameSpace_P),
            LanguageListNode=DictionaryRootNode:getNode_nd([child("language_list", {(_)})]),
            foreach
                namedValue(Language,string(LanguageName)) in languageList_P
            do
                setAttribute(LanguageListNode,Language,LanguageName)
            end foreach,

            foreach
                SectionNode = RibbonDoc:getNode_nd([root(),child("section", {(_)})]),
                SectionID=SectionNode:attribute("id")
                do
                    if SectLabel=SectionNode:attribute("label") then
                    else
                        SectLabel=SectionID
                    end if,
                    addDictionaryItem(DictionaryRootNode,SectionID,SectLabel,SectionID),
                    foreach
                        CmdNode=SectionNode:getNode_nd([descendant("*",{(O):-O:name_P="cmd"})]),
                        CmdID=CmdNode:attribute("id")
                        do
                        addItemLabels(DictionaryRootNode,CmdNode,CmdID)
                    end foreach,
                    foreach
                        MenuNode=SectionNode:getNode_nd([descendant("*",{(O):-O:name_P="menu"})]),
                        MenuID=MenuNode:attribute("id")
                    do
                        addItemLabels(DictionaryRootNode,MenuNode,MenuID)
                    end foreach
            end foreach,
            OutputStream = outputStream_file::create(dictionaryFileName_P, stream::binary),
            DictionaryDoc:saveXml(OutputStream),
            modifyScript_P=true,
            !,
            OutputData=modifyScriptIfRequested(RibbonDoc,RibbonRootNode)
        else
            OutputData=core::none
        end if,
        !.
    doIt()=core::none.

clauses
    doIt(ItemList)=DictionaryDoc:-
        if saveDictionary_P=true, file::existExactFile(dictionaryFileName_P) then
            DictionaryDoc=createXmlDoc("language",string(dictionaryFileName_P))
        else
            DictionaryDoc=createXmlDoc("language",binary(dictionaryTemplate_C))
        end if,
        DictionaryRootNode=DictionaryDoc:getNode_nd([root()]),
        setAttribute(DictionaryRootNode,"namespace",nameSpace_P),
        LanguageListNode=DictionaryRootNode:getNode_nd([child("language_list", {(_)})]),
        !,
        foreach
            namedValue(Language,string(LanguageName)) in languageList_P
        do
            setAttribute(LanguageListNode,Language,LanguageName)
        end foreach,
        foreach tuple(ItemID,ItemValue,ItemMeaning) in ItemList do
            addDictionaryItem(DictionaryRootNode,ItemID,ItemValue,ItemMeaning)
        end foreach,
        if saveDictionary_P=true then
            OutputStream = outputStream_file::create(dictionaryFileName_P, stream::binary),
            DictionaryDoc:saveXml(OutputStream)
        end if.
    doIt(_ItemList)=_DictionaryDoc:-
        exception::raise_User("Unexpected Alternative").

clauses
    createDictionaryXmlDocument()=DictionaryXmlDocument:-
            DictionaryXmlDocument=createXmlDoc("language",string(dictionaryFileName_P)).

predicates
    modifyScriptIfRequested:(xmlDocument RibbonDoc,xmlElement RibbonRootNode)->value OutputData.
clauses
    modifyScriptIfRequested(RibbonDoc,RibbonRootNode)=OutputData:-
        if DictionaryNode=RibbonDoc:getNode_nd([root(),child("dictionary",{(_)})]),! then
        else
            DictionaryNode = xmlElement::new("dictionary", RibbonRootNode),
            RibbonRootNode:addNode(DictionaryNode)
        end if,
        setAttribute(DictionaryNode,"namespace",nameSpace_P),
        setAttribute(DictionaryNode,"file",fileName::reduceToShort(dictionaryFileName_P,directory::getCurrentDirectory())),
        if ribbonContent_V=string(ScriptFileName) then
            FileStream = outputStream_file::create(ScriptFileName, stream::binary),
            RibbonDoc:saveXml(FileStream),
            OutputData=core::none
        else % delivered from FrontEnd must be sent back
            BinStream = outputStream_binary::new(),
            RibbonDoc:saveXml(BinStream),
            Bin=BinStream:getBinary(),
            OutputData=binary(Bin)
        end if.

predicates
    addItemLabels:(xmlElement DictionaryRootNode,xmlElement ItemNode,string ItemID).
clauses
    addItemLabels(DictionaryRootNode,ItemNode,ItemID):-
        if ItemLabel=ItemNode:attribute("label") then
        else
            ItemLabel="undefined"
        end if,
        addDictionaryItem(DictionaryRootNode,ItemID,ItemLabel,ItemID),
        if MenuLabel=ItemNode:attribute("menu-label") then
        else
            MenuLabel=ItemLabel
        end if,
        MenuID=string::concat(ItemID,".menulabel"),
        addDictionaryItem(DictionaryRootNode,MenuID,MenuLabel,MenuID),
        if
            TooltipNode = ItemNode:getNode_nd([child("tooltip", {(_)})]),
            Tooltip=TooltipNode:attribute("text")
        then
        else
            Tooltip=ItemLabel
        end if,
        TooltipID=string::concat(ItemID,".tooltip"),
        addDictionaryItem(DictionaryRootNode,TooltipID,Tooltip,TooltipID).

predicates
    addDictionaryItem:(xmlElement RootNode,string ItemID,string ItemLabel,string Meaning).
clauses
    addDictionaryItem(RootNode,ItemID,ItemLabel,Meaning):-
        if Row=RootNode:getNode_nd([child("row", {(O):-O:attribute("id")=ItemID})]) then
        else
            Row = xmlElement::new("row", RootNode),
            RootNode:addNode(Row),
            Row:addAttribute("id",ItemID),
            Row:addAttribute("meaning",Meaning)
        end if,
        foreach namedValue(Language,string(_LanguageName)) in languageList_P do
            if LangIDNode=Row:getNode_nd([child(Language, {(_)})]) then
            else
                LangIDNode = xmlElement::new(Language, Row),
                Row:addNode(LangIDNode),
                LangIDNode:addText(ItemLabel)
            end if
        end foreach.

predicates
    createXmlDoc:(string DocName,value XmlData)->xmlDocument TempDocument.
clauses
    createXmlDoc(DocName,XmlData)=TmpDoc:-
        TmpDoc=xmlDocument::new(DocName),
        TmpDoc:codePage_P:=utf8,
        TmpDoc:indent_P:=true,
        TmpDoc:xmlStandalone_P:=xmlLite::yes,
        if XmlData=string(XmlFileName) then
            BinStream = inputStream_file::openFile(XmlFileName, stream::binary)
        elseif XmlData=binary(XmlBinData) then
            BinStream=inputStream_binary::new(XmlBinData)
        else
            exception::raise_User("Unexpected Alternative")
        end if,
        spbXmlLigntSupport::read(BinStream, TmpDoc),
        BinStream:close().

predicates
    setAttribute:(xmlElement XmlNode,string AttributeName,string AttributeValue).
clauses
    setAttribute(XmlNode,AttributeName,AttributeValue):-
        if _TmplateNameSpace=XmlNode:attribute(AttributeName) then
            XmlNode:modifyAttribute(AttributeName,AttributeValue)
        else
            XmlNode:addAttribute(AttributeName,AttributeValue)
        end if.

end implement dictionarySupport
