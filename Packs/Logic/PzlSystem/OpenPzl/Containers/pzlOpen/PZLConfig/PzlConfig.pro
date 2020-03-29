/*****************************************************************************

Copyright (c) Victor Yukhtenko

 Written by: Victor Yukhtenko
******************************************************************************/

implement pzlConfig

clauses
    init().

clauses
    getContainerVersion()=iPzlConfig::pzlContainerVersion_C.

clauses
    getComponentIDInfo()=
        [
        ].

% put here clauses related to the visible classes implemented (ONLY) in this PZL Container.
    new(pzlDomains::str("DummyID"),pzlDomains::nullObject_C)=pzlDomains::nullObject_C:-!.
    new(ClassUID,_Container)=_:-
        MSG=string::format("The pzlComponent <%> is not supported in the pzlContainer <%>, ver. %",ClassUID,pzl::getContainerName(),getContainerVersion()),
       exception::raise_User(Msg).

end implement pzlConfig
