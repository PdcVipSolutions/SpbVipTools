%

interface be_Dictionary
    open core, edf

constants
    version_C="version".
    xmlDictionaryScriptVersion_C="10.06.2019".
    dictionaryRootName_C="language".
    substitute_C="subst".
    id_C="id".

predicates
    create_CoreDictionary:(string NameSpace,string FileName,tuple{string ItemId,string ItemValue,string ItemMEaning}*).

predicates
    tryAdd_DictionaryNameSpace:(string NameSpace,string DictionaryXmlFile) determ.
    remove_DictionaryNameSpace:(string NameSpace).

predicates
    getDictionary_nd : () -> edf_D nondeterm.
    getDictionary : (string NameSpace) -> edf_D DictionaryItemList.
    getLanguageList : () -> edf_D LanguageList_Structure.
    removeExtraLanguagesFromAllDictionaries:().

end interface be_Dictionary
