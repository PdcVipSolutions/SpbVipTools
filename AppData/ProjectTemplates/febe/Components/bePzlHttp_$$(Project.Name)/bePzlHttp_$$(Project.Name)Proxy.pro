/*****************************************************************************
Copyright (c) PDCSPB

Author: Victor Yukhtenko
******************************************************************************/
implement bePzlHttp_$$(Project.Name)
    open core
    open exception

clauses
    new(Container)=convert(iPzlWSM_BE, Object):-
        try
            Object = pzl::newByID(iPzlWSM_BE::componentID_C,Container)
        catch TraceID do
            Msg=string::format("Can not create the Object of the class %",toString(iPzlWSM_BE::componentID_C)),
            continue_User(TraceID,Msg)
        end try.

end implement bePzlHttp_$$(Project.Name)
