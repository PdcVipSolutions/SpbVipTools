% Prolog Development Center SPb

interface dictionarySupport
    open core

properties
    languageList_P:namedValue_list.
    nameSpace_P:string.
    dictionaryFileName_P:string.
    modifyScript_P:boolean.
    saveDictionary_P:boolean.

predicates
    doIt:()->value ScriptNewContent. % if input data was BinContent

    doIt:(tuple{string ItemId,string ItemValue,string ItemMeaning}*)->xmlDocument DictionaryXmlDocument.

    createDictionaryXmlDocument:()->xmlDocument DictionaryXmlDocument.

end interface dictionarySupport
