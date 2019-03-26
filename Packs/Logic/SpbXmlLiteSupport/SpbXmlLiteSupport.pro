% Copyright (c) Prolog Development Center SPb

implement spbXmlLigntSupport
    open core, xmlLite

class facts
    target_V:xmlDataImporter:=erroneous.

clauses
    read(InputStream,DataImporter) :-
        target_V:=DataImporter,
        XmlReader = xmlReader::new(),
        XmlReader:setProperty(dtdProcessing, xmlLite_native::dtdProcessing_parse),
        XmlReader:setInput(InputStream),
        read1(XmlReader,[]).

class predicates
    read1 : (xmlReader XmlReader, tuple{string Prefix,string Name}* Context).
clauses
    read1(XmlReader,Context) :-
        if NodeType = XmlReader:tryRead() then
            NewContext=read2(XmlReader, NodeType,Context),
            read1(XmlReader,NewContext)
        end if.

class predicates
    read2 : (xmlReader XmlReader, xmlNodeType NodeType,tuple{string Prefix,string Name}*  Context)->tuple{string Prefix,string Name}*  NewContext.
clauses
    read2(_XmlReader, xmlNodeType_none,Context)=Context:-!.
    read2(XmlReader, attribute,Context)=NewContext:-
        !,
        NewContext=extract_Params(XmlReader,Context).
    read2(XmlReader, cdata,Context)=Context:-
        Value = XmlReader:getValue(),
        !,
        target_V:cData(Value,Context).
    read2(XmlReader, processingInstruction,Context)=Context:-
        Value = XmlReader:getValue(),
        !,
        target_V:procInstruction(Value,Context).
    read2(XmlReader, comment,Context)=Context:-
        Value = XmlReader:getValue(),
        !,
        target_V:comment(Value,Context).
    read2(XmlReader, documentType,Context)=Context:-
        DocTypeAttrList=[DocTypeAttr||DocTypeAttr=readAttribute(XmlReader)],
        !,
        target_V:docType(DocTypeAttrList,Context).
    read2(_XmlReader, whitespace,Context)=Context:-!.
    read2(XmlReader, xmlDeclaration,Context)=NewContext:-
        !,
        NewContext=extract_Params(XmlReader,Context).
    read2(XmlReader, element,Context)=NewContext:-
        tuple(Prefix,Name)=getEntity(XmlReader),
        target_V:element(Prefix,Name,Context),
        !,
        NewContext=extract_Params(XmlReader,Context).
    read2(_XmlReader, endElement,[tuple(Prefix,Name)|ContextTail])=ContextTail:-
        target_V:endElement(Prefix,Name,ContextTail),!.
    read2(XmlReader, text,Context)=Context :-
        Text = XmlReader:getValue(),
        target_V:text(Text,Context),
        !.
    read2(_XmlReader, NodeType,Context)=_NewContext :-
            exception::raise_user
                (
                "Invalid node type",
                    [
                    namedValue("type",string(toString(NodeType))),
                    namedValue("context",string(toString(Context)))
                    ]
                ).

class predicates
    extract_Params:(xmlReader XmlReader,tuple{string Prefix,string Name}* Context)->tuple{string Prefix,string Name}* NewContext.
clauses
    extract_Params(XmlReader,Context)=NewContext:-
        tuple(Prefix,Name)=getEntity(XmlReader),
        if XmlReader:isEmptyElement() then
            NewContext=Context,
            readElement(XmlReader,[tuple(Prefix,Name)|Context]),
            target_V:endElement(Prefix,Name,Context)
        else
            NewContext=[tuple(Prefix,Name)|Context],
            readElement(XmlReader,[tuple(Prefix,Name)|Context])
        end if.

class predicates
    getEntity:(xmlReader XmlReader)->tuple{string Prefix,string Name}.
clauses
    getEntity(XmlReader)=tuple(Prefix,Name):-
        Prefix = XmlReader:getPrefix(),
        Name = XmlReader:getLocalName().

class predicates
    readElement:(xmlReader XmlReader,tuple{string Prefix, string Name}* Context).
clauses
    readElement(XmlReader,Context):-
        if XmlReader:tryMoveToFirstAttribute() then
            _NameList=
            [
                AttrName||tuple(AttrPrefix,AttrName,Value)=readAttribute(XmlReader),
                target_V:attribute(AttrPrefix,AttrName,Value,Context)
            ]
        end if.

class predicates
    readAttribute : (xmlReader XmlReader) -> tuple {string Prefix, string Name, string Value} multi.
clauses
    readAttribute(XmlReader) = tuple(Prefix,LocalName,Value):-
        Prefix = XmlReader:getPrefix(),
        LocalName = XmlReader:getLocalName(),
        Value = XmlReader:getValue().
    readAttribute(XmlReader)=Attribute :-
        XmlReader:tryMoveToNextAttribute(),
        Attribute=readAttribute(XmlReader).

clauses
    tryFindDocumentID(_InputStream, [])="". % DocumentID.

end implement spbXmlLigntSupport