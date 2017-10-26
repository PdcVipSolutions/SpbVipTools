/*****************************************************************************
Copyright (c) Victor Yukhtenko

Author: Victor Yukhtenko
******************************************************************************/
implement spbAbstracts
    open core

clauses
    mapAbstract(lambda(Convert,ExtParameterList),Detach,Merge,ElementID,DataStructureIn)=DataStructureOut:-
        Detach(DataStructureIn,ElementID,SourceTypeElement,NewElementID,RestDataStructure),
        DataStructureIn=RestDataStructure,
        !,
        NewTypeElement=Convert(ExtParameterList,NewElementID,SourceTypeElement),
        DataStructureOut=Merge(NewTypeElement,noData).
    mapAbstract(lambda(Convert,ExtParameterList),Detach,Merge,ElementID,DataStructureIn) = DataStructureOut:-
        Detach(DataStructureIn,ElementID,SourceTypeElement,NewElementID,RestDataStructure),
        NewTypeElement=Convert(ExtParameterList,NewElementID,SourceTypeElement),
        !,
        NewTypeDataStruct=mapAbstract(lambda(Convert,ExtParameterList),Detach,Merge,NewElementID,RestDataStructure),
        DataStructureOut=Merge(NewTypeElement,NewTypeDataStruct).

end implement spbAbstracts
