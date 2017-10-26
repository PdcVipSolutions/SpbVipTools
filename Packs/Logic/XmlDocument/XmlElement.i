% Copyright (c) 20016

interface xmlElement
    supports xmlAttributes
    supports xmlNavigate

    open core

domains
    itemTypeID_D=
        text;
        comment;
        cData;
        node;
        all.

domains
    elItem_D=
        text(string);
        comment(string);
        cData(string);
        node(string Name,xmlElement ChildElement).

properties
    name_P:string (o). %ElementName.
    nameSpacePrefix_P:string.

predicates
    addItem:(elItem_D ElementItem).

predicates
    addText:(string TextAsString).

predicates
    addComment:(string TextAsComment).

predicates
    addCData:(string TextAsCData).

predicates
    addNode:(xmlElement ChildElement).

predicates
    removeNode:(xmlElement ChildElement).

predicates
    saveElement:(xmlWriter XmlWriter).

predicates
    count:(itemTypeID_D)->positive ContentPosition.

predicates
    tryGetItem:(itemTypeID_D,positive ItemNo)->elItem_D ElementItem determ.

predicates
    getItem_nd:()->elItem_D ElementItem nondeterm.

predicates
    tryRemoveItem:(itemTypeID_D,positive ItemNo)->elItem_D ElementItem determ.

predicates
    tryModifyItem:(itemTypeID_D,positive ItemNo,elItem_D ElementItem)->elItem_D OldElementItem determ.

predicates
    tryInsertItem:(itemTypeID_D,positive AfterItemNo,elItem_D ElementItem) determ.

predicates
    clearContent:().

end interface xmlElement
