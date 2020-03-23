%

interface coreDictionary
    open core

properties
    nameSpace_P:string (o).
    fileName_P:string (o).

predicates
    getItem:(string ItemID ,string ItemString ,string Meaning) nondeterm (i,o,o) nondeterm (o,o,o).

predicates
    getItemList:()->tuple{string ItemId,string ItemValue,string ItemMeaning}*.

end interface coreDictionary
