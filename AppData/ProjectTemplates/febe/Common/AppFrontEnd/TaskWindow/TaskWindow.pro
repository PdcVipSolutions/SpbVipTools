% Copyright (c) Prolog Development Center SPb

implement taskWindow
    inherits applicationWindow
    inherits fe_Connector

    open core, vpiDomains, ribbonControl, pfc\log
    open coreIdentifiers,  edf

constants
    mdiProperty : boolean = true.

facts
    fe_Command_P:fe_Command := erroneous.
    progress_P : core::predicate{integer,string} := {(_,_):-succeed}.
    backEndStatus_V: circleIndicator:=circleIndicator::new().

clauses
    new(FrontEnd) :-
        applicationWindow::new(),
        fe_Connector::new(FrontEnd),
        succeed().

predicates
    onShow : window::showListener.
clauses
    onShow(_, _CreationData):-
        navigationOverlay::initMDI(This, ribbonControl_ctl:getNavigationPoints),
        if statusBarControl_V:cells = [_, _, _, Cell3] then
            Cell3:control := some(backEndStatus_V)
        end if,
        _MessageForm = messageForm::display(This).

class predicates
    onDestroy : window::destroyListener.
clauses
    onDestroy(_).

predicates
    onFileExit : window::menuItemListener.
clauses
    onFileExit(_, _MenuTag) :-
        close().

predicates
    onSizeChanged : window::sizeListener.
clauses
    onSizeChanged(_).

clauses
    initContent(FrontEnd):-
        generatedInitialize(),
        ribbonControl_ctl := ribboncontrol::new(),
        addControl(ribbonControl_ctl),
        fe_Command_P:=fe_Command::new(This,FrontEnd),
        fe_CoreTasks():getDictionary(),
        createStatusBar(),
        fe_Command_P:initRibbon(false),
        fe_Command_P:setMenu(),
        setTitle().

facts
    ribbonControl_ctl : ribboncontrol.
clauses
    ribbonControl_P() = ribbonControl_ctl.

clauses
    setTitle():-
        TitleStr = string::format("$$(Project.Name)App - %s (%s) %s ", ""/*AppName*/, "" /*Path */, "" /*ReadOnly*/),
        setText(TitleStr).

facts
    statusBarControl_V : statusBarControl := erroneous.
    progressBar_V : progressBarControl := erroneous.

predicates
    createStatusBar : ().
clauses
    createStatusBar() :-
        statusBarControl_V := statusBarControl::new(),
        addControl(statusBarControl_V),
        Cell1 = statusBarCell::new(statusBarControl_V, 300),
        CellPB = statusBarCell::new(statusBarControl_V, 200), % progress bar
        Cell2 = statusBarCell::new(statusBarControl_V, 300),
        Cell3 = statusBarCell::new(statusBarControl_V, 50),
        statusBarControl_V:cells := [Cell1, CellPB, Cell2, Cell3],
        backEndStatus_V:=circleIndicator::new(statusBarControl_V),
        backEndStatus_V:setWidth(10),
        backEndStatus_V:setHeight(statusBarControl_V:getHeight()),
        backEndStatus_V:setColor(vpiDomains::color_Yellow),
        setStatusBar().

clauses
    setStatusBar():-
        progress_P := statusBar_set.

clauses
    showBackEndStatus(true):-
        backEndStatus_V:setColor(vpiDomains::color_green).
    showBackEndStatus(false):-
        backEndStatus_V:setColor(vpiDomains::color_red).

predicates
    statusBar_set : (integer CellNumber,string Text).
clauses
    statusBar_set(CellNumber, Text) :-
        if Cell = list::tryGetNth(CellNumber-1, statusBarControl_V:cells) then
            Cell:text := Text
        end if.

clauses
    progressBar_activate(Count) :-
        progressBar_V := progressBarControl::new(statusBarControl_V),
        if Count <= 1 then
            progressBar_V:marquee_style := true
        else
            progressBar_V:setRange(0, Count)
        end if,
        progressBar_V:show(),
        progressBar_V:useTaskBarList := true,
        if Count <= 1 then
            progressBar_V:autoMarqueeMode := true,
            progressBar_V:autoMarqueeMs := 100
        end if,
        [_, CellPB, _, _] == statusBarControl_V:cells,
        CellPB:control := some(progressBar_V).

clauses
    progressBar_progress(Count) :-
        if not(isErroneous(progressBar_V)) then
            progressBar_V:progress := Count
        end if.

clauses
    progressBar_remove() :-
        [_, CellPB, _, _] == statusBarControl_V:cells,
        CellPB:control := core::none(),
        progressBar_V := erroneous.

predicates
    onClose : frameDecoration::closeResponder.
clauses
    onClose(_Source) = frameDecoration::acceptClose :-
        !,
        OptionList=[s(lastFolder_C), s(lastRibbonLayout_C), s(currentLanguage_C),
                        s(ribbonStartup_C), s(useDictionary_C), s(ribbonState_C),  s(lastLanguage_C)],
        fe_CoreTasks():saveFrontEndOptions(a(OptionList)),
        fe_CoreTasks():saveOptions(),
        forgetObjects(),
        mainEventManager():appEvent_P:notify(0),
        succeed().

predicates
    forgetObjects:().
clauses
    forgetObjects():-
        fe_Command_P := erroneous,
        progress_P := erroneous,
        ribbonControl_ctl := erroneous,
        statusBarControl_V := erroneous,
        progressBar_V := erroneous,
        succeed().

predicates
    onHelpContents : window::menuItemListener.
clauses
    onHelpContents(_Source, _MenuTag):-
        fe_Tasks():help("NoNameSpace").

predicates
    onHelpAbout : window::menuItemListener.
clauses
    onHelpAbout(_Source, _MenuTag):-
        fe_Tasks():about("NoNameSpace").

% This code is maintained automatically, do not update it manually.
%  17:09:06-20.3.2020

predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setText("$$(Project.Name)_MDI_Mono"),
        setDecoration(titlebar([closeButton, maximizeButton, minimizeButton])),
        setBorder(sizeBorder()),
        setState([wsf_ClipSiblings]),
        setMdiProperty(mdiProperty),
        menuSet(resMenu(resourceIdentifiers::mnu_TaskMenu)),
        addShowListener(onShow),
        addSizeListener(onSizeChanged),
        setCloseResponder(onClose),
        addDestroyListener(onDestroy),
        addMenuItemListener(resourceIdentifiers::id_help_contents, onHelpContents),
        addMenuItemListener(resourceIdentifiers::id_help_about, onHelpAbout).
% end of automatic code

end implement taskWindow
