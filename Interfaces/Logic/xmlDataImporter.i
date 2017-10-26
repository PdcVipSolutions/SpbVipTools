% Copyright SPBrSolutions

interface xmlDataImporter
    open core

properties
    target_P:object (i).

predicates
    element:(string Prefix,string ElName,tuple{string Prefix,string Name}* Context).
    endElement:(string Prefix,string ElName,tuple{string Prefix,string Name}* Context).

    docType:(tuple{string AttrPrefix,string AttrName,string Value}* DocTypeParams,tuple{string Prefix,string Name}* Context).

    attribute:(string AttrPrefix,string AttrName,string Value,tuple{string Prefix,string Name}* Context).
    text:(string Text,tuple{string Prefix,string Name}* Context).
    cData:(string Value,tuple{string Prefix,string Name}* Context).
    procInstruction:(string Value,tuple{string Prefix,string Name}* Context).
    comment:(string Value,tuple{string Prefix,string Name}* Context).

end interface xmlDataImporter
