%

interface chooseRibbonScriptFileDlg supports dialog
    open core

properties
    coreDictionary_P:coreDictionary.
    dictionary_P:dictionary.

predicates
    setFileCandidates:(string FileName,binary BinContent).

predicates
    initData:().

end interface chooseRibbonScriptFileDlg
