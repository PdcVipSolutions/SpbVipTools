% Copyright (c) 2006

class xmlElement : xmlElement
    open core

constructors
    new:(string NameSpace, string ElementName,xmlHierarchy ParentElement).
    new:(string ElementName,xmlHierarchy ParentElement).
    new:(string ElementName).

predicates
    clone:(xmlElement XmlElementTemplate)->xmlElement XmlElementClone.

end class xmlElement