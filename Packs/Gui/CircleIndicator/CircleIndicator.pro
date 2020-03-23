/*****************************************************************************

Copyright (c) Victor Yukhtenko

******************************************************************************/
implement circleIndicator
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
    color_V:vpiDomains::color:=vpiDomains::color_red.

clauses
    setColor(Color):-
        color_V:=Color,
        invalidate().

predicates
    onPaint : window::paintResponder.
clauses
    onPaint(_Source, _Rectangle, GDIObject):-
        GDIObject:setPen(pen(2,ps_Solid,color_Black)),
        GDIObject:setBrush(vpiDomains::brush (vpiDomains::pat_Solid,color_V)),
        getSize(Width,Height),
        pnt(WidthPxl,HeightPxl)=getTopLevelContainerWindow():pntUnit2Pixel(pnt(Width,Height)),
        MinSize=math::min(WidthPxl,HeightPxl),
        VertAxis=math::round(WidthPxl/2),
        HorAxis=math::round(HeightPxl/2),
        HalfMinSize=math::round(MinSize/2)-2,
        GDIObject:drawEllipse(rct(VertAxis-HalfMinSize,HorAxis-HalfMinSize,VertAxis+HalfMinSize,HorAxis+HalfMinSize)).

% This code is maintained automatically, do not update it manually. 17:34:26-25.5.2009
facts

predicates
    generatedInitialize : ().
clauses
    generatedInitialize():-
        setText("CircleIndicator"),
        This:setSize(56, 36),
        setPaintResponder(onPaint).
% end of automatic code

end implement circleIndicator
