/*****************************************************************************
SpbSolutions
Visual Prolog PuZzLe

Copyright (c) Victor Yukhtenko

Send feedback to mailto:victor.a.yukhtenko@gmail.com

Package: PzlComponent
Class: PzlComponent

Written by: Victor Yukhtenko
******************************************************************************/
implement pzlComponent
    open core

clauses
    new():-
        pzl::newInstance().

clauses
    finalize():-
        pzl::release().

clauses % declared in the pzlComponent Interface
    getClassInfo(class_name(),"1.0").

clauses
    getContainerVersion()=iPzlConfig::pzlContainerVersion_C.

clauses
    getContainerName()=pzl::getContainerName().

clauses
    getComponentVersion()=_:-
        exception::raise_User("Predicate Not Defined").

clauses
    getComponentID()=_:-
        exception::raise_User("Predicate Not Defined").

clauses
    getComponentAlias()=_:-
        exception::raise_User("Predicate Not Defined").

clauses
    getComponentMetaInfo()=_:-
        exception::raise_User("Predicate Not Defined").

clauses
    release():-
        exception::raise_User("Predicate Not Defined").

end implement pzlComponent
