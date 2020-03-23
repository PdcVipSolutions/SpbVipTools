%

interface createOrModifyRbnDictionaryDlg supports dialog
    open core

properties
    coreDictionary_P:coreDictionary.
    dictionary_P:dictionary.

predicates
    setFileCandidates:(tuple{string FileName,string NameSpace,string DictionaryFile}).

predicates
    initData:().

end interface createOrModifyRbnDictionaryDlg
