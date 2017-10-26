/*****************************************************************************
Copyright (c) Victor Yukhtenko

Author: Victor Yukhtenko
******************************************************************************/
implement spbTree
    open core

/*ADD NODE*/
clauses
    addNode(Place,NodeID,Comparator,SourceTree,NodeToAdd)=Result:-
        Result=tryAddNode(Place,NodeID,Comparator,SourceTree,NodeToAdd),
        !.
    addNode(_Place,NodeID,_Comparator,_SourceTree,_NodeToAdd)=_Result:-
        exception::raise_User(string::format("No Node with the NodeID=% found",toString(NodeID))).

clauses
    tryAddNode(leftmost,NodeID,Comparator,tree(NodeIDSrc,Data,NodeList),NodeToAdd)=tree(NodeIDSrc,Data,[NodeToAdd|NodeList]):-
        equal=Comparator(NodeID,NodeIDSrc),
        !.
    tryAddNode(rightmost,NodeID,Comparator,tree(NodeIDSrc,Data,NodeList),NodeToAdd)=tree(NodeIDSrc,Data,list::append(NodeList,[NodeToAdd])):-
        equal=Comparator(NodeID,NodeIDSrc),
        !.
    tryAddNode(Place,NodeID,Comparator,tree(RootNodeID,Data,[LeftNode|RightNodeList]),NodeToAdd)=tree(RootNodeID,Data,[UpdatedLeftNode|RightNodeList]):-
        UpdatedLeftNode=tryAddNode(Place,NodeID,Comparator,LeftNode,NodeToAdd),
        !.
    tryAddNode(Place,NodeID,Comparator,tree(RootNodeID,Data,[LeftNode|RightNodeList]),NodeToAdd)=tree(RootNodeID,Data,[LeftNode|UpdatedRightNodeList]):-
        tree(RootNodeID,Data,UpdatedRightNodeList)=tryAddNode(Place,NodeID,Comparator,tree(RootNodeID,Data,RightNodeList),NodeToAdd),
        !.
    tryAddNode(leftmost,_NodeID,_Comparator,_SrcTree,_NodeToAdd)=_:-
        !,
        fail.
    tryAddNode(rightmost,_NodeID,_Comparator,_SrcTree,_NodeToAdd)=_:-
        !,
        fail.

    tryAddNode(left,NodeID,Comparator,tree(RootNodeID,Data,[tree(NodeIDSrc,NodeData,NodeList)|Tail]),NodeToAdd)=
        tree(RootNodeID,Data,[NodeToAdd,tree(NodeIDSrc,NodeData,NodeList)|Tail]):-
        equal=Comparator(NodeID,NodeIDSrc),
        !.
    tryAddNode(right,NodeID,Comparator,tree(RootNodeID,Data,[tree(NodeIDSrc,NodeData,NodeList)|Tail]),NodeToAdd)=
        tree(RootNodeID,Data,[tree(NodeID,NodeData,NodeList),NodeToAdd|Tail]):-
        equal=Comparator(NodeID,NodeIDSrc),
        !.
    tryAddNode(Place,NodeID,Comparator,tree(RootNodeID,Data,[LeftNode|RightNodeList]),NodeToAdd)=
        tree(RootNodeID,Data,[UpdatedLeftNode|RightNodeList]):-
        UpdatedLeftNode=tryAddNode(Place,NodeID,Comparator,LeftNode,NodeToAdd),
        !.
    tryAddNode(Place,NodeID,Comparator,tree(RootNodeID,Data,[LeftNode|RightNodeList]),NodeToAdd)=tree(RootNodeID,Data,[LeftNode|UpdatedRightNodeList]):-
        tree(RootNodeID,Data,UpdatedRightNodeList)=tryAddNode(Place,NodeID,Comparator,tree(RootNodeID,Data,RightNodeList),NodeToAdd).

clauses
    addNode(Place,NodeID,SourceTree,NodeToAdd)=Result:-
        Result=tryAddNode(Place,NodeID,SourceTree,NodeToAdd),
        !.
    addNode(_Place,NodeID,_SourceTree,_NodeToAdd)=_Result:-
        exception::raise_User(string::format("No Node with the NodeID=% found",toString(NodeID))).

