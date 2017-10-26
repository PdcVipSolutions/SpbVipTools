% Copyright (c) 2006

interface xmlHierarchy
    open core

domains
    ns_Attr_D=
        ns_Writer(string NS_Uri,xmlWriter XMLWriter);
        ns_Uri(string NS_Uri).

    entityType_D=
            element;
            attribute.

properties
    nameSpace_P:mapM{string NameSpaceName, ns_Attr_D NS_Attributes}.
    parent_P:xmlHierarchy.

predicates
    isParentErroneous:() determ.

predicates
    tryGetNameSpaceData:(entityType_D EntityType,xmlWriter CurrentXMLWriter,string NameSpace)->
        tuple{
            mapM{string NameSpaceName, ns_Attr_D NS_Attributes},
            string NSURI,
            xmlWriter NSWriter
            } determ.

end interface xmlHierarchy
