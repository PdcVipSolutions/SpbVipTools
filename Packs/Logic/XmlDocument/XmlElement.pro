% Copyright (c) 2015
implement xmlElement
    inherits xmlAttributes
    open core

facts
    nameSpacePrefix_P:string:=erroneous.

clauses
    new(NameSpace,ElementName,Parent):-
        parent_P:=Parent,
        name_P:=ElementName,
        nameSpacePrefix_P:=NameSpace.

clauses
    new(ElementName):-
        name_P:=ElementName.

facts
    name_P:string:=erroneous.

facts
    content_V:elItem_D*:=[].

clauses
    clearContent():-content_V:=[].

clauses
    addText(TextAsString):-
        content_V:=list::append(content_V,[text(TextAsString)]).

clauses
    addComment(Comment):-
        content_V:=list::append(content_V,[comment(Comment)]).

clauses
    addCData(CDataText):-
        content_V:=list::append(content_V,[cData(CDataText)]).

clauses
    addNode(ChildElement):-
        content_V:=list::append(content_V,[node(ChildElement:name_P,ChildElement)]),
        ChildElement:parent_P:=This.

clauses
    removeNode(ChildElement):-
        content_V:=list::remove(content_V,node(ChildElement:name_P,ChildElement)).

clauses
    saveElement(XmlWriter):-
        saveElementCL(This,content_V,XmlWriter).

class predicates
    saveElementCL:(xmlElement,elItem_D* ContentData,xmlWriter XmlWriter).
clauses
    saveElementCL(XmlElement,ContentData,XmlWriter):-
        initNameSpace(XmlElement,XmlWriter),
        if XmlElement:tryGetNameSpaceData(element,XmlWriter,XmlElement:nameSpacePrefix_P)=tuple(_NS,_NSURI,NSWriter) then
            NSW=NSWriter
        else
            NSW=XmlWriter
        end if,
        NSW:writeStartElement(XmlElement:name_P),
        XmlElement:saveAttributes(XmlWriter),
        list::forAll(ContentData,{(ContentItem):-saveContentItem(XmlWriter,ContentItem)}),
        NSW:writeEndElement().

class predicates
    saveContentItem:(xmlWriter XmlWriter,elItem_D ContentItem).
clauses
    saveContentItem(XmlWriter,text(Text)):-
        XmlWriter:writeString(Text).
    saveContentItem(XmlWriter,comment(Comment)):-
        XmlWriter:writeComment(Comment).
    saveContentItem(XmlWriter,cData(CData)):-
        XmlWriter:writeCData(CData).
    saveContentItem(XmlWriter,node(_Name,ChildElement)):-
        ChildElement:saveElement(XmlWriter).

class predicates
    initNameSpace:(xmlElement,xmlWriter XmlWriter).
clauses
    initNameSpace(XmlElement,XmlWriter):-
        if XmlElement:tryGetNameSpaceData(element,XmlWriter,"xmlns")=tuple(_NSobj,_NSN,XmlObj) then
            XMLNS_XmlWriter = XmlObj
        else
            XMLNS_XmlWriter = XmlWriter
        end if,
        if tuple("xmlns",ns_Uri(XMLNSNSURI))=XmlElement:nameSpace_P:getAll_nd(),! then
            XMLNS_XmlWriterLocal=XMLNS_XmlWriter:newNamespace("",XMLNSNSURI),
            XmlElement:nameSpace_P:set("xmlns",ns_Writer(XMLNSNSURI,XMLNS_XmlWriterLocal))
        else
            XMLNS_XmlWriterLocal=XMLNS_XmlWriter
        end if,
        _Dummy0=[""||
            tuple(NSName,ns_Uri(NSURI))=XmlElement:nameSpace_P:getAll_nd(),
                not(NSName="xmlns"),
                NSW=XMLNS_XmlWriterLocal:newNamespace(NSName,NSURI),
                XmlElement:nameSpace_P:set(NSName,ns_Writer(NSURI,NSW))
            ].

clauses
    getNode_nd(Path)=getNodeCL_nd(This,content_V,Path,[],_Lout).

clauses
    getNodeAndPath_nd(Path)=tuple(Node,Lout):-Node=getNodeAndPath_nd(Path,[],Lout).

clauses
    getNodeAndPath_nd(Path,Lin,Lout)=getNodeCL_nd(This,content_V,Path,Lin,Lout).

clauses
    getNodeTree()=getNodeTreeCL(This,content_V).

class predicates
    getNodeTreeCL:(xmlElement Element,elItem_D* Content_V)->spbTree::tree{string NodeName,xmlElement ElementObj}.
