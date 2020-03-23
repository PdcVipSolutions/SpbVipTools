/*****************************************************************************
Copyright (c) PDCSPB

Author: Victor Yukhtenko
******************************************************************************/
implement monoPzl_$$(Project.Name)
    inherits pzlComponent

    open core, pfc\log

clauses
    new(_Container):-
        try
            applicationWindow::set(convert(applicationWindow,getTaskWindow()))
        catch _TraceID do
            succeed()
        end try.

predicates
    getTaskWindow:()->window.
clauses
    getTaskWindow()=convert(window,Object):-
        Object=pzl::getObjectByName_nd(coreConstants::applicationTaskWindow_C),
        !.
    getTaskWindow()=_:-
        exception::raise_User("Aplication's TaskWindow not found!").
/*
predicates
    restore:().
clauses
    restore():-
        RestoreData=tryGetRestoreData(componentAlias_C),
        Position=namedValue::tryGetNamed_string(RestoreData,position_C),
        Size=namedValue::tryGetNamed_string(RestoreData,size_C),
        try
        	toTerm(Position) = vpiDomains::pnt(X, Y)
        catch _TraceID1 do
        	fail
        end try,
        try
        	toTerm(Size) = vpiDomains::pnt(W, H)
        catch _TraceID2 do
        	fail
        end try,
        !,
        appHead_V:get_Form():setPosition(X,Y),
        appHead_V:get_Form():setSize(W,H).
    restore().
*/
class facts
    appHead_V:appHead:=erroneous.
clauses
	pzlRun(UserText):-
        pzl::log():writef(log::info,"appHead> run: [%]",UserText),
        Object=pzl::getObjectByName_nd(componentAlias_C),
        This=convert(iMonoPzl_$$(Project.Name),Object),
        pzl::log():writef(log::info,"appHead> is active: [%]",toString(This)),
        appHead_V:mainWindow_P:setFocus(),
        !.
	pzlRun(UserText):-
        TaskWindow=getTaskWindow(),
        pzl::log():writef(log::info,"appHead> creating new: [%] with [%]",toString(This),UserText),
        appHead_V:=appHead::new(),
        pzl::register(componentAlias_C,This),
    %        restore(),
        appHead_V:mainWindow_P:addDestroyListener(onDestroy),
        appHead_V:run(TaskWindow).

predicates
    onDestroy:window::destroyListener.
clauses
/*
    onDestroy(_Source):-
        appHead_V:get_Form():getSize(W,H),
        appHead_V:get_Form():getPosition(X,Y),
        setRestoreData(
            componentAlias_C,
            [
            namedValue(position_C,string(toString(vpiDomains::pnt(X,Y)))),
            namedValue(size_C,string(toString(vpiDomains::pnt(W,H))))
            ],[]),
        pzl::unRegister(componentAlias_C,convert(object,This)),
        fail.
*/
    onDestroy(_Source):-
        pzl::unRegister(componentAlias_C,convert(object,This)),
        appHead_V:=erroneous,
        fail.
    onDestroy(_Source).

clauses
    pzlInit(_UserInfo).

clauses
	pzlComplete().

end implement monoPzl_$$(Project.Name)
