/*****************************************************************************
Copyright (c) PDCSPB

Author: Victor Yukhtenko
******************************************************************************/
implement fePzlHttp_$$(Project.Name)
    inherits pzlComponent
    open core
    open pfc\log

clauses
    new(_Container):-
        try
            applicationWindow::set(convert(applicationWindow,getPzlParentWindow()))
        catch _TraceID do
            succeed()
        end try.

predicates
    getPzlParentWindow:()->window.
clauses
    getPzlParentWindow()=convert(window,Object):-
        Object=pzl::getObjectByName_nd(coreConstants::applicationTaskWindow_C),!.
    getPzlParentWindow()=_:-
        exception::raise_User("No Task Window registered in the PZL registry").

class facts
    appHead_V:appHead:=erroneous.
clauses
	pzlRun(_UserInfo):-
        Object=pzl::getObjectByName_nd(componentAlias_C),
        _This=convert(ifePzlHttp_$$(Project.Name),Object),
        appHead_V:mainWindow_P:setFocus(),
        !.
	pzlRun(UserInfo):-
        TaskWindow=getPzlParentWindow(),
        appHead_V:=appHead::new(),
        ServiceParamList=toTerm(namedValue_list,UserInfo),
        foreach ServiceParam in ServiceParamList do
            if ServiceParam=namedValue("beHost",string(Value)) then appHead_V:backEndServiceIP_P:=Value
            elseif  ServiceParam=namedValue("bePath",string(Value)) then appHead_V:backEndServicePath_P:=Value
            end if
        end foreach,
        pzl::register(componentAlias_C,This),
    %        restore(),
        appHead_V:run(TaskWindow),
        appHead_V:mainWindow_P:addDestroyListener(onDestroy).

    pzlInit(_UserInfo).

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
        appHead_V:=erroneous.

clauses
	pzlComplete().

end implement fePzlHttp_$$(Project.Name)
