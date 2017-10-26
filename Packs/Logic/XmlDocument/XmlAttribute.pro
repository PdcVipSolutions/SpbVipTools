% Copyright (c) 2015

implement xmlAttributes
    open core

facts
    attributes_P:mapM{string NameSpaceName, mapM{string AttrName, string AttrValue}}:=erroneous.
    nameSpace_P:mapM{string NameSpaceName, ns_Attr_D NS_Attributes}:=mapM_RedBlack::new().
    parent_P:xmlHierarchy:=erroneous.

clauses
    isAttributesErroneous():-
        isErroneous(attributes_P).

    isParentErroneous():-
        isErroneous(parent_P).

clauses
    addAttribute(AttributeName,AttrValue):-
        addAttributeCL(This,AttributeName,AttrValue).

class predicates
    addAttributeCL:(xmlAttributes,string AttrName,string AttrValue).
clauses
    addAttributeCL(XmlAttributes,AttributeName,AttrValue):-
        splitAttributeName(AttributeName)=tuple(NameSpace,AttrName),
        addAttributeCL(XmlAttributes,NameSpace,AttrName,AttrValue).


clauses
    addAttribute(AttrPrefix,AttrName,NS_Uri):-
        addAttributeCL(This,AttrPrefix, AttrName,NS_Uri).

class predicates
    addAttributeCL:(xmlAttributes,string AttrPrefix,string AttrName,string AttrValue).
clauses
    addAttributeCL(XmlAttributes,_AttrPrefix, "xmlns",NS_Uri):-
        XmlAttributes:nameSpace_P:set("xmlns",ns_Uri(NS_Uri)),
        !.
    addAttributeCL(XmlAttributes,"xmlns", NameSpaceName, NS_Uri):-
        XmlAttributes:nameSpace_P:set(NameSpaceName,ns_Uri(NS_Uri)),
        !.
    addAttributeCL(XmlAttributes,_NS_Name,_AttrName,_AttrValue):-
        XmlAttributes:isAttributesErroneous(),
        XmlAttributes:attributes_P:=mapM_RedBlack::new(),
        fail.
    addAttributeCL(XmlAttributes,NS_Name,AttrName,_AttrValue):-
        not(NS_Name=""),
        if tryConfirmNameSpace(convert(xmlElement,XmlAttributes),NS_Name)=_NSURI then
            fail
        else
            exception::raise_User("No nameSpace defined",[namedValue("nameSpace",string(NS_Name)),namedValue("attrName",string(AttrName))])
        end if.
    addAttributeCL(XmlAttributes,NS_Name,AttrName,AttrValue):-
        getNameSpaceKey(NS_Name,NS_Key),
        if NS_Obj=XmlAttributes:attributes_P:tryGet(NS_Key),! then
            succeed()
        else
            NS_Obj=mapM_RedBlack::new(),
            XmlAttributes:attributes_P:set(NS_Key,NS_Obj)
        end if,
        !,
        NS_Obj:set(AttrName,AttrValue).

class predicates
    getNameSpaceKey:(string NS_Name,string NS_ActualName) procedure (i,o) procedure(o,i).
clauses
    getNameSpaceKey("",noNS_C):-
        !.
    getNameSpaceKey(NS_Name,NS_Name).

clauses
    removeAttribute(AttrName):-
        splitAttributeName(AttrName)=tuple(NameSpace,AttributeName),
        removeAttributeCL(This,NameSpace,AttributeName).

    tryRemoveAttribute(AttrName):-
        try
            removeAttribute(AttrName)
        catch _TraceID do
            fail
        end try.

clauses
    removeAttribute(AttrPrefix,AttrName):-
        removeAttributeCL(This,AttrPrefix,AttrName).

class predicates
    removeAttributeCL:(xmlAttributes, string AttrPrefix, string AttrName).
