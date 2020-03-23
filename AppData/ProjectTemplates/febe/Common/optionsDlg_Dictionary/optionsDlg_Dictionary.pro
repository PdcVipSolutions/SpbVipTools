%
%

implement optionsDlg_Dictionary
    open core

facts
    nameSpace_P : string := "optionsDlg".
    fileName_P : string := @"$$(Project.Name)AppData\optionsDlg_Dictionary.xml".

clauses
    getItem(ItemID, ItemString, Meaning) :-
        item_F(ItemID, ItemString, Meaning).

clauses
    getItemList() = [ tuple(ItemID, ItemString, Meaning) || item_F(ItemID, ItemString, Meaning) ].

facts
    item_F : (string ItemID, string ItemString, string Meaning).

clauses
    item_F(dialog_options_title_C, "Application Options", "Option Dialog title").
    item_F(dialog_options_pb_Cancel_C, "Cancel", "Option Dialog button \"Cancel\"").

    item_F(dialog_options_tab_misc_C, "Misc", "Title of Misc Tab of Opttions dialog").
    item_F(dialog_options_tab_appconfig_C, "AppConfig", "Title of Application Config Tab of Options dialog").

end implement optionsDlg_Dictionary