clauses
    getNodeTreeCL(XmlElement, Content_V)=spbTree::tree(XmlElement:name_P,XmlElement,[]):-
        []=[""||xmlElement::node(_ElementName,_ChildElement)=list::getMember_nd(Content_V),!],
        !.
    getNodeTreeCL(XmlElement, Content_V)=spbTree::tree(XmlElement:name_P,XmlElement,XmlTreeList):-
        XmlTreeList=[XmlTree||
            xmlElement::node(_ElementName,ChildElement)=list::getMember_nd(Content_V),
                XmlTree=ChildElement:getNodeTree()
            ].

class predicates
    getNodeCL_nd:(xmlElement, elItem_D* Content_V,step_D*,xmlElement* Lin,xmlElement* [out] Lout)->xmlElement nondeterm.
clauses
    getNodeCL_nd(XmlElement,_Content_V,[],Lin,Lin)=XmlElement.
    getNodeCL_nd(XmlElement,Content_V,[PathHead|PathTail],Lin,PathToTarget)=TargetObject:-
        !,
        if Lin=[XmlElement|_Tail] then
            NewObjPath=Lin
        else
            NewObjPath=[XmlElement|Lin]
        end if,
        ElementObj=handleStep_nd(XmlElement,Content_V,PathHead,NewObjPath,Lout),
        TargetObject=ElementObj:getNodeAndPath_nd(PathTail,Lout,PathToTarget).

facts
    counter_P:positive:=0.
class predicates
    handleStep_nd:(xmlElement,elItem_D* Content_V,step_D Step,xmlElement* Lin,xmlElement* [out] Lout)->xmlElement Element nondeterm.
clauses
    handleStep_nd(XmlElement,_Content_V,self(Predicate),Lin,Lin)=XmlElement:-Predicate(XmlElement).
    handleStep_nd(XmlElement,_Content_V,parent(Predicate),Lin,Lin)=Parent:-
        not(XmlElement:isParentErroneous()),
        Parent=convert(xmlElement,XmlElement:parent_P),
        Predicate(Parent).
/*child*/
    handleStep_nd(XmlElement,Content_V,xmlNavigate::child(ElementNameIntegrated,Predicate),Lin,Lin)=ChildElement:-
        trySplitName(XmlElement,ElementNameIntegrated)=ElementName,
        if ElementName="*" then
            xmlElement::node(_ElementName,ChildElement)=list::getMember_nd(Content_V)
        else
            xmlElement::node(ElementName,ChildElement)=list::getMember_nd(Content_V)
        end if,
        Predicate(ChildElement).
/*Desscendant*/
    handleStep_nd(XmlElement,Content_V,xmlNavigate::descendant(ElementNameIntegrated,Predicate),Lin,Lout)=Discendant:-
        trySplitName(XmlElement,ElementNameIntegrated)=ElementName,
        if ElementName="*" then
            xmlElement::node(_ElementName,ChildElement)=list::getMember_nd(Content_V)
        else
            xmlElement::node(ElementName,ChildElement)=list::getMember_nd(Content_V)
        end if,
        Discendant=ChildElement:getNodeAndPath_nd([xmlNavigate::descendant_or_self(ElementNameIntegrated,Predicate)],Lin,Lout),
        Predicate(Discendant).
/*Descendant_or_self*/
    handleStep_nd(XmlElement,_Content_V,xmlNavigate::descendant_or_self(ElementNameIntegrated,Predicate),Lin,Lin)=XmlElement:-
        trySplitName(XmlElement,ElementNameIntegrated)=ElementName,
        if not(ElementName="*") then
            ElementName=XmlElement:name_P
        else
            succeed()
        end if,
        Predicate(XmlElement).
    handleStep_nd(XmlElement,Content_V,xmlNavigate::descendant_or_self(ElementNameIntegrated,Predicate),Lin,Lout)=Discendant:-
        trySplitName(XmlElement,ElementNameIntegrated)=ElementName,
        if ElementName="*" then
            xmlElement::node(_ElementName,ChildElement)=list::getMember_nd(Content_V)
        else
            xmlElement::node(ElementName,ChildElement)=list::getMember_nd(Content_V)
        end if,
        Discendant=ChildElement:getNodeAndPath_nd([xmlNavigate::descendant_or_Self(ElementNameIntegrated,Predicate)],Lin,Lout),
        Predicate(Discendant).
