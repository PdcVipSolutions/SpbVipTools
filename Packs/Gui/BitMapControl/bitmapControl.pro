/*****************************************************************************

Copyright (c) Victor Yukhtenko

******************************************************************************/
implement bitmapControl
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
    picture_V:vpiDomains::picture:=erroneous.
clauses
    setPicture(PicturToBeShown):-
        picture_V:=PicturToBeShown.

predicates
    onPaint :  window ::paintResponder.
clauses
    onPaint(_Source, _Rectangle, _GDIObject):-
        isErroneous(picture_V),
        !.
    onPaint(_Source, _Rectangle, GDIObject):-
        GDIObject:pictDraw(picture_V,pnt(0,0),vpiDomains::rop_SrcCopy).

% This code is maintained automatically, do not update it manually. 12:04:32-25.9.2006
facts

predicates
    generatedInitialize : ().
clauses
    generatedInitialize():-
        setText("bitmapControl"),
        This:setSize(132, 120),
        setPaintResponder(onPaint).
% end of automatic code
end implement bitmapControl
