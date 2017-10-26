/*****************************************************************************
Copyright (c) Victor Yukhtenko

Author: Victor Yukhtenko
******************************************************************************/
class spbTree
    open core

domains
    tree{NodeID,Data}=
        tree(NodeID,Data,tree{NodeID,Data}*).

domains
    place=
        leftmost;
        rightmost;
        left;
        right.

predicates
    addNode:(place,NodeID,comparator{NodeID},tree{NodeID,Data},tree{NodeID,Data})->tree{NodeID,Data} procedure (i,i,i,i,i).

predicates
    tryAddNode:(place,NodeID,comparator{NodeID},tree{NodeID,Data},tree{NodeID,Data})->tree{NodeID,Data} determ (i,i,i,i,i).

predicates
    addNode:(place,NodeID,tree{NodeID,Data},tree{NodeID,Data})->tree{NodeID,Data} procedure (i,i,i,i).

predicates
    tryAddNode:(place,NodeID,tree{NodeID,Data},tree{NodeID,Data})->tree{NodeID,Data} determ (i,i,i,i).

predicates
    removeNode:(NodeID,tree{NodeID,Data})->tree{NodeID,Data} procedure (i,i).

predicates
    removeNode:(NodeID,comparator{NodeID},tree{NodeID,Data})->tree{NodeID,Data} procedure (i,i,i).

predicates
    tryRemoveNode:(NodeID,tree{NodeID,Data})->tree{NodeID,Data} determ (i,i).

predicates
    tryRemoveNode:(NodeID,comparator{NodeID},tree{NodeID,Data})->tree{NodeID,Data} determ (i,i,i).

predicates
    getNode:(NodeID,tree{NodeID,Data})->tree{NodeID,Data} procedure (i,i).

predicates
    getNode:(NodeID,comparator{NodeID},tree{NodeID,Data})->tree{NodeID,Data} procedure (i,i,i).

predicates
    tryGetNode:(NodeID,tree{NodeID,Data})->tree{NodeID,Data} determ (i,i).

predicates
    tryGetNode:(NodeID,comparator{NodeID},tree{NodeID,Data})->tree{NodeID,Data} determ (i,i,i).

predicates
    getNodeByData_nd:(Data,tree{NodeID,Data})->tree{NodeID,Data} nondeterm (i,i).

predicates
    getNodeByData_nd:(Data,comparator{Data},tree{NodeID,Data})->tree{NodeID,Data} nondeterm (i,i,i).

predicates
    tryGetNodeByPath:(NodeID*,tree{NodeID,Data})->tree{NodeID,Data} determ (i,i).

predicates
    replaceNode:(NodeID,tree{NodeID,Data},tree{NodeID,Data})->tree{NodeID,Data} procedure (i,i,i).

predicates
    replaceNode:(NodeID,comparator{NodeID},tree{NodeID,Data},tree{NodeID,Data})->tree{NodeID,Data} procedure (i,i,i,i).

predicates
    tryReplaceNode:(NodeID,tree{NodeID,Data},tree{NodeID,Data})->tree{NodeID,Data} determ (i,i,i).

predicates
    tryReplaceNode:(NodeID,comparator{NodeID},tree{NodeID,Data},tree{NodeID,Data})->tree{NodeID,Data} determ (i,i,i,i).

predicates
    getNodeData_nd:(tree{NodeID,Data})->tree{NodeID,Data} nondeterm (i).

predicates
    map:
        (
        spbAbstracts::lambda_1{ExtParameter,NodeID*,spbTree::tree{NodeID,Data},spbTree::tree{NewNodeID,NewData}},
        NodeID* CurrentElementID,
        spbTree::tree{NodeID,Data} DataStructureIn
        )->spbTree::tree{NewNodeID,NewData} DataStructureOut.

predicates
    reduce:
        (
        spbAbstracts::lambda_2{ExtParameter,NodeID*,spbTree::tree{NodeID,Data},Accumulator},
        NodeID*,
        spbTree::tree{NodeID,Data},
        Accumulator
        )->Accumulator.

end class spbTree