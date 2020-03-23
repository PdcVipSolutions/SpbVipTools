% Copyright PDCSPB

implement fe_RibbonScriptEmbedded
    inherits fe_Connector

    open core, pfc\log

clauses
    new(FrontEnd):-
        fe_Connector::new(FrontEnd).

clauses
    setRibbonContext(CmdContext):-
        CmdContext:setRunner("embedded-default",defaultHandler).

predicates
    defaultHandler:(command RibbonCommand).
    defaultHandler:(string CommandID,string NameSpace,command RibbonCommand) multi.
clauses
    defaultHandler(RibbonCommand):-
        string::frontToken(RibbonCommand:id,NameSpace,CommandIDWithSlash),
        string::frontChar(CommandIDWithSlash,_,CommandID),
        defaultHandler(CommandID,NameSpace,RibbonCommand),
        !.
    defaultHandler(_RibbonCommand).

    defaultHandler("ribbon.menu.language.cmd.rus",_NameSpace,_RibbonCmd):-fe_CoreTasks():setNewLanguage("rus").
    defaultHandler("ribbon.menu.language.cmd.eng",_NameSpace,_RibbonCmd):-fe_CoreTasks():setNewLanguage("eng").
    defaultHandler("ribbon.cmd.info",NameSpace,_RibbonCmd):-
        stdio::writef("NameSpace=[%]\n",NameSpace),
        stdio::writef("currentDirectory_P=[%]\n",frontEnd_P:currentDirectory_P),
        stdio::writef("lastFolder_P=[%]\n",frontEnd_P:lastFolder_P),
        stdio::writef("ribbonStartup_P=[%]\n",frontEnd_P:ribbonStartup_P),
        stdio::writef("use_dictionary_P=[%]\n",fe_Dictionary():useDictionary_P),
        stdio::writef("lastLanguage_P=[%]\n",frontEnd_P:lastLanguage_P),
        stdio::writef("currentLanguage_P=[%]\n",fe_Dictionary():currentLanguage_P),
        stdio::write("Info:Done\n").
    defaultHandler(_CommandID,_NameSpace,RibbonCmd):-
        stdio::write(RibbonCmd:id,"\n"),
        succeed().

end implement fe_RibbonScriptEmbedded
