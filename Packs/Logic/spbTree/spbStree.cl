/*****************************************************************************
Copyright (c) Victor Yukhtenko

Author: Victor Yukhtenko
******************************************************************************/
class spbTree
    open core

predicates
    classInfo : core::classInfo.
    % @short Class information  predicate. 
    % @detail This predicate represents information predicate of this class.
    % @end

domains
    tree{NodeID,Data}=
        tree(NodeID,Data,tree{NodeID,Data}*).

domains
    place{NodeID}=
        left();
        right();
        before(NodeID);
        after(NodeID).
        

predicates
    addTree(place{NodeID},tree{NodeID,Data},tree{NodeID,Data})->tree{NodeID,Data}.
    
end class spbTree