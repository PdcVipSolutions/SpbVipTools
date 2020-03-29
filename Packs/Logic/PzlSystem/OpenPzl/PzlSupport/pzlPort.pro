/*****************************************************************************

Copyright (c) Victor Yukhtenko

******************************************************************************/
implement pzlPort
open pfc\log

clauses
    init():-
        pzlCore::init().

clauses
    isInitialized():-
        pzlCore::isInitialized().

clauses
    setComponentRegisterFileName(DllRegisterFileName):-
        pzlCore::setComponentRegisterFileName(DllRegisterFileName).

end implement pzlPort
