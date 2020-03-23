/*****************************************************************************

Copyright (c) Victor Yukhtenko

******************************************************************************/
interface pzlRun
    open core

    predicates
        pzlInit:(string UserInfo).
        pzlRun:(string UserInfo).
        pzlComplete:().

end interface pzlRun
