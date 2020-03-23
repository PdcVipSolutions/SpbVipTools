% Copyright (c) Prolog Development Center SPb
%

implement defaultDictionary
    open core

facts
    nameSpace_P : string := "basic".
    fileName_P : string := @"$$(Project.Name)AppData\basic_Dictionary.xml".

clauses
    getItem(ItemID, ItemString, Meaning) :-
        item_F(ItemID, ItemString, Meaning).

clauses
    getItemList() = [ tuple(ItemID, ItemString, Meaning) || item_F(ItemID, ItemString, Meaning) ].

facts
    item_F : (string ItemID, string ItemString, string Meaning).

clauses
    item_F(ribbon_default_section_basic_C, "Help", "Help Section with About and Features commands").
    item_F(ribbon_default_section_basic_tooltip_C, "Help", "Ribbon.Section.Default tooltip, when no ribbon file exists").

    item_F(ribbon_default_section_C, "Initial", "Ribbon.Section.Default, when no ribbon file exists").
    item_F(ribbon_default_section_tooltip_C, "Initial", "Ribbon.Section.Default tooltip, when no ribbon file exists").

    item_F(ribbon_default_cmd_options_C, "Options", "Label of default Ribbon Options button").
    item_F(ribbon_default_cmd_options_tooltip_C, "Options Regarding This application", "Tooltip of default Ribbon Options button").

    item_F(ribbon_default_cmd_help_C, "Help", "Label of default Ribbon Help button").
    item_F(ribbon_default_cmd_help_tooltip_C, "Help Regarding This application", "Tooltip of default Ribbon Help button").

    item_F(ribbon_default_cmd_about_C, "About", "Title Ribbon default button About").
    item_F(ribbon_default_cmd_about_tooltip_C, "About This Application", "Tooltip of default Ribbon button About").

    item_F(ribbon_default_cmd_design_C, "Design", "Title Ribbon default button design, when no ribbon script file exists").
    item_F(ribbon_default_cmd_design_tooltip_C, "Design the ribbon layout, when no ribbon script file exists",
            "Tooltip of default Ribbon button design, when no ribbon script file exists").

    item_F(ribbon_default_cmd_expand_C, "Expand", "Title Ribbon default button expand, when no ribbon script file exists").
    item_F(ribbon_default_cmd_expand_tooltip_C, "Expand the ribbon layout",
            "Tooltip of default Ribbon button expand, when no ribbon script file exists").

    item_F(ribbon_default_cmd_reload_C, "Reload", "Title Ribbon default button reload, when no ribbon script file exists").
    item_F(ribbon_default_cmd_reload_tooltip_C, "Reload the ribbon layout",
            "Tooltip of default Ribbon button design, when no ribbon script file exists").

    item_F(helpFile_C, "appHead_CookBookEn.chm", "Current config Demo HelpFileName").

end implement defaultDictionary