/*ancestor*/
    handleStep_nd(XmlElement,_Content_V,xmlNavigate::ancestor(ElementNameIntegrated,Predicate),Lin,Lin)=Parent:-
        not(XmlElement:isParentErroneous()),
        trySplitName(XmlElement,ElementNameIntegrated)=ElementName,
        Parent=convert(xmlElement,XmlElement:parent_P),
        if not(ElementName="*") then
            Parent:name_P=ElementName
        end if,
        Predicate(Parent).
    handleStep_nd(XmlElement,_Content_V,xmlNavigate::ancestor(ElementNameIntegrated,Predicate),Lin,Lout)=Node:-
        not(XmlElement:isParentErroneous()),
        Parent=convert(xmlElement,XmlElement:parent_P),
        Node=Parent:getNodeAndPath_nd([xmlNavigate::ancestor(ElementNameIntegrated,Predicate)],[Parent|Lin],Lout).
/*ancestor_or_self*/
    handleStep_nd(XmlElement,_Content_V,xmlNavigate::ancestor_or_self(_ElementName,Predicate),Lin,Lin)=XmlElement:-
        Predicate(XmlElement).
    handleStep_nd(XmlElement,Content_V,xmlNavigate::ancestor_or_self(ElementNameIntegrated,Predicate),Lin,Lout)=Parent:-
        Parent=handleStep_nd(XmlElement,Content_V,xmlNavigate::ancestor(ElementNameIntegrated,Predicate),Lin,Lout).
/*following-sibling*/
    handleStep_nd(XmlElement,_Content_V,xmlNavigate::following_sibling(ElementNameIntegrated,Predicate),Lin,Lin)=FollowingElement:-
        not(XmlElement:isParentErroneous()),
        XmlElement:counter_P:=0,
        ParentElement=convert(xmlElement,XmlElement:parent_P),
        trySplitName(ParentElement,ElementNameIntegrated)=ElementName,
        if ElementName="*" then
            ParentElement:getItem_nd()=node(_ElementName,Object)
        else
            ParentElement:getItem_nd()=node(ElementName,Object)
        end if,
        if Object=XmlElement then
            XmlElement:counter_P:=1, % the counter is used as the flag with 0/1 values
            fail
        end if,
        if XmlElement:counter_P=1 then
            Predicate(Object),
            FollowingElement=Object
        else
            fail
        end if.
/*preceding_sibling*/
    handleStep_nd(XmlElement,_Content_V,xmlNavigate::preceding_sibling(ElementNameIntegrated,Predicate),Lin,Lin)=PreseedingElement:-
        not(XmlElement:isParentErroneous()),
        ParentElement=convert(xmlElement,XmlElement:parent_P),
        trySplitName(ParentElement,ElementNameIntegrated)=ElementName,
        if ElementName="*" then
            ParentElement:getItem_nd()=node(_ElementName,PreseedingElement)
        else
            ParentElement:getItem_nd()=node(ElementName,PreseedingElement)
        end if,
        Predicate(PreseedingElement),
        if PreseedingElement=XmlElement then
            !,
            fail
        end if.
/*attribute*/
    handleStep_nd(XmlElement,_Content_V,xmlNavigate::attribute(AttributeNameIntegrated,Predicate),Lin,Lin)=XmlElement:-
        splitAttributeName(AttributeNameIntegrated)=tuple(NameSpace,AttributeName),
        try
            _AttributeValue=XmlElement:tryGetAttribute(NameSpace,AttributeName)
        catch _TraceID do
            fail
        end try,
        Predicate(XmlElement).
/*xmlNameSpace*/
    handleStep_nd(XmlElement,_Content_V,xmlNavigate::xmlNameSpace(NameSpace,Predicate),Lin,Lin)=XmlElement:-
        _NSURI=XmlElement:tryNameSpaceDeclaration(NameSpace),
        Predicate(XmlElement).
    handleStep_nd(_XmlElement,Content_V,xmlNavigate::last(Predicate),Lin,Lin)=LastXmlElement:-
        count(Content_V,node)=LastNodeNo,
        node(_ElementName,LastXmlElement)=tryGetItem(Content_V,node,LastNodeNo),
        Predicate(LastXmlElement).

/*XPath-like Functions*/
/*
last() -> positive.
position()->positive.
count(node-set) -> positive.
local-name(node-set?)
namespace-uri(node-set?)
name(node-set?)
*/
clauses
    position()=counter_P:-
        counter_P:=0,
        if isParentErroneous() then
                counter_P:=1 % parent  is the document class and the root is the only possible node
        else
            ParentElement=convert(xmlElement,parent_P),
            _Dummy=[""||
            ParentElement:getItem_nd()=node(_Name,Object),
            counter_P:=counter_P+1,
            Object=This,
            !
            ]
        end if.

