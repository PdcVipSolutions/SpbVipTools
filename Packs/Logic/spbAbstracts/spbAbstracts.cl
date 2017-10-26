/*****************************************************************************
Copyright (c) Victor Yukhtenko

Author: Victor Yukhtenko
******************************************************************************/
class spbAbstracts
    open core


domains
    function_1{ExtParameter,ElementID,Element,NewTypeElement}=
        (
        ExtParameter* ExternalParList,
        ElementID IdentifiesTheElementInStructure,
        Element SourceStructureElement
        )->NewTypeElement Result.

domains
    function_2{ExtParameter,ElementID,Element,Accumulator}=
        (
        ExtParameter* ExternalParList,
        ElementID IdentifiesTheElementInStructure,
        Element SourceStructureElement,
        Accumulator Accumulator
        )->Accumulator Result.


domains
    lambda_1{ExtParameter,ElementID,ElementIn,ElementOut}=lambda(function_1{ExtParameter,ElementID,ElementIn,ElementOut},ExtParameter*).
    lambda_2{ExtParameter,ElementID,Element,Accumulator}=lambda(function_2{ExtParameter,ElementID,Element,Accumulator},ExtParameter*).

domains
    detach{DataStructure,Element,ElementID}=
        (
        DataStructure SourceDataStructure,
        ElementID CurrentElementID,
        Element ExtractedElement,
        ElementID NextElementID,
        DataStructure  RestDataStructure
        ) procedure (i,i,o,o,o).

domains
    merge{Element,DataStructure}=
        (
        Element,
        data{DataStructure}
        )->data{DataStructure} procedure (i,i).

domains
    data{DataStructure}=
        noData;
        data(DataStructure).

domains
    mapAbstract{ExtParameter,ElementID,Element,NewElement,DataStructure,NewDataStructure}=
        (
        lambda_1{ExtParameter,ElementID,Element,NewElement},
        detach{DataStructure,Element,ElementID},
        merge{NewElement,NewDataStructure},
        ElementID CurrentElementID,
        DataStructure DataStructureIn
        )->data{NewDataStructure} DataStructureOut.

predicates
    mapAbstract:mapAbstract{ExtParameter,ElementID,Element,NewElement,DataStructure,NewDataStructure}.

end class spbAbstracts