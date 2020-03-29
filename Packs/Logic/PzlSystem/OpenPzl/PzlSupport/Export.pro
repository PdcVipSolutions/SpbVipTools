/*****************************************************************************
Copyright (c) Victor Yukhtenko

******************************************************************************/
implement export
    open core

    clauses
        initContainer(PzlPortObj)=Object:-
            PzlPort=convert(pzlCore,PzlPortObj),
            stdIO::outputStream:=PzlPort:getStdOutputStream(),
            Object = pzlSys::new(),
            pzlSys::setPort(PzlPortObj).

end implement export
