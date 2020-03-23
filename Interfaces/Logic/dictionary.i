%

interface dictionary
    open core

predicates
    initDictionary:(string NameSpace,string DictionaryFile).

predicates
    getStringByKey : (string Key,string DefaultValue) -> string Value.

end interface dictionary
