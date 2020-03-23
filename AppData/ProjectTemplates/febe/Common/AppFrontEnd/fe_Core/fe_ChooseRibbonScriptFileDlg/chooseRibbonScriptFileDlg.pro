%

implement chooseRibbonScriptFileDlg inherits dialog
    open core, vpiDomains, chooseRbnScriptDlg_Dictionary

facts - scripts
    file_F:(string Name,string FileName,binary BinContent).


facts
    invoker_V:fe_CoreTasks:=erroneous.
    coreDictionary_P:coreDictionary:=erroneous.
    dictionary_P:dictionary:=erroneous.

clauses
    new(Parent,Invoker) :-
        dialog::new(Parent),
        generatedInitialize(),
        invoker_V:=Invoker,
        coreDictionary_P:=chooseRbnScriptDlg_Dictionary::new().

clauses
    setFileCandidates(FileName,BinContent):-
        fileName::getPathAndName(FileName,Path,Name),
        assert(file_F(Name,FileName,BinContent)),
        backendRibbons_LBX_ctl:add(string::format("% (%)",Name,Path)).

clauses
    initData():-
        setText(dictionary_P:getStringByKey(string::concat(coreDictionary_P:nameSpace_P,"/",chooseRbnScript_DlgTitle_C),getText())),
        groupBox_ctl:setText(dictionary_P:getStringByKey(string::concat(coreDictionary_P:nameSpace_P,"/",chooseRbnScript_GBX_Name_C),groupBox_ctl:getText())),
        backendRibbons_LBX_ctl:selectAt(0).

predicates
    onOkClick : button::clickResponder.
clauses
    onOkClick(_Source) = button::defaultAction:-
        Position=backendRibbons_LBX_ctl:tryGetSelectedIndex(),
        FileDescr=backendRibbons_LBX_ctl:getAt(Position),
        [NameSrc|_]=string::split(FileDescr,"("),
        Name=string::trim(NameSrc),
        file_F(Name,FileNameSrc,BinContent),
        !,
        invoker_V:expandRibbon(FileNameSrc,BinContent).
    onOkClick(_Source) = button::defaultAction.

% This code is maintained automatically, do not update it manually.
%  13:09:15-27.10.2019

facts
    ok_ctl : button.
    cancel_ctl : button.
    backendRibbons_LBX_ctl : listBox.
    groupBox_ctl : groupBox.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setText("chooseRibbonScriptFileDlg"),
        setRect(rct(50, 40, 282, 143)),
        setModal(true),
        setDecoration(titlebar([closeButton])),
        setBorder(sizeBorder()),
        setState([wsf_NoClipSiblings]),
        ok_ctl := button::newOk(This),
        ok_ctl:setText("&OK"),
        ok_ctl:setPosition(108, 84),
        ok_ctl:setSize(56, 16),
        ok_ctl:defaultHeight := false,
        ok_ctl:setAnchors([control::right, control::bottom]),
        ok_ctl:setClickResponder(onOkClick),
        cancel_ctl := button::newCancel(This),
        cancel_ctl:setText("Cancel"),
        cancel_ctl:setPosition(172, 84),
        cancel_ctl:setSize(56, 16),
        cancel_ctl:defaultHeight := false,
        cancel_ctl:setAnchors([control::right, control::bottom]),
        backendRibbons_LBX_ctl := listBox::new(This),
        backendRibbons_LBX_ctl:setPosition(8, 14),
        backendRibbons_LBX_ctl:setSize(216, 58),
        backendRibbons_LBX_ctl:setAnchors([control::left, control::top, control::right, control::bottom]),
        backendRibbons_LBX_ctl:setHorizontalScroll(true),
        backendRibbons_LBX_ctl:toolTip := core::none,
        groupBox_ctl := groupBox::new(This),
        groupBox_ctl:setText("BackEnd Ribbon Script Files"),
        groupBox_ctl:setPosition(4, 4),
        groupBox_ctl:setSize(224, 74),
        groupBox_ctl:setAnchors([control::left, control::top, control::right, control::bottom]),
        setDefaultButton(ok_ctl).
% end of automatic code

end implement chooseRibbonScriptFileDlg
