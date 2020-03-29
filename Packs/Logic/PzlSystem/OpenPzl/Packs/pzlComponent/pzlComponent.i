/*****************************************************************************

Copyright (c) Victor Yukhtenko

******************************************************************************/
interface pzlComponent
    open core

predicates
    getContainerVersion:()-> string.

predicates
    getClassInfo:(string ClassName [out],string ClassVersion [out]).

predicates
    getContainerName:()-> string.

/*Predicates below by need should be defined in the User's class implementation*/
predicates
    getComponentVersion:()->string ComponentVersion.

predicates
    getComponentID:()->pzlDomains::entityUID_D ComponentID.

predicates
    getComponentAlias:()->string ComponentAlias.

predicates
    getComponentMetaInfo:()->namedValue_List UserInfo.

predicates
    release:().

end interface pzlComponent