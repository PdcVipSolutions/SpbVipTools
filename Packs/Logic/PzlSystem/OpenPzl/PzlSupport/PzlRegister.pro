/*****************************************************************************
Copyright (c) 2006 Prolog Development Center SPb

Author: Victor Yukhtenko
******************************************************************************/
implement pzlRegistry

    open core
    open redBlackTree, redBlackTreeRep

constants
    treeInitial_C:redBlackTree::tree{string,object}=redBlackTree::tree(treeProperty(objectIdComparator,nonUnique()),emptyRep()).

class facts - redBlackTreeStruct
    tree_V:redBlackTree::tree{string,object}:=treeInitial_C.

class predicates
    objectIdComparator:core::comparator{string,string}.
clauses
    objectIdComparator(Name1,Name2)=equal():-
        string::equalIgnoreCase(Name1,Name2),
        !.
    objectIdComparator(Name1,Name2)=less():-
        Name1<Name2,
        !.
    objectIdComparator(_Name1,_Name2)=greater().

clauses
    register(ObjectName,ReferenceToObject):-
        not(_Object=tryLookUp(tree_V,ObjectName)),
        !,
        tree_V:=redBlackTree::insert(tree_V,ObjectName,ReferenceToObject).
    register(_ObjectName,_ReferenceToObject). % Exception "This Name already used" must be here, but now if exception it desn't work.

clauses
    registerMulti(ObjectName,ReferenceToObject):-
        ReferenceToObject=getObjectByName_nd(ObjectName),
        !.
    registerMulti(ObjectName,ReferenceToObject):-
        tree_V:=redBlackTree::insert(tree_V,ObjectName,ReferenceToObject).

clauses
    getNameAndObject_nd(ObjectName,Object):-
        tuple(ObjectName,Object)=getAll_nd(tree_V).

clauses
    getObjectByName_nd(ObjectName)=ReferenceToObject:-
        getNameAndObject_nd(Name,ReferenceToObject),
        string::equalIgnoreCase(ObjectName,Name).

clauses
    getNamebyObject_nd(ReferenceToObject)=ObjectName:-
        getNameAndObject_nd(ObjectName,Object),
        ReferenceToObject=Object.

clauses
    unRegister(ObjectName,ReferenceToObject):-
        tree_V:=delete(tree_V,ObjectName,ReferenceToObject).

clauses
    unRegisterByName(ObjectName):-
        getNameAndObject_nd(Name,Object),
            string::equalIgnoreCase(ObjectName,Name),
            tree_V:=delete(tree_V,Name,Object),
        fail.
    unRegisterByName(_ObjectName).

clauses
    unRegisterAllByNamePrefix(ObjectNamePrefix):-
        foreach
            getNameAndObject_nd(Name,Object),
            string::hasPrefixIgnoreCase(Name,ObjectNamePrefix,_)
        do
            tree_V:=delete(tree_V,Name,Object)
        end foreach.

clauses
    unRegisterByObject(ReferenceToObject):-
        getNameAndObject_nd(Name,Object),
            ReferenceToObject=Object,
            tree_V:=delete(tree_V,Name,Object),
        fail.
    unRegisterByObject(_ReferenceToObject).

clauses
    unRegisterAll():-
        tree_V:=treeInitial_C.

end implement pzlRegistry