clauses
    tryAddNode(leftmost,NodeID,tree(NodeID,Data,NodeList),NodeToAdd)=tree(NodeID,Data,[NodeToAdd|NodeList]):-
        !.
    tryAddNode(rightmost,NodeID,tree(NodeID,Data,NodeList),NodeToAdd)=tree(NodeID,Data,list::append(NodeList,[NodeToAdd])):-
        !.
    tryAddNode(Place,NodeID,tree(RootNodeID,Data,[LeftNode|RightNodeList]),NodeToAdd)=tree(RootNodeID,Data,[UpdatedLeftNode|RightNodeList]):-
        UpdatedLeftNode=tryAddNode(Place,NodeID,LeftNode,NodeToAdd),
        !.
    tryAddNode(Place,NodeID,tree(RootNodeID,Data,[LeftNode|RightNodeList]),NodeToAdd)=tree(RootNodeID,Data,[LeftNode|UpdatedRightNodeList]):-
        tree(_RootNodeID,_Data,UpdatedRightNodeList)=tryAddNode(Place,NodeID,tree(RootNodeID,Data,RightNodeList),NodeToAdd),
        !.
    tryAddNode(leftmost,_NodeID,_SrcTree,_NodeToAdd)=_:-
        !,
        fail.
    tryAddNode(rightmost,_NodeID,_SrcTree,_NodeToAdd)=_:-
        !,
        fail.
    tryAddNode(left,NodeID,tree(RootNodeID,Data,[tree(NodeID,NodeData,NodeList)|Tail]),NodeToAdd)=
        tree(RootNodeID,Data,[NodeToAdd,tree(NodeID,NodeData,NodeList)|Tail]):-
        !.
    tryAddNode(right,NodeID,tree(RootNodeID,Data,[tree(NodeID,NodeData,NodeList)|Tail]),NodeToAdd)=
        tree(RootNodeID,Data,[tree(NodeID,NodeData,NodeList),NodeToAdd|Tail]):-
        !.
    tryAddNode(Place,NodeID,tree(RootNodeID,Data,[LeftNode|RightNodeList]),NodeToAdd)=
        tree(RootNodeID,Data,[UpdatedLeftNode|RightNodeList]):-
        UpdatedLeftNode=tryAddNode(Place,NodeID,LeftNode,NodeToAdd),
        !.
    tryAddNode(Place,NodeID,tree(RootNodeID,Data,[LeftNode|RightNodeList]),NodeToAdd)=tree(RootNodeID,Data,[LeftNode|UpdatedRightNodeList]):-
        tree(RootNodeID,Data,UpdatedRightNodeList)=tryAddNode(Place,NodeID,tree(RootNodeID,Data,RightNodeList),NodeToAdd).

/*Remove Node*/
clauses
    removeNode(NodeID,SourceTree)=Result:-
        Result=tryRemoveNode(NodeID,SourceTree),
        !.
    removeNode(NodeID,_SourceTree)=_Result:-
        exception::raise_User(string::format("No Node with the NodeID=% found",toString(NodeID))).

clauses
    removeNode(NodeID,Comparator,SourceTree)=Result:-
        Result=tryRemoveNode(NodeID,Comparator,SourceTree),
        !.
    removeNode(NodeID,_Comparator,_SourceTree)=_Result:-
        exception::raise_User(string::format("No Node with the NodeID=% found",toString(NodeID))).

clauses
    tryRemoveNode(NodeID,tree(RootNodeID,Data,[tree(NodeID,_NodeData,_NodeList)|ListTail]))=tree(RootNodeID,Data,ListTail):-
        !.
    tryRemoveNode(NodeID,tree(RootNodeID,Data,[LeftNode|RightNodeList]))=
        tree(RootNodeID,Data,[UpdatedLeftNode|RightNodeList]):-
        UpdatedLeftNode=tryRemoveNode(NodeID,LeftNode),
        !.
    tryRemoveNode(NodeID,tree(RootNodeID,Data,[LeftNode|RightNodeList]))=tree(RootNodeID,Data,[LeftNode|UpdatedRightNodeList]):-
        tree(_RootNodeID,_Data,UpdatedRightNodeList)=tryRemoveNode(NodeID,tree(RootNodeID,Data,RightNodeList)).

clauses
    tryRemoveNode(NodeID,Comparator,tree(RootNodeID,Data,[tree(NodeIDSrc,_NodeData,_NodeList)|ListTail]))=tree(RootNodeID,Data,ListTail):-
        equal=Comparator(NodeID,NodeIDSrc),
        !.
    tryRemoveNode(NodeID,Comparator,tree(RootNodeID,Data,[LeftNode|RightNodeList]))=
        tree(RootNodeID,Data,[UpdatedLeftNode|RightNodeList]):-
        UpdatedLeftNode=tryRemoveNode(NodeID,Comparator,LeftNode),
        !.
    tryRemoveNode(NodeID,Comparator,tree(RootNodeID,Data,[LeftNode|RightNodeList]))=tree(RootNodeID,Data,[LeftNode|UpdatedRightNodeList]):-
        tree(_RootNodeID,_Data,UpdatedRightNodeList)=tryRemoveNode(NodeID,Comparator,tree(RootNodeID,Data,RightNodeList)).

