%

implement fe_Tabcontrol inherits userControlSupport
    open core

clauses
    new(Parent) :-
        new(),
        setContainer(Parent).

facts
    ribbonControl_ctl : ribboncontrol.

clauses
    new() :-
        userControlSupport::new(),
        generatedInitialize(),
        ribbonControl_ctl := ribboncontrol::new(This),
        ribbonControl_ctl:dockStyle := control::dockTop.

clauses
    ribbonControl_P() = ribbonControl_ctl.

% This code is maintained automatically, do not update it manually.
%  12:45:54-19.8.2019

facts
    listbox_ctl : listBox.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setText("fe_Tabcontrol"),
        This:setSize(224, 136),
        listbox_ctl := listBox::new(This),
        listbox_ctl:setPosition(56, 50),
        listbox_ctl:setSize(68, 62),
        listbox_ctl:setAnchors([control::left, control::top, control::right, control::bottom]).
% end of automatic code

end implement fe_Tabcontrol
