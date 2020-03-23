/*****************************************************************************
Copyright (c) 2006-2016 PDCSPB

Author: Виктор Юхтенко/WIN-5L3MH3V6R7Q
******************************************************************************/
implement appHead
    open core
    open exception

clauses
    new(Container)=convert(iMonoPzl_$$(Project.Name), Object):-
        try
            Object = pzl::newByID(iappHead::componentID_C,Container),
        catch TraceID do
            Msg=string::format("Can not create the Object of the class %",toString(iappHead::componentID_C)),
            continue_User(TraceID,Msg)
        end try.

end implement appHead