clauses
    namespace_uri(NameSpace)=tryConfirmNameSpace(This,NameSpace).

clauses
    attribute(AttributeName)=AttributeValue:-
        splitAttributeName(AttributeName)=tuple(NameSpace,AttributeName),
        try
            AttributeValue=tryGetAttribute(NameSpace,AttributeName)
        catch _TraceID do
            fail
        end try.

class predicates
    trySplitName:(xmlElement, string ElementNameIntegrated)->string ElementName determ.
clauses
    trySplitName(_XmlElement,"*")="*":-!.
    trySplitName(XmlElement,ElementNameIntegrated)=ElementName:-
        if [NameSpace,ElementName]=string::split(ElementNameIntegrated,":") then
            _NSURI=tryConfirmNameSpace(XmlElement,NameSpace)
        else
            ElementName=ElementNameIntegrated
        end if.

/*
+        ancestor(string,predicate{xmlElement}); 			% Возвращает множество предков.
+        ancestor_or_self(string,predicate{xmlElement});		% Возвращает множество предков и текущий элемент.
+        attribute(string);			%Возвращает множество атрибутов текущего элемента. Это обращение можно заменить на «@»
+        node(string,predicate{xmlElement});			%Возвращает множество потомков на один уровень ниже. Это название сокращается полностью, то есть его можно вовсе опускать.
+        descendant(string,predicate{xmlElement});		%Возвращает полное множество потомков (то есть, как ближайших потомков, так и всех их потомков).
+        descendant_or_self(string,predicate{xmlElement});	/*Возвращает полное множество потомков и текущий элемент. Выражение «/descendant-or-self::node()/» можно сокращать до «//». С помощью этой оси, например, можно вторым шагом организовать отбор элементов с любого узла, а не только с корневого: достаточно первым шагом взять всех потомков корневого. Например, путь «//span» отберёт все узлы span документа, независимо от их положения в иерархии, взглянув как на имя корневого, так и на имена всех его дочерних элементов, на всю глубину их вложенности.*/
        following(string,predicate{xmlElement});			%Возвращает необработанное множество, ниже текущего элемента.
+        following_sibling(string,predicate{xmlElement});		%Возвращает множество элементов на том же уровне, следующих за текущим.
+        xmlNamespace(predicate{xmlElement});		%Возвращает множество, имеющее пространство имён (то есть присутствует атрибут xmlns).
+        parent(predicate{xmlElement});			%Возвращает предка на один уровень назад. Это обращение можно заменить на «..»
        preceding(string,predicate{xmlElement});		%Возвращает множество обработанных элементов исключая множество предков.
+        preceding_sibling(string,predicate{xmlElement});	%Возвращает множество элементов на том же уровне, предшествующих текущему.
+        self(predicate{xmlElement}).			%Возвращает текущий элемент. Это обращение можно заменить на«.»
*/
clauses
    count(ItemTypeID)=count(content_V,ItemTypeID).
class predicates
    count:(elItem_D* ContentIn,itemTypeID_D)->positive ContentPosition.
clauses
    count(ContentIn,all)=list::length(ContentIn):-!.
    count(ContentIn,ItemID)=list::length([""||Item=list::getMember_nd(ContentIn),isItemCorrespond(ItemID,Item)]).

clauses
    getItem_nd()=list::getMember_nd(content_V).

clauses
    tryGetItem(ItemID,ItemPosition)=tryGetItem(content_V,ItemID,ItemPosition).
class predicates
    tryGetItem:(elItem_D* ContentIn,itemTypeID_D,positive ItemPosition)->elItem_D determ.
clauses
    tryGetItem(ContentIn,all,ItemPosition)=list::nth(ItemPosition-1,ContentIn):-!.
    tryGetItem(ContentIn,ItemID,ItemPosition)=FoundItem:-
        try
            FoundItem=list::nth(ItemPosition-1,[Item||Item=list::getMember_nd(ContentIn),isItemCorrespond(ItemID,Item)])
        catch _TraceID do
            fail
        end try.

class predicates
    isItemCorrespond:(itemTypeID_D,elItem_D) determ.
clauses
    isItemCorrespond(text,text(_Text)).
    isItemCorrespond(comment,comment(_Text)).
    isItemCorrespond(cData,cData(_Text)).
    isItemCorrespond(node,node(_Name,_Object)).

clauses
    tryRemoveItem(ItemID,ItemPosition)=Item:-
        content_V:=tryRemoveItem(content_V,ItemID,ItemPosition,Item).
class predicates
    tryRemoveItem:(elItem_D* ContentIn,itemTypeID_D,positive ItemNo,elItem_D ElementItem [out])-> elItem_D* ContentOut determ.
clauses
    tryRemoveItem(ContentIn,ItemID,ItemPosition,Item)=ContentOut:-
        Item=tryGetItem(ContentIn,ItemID,ItemPosition),
        ContentOut=list::remove(ContentIn,Item).

clauses
    tryModifyItem(ItemID,ItemPosition,ElementItem)=Item:-
        content_V:=tryModifyItem(content_V,ItemID,ItemPosition,ElementItem,Item).
class predicates
    tryModifyItem:(elItem_D* ContentIn, itemTypeID_D ItemID,positive ItemPosition,elItem_D ElementItem,elItem_D ElementOut [out])->elItem_D* ContentOut determ.
clauses
    tryModifyItem(ContentIn,ItemID,ItemPosition,ElementItem,Item)=ContentOut:-
        Item=tryGetItem(ContentIn,ItemID,ItemPosition),
        AbsolutePosition=list::tryGetIndex(Item,ContentIn),
        ContentOut=list::setNth(AbsolutePosition,ContentIn,ElementItem).

clauses
    addItem(ElementItem):-
        if ElementItem=node(_Name,ElementObj) then
            ElementObj:parent_P:=This
        end if,
        content_V:=list::append(content_V,[ElementItem]).

clauses
    tryInsertItem(ItemID,ItemPosition,ElementItem):-
        if ElementItem=node(_Name,ElementObj) then
            ElementObj:parent_P:=This
        end if,
        content_V:=tryInsertItem(content_V,ItemID,ItemPosition,ElementItem).
class predicates
    tryInsertItem:(elItem_D* ContentIn,itemTypeID_D,positive AfterItemNo,elItem_D ElementItem)->elItem_D* ContentOut determ.
clauses
    tryInsertItem(ContentIn,ItemID,ItemPosition,ElementItem)=ContentOut:-
        Item=tryGetItem(ContentIn,ItemID,ItemPosition),
        AbsolutePosition=list::tryGetIndex(Item,ContentIn),
        !,
        list::split(AbsolutePosition,ContentIn,LeftList,RightList),
        RightList=[Item|Tail],
        ContentOut=list::append(LeftList,[Item,ElementItem|Tail]).
    tryInsertItem(ContentIn,ItemID,0,ElementItem)=ContentOut:-
        ItemList=[Item||Item=list::getMember_nd(ContentIn),isItemCorrespond(ItemID,Item)],
        if ItemList=[] then
            ContentOut=list::append(ContentIn,[ElementItem])
        else
            ItemList=[FirstTypedItem|_],
            AbsolutePosition=list::tryGetIndex(FirstTypedItem,ContentIn),
            list::split(AbsolutePosition,ContentIn,LeftList,RightList),
            ContentOut=list::append(LeftList,[ElementItem|RightList])
        end if.

clauses
    clone(XmlElementTemplate)=XmlElementClone:-
        XmlElementClone=xmlElement::new(XmlElementTemplate:name_P),
        XmlElementClone:parent_P:=XmlElementTemplate:parent_P,

%        XmlElementClone:name_P:=XmlElementTemplate:name_P,
        XmlElementClone:nameSpacePrefix_P:=XmlElementTemplate:nameSpacePrefix_P,
        _Dummy1=[""||
            tuple(AttrPrefix,AttrName,AttrValue)=XmlElementTemplate:getAttribute_nd(),
            XmlElementClone:addAttribute(AttrPrefix,AttrName,AttrValue)],
        _Dummy2=[""||
            tuple(NameSpaceName,NS_Attributes)=XmlElementTemplate:nameSpace_P:getAll_nd(),
                if NS_Attributes= ns_Uri(NS_Uri)
                then
                    URI=NS_Uri
                else
                    NS_Attributes= ns_Writer(NS_Uri,_XmlWriter),
                    URI=NS_Uri
                end if,
                XmlElementClone:nameSpace_P:set(NameSpaceName,ns_Uri(URI))
            ],
        _Dummy3=[""||
            ElementItem=XmlElementTemplate:getItem_nd(),
                if ElementItem= node(_NodeName,ChildElement)
                then
                    ChildElementClone=clone(ChildElement),
                    XmlElementClone:addNode(ChildElementClone)
                else
                    XmlElementClone:addItem(ElementItem)
                end if
            ].

end implement xmlElement
