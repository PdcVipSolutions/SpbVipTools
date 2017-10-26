 % Copyright (c) 2014

implement entityRegistry {@Entity}
    open core
%    open redBlackTree
    open redBlackTree, redBlackTreeRep

constants
    treeInitial_C:redBlackTree::tree{string,  @Entity}=redBlackTree::tree(treeProperty(entityIdComparator,unique()),emptyRep()).

facts - redBlackTreeStruct
    tree_V:redBlackTree::tree{string, @Entity}:=treeInitial_C.

predicates
    entityIdComparator:core::comparator{string,string}.
clauses
    entityIdComparator(Name1,Name2)=equal():-
        string::equalIgnoreCase(Name1,Name2),
        !.
    entityIdComparator(Name1,Name2)=less():-
        Name1<Name2,
        !.
    entityIdComparator(_Name1,_Name2)=greater().

clauses
    register(EntityName,ReferenceToEntity):-
        tree_V:=redBlackTree::insert(tree_V,EntityName,ReferenceToEntity).

clauses
    getNameAndEntity_nd(EntityName,Entity):-
        tuple(EntityName,Entity)=getAll_nd(tree_V).

clauses
    getEntityByName_nd(EntityName)=ReferenceToEntity:-
        getNameAndEntity_nd(Name,ReferenceToEntity),
        string::equalIgnoreCase(EntityName,Name).

clauses
    getNameByEntity_nd(ReferenceToEntity)=EntityName:-
        getNameAndEntity_nd(EntityName,Entity),
        ReferenceToEntity=Entity.

clauses
    unRegister(EntityName,ReferenceToEntity):-
        tree_V:=delete(tree_V,EntityName,ReferenceToEntity).

clauses
    unRegisterByName(EntityName):-
        getNameAndEntity_nd(Name,Entity),
            string::equalIgnoreCase(EntityName,Name),
            tree_V:=delete(tree_V,Name,Entity),
        fail.
    unRegisterByName(_EntityName).

clauses
    unRegisterByEntity(ReferenceToEntity):-
        getNameAndEntity_nd(Name,Entity),
            ReferenceToEntity=Entity,
            tree_V:=delete(tree_V,Name,Entity),
        fail.
    unRegisterByEntity(_ReferenceToEntity).

clauses
    unRegisterAll():-
        tree_V:=treeInitial_C.

end implement entityRegistry