% Copyright (c) Prolog Development Center SPb

implement xmlDocument
    open core, xmlLite, pfc\log

facts
    docType_P:tuple{string Name,string PublicID,string SystemID,string Subset}:=erroneous.
    processingInstruction_P:string:="".
    root_P:xmlElement:=erroneous.

facts
    xmlElement_F:(xmlElement XmlElement). % XML level stack

facts
    codePage_P:core::codePage:=erroneous.
    multiLanguage_P:boolean:=erroneous.
    indent_P:boolean:=erroneous.
    byteOrderMark_P:boolean:=erroneous.
    omitXmlDeclaration_P:boolean:=erroneous.
    conformanceLevel_P:boolean:=erroneous.
    xmlStandalone_P:xmlStandalone:= erroneous.

clauses
    new(MainDocName):-
        element("",MainDocName,[tuple("","xml")]).

clauses
    saveXml(XmlDeclarationOutput):-
        saveXml(root_P,XmlDeclarationOutput).

    saveXml(XMLElement,XmlDeclarationOutput):-
        XmlWriter= xmlWriter::new(),
        Boolean={(P)=Result:-if P=true then Result=b_true else Result=b_false end if},
        XmlWriter:setOutput(XmlDeclarationOutput, codePage_P),
        if not(isErroneous(multiLanguage_P)) then
            XmlWriter:setProperty(multiLanguage, Boolean(multiLanguage_P))
        end if,
        if not(isErroneous(indent_P)) then
            XmlWriter:setProperty(indent, Boolean(indent_P))
        end if,
        if not(isErroneous(byteOrderMark_P)) then
            XmlWriter:setProperty(byteOrderMark, Boolean(byteOrderMark_P))
        end if,
        if not(isErroneous(conformanceLevel_P)) then
            XmlWriter:setProperty(conformanceLevel, Boolean(conformanceLevel_P))
        end if,
        if not(isErroneous(omitXmlDeclaration_P)) then
            XmlWriter:setProperty(omitXmlDeclaration, Boolean(omitXmlDeclaration_P))
        end if,
        if not(isErroneous(xmlStandalone_P)) then
            XmlWriter:writeStartDocument(xmlStandalone_P)
        end if,
        if not(isErroneous(docType_P)) then
            docType_P=tuple(Name,PublicID,SystemID,Subset),
            XmlWriter:writeDocType(Name,PublicID,SystemID,Subset)
        end if,
        XMLElement:saveElement(XmlWriter),
        XmlWriter:writeEndDocument(),
        XmlWriter:flush(),
        XmlDeclarationOutput:close().

    procInstruction(_Value,_Context).

    docType(DocTypeParams,_Context):-
        _Dummy=[""||
            DocTypeParam=list::getMember_nd(DocTypeParams),
            setDocTypeParam(DocTypeParam)
            ].

predicates
    setDocTypeParam:(tuple{string Prefix,string Name,string Value}).
clauses
    setDocTypeParam(_DTParam):-
        isErroneous(docType_P),
        docType_P:=tuple("",nullString,nullString,nullString),
        fail.
    setDocTypeParam(tuple(_Prefix,"SYSTEM",SystemID)):-
        !,
        if SystemID = "" then SystemIDact=nullString
        else SystemIDact=SystemID end if,
        docType_P=tuple(Name,PublicID,_SystemID,Subset),
        docType_P:=tuple(Name,PublicID,SystemIDact,Subset).
    setDocTypeParam(tuple(_Prefix,"PUBLIC",PublicID)):-
        !,
        if PublicID = "" then PublicIDact=nullString
        else PublicIDact=PublicID end if,
        docType_P=tuple(Name,_PublicID,SystemID,Subset),
        docType_P:=tuple(Name,PublicIDact,SystemID,Subset).
    setDocTypeParam(tuple(_Prefix,Name,Subset)):-
        !,
        if Subset = "" then SubsetAct=nullString
        else SubsetAct=string::trim(Subset) end if,
        docType_P=tuple(_Name,PublicID,SystemID,_Subset),
        docType_P:=tuple(Name,PublicID,SystemID,SubsetAct).

clauses
    text(Text,[tuple(_P,ElName)|_]):-
        if
            xmlElement_F(CurrentElement),
            !,
            CurrentElement:name_P=ElName
        then
            CurrentElement:addText(Text),
            !
        else
            fail
        end if.
    text(_Text, _Context):-
        exception::raise_User("Inconsistent element flow").

clauses
    comment(CommentText,[tuple(_P,ElName)|_]):-
        if
            xmlElement_F(CurrentElement),
            !,
            CurrentElement:name_P=ElName
        then
            CurrentElement:addComment(CommentText),
            !
        else
            fail
        end if.
    comment(_CDataText, _Context):-
        exception::raise_User("Inconsistent element flow").

clauses
    cData(CDataText,[tuple(_P,ElName)|_]):-
        if
            xmlElement_F(CurrentElement),
            !,
            CurrentElement:name_P=ElName
        then
            CurrentElement:addCData(CDataText),
            !
        else
            fail
        end if.
    cData(_CDataText, _Context):-
        exception::raise_User("Inconsistent element flow").

clauses
    attribute(_XmlPrefix, _AttrName, _Value, [tuple(_Prefix,"xml")]):-
        !.
    attribute(AttrPrefix, AttrName, Value,[tuple(_P,ElName)|_]):-
        if
            xmlElement_F(CurrentElement),
            !,
            CurrentElement:name_P=ElName
        then
            CurrentElement:addAttribute(AttrPrefix,AttrName,Value),
            !
        else
            fail
        end if.
    attribute(_AttrPrefix, AttrName, Value, Context):-
        exception::raise_User(string::format("Inconsistent attribute flow A=%s V=%s C=%",AttrName,Value,Context)).

clauses
    element(Prefix,ElName,Context):-
        if Context=[tuple(_P,"xml")] then
            XmlElement=xmlElement::new(ElName),
            XmlElement:nameSpacePrefix_P:=Prefix,
            root_P:=XmlElement
        else
            xmlElement_F(ParentElement),
            XmlElement=xmlElement::new(Prefix,ElName,ParentElement),
            ParentElement:addNode(XmlElement)
        end if,
        asserta(xmlElement_F(XmlElement)),
        !.
    element(_Prefix,AttrName,Context):-
        exception::raise_User(string::format("Inconsistent element flow A=%s  C=%",AttrName,Context)).

clauses
    endElement(_Prefix,ElName,_Context):-
        retract(xmlElement_F(ParentElement)),
        ParentElement:name_P=ElName,
        !.
    endElement(_Prefix,ElName,Context):-
        exception::raise_User(string::format("Inconsistent EndElement flow A=%s  C=%",ElName,Context)).

clauses
    getNode_nd([xmlNavigate::current(StartElement)|Path])=StartElement:getNode_nd(Path).
    getNode_nd([xmlNavigate::root|Path])=root_P:getNode_nd(Path).

    getNodeAndPath_nd([xmlNavigate::current(StartElement)|Path])=StartElement:getNodeAndPath_nd(Path).
    getNodeAndPath_nd([xmlNavigate::root|Path])=root_P:getNodeAndPath_nd(Path).

    getNodeTree(XmlElement)=XmlElement:getNodeTree().
    getNodeTree()=getNodeTree(root_P).

end implement xmlDocument


