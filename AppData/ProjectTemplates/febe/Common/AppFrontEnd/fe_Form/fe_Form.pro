/*****************************************************************************
Copyright (c) Prolog Development Center SPB

******************************************************************************/
implement fe_Form
    inherits formWindow
    inherits formSplittedLayout{string}
    inherits fe_Connector

    open edf, coreIdentifiers
    open core, vpiDomains, ribbonControl, control, pfc\log

facts
    fe_Command_P:fe_Command := erroneous.
    progress_P : core::predicate{integer,string} := {(_,_):-succeed}.
    backEndStatus_V: circleIndicator:=circleIndicator::new().

clauses
    new(FrontEnd):-
        fe_Connector::new(FrontEnd),
        formWindow::new(This),
        formSplittedLayout{string}::new(This).

clauses
    new(Parent,FrontEnd):-
        fe_Connector::new(FrontEnd),
        formWindow::new(Parent),
        formSplittedLayout{string}::new(This).

clauses
    initContent(FrontEnd):-
        generatedInitialize(),
        fe_Command_P:=fe_Command::new(This,FrontEnd),
        fe_CoreTasks():getDictionary(),
        createStatusBar(),
        buildLayout(This,layout_C,notSet),
        setControls(),
        fe_Command_P:initRibbon(false),
        fe_Command_P:setMenu(),
        setTitle().

clauses
    ribbonControl_P() = ribbonControl_ctl.

constants
    contentRow_C:string="R1".
    horizSplitter_C:string="HS1".
    messages_C:string="R2".
    selector_C:string="R1C1".
    vertSplitter_C:string="VS1".
    content_C:string="R1C2".

constants
    layout_C:content_D*=
        [
        row(contentRow_C,250,formSplittedLayout::border,control::dockTop,
            [
            column(selector_C,160,formSplittedLayout::border,control::dockLeft,[]),
            splitter(vertSplitter_C,control::dockLeft),
            column(content_C,200,formSplittedLayout::border,control::dockFill,[])
            ]),
        splitter(horizSplitter_C,control::dockTop),
        row(messages_C,150,formSplittedLayout::border,control::dockfill,[])
        ].

clauses
    layoutControl_nd(selector_C,"selector",56).
    layoutControl_nd(content_C,"content",70).
    layoutControl_nd(messages_C,"message",100).

clauses
    createControl(Container,"selector") = ContainerControl :-
        !,
        ContainerControl = containerControl::new(Container),
        ContainerControl:dockStyle := control::dockFill,
        succeed().
    createControl(Container,"message")=Control:-
        !,
        Control = messageControl::new(Container),
        Control:dockStyle := control::dockfill,
        stdio::outputStream := Control:outputStream,
        succeed().
    createControl(Container,"content")= ContainerControl :-
        ContainerControl = containerControl::new(Container),
        ContainerControl:dockStyle := control::dockFill,
        succeed().

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
        statusBarControl_V := statusBarControl::new(This),
        Cell1 = statusBarCell::new(statusBarControl_V, 300),
        CellPB = statusBarCell::new(statusBarControl_V, 200), % progress bar
        Cell2 = statusBarCell::new(statusBarControl_V, 300),
        Cell3 = statusBarCell::new(statusBarControl_V, 50),
        statusBarControl_V:cells := [Cell1, CellPB, Cell2, Cell3],
           backEndStatus_V:=circleIndicator::new(statusBarControl_V),
           backEndStatus_V:setWidth(20),
           backEndStatus_V:setHeight(20),
           backEndStatus_V:setColor(vpiDomains::color_Yellow),
        setStatusBar().

clauses
    setStatusBar():-
        progress_P := statusBar_set.

predicates
    statusBar_set : (integer CellNumber,string Text).
clauses
    statusBar_set(CellNumber, Text) :-
        if Cell = list::tryGetNth(CellNumber-1, statusBarControl_V:cells) then
            Cell:text := Text
        end if.

clauses
    showBackEndStatus(true):-
        backEndStatus_V:setColor(vpiDomains::color_green).
    showBackEndStatus(false):-
        backEndStatus_V:setColor(vpiDomains::color_red).

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
        if fe_CoreTasks():backEndAlive_P=true then
            OptionList=
                [
                    s(lastFolder_C),
                    s(lastRibbonLayout_C),
                    s(currentLanguage_C),
                    s(ribbonStartup_C),
                    s(useDictionary_C),
                    s(ribbonState_C),
                    s(lastLanguage_C)
                ],
            fe_CoreTasks():saveFrontEndOptions(a(OptionList)),
            fe_CoreTasks():saveOptions()
        end if,
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
    onShow : window::showListener.
clauses
    onShow(_Source, _Data):-
        if statusBarControl_V:cells = [_, _, _, Cell] then
            Cell:control := some(   backEndStatus_V)
        end if.

% This code is maintained automatically, do not update it manually.
%  23:40:12-11.7.2019

facts
    ribbonControl_ctl : ribboncontrol.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setText("$$(Project.Name)Form"),
        setRect(rct(100, 100, 800, 500)),
        setDecoration(titlebar([closeButton, maximizeButton, minimizeButton])),
        setBorder(sizeBorder()),
        setState([wsf_ClipSiblings, wsf_ClipChildren]),
        menuSet(noMenu),
        addShowListener(onShow),
        setCloseResponder(onClose),
        ribbonControl_ctl := ribboncontrol::new(This),
        ribbonControl_ctl:setPosition(12, 4),
        ribbonControl_ctl:setSize(232, 16),
        ribbonControl_ctl:dockStyle := control::dockTop.
% end of automatic code


end implement fe_Form