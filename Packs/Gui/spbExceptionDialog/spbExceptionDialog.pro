%

implement spbExceptionDialog inherits dialog
    open core, vpiDomains,exception

clauses
    displayMsg(Parent,ShortDescription,DetailedDescription):-
        Dialog = newMsg(Parent,ShortDescription,DetailedDescription),
        Dialog:show().

    displayError(Parent,TraceID,UserMessage):-
        Dialog = newError(Parent,TraceID,UserMessage),
        Dialog:show().

clauses
    newMsg(Parent,ShortDescription,DetailedDescription):-
        dialog::new(Parent),
        generatedInitialize(),
        showText(ShortDescription,DetailedDescription).

    newError(Parent,TraceID,UserMessage):-
        dialog::new(Parent),
        generatedInitialize(),
        showError(TraceID,UserMessage).

predicates
    showText:(string ShortDescription,string DetailedDescription).
    showError:(traceID TraceID,string UserMessage).
clauses
    showText(ShortDescription,DetailedDescription):-
        details_ctl:setText(DetailedDescription),
        short_ctl:setText(ShortDescription).

    showError(TraceID,UserMessage):-
        tuple(ShortInfo,DetailedInfo)=exceptionHandlingSupport::new():getExceptionInfo(TraceID),
        short_ctl:setText(string::concat(ShortInfo,UserMessage)),
        details_ctl:setText(DetailedInfo),
        succeed().

facts - flipFlop_FB
    opened_V:boolean:=false.
constants
    openDetailsTitle_C=">>>".
    hideDetailsTitle_C="<<<".

predicates
    onOkClick : button::clickResponder.
clauses
    onOkClick(_Source) = button::defaultAction.

predicates
    onSizeClick : button::clickResponder.
clauses
    onSizeClick(_Source) = button::defaultAction:-
        opened_V=true,
        !,
        opened_V:=false,
        details_ctl:setVisible(false),
        details_ctl:setAnchors([control::left, control::top, control::right]),
        rct(_, _, _, B) = ok_ctl:getClientRect(),
        getClientSize(W,_H),
        setClientSize(W, B+8),
        ok_ctl:setAnchors([control::left, control::bottom]),
        size_ctl:setAnchors([control::right, control::bottom]),
        short_ctl:setAnchors([control::left, control::right, control::top, control::bottom]),
        size_ctl:setText(openDetailsTitle_C).
    onSizeClick(_Source) = button::defaultAction:-
        ok_ctl:setAnchors([control::left, control::top]),
        size_ctl:setAnchors([control::right, control::top]),
        short_ctl:setAnchors([control::left, control::right, control::top]),
        short_ctl:getClientSize(CtrlW, _),
        rct(L, _, _, B) = ok_ctl:getClientRect(),
        details_ctl:getClientSize(_, CtrlH),
        ShowDetailHeight = B + CtrlH + 16,
        getClientSize(W,_H),
        setClientSize(W, ShowDetailHeight),
        details_ctl:setAnchors([control::left, control::top, control::right, control::bottom]),
        details_ctl:setClientRect(rct(L, B+8, L+CtrlW, B+CtrlH+8)),
        details_ctl:setVisible(true),
        opened_V:=true,
        size_ctl:setText(hideDetailsTitle_C).

predicates
    onShow : window::showListener.
clauses
    onShow(_Source, _Data):-
        getOuterSize(Width, Height),
        setMinimizeSize(Width, Height).

% This code is maintained automatically, do not update it manually.
%  13:48:51-9.8.2019

facts
    ok_ctl : button.
    size_ctl : button.
    short_ctl : textControl.
    details_ctl : editControl.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setText("spbExceptionDialog"),
        setRect(rct(50, 40, 290, 132)),
        setModal(true),
        setDecoration(titlebar([closeButton])),
        setBorder(sizeBorder()),
        setState([wsf_NoClipSiblings]),
        addShowListener(onShow),
        ok_ctl := button::newOk(This),
        ok_ctl:setText("Close"),
        ok_ctl:setPosition(4, 72),
        ok_ctl:setSize(56, 16),
        ok_ctl:defaultHeight := false,
        ok_ctl:setAnchors([control::left, control::bottom]),
        ok_ctl:setClickResponder(onOkClick),
        size_ctl := button::new(This),
        size_ctl:setText(">>>"),
        size_ctl:setPosition(180, 72),
        size_ctl:setWidth(56),
        size_ctl:defaultHeight := true,
        size_ctl:setAnchors([control::right, control::bottom]),
        size_ctl:defaultHeight := false,
        size_ctl:setClickResponder(onSizeClick),
        short_ctl := textControl::new(This),
        short_ctl:setText("Short Error Description"),
        short_ctl:setPosition(4, 4),
        short_ctl:setSize(232, 64),
        short_ctl:setTabStop(true),
        short_ctl:setAnchors([control::left, control::top, control::right, control::bottom]),
        short_ctl:setBorder(true),
        details_ctl := editControl::new(This),
        details_ctl:setText("Edit"),
        details_ctl:setPosition(4, 92),
        details_ctl:setWidth(232),
        details_ctl:setHeight(174),
        details_ctl:setAnchors([control::left, control::top, control::right]),
        details_ctl:setVisible(false),
        details_ctl:setMultiLine(),
        details_ctl:setVScroll(),
        details_ctl:setAutoVScroll(true),
        details_ctl:setVerticalScroll(true),
        setDefaultButton(ok_ctl).
% end of automatic code

end implement spbExceptionDialog