clauses
    removeAttributeCL(XmlAttributes,AttrPrefix,AttrName):-
        getNameSpaceKey(AttrPrefix,NS_Name),
        NS_Obj=XmlAttributes:attributes_P:tryGet(NS_Name),
        _OldValue=NS_Obj:tryGet(AttrName),
        !,
        NS_Obj:removeKey(AttrName).
    removeAttributeCL(_XmlAttributes,AttrPrefix,AttrName):-
        exception::raise_User("No requested attribute found",[namedValue("nameSpace",string(AttrPrefix)),namedValue("attrName",string(AttrName))]).

    tryRemoveAttribute(NameSpace,AttrName):-
        try
            removeAttributeCL(This,NameSpace,AttrName)
        catch _TraceID do
            fail
        end try.

clauses
    tryModifyAttribute(AttrName,AttrValue):-
        try
            modifyAttribute(AttrName,AttrValue)
        catch _TraceID do
            fail
        end try.

    modifyAttribute(AttrName,AttrValue):-
        splitAttributeName(AttrName)=tuple(NameSpace,AttributeName),
        modifyAttributeCL(This,NameSpace,AttributeName,AttrValue).

clauses
    tryModifyAttribute(NS_UserName,AttrName,AttrValue):-
        try
            modifyAttributeCL(This,NS_UserName,AttrName,AttrValue)
        catch _TraceID do
            fail
        end try.

clauses
    modifyAttribute(NS_UserName,AttrName,AttrValue):-
        modifyAttributeCL(This,NS_UserName,AttrName,AttrValue).

class predicates
    modifyAttributeCL:(xmlAttributes, string AttrPrefix,string AttrName,string AttrValue).
clauses
    modifyAttributeCL(XmlAttributes,NS_UserName,AttrName,AttrValue):-
        getNameSpaceKey(NS_UserName,NS_Name),
        NS_Obj=XmlAttributes:attributes_P:tryGet(NS_Name),
        _OldValue=NS_Obj:tryGet(AttrName),
        !,
        NS_Obj:set(AttrName,AttrValue).
    modifyAttributeCL(_XmlAttributes,NameSpace,AttrName,_AttrValue):-
        exception::raise_User("No requested attribute found",[namedValue("nameSpace",string(NameSpace)),namedValue("attrName",string(AttrName))]).

clauses
    tryGetAttribute(AttrName)=tryGetAttributeCL(This,NameSpace,AttributeName):-
        splitAttributeName(AttrName)=tuple(NameSpace,AttributeName).
    tryGetAttribute(AttrPrefix,AtrName)=tryGetAttributeCL(This,AttrPrefix,AtrName).
    getAttribute_nd()=getAttributeCL_nd(This).
class predicates
    tryGetAttributeCL:(xmlAttributes,string AttrPrefix,string AtrName)->string Value determ.
    getAttributeCL_nd:(xmlAttributes)->tuple{string AttrPrefix,string AttrName,string AttrValue} nondeterm.
clauses
    tryGetAttributeCL(XmlAttributes,NS_UserName,AttrName)=Value:-
        not(XmlAttributes:isAttributesErroneous()),
        getNameSpaceKey(NS_UserName,NS_Name),
        NS_Obj=XmlAttributes:attributes_P:tryGet(NS_Name),
        Value=NS_Obj:tryGet(AttrName).

    getAttributeCL_nd(XmlAttributes)=tuple(NS_UserView,AttrName,AttrValue):-
        not(XmlAttributes:isAttributesErroneous()),
        tuple(NS_Name,NS_Obj)=XmlAttributes:attributes_P:getAll_nd(),
            tuple(AttrName,AttrValue)=NS_Obj:getAll_nd(),
            getNameSpaceKey(NS_UserView,NS_Name).

clauses
    saveAttributes(XmlWriter):-
        saveAttributesCL(This,XmlWriter).

class predicates
    saveAttributesCL:(xmlAttributes,xmlWriter XmlWriter).
