%

implement formSplittedLayout{@CellID}
    open core

clauses
    new(SplittedForm) :-
        splittedForm_V := SplittedForm.

facts
    splittedForm_V : splitForm{@CellID} := erroneous.
    layoutControls_P : mapM{@CellID CellID, cell_D CellDescriptor} := mapM_RedBlack::new().
    splitControls_V : mapM{@CellID CellID, splittercontrol SplitterControl} := mapM_RedBlack::new().

predicates
    buildElement : (containerWindow Parent, content_D, interContent_D) -> interContent_D.
clauses
    buildLayout(_Parent, [], _Type) :-
        !.
    buildLayout(Parent, [Element | ListTail], Type) :-
        NewType = buildElement(Parent, Element, Type),
        !,
        buildLayout(Parent, ListTail, NewType).

    buildElement(Parent, splitter(Name, Docking), Type) = Type :-
        !,
        Splitter = splittercontrol::new(Parent),
        splitControls_V:set(Name, Splitter),
        Splitter:setPosition(0, 0),
        if Type = col then
            Splitter:setSize(4, 20),
            Splitter:dockStyle := Docking
        elseif Type = row then
            Splitter:setSize(20, 4),
            Splitter:dockStyle := Docking
        end if.
    buildElement(Parent, column(CellID, Width, Border, Docking, ContentList), _Type) = col :-
        !,
        SplitObject = splitContainerControl::new(Parent),
        layoutControls_P:set(CellID, cell(SplitObject, formSplittedLayout::none, "", 0)),
        if Border = border then
            SplitObject:setBorder(true)
        end if,
        SplitObject:setWidth(Width),
        SplitObject:dockStyle := Docking,
        buildLayout(SplitObject, ContentList, col).
    buildElement(Parent, row(CellID, Height, Border, Docking, ContentList), _Type) = row :-
        !,
        SplitObject = splitContainerControl::new(Parent),
        layoutControls_P:set(CellID, cell(SplitObject, formSplittedLayout::none, "", 0)),
        if Border = border then
            SplitObject:setBorder(true)
        end if,
        SplitObject:setHeight(Height),
        SplitObject:dockStyle := Docking,
        buildLayout(SplitObject, ContentList, row).

clauses
    setControls() :-
        _CList =
            [ CellID ||
                splittedForm_V:layoutControl_nd(CellID, Type, Size),
                layoutControls_P:tryGet(CellID) = cell(SplitObject, _ControlObject, _Type, _Size),
                ControlObject = splittedForm_V:createControl(SplitObject, Type),
                layoutControls_P:set(CellID, cell(SplitObject, control(ControlObject), Type, Size))
            ].

clauses
    tryGetControl(CellID) = tuple(ControlContainer, ControlObject, Size) :-
        layoutControls_P:tryGet(CellID) = cell(ControlContainer, control(ControlObject), _Type, Size).

end implement formSplittedLayout
