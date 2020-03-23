%

interface fe_Dictionary
    supports dictionary
    open core

properties
    currentLanguage_P : string.
    useDictionary_P:string.

predicates
    setDictionary : (edf::edf_D DictionaryNameSpaceAndContent).

end interface fe_Dictionary