clauses
    saveAttributesCL(XmlAttributes,_XmlWriter):-
        _Dummy0=[""||
        tuple(NSN,ns_Writer(NSURI,NSW))=convert(xmlHierarchy,XmlAttributes):nameSpace_P:getAll_nd(),
            not(NSN="xmlns"),
            NSW:writeNamespace(NSN,NSURI)
        ],
        fail.
    saveAttributesCL(XmlAttributes,XmlWriter):-
        _Dummy=
        [""||
            XmlAttributes:getAttribute_nd()=tuple(NameSpace,AttrName,AttrValue),
                tryGetNameSpaceDataCL(XmlAttributes,attribute,XmlWriter,NameSpace)=tuple(_NameSpaceObj,_NSURI,NS_Writer),
                NS_Writer:writeAttributeString(AttrName, AttrValue)
        ].

clauses
    tryGetNameSpaceData(EntityType,XmlWriter,NameSpace)=NameSpaceData:-
        try
            NameSpaceData=tryGetNameSpaceDataCL(This,EntityType,XmlWriter,NameSpace)
        catch _TraceID do
            fail
        end try.

class predicates
    tryGetNameSpaceDataCL:(xmlAttributes,entityType_D EntityType,xmlWriter CurrentXMLWriter,string NameSpace)->
        tuple{
            mapM{string NameSpaceName, ns_Attr_D NS_Attributes},
            string NSURI,
            xmlWriter NSWriter
            } determ.
clauses
    tryGetNameSpaceDataCL(XmlAttributes,element,XmlWriter,"")=tuple(XmlAttributes:nameSpace_P,"",Writer):-
        if ns_Writer(_NSURI,NSW)=XmlAttributes:nameSpace_P:tryGet("xmlns"),! then
            Writer=NSW
        else
            Writer=XmlWriter
        end if,
        !.
    tryGetNameSpaceDataCL(XmlAttributes,attribute,XmlWriter,"")=tuple(XmlAttributes:nameSpace_P,"",XmlWriter):-
        !.
    tryGetNameSpaceDataCL(XmlAttributes,_Any,_XmlWriter,NameSpace)=tuple(XmlAttributes:nameSpace_P,NSURI,NSW):-
        ns_Writer(NSURI,NSW)=XmlAttributes:nameSpace_P:tryGet(NameSpace),
        !.
    tryGetNameSpaceDataCL(XmlAttributes,InvokeEntityType,XmlWriter,NameSpace)=NameSpaceData:-
        NameSpaceData=tryGetNameSpaceDataCL(convert(xmlAttributes,XmlAttributes:parent_P),InvokeEntityType,XmlWriter,NameSpace).

/* Class Predicates*/
clauses
    tryConfirmNameSpace(XmlElement,NameSpace)=NSURI:-
        ns_Uri(NSURI)=convert(xmlHierarchy,XmlElement):nameSpace_P:tryGet(NameSpace),
        !.
    tryConfirmNameSpace(XmlElement,NameSpace)=NSURI:-
        try
            NSURI=tryConfirmNameSpace(convert(xmlAttributes,XmlElement:parent_P),NameSpace)
        catch _TraceID do
            fail
        end try.

clauses
    splitAttributeName(AttributeNameIntegrated)=tuple(NameSpace,AttributeName):-
        [NameSpace,AttributeName]=string::split(AttributeNameIntegrated,":"),
        !.
    splitAttributeName(AttributeName)=tuple("",AttributeName).

clauses
    tryNameSpaceDeclaration(NameSpace)=tryNameSpaceDeclarationCL(This,NameSpace).
class predicates
    tryNameSpaceDeclarationCL:(xmlAttributes XmlAttributes,string NameSpace) -> string NameSpaceUri determ.
clauses
    tryNameSpaceDeclarationCL(XmlElement,NameSpace)=NSURI:-
        ns_Uri(NSURI)=XmlElement:nameSpace_P:tryGet(NameSpace).

end implement xmlAttributes
