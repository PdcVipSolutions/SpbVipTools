%
%

implement createRbnDictionaryDlg_Dictionary
    open core

facts
    nameSpace_P : string := "createRbnDictionaryDlg".
    fileName_P : string := @"$$(Project.Name)AppData\createRbnDictionaryDlg_Dictionary.xml".

clauses
    getItem(ItemID, ItemString, Meaning) :-
        item_F(ItemID, ItemString, Meaning).

clauses
    getItemList() = [ tuple(ItemID, ItemString, Meaning) || item_F(ItemID, ItemString, Meaning) ].

facts
    item_F : (string ItemID, string ItemString, string Meaning).

clauses
    item_F(scriptFilename_STT_C,"RibbonScript FileName","New Ribbon Dictionary Dialog.scriptFilename_STT").
    item_F(namespace_STT_C,"Dictionary NameSpace","New Ribbon Dictionary Dialog.namespace_STT").
    item_F(dictionaryFileName_STT_C,"Dictionary FileName","New Ribbon Dictionary Dialog.dictionaryFileName_STT").
    item_F(browse_PB_C,"Browse","New Ribbon Dictionary Dialog.browse_PB").
    item_F(modifySourceScript_CHB_C," Modify Source Script","New Ribbon Dictionary Dialog.modifySourceScript_CHB").
    item_F(modifySourceScript_CHB_C," Modify Source Script","New Ribbon Dictionary Dialog.modifySourceScript_CHB").
    item_F(dialogTitle_C,"Create New Ribbon Dictionary","New Ribbon Dictionary Dialog. DialogTitle").

end implement createRbnDictionaryDlg_Dictionary
