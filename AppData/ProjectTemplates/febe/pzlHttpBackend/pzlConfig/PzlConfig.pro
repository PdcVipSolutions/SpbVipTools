/*****************************************************************************
                                        Visual Prolog PuZzLe Studio
                        Copyright (c) 2003-2004, Prolog Development Center Spb Ltd.

Created by: Visual Prolog PuZzLe Studio

Container: Copyright (c) Prolog Development Center SPb, PDCSPB
Used by: Виктор Юхтенко
******************************************************************************/
implement pzlConfig

clauses
    init().

clauses
    getContainerVersion()=iPzlConfig::pzlContainerVersion_C.

clauses
    getComponentIDInfo()=
        [
		ibePzlHttp_$$(Project.Name)::componentDescriptor_C
        ].

% put here ONLY clauses related to the visible pzlComponents implemented  into this pzlContainer.
clauses
	new(ibePzlHttp_$$(Project.Name)::componentID_C,Container)=Object:-
		!,
		Object = bePzlHttp_$$(Project.Name)::new(Container).
    new(ClassUID,_Container)=pzlDomains::nullObject_C:-
        if not(ClassUID=pzlDomains::str("DummyX")) then
            MSG=string::format("The pzlComponent \"%\" is not supported in the pzlContainer \"%\", ver. \"%\"",ClassUID,pzl::getContainerName(),getContainerVersion()),
            exception::raise_User(Msg)
        end if.

end implement pzlConfig
