%

implement splitContainerControl
    inherits userControlSupport
    open core, vpiDomains



clauses
    new(Parent):-
        new(),
        setContainer(Parent).

clauses
    new():-
        userControlSupport::new(),
        generatedInitialize().

facts
    color_P : vpiDomains::color := vpiDomains::color_Aqua.

predicates
    onPaint : window::paintResponder.
clauses
    onPaint(_Source, _Rectangle, GDI):-
        GDI:clear(color_P).

% This code is maintained automatically, do not update it manually. 23:16:35-30.8.2015
predicates
    generatedInitialize : ().
clauses
    generatedInitialize():-
        setText("SplitContainerControl"),
        This:setSize(240, 120),
        setPaintResponder(onPaint).
% end of automatic code
end implement splitContainerControl