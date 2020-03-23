%

implement fe_Options inherits dialog
    inherits fe_Connector

    open core, vpiDomains
    open optionsDlg_Dictionary, coreIdentifiers%, edf

facts
    coreDictionary_P:coreDictionary:=erroneous.
    dictionary_P:dictionary:=erroneous.

clauses
    new(Parent, FrontEnd, _SettingsList) :-
        fe_Connector::new(FrontEnd),
        dialog::new(Parent),
        generatedInitialize(),
        coreDictionary_P:=optionsDlg_Dictionary::new().

clauses
    initData():-
        %---
        Page1 = tabPage::new(),
        %---
        Page2 = tabPage::new(),
        tabControl_ctl:addPage(Page1),
        tabControl_ctl:addPage(Page2),
        if fe_Dictionary():useDictionary_P=useDictionaryNo_C then
            Page1:setText("Misc"),
            Page2:setText("AppSettings")
        else
            NameSpace=coreDictionary_P:nameSpace_P,
            setText(fe_Dictionary():getStringByKey(string::concat(NameSpace,@"\",dialog_options_title_C),"Options")),
            cancel_ctl:setText(fe_Dictionary():getStringByKey(string::concat(NameSpace,@"\",dialog_options_pb_Cancel_C),"Cancel")),
            Page1:setText(fe_Dictionary():getStringByKey(string::concat(NameSpace,@"\",dialog_options_tab_misc_C),"Misc.")),
            Page2:setText(fe_Dictionary():getStringByKey(string::concat(NameSpace,@"\",dialog_options_tab_appconfig_C),"Config"))
        end if.

% This code is maintained automatically, do not update it manually.
%  23:48:38-8.6.2019

facts
    ok_ctl : button.
    cancel_ctl : button.
    tabControl_ctl : tabcontrol.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setText("fe_Options"),
        setRect(rct(50, 40, 290, 293)),
        setModal(true),
        setDecoration(titlebar([closeButton])),
        setState([wsf_NoClipSiblings]),
        tabControl_ctl := tabcontrol::new(This),
        tabControl_ctl:setPosition(4, 4),
        tabControl_ctl:setSize(232, 226),
        tabControl_ctl:setText("TabControl"),
        ok_ctl := button::newOk(This),
        ok_ctl:setText("&OK"),
        ok_ctl:setPosition(116, 234),
        ok_ctl:setSize(56, 16),
        ok_ctl:defaultHeight := false,
        ok_ctl:setAnchors([control::right, control::bottom]),
        cancel_ctl := button::newCancel(This),
        cancel_ctl:setText("Cancel"),
        cancel_ctl:setPosition(180, 234),
        cancel_ctl:setSize(56, 16),
        cancel_ctl:defaultHeight := false,
        cancel_ctl:setAnchors([control::right, control::bottom]).
% end of automatic code

end implement fe_Options
