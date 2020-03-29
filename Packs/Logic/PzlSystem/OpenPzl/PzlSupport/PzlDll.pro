/*****************************************************************************
Copyright (c) 2003-2006 Prolog Development Center SPb

Author: Victor Yukhtenko
******************************************************************************/
implement pzlDll
    inherits mainDll
    open core

clauses
    new():-
        mainDll::new(),
        addDestroyListener(onDestroy).

predicates
    onDestroy : resourceEventSource::destroyListener.
clauses
    onDestroy(_ObjectMainDll):-
        stdIO::outputStream:=uncheckedConvert(outputStream,0).

    %add your code for unloading DLL here
end implement pzlDll

#export export

goal
    DLL = pzlDll::new(),
    DLL:init().
