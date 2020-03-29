/*****************************************************************************

Copyright (c) Victor Yukhtenko

 Written by: Victor Yukhtenko
******************************************************************************/
class pzlConfig

predicates
    init:().

predicates
    getContainerVersion:()-> string ContainerVersion.

predicates
    new:(pzlDomains::entityUID_D ClassUID,object Container) -> object procedure (i,i).

predicates
    getComponentIDInfo:()->pzlDomains::pzlContainerContentInfo_D procedure().

end class pzlConfig
