%

implement fe_RibbonScriptLoadable
    inherits fe_Connector

    open core, pfc\asynchronous\, pfc\log
%    open coreIdentifiers, edf

clauses
    new(FrontEnd):-
        fe_Connector::new(FrontEnd).

clauses
    setRibbonContext(ContextObj):-
        ContextObj:setIconByIDRender("by-id-loadable",iconByIDRender).

predicates
    iconByIDRender:(string IconID)->binary IconBitmap.
clauses
    iconByIDRender(IconID)=IconAsBinary:-
        IconAsBinary=getIconByID(IconID),
        log::writef(log::info,"Icon By ID [%] loaded",IconID).

predicates
    getIconByID:(string IconID)->binary IconAsBinary.
clauses
    getIconByID("new")=IconAsBinary:-
        !,
        IconAsBinary=file::readBinary(@".\$$(Project.Name)AppData\pdcVipIcons\actions\document-new.ico").
    getIconByID("open")=IconAsBinary:-
        !,
        IconAsBinary=file::readBinary(@".\$$(Project.Name)AppData\pdcVipIcons\actions\document-open.ico").
    getIconByID("save")=IconAsBinary:-
        !,
        IconAsBinary=file::readBinary(@".\$$(Project.Name)AppData\pdcVipIcons\actions\document-save.ico").
    getIconByID(IconID)=_IconAsBinary:-
        exception::raise_User(string::format("Invalid IconRequest via ID [%]",IconID)).

end implement fe_RibbonScriptLoadable
