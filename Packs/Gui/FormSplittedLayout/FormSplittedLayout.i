%

interface formSplittedLayout {@CellID}
    open core

domains
    interContent_D=
        col;
        row;
        notSet.

    border_D=
        border;
        noBorder.

    content_D=
        splitter(@CellID CellID,control::dockStyle Docking);
        row(@CellID CellID,integer Height,border_D,control::dockStyle Docking,content_D* Content);
        column(@CellID CellID,integer Width,border_D,control::dockStyle Docking,content_D* Content).

    control_D=
        none;
        control(control).

domains
    cell_D=cell(
        splitContainerControl ContainerControl,
        control_D ActualControl,
        string TypeID,
        integer Size).

predicates
    buildLayout:(containerWindow Parent,content_D*, interContent_D).

predicates
    setControls:().

predicates
    tryGetControl:(@CellID AreaName)->tuple{splitContainerControl ControlContainer,control Control,integer Size} determ.

end interface formSplittedLayout