/*Get Node*/
clauses
    getNode(NodeID,SourceTree)=Result:-
        Result=tryGetNode(NodeID,SourceTree),
        !.
    getNode(NodeID,_SourceTree)=_Result:-
        exception::raise_User(string::format("No Node with the NodeID=% found",toString(NodeID))).

clauses
    getNode(NodeID,Comparator,SourceTree)=Result:-
        Result=tryGetNode(NodeID,Comparator,SourceTree),
        !.
    getNode(NodeID,_Comparator,_SourceTree)=_Result:-
        exception::raise_User(string::format("No Node with the NodeID=% found",toString(NodeID))).

clauses
    tryGetNode(NodeID,tree(NodeID,Data,NodeList))=tree(NodeID,Data,NodeList):-
        !.
    tryGetNode(NodeID,tree(_RootNodeID,_Data,[LeftNode|_RightNodeList]))=Result:-
        Result=tryGetNode(NodeID,LeftNode),
        !.
    tryGetNode(NodeID,tree(RootNodeID,Data,[_LeftNode|RightNodeList]))=tryGetNode(NodeID,tree(RootNodeID,Data,RightNodeList)).

clauses
    tryGetNode(NodeID,Comparator,tree(NodeIDSrc,Data,NodeList))=tree(NodeIDSrc,Data,NodeList):-
        equal=Comparator(NodeID,NodeIDSrc),
        !.
    tryGetNode(NodeID,Comparator,tree(_RootNodeID,_Data,[LeftNode|_RightNodeList]))=Result:-
        Result=tryGetNode(NodeID,Comparator,LeftNode),
        !.
    tryGetNode(NodeID,Comparator,tree(RootNodeID,Data,[_LeftNode|RightNodeList]))=tryGetNode(NodeID,Comparator,tree(RootNodeID,Data,RightNodeList)).

/*Get Node By Path*/
clauses
    tryGetNodeByPath([],SourceTree)=SourceTree.

/*Replace Node*/
clauses
    replaceNode(NodeID,SourceTree,ReplaceByNode)=Result:-
        Result=tryReplaceNode(NodeID,SourceTree,ReplaceByNode),
        !.
    replaceNode(NodeID,_SourceTree,_ReplaceByNode)=_Result:-
        exception::raise_User(string::format("No Node with the NodeID=% found",toString(NodeID))).

clauses
    replaceNode(NodeID,Comparator,SourceTree,ReplaceByNode)=Result:-
        Result=tryReplaceNode(NodeID,Comparator,SourceTree,ReplaceByNode),
        !.
    replaceNode(NodeID,_Comparator,_SourceTree,_ReplaceByNode)=_Result:-
        exception::raise_User(string::format("No Node with the NodeID=% found",toString(NodeID))).

clauses
    tryReplaceNode(NodeID,tree(NodeID,_Data,_NodeList),ReplaceByNode)=ReplaceByNode:-
        !.
    tryReplaceNode(NodeID,tree(RootNodeID,Data,[LeftNode|RightNodeList]),ReplaceByNode)=
        tree(RootNodeID,Data,[UpdatedLeftNode|RightNodeList]):-
        UpdatedLeftNode=tryReplaceNode(NodeID,LeftNode,ReplaceByNode),
        !.
    tryReplaceNode(NodeID,tree(RootNodeID,Data,[LeftNode|RightNodeList]),ReplaceByNode)=tree(RootNodeID,Data,[LeftNode|UpdatedRightNodeList]):-
        tree(RootNodeID,Data,UpdatedRightNodeList)=tryReplaceNode(NodeID,tree(RootNodeID,Data,RightNodeList),ReplaceByNode).

clauses
    tryReplaceNode(NodeID,Comparator,tree(NodeIDSrc,_Data,_NodeList),ReplaceByNode)=ReplaceByNode:-
        equal=Comparator(NodeID,NodeIDSrc),
        !.
    tryReplaceNode(NodeID,Comparator,tree(RootNodeID,Data,[LeftNode|RightNodeList]),ReplaceByNode)=
        tree(RootNodeID,Data,[UpdatedLeftNode|RightNodeList]):-
        UpdatedLeftNode=tryReplaceNode(NodeID,Comparator,LeftNode,ReplaceByNode),
        !.
    tryReplaceNode(NodeID,Comparator,tree(RootNodeID,Data,[LeftNode|RightNodeList]),ReplaceByNode)=tree(RootNodeID,Data,[LeftNode|UpdatedRightNodeList]):-
        tree(RootNodeID,Data,UpdatedRightNodeList)=tryReplaceNode(NodeID,Comparator,tree(RootNodeID,Data,RightNodeList),ReplaceByNode).

/*Search Node*/
clauses
    getNodeByData_nd(Data,tree(NodeID,Data,[]))=tree(NodeID,Data,[]).
    getNodeByData_nd(Data,tree(_NodeID,_NodeData,[LeftNode|_RightNodeList]))=getNodeByData_nd(Data,LeftNode).
    getNodeByData_nd(Data,tree(NodeID,NodeData,[_LeftNode|RightNodeList]))=getNodeByData_nd(Data,tree(NodeID,NodeData,RightNodeList)).

clauses
    getNodeByData_nd(Data,Comparator,tree(NodeID,DataSrc,[]))=tree(NodeID,DataSrc,[]):-
        equal=Comparator(Data,DataSrc).
    getNodeByData_nd(Data,Comparator,tree(_NodeID,_NodeData,[LeftNode|_RightNodeList]))=getNodeByData_nd(Data,Comparator,LeftNode).
    getNodeByData_nd(Data,Comparator,tree(NodeID,NodeData,[_LeftNode|RightNodeList]))=getNodeByData_nd(Data,Comparator,tree(NodeID,NodeData,RightNodeList)).

clauses
    getNodeData_nd(tree(NodeID,Data,[]))=tree(NodeID,Data,[]).
    getNodeData_nd(tree(_NodeID,_Data,[LeftNode|_RightNodeList]))=getNodeData_nd(LeftNode).
    getNodeData_nd(tree(NodeID,Data,[_LeftNode|RightNodeList]))=getNodeData_nd(tree(NodeID,Data,RightNodeList)).

/*************************
Complex operations
*************************/
clauses
    map(Lambda,ElementID,TreeIn)=TreeOut:-
        TreeOut=mapInternal(Lambda,ElementID,TreeIn),
        !.
    map(_Lambda,_ElementID,_TreeIn)=_TreeOut:-
        exception::raise_User("InternalError: Unexpected Alternative").

class predicates
    mapInternal:
        (
        spbAbstracts::lambda_1{ExtParameter,NodeID*,spbTree::tree{NodeID,Data},spbTree::tree{NewNodeID,NewData}},
        NodeID* ,
        spbTree::tree{NodeID,Data}
        )->spbTree::tree{NewNodeID,NewData} determ.
clauses
    mapInternal(spbAbstracts::lambda(Convert,ExtParameterList),ElementID,spbTree::tree(NodeID,Data,[]))=NewNode:-
        !,
        NewNode=Convert(ExtParameterList,ElementID,spbTree::tree(NodeID,Data,[])).
    mapInternal(spbAbstracts::lambda(Convert,ExtParameterList),ElementID,spbTree::tree(NodeID,Data,[LeftNode|RestNodeList])) = spbTree::tree(NewNodeID,NewNodeData,[NewLeftNode|NewRestNodeList]):-
        NewLeftNode=mapInternal(spbAbstracts::lambda(Convert,ExtParameterList),[NodeID|ElementID],LeftNode),
        !,
        spbTree::tree(NewNodeID,NewNodeData,NewRestNodeList)=mapInternal(spbAbstracts::lambda(Convert,ExtParameterList),[NodeID|ElementID],spbTree::tree(NodeID,Data,RestNodeList)).

clauses
    reduce(spbAbstracts::lambda(ReduceFunction,ExtParameterList),ElementID,spbTree::tree(NodeID,Data,[]),AccumulatorIn) =AccumulatorOut:-
        !,
        AccumulatorOut=ReduceFunction(ExtParameterList,ElementID,spbTree::tree(NodeID,Data,[]),AccumulatorIn).
    reduce(Lambda,ElementID,spbTree::tree(NodeID,Data,[LeftNode|RestNodeList]),AccumulatorIn)=AccumulatorOut:-
        AccumulatorOut1=reduce(Lambda,[NodeID|ElementID],LeftNode,AccumulatorIn),
        !,
        AccumulatorOut=reduce(Lambda,[NodeID|ElementID],spbTree::tree(NodeID,Data,RestNodeList),AccumulatorOut1).

end implement spbTree
