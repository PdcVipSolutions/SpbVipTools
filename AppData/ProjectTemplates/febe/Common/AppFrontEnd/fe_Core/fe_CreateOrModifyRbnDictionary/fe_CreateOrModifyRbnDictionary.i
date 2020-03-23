%

interface fe_CreateOrModifyRbnDictionary
    open core

predicates
    onCreateOrModifyRbnDictionary:().

predicates
    performTask:(boolean TrueIfFrontEndFile,string ScriptFileName,string NameSpace,string DictionaryFile,boolean ModifySourceScript).

end interface fe_CreateOrModifyRbnDictionary
