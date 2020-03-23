% Copyright (c) Prolog Development Center SPb

interface xmlDocument
    supports xmlDataImporter

    open core

properties
    docType_P:tuple{string Name,string PublicID,string SystemID,string Subset}.
    processingInstruction_P:string.
    root_P:xmlElement.

    codePage_P:core::codePage.
    multiLanguage_P:boolean.
    indent_P:boolean.
    byteOrderMark_P:boolean.
    omitXmlDeclaration_P:boolean.
    conformanceLevel_P:boolean.
    xmlStandalone_P:xmlLite::xmlStandalone.

predicates
    saveXml:(outputStream OutputStream).
    saveXml:(xmlElement SaveFromElement, outputStream OutputStream).

predicates
    getNode_nd:(xmlNavigate::step_D* Path)->xmlElement nondeterm.
    getNodeAndPath_nd:(xmlNavigate::step_D* Path)->tuple{xmlElement NodeObj,xmlElement* NodeListAsPath} nondeterm.

    getNodeTree:()->spbTree::tree{string NodeName,xmlElement Data}.
    getNodeTree:(xmlElement XmlSubTree)->spbTree::tree{string NodeName,xmlElement Data}.

end interface xmlDocument
