% Copyright (c) Prolog Development Center Spb
%
implement chooseRbnScriptDlg_Dictionary
    open core

facts
    nameSpace_P:string:="chooseRbnScriptDlg".
    fileName_P:string:=@"$$(Project.Name)AppData\chooseRbnScriptDlg_Dictionary.xml".

clauses
    getItem(ItemID, ItemString, Meaning) :-
        item_F(ItemID, ItemString, Meaning).
clauses
    getItemList()=[tuple(ItemID ,ItemString ,Meaning)||item_F(ItemID ,ItemString ,Meaning)].

facts
    item_F : (string ItemID, string ItemString, string Meaning).

clauses
    item_F(chooseRbnScript_GBX_Name_C, "BackEnd Ribbon Script Files Available", "Expand Ribbon - Choose RibbonScript file Dialog: groupBox Name").
    item_F(chooseRbnScript_DlgTitle_C, "Choose Script to Expand the Ribbon", "Expand Ribbon - Choose RibbonScript file Dialog: Dialog Title").

end implement chooseRbnScriptDlg_Dictionary
