/*****************************************************************************
Copyright (c)  PDCSPB

Author: Victor Yukhtenko
******************************************************************************/
implement bePzlHttp_$$(Project.Name)
    inherits pzlComponent
    inherits appHead

    open core, pfc\log

clauses
    new(_Container).

clauses
    pzlInit(_):-
        log::write(log::info,"Component bePzlHttp_$$(Project.Name): ","Initiated").

    pzlRun(_).
    pzlComplete().

end implement bePzlHttp_$$(Project.Name)
