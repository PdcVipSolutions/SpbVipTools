%

implement fe_TabpageForm inherits formWindow
    inherits fe_Connector

    open core, vpiDomains

clauses
    display(Parent, FrontEnd) = Form :-
        Form = new(Parent, FrontEnd),
        Form:show().

clauses
    new(Parent, FrontEnd) :-
        formWindow::new(Parent),
        fe_Connector::new(FrontEnd),
        generatedInitialize(),
        initTabControl().

predicates
    initTabControl : ().
clauses
    initTabControl():-
        Page1 = tabPage::new(),
        TabCtrl = fe_Tabcontrol::new(Page1:getContainerControl()),
        TabCtrl:setAnchors([control::left, control::top, control::right, control::bottom]),
        Ribbon = fe_RibbonDefault::new(frontEnd_P),
        Ribbon:onDesign_P:=onDesign,
        Ribbon:onReload_P:=onReload,
        tuple(_,Layout,_) = Ribbon:getRibbonLayout(convert(window,TabCtrl)),
        TabCtrl:ribbonControl_P:layout := Layout,
        Page1:setText("Tab 1"),
        tabControl_ctl:addPage(Page1),
        Page2 = tabPage::new(),
        TabCtrl2 = fe_Tabcontrol::new(Page2:getContainerControl()),
        TabCtrl2:setAnchors([control::left, control::top, control::right, control::bottom]),
        Ribbon2 = fe_RibbonScriptLoadable::new(frontEnd_P),
        Ribbon2:onDesign_P:=onDesign,
        Ribbon2:onReload_P:=onReload,
        tuple(_,Layout2,_) = Ribbon2:getRibbonLayout(convert(window,TabCtrl2)),
        TabCtrl2:ribbonControl_P:layout := Layout2,
        Page2:setText("Tab 2"),
        tabControl_ctl:addPage(Page2).

predicates
    onDesign : (command).
%    designRibbonLayout : ().
clauses
    onDesign(_) :-
        !.
%        designRibbonLayout().
%
%    designRibbonLayout():-
%        Fe_Form=fe_AppWindow(),
%        DesignerDlg = ribbonDesignerDlg::new(convert(window,Fe_Form)),
%        DesignerDlg:cmdHost := convert(window,Fe_Form),
%        DesignerDlg:designLayout := Fe_Form:ribbonControl_P:layout,
%        DesignerDlg:predefinedSections := Fe_Form:ribbonControl_P:layout,
%        DesignerDlg:show(),
%        if DesignerDlg:isOk() then
%            Fe_Form:ribbonControl_P:layout := DesignerDlg:designLayout
%        end if.

predicates
    onReload:(command).
%    reloadRibbonLayout:().
clauses
    onReload(_Command):-
        !.
%        reloadRibbonLayout().
%
%    reloadRibbonLayout():-
%        initRibbon(true).

% This code is maintained automatically, do not update it manually.
%  11:48:50-19.8.2019

facts
    ok_ctl : button.
    cancel_ctl : button.
    help_ctl : button.
    tabControl_ctl : tabcontrol.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setText("fe_TabpageForm"),
        setRect(rct(50, 40, 459, 311)),
        setDecoration(titlebar([closeButton, maximizeButton, minimizeButton])),
        setBorder(sizeBorder()),
        setState([wsf_ClipSiblings, wsf_ClipChildren]),
        menuSet(noMenu),
        ok_ctl := button::newOk(This),
        ok_ctl:setText("&OK"),
        ok_ctl:setPosition(217, 249),
        ok_ctl:setSize(56, 16),
        ok_ctl:defaultHeight := false,
        ok_ctl:setAnchors([control::right, control::bottom]),
        cancel_ctl := button::newCancel(This),
        cancel_ctl:setText("Cancel"),
        cancel_ctl:setPosition(281, 249),
        cancel_ctl:setSize(56, 16),
        cancel_ctl:defaultHeight := false,
        cancel_ctl:setAnchors([control::right, control::bottom]),
        help_ctl := button::new(This),
        help_ctl:setText("&Help"),
        help_ctl:setPosition(345, 249),
        help_ctl:setSize(56, 16),
        help_ctl:defaultHeight := false,
        help_ctl:setAnchors([control::right, control::bottom]),
        tabControl_ctl := tabcontrol::new(This),
        tabControl_ctl:setPosition(8, 6),
        tabControl_ctl:setSize(392, 236),
        tabControl_ctl:setAnchors([control::left, control::top, control::right, control::bottom]).
% end of automatic code

end implement fe_TabpageForm
