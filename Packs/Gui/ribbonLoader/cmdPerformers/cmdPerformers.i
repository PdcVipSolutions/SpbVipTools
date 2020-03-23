%

interface cmdPerformers
    open core

properties
    useDictionary_P:boolean.
    dictionary_P:dictionary.
    noIconRender_P:function{binary}.

predicates
    setRunner:(string RunnerID,predicate{command}).
    setChangeStateHandler:(string StateHandlerID,predicate{command}).
    setTooltipRender:(string StateHandlerID, function{string}).
    setMenuRender:(string RenderID, function{menuCommand::menuItem*}).
    setIconByIDRender:(string RenderID,function{string, binary}).
    setCustomFactory:(string CustomFactoryID, function{string,function{control}}).

predicates
    tryGetRunner:(string RunneID)->predicate{command} determ.
    tryGetChangeStateHandler:(string StateHandlerID)->predicate{command} determ.
    tryGetTooltipRender:(string RenderID)-> function{string} determ.
    tryGetMenuRender:(string RenderID)-> function{menuCommand::menuItem*} determ.
    tryGetIconByIDRender:(string RenderID)->function{string, binary} determ.
    tryGetCustomFactory:(string FactoryID)->function{string,function{control}} determ.

end interface cmdPerformers
