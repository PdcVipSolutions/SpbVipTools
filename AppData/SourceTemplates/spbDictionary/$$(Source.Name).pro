%
$$(Source.Namespace)

implement $$(Source.NameFull)
    open core

facts
    nameSpace_P:string:="$$(Source.NameFull)".
    fileName_P:string:="$$(Source.NameFull).xml".

clauses
    getItem(ItemID, ItemString, Meaning) :-
        item_F(ItemID, ItemString, Meaning).
clauses
    getItemList()=[tuple(ItemID ,ItemString ,Meaning)||item_F(ItemID ,ItemString ,Meaning)].

facts
    item_F : (string ItemID, string ItemString, string Meaning).

clauses
    item_F(itemName_C, "ItemContent", "Item Content Explanation").

end implement $$(Source.Name)
