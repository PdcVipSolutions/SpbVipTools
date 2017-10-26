% Copyright (c) 2006

interface xmlAttributes
    supports xmlHierarchy

    open core

constants
    noNS_C:string=".".

properties
     attributes_P:mapM{string NameSpaceName, mapM{string AttrName, string AttrValue}}.

predicates
    isAttributesErroneous:() determ.

predicates
    addAttribute:(string AttrName,string AttrValue).
    addAttribute:(string AttrPrefix,string AttrName,string AttrValue).

    removeAttribute:(string AttrName).
    removeAttribute:(string AttrPrefix,string AttrName).
    tryRemoveAttribute:(string AttrName) determ.
    tryRemoveAttribute:(string AttrPrefix,string AttrName) determ.

    modifyAttribute:(string AttrName,string AttrValue).
    modifyAttribute:(string AttrPrefix,string AttrName,string AttrValue).
    tryModifyAttribute:(string AttrName,string AttrValue) determ.
    tryModifyAttribute:(string AttrPrefix,string AttrName,string AttrValue) determ.

    getAttribute_nd:()->tuple{string AttrPrefix,string AttrName,string AttrValue} nondeterm.
    tryGetAttribute:(string AtrName)->string Value determ.
    tryGetAttribute:(string AttrPrefix,string AtrName)->string Value determ.

predicates
    saveAttributes:(xmlWriter XmlWriter).
predicates
    tryNameSpaceDeclaration:(string NameSpace) -> string NameSpaceUri determ.

end interface xmlAttributes
