%

implement fe_Dictionary
    inherits fe_Connector

    open core,redBlackTree, pfc\log, edf


facts - dictionary_RBT
    dictionaries_V:entityRegistry{redBlackTree::tree{string, string} DictionaryNS}:=entityRegistry{redBlackTree::tree{string, string} CoreDictionary}::new().

facts
    currentLanguage_P : string:="".
    useDictionary_P:string:="no".

clauses
    new(FrontEnd):-
        fe_Connector::new(FrontEnd).

clauses
    initDictionary("noNameSpace",_DictionaryFileName):-!.
    initDictionary(NameSpace,DictionaryFileName):-
        fe_CoreTasks():add_DictionaryNameSpace(NameSpace,DictionaryFileName).

clauses
    getStringByKey(ItemId,_DefaultValue)= StringValue:-
        string::frontToken(ItemId,NameSpace,ItemIDWithSlash),
        not(NameSpace="noNameSpace"),
        string::frontChar(ItemIDWithSlash,_,Key),
        RB_Tree=dictionaries_V:getEntityByName_nd(NameSpace),
        StringValue=tryLookUp(RB_Tree,Key),
        !.
    getStringByKey(_Key,DefaultValue)=DefaultValue.

facts
    tempDictionary_V:redBlackTree::tree{string, string}:=emptyUnique().

clauses
    setDictionary(av(NameSpace,a(DictionaryItemList))):-
        !,
        tempDictionary_V:=emptyUnique(),
        foreach av(Key,s(Value)) in DictionaryItemList do
            tempDictionary_V:=insert(tempDictionary_V,Key,Value)
        end foreach,
        if _RB_Tree=dictionaries_V:getEntityByName_nd(NameSpace),! then
            dictionaries_V:unRegisterByName(NameSpace)
        end if,
        dictionaries_V:register(NameSpace,tempDictionary_V).
    setDictionary(Dictionary):-
        Msg=string::format("Wrong Dictionary format [%]. Must Look like av(NameSpace,a(av(Key,s(Text)),...])",Dictionary),
        log::write(log::error,Msg),
        exception::raise_User(Msg).

end implement fe_Dictionary
