% Copyright SPBrSolutions

class spbXmlLigntSupport
    open core

predicates
    read : (inputStream Input, xmlDataImporter).

predicates
    tryFindDocumentID:(inputStream Input, string* PossibleDocuments)->string DocumentID determ.

end class spbXmlLigntSupport