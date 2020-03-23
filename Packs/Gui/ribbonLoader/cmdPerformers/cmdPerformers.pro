%

implement cmdPerformers
    open core,  pfc\log, redblackTree, redblackTreeRep

constants
    treeTipRenderInitial_C:redBlackTree::tree{string,  function{string}}=redBlackTree::tree(treeProperty(keyComparator,unique()),emptyRep()).
    treeMenuRenderInitial_C:redBlackTree::tree{string,  function{menuCommand::menuItem*}}=redBlackTree::tree(treeProperty(keyComparator,unique()),emptyRep()).
    treeStateHandlerInitial_C:redBlackTree::tree{string,  predicate{command}}=redBlackTree::tree(treeProperty(keyComparator,unique()),emptyRep()).
    treeRunnerInitial_C:redBlackTree::tree{string,  predicate{command}}=redBlackTree::tree(treeProperty(keyComparator,unique()),emptyRep()).
    treeIconByIdRenderInitial_C:redBlackTree::tree{string,function{string,binary}}=redBlackTree::tree(treeProperty(keyComparator,unique()),emptyRep()).
    treeCustomInitial_C:redBlackTree::tree{string, function{string,function{control}}}=redBlackTree::tree(treeProperty(keyComparator,unique()),emptyRep()).

class predicates
    keyComparator:core::comparator{string,string}.
clauses
    keyComparator(Name1,Name2)=equal():-
        string::equalIgnoreCase(Name1,Name2),
        !.
    keyComparator(Name1,Name2)=less():-
        Name1<Name2,
        !.
    keyComparator(_Name1,_Name2)=greater().

facts  %externalPredicates
    runner_V:redBlackTree::tree{string, predicate{command}}:=treeRunnerInitial_C.
    changeStateHandler_V:redBlackTree::tree{string, predicate{command}}:=treeStateHandlerInitial_C.
    menuRender_V:redBlackTree::tree{string, function{menuCommand::menuItem*}}:=treeMenuRenderInitial_C.
    tooltipRender_V:redBlackTree::tree{string, function{string}}:=treeTipRenderInitial_C.
    iconByIdRender_V:redBlackTree::tree{string, function{string,binary}}:=treeIconByIdRenderInitial_C.
    customFactory_V:redBlackTree::tree{string, function{string,function{control}}}:=treeCustomInitial_C.
    noIconRender_P: function{binary}:=defaultNoIconRender.

constants
    noNameBitMap_C:binary=#bininclude(@"appData\Res\NoName.bmp").
predicates
    defaultNoIconRender : ()->binary BinaryIconToUse.
clauses
    defaultNoIconRender()=noNameBitMap_C:-
        log::write(log::error,"Icon File not found. Default Icon File Used").

facts  %externalPredicates
    useDictionary_P:boolean:=false.
    dictionary_P:dictionary:=erroneous.

clauses
    setRunner(Runner_StringID,Predicate):-
        runner_V:=redBlackTree::insert(runner_V,Runner_StringID,Predicate).

    setChangeStateHandler(ChangeStateHandler_StringID,Predicate):-
        changeStateHandler_V:=redBlackTree::insert(changeStateHandler_V,ChangeStateHandler_StringID,Predicate).

    setTooltipRender(TooltipRender_StringID, Function):-
        tooltipRender_V:=redBlackTree::insert(tooltipRender_V,TooltipRender_StringID,Function).

    setMenuRender(MenuRender_StringID, Function):-
        menuRender_V:=redBlackTree::insert(menuRender_V,MenuRender_StringID,Function).

    setCustomFactory(CustomFactory_StringID, Function):-
        customFactory_V:=redBlackTree::insert(customFactory_V,CustomFactory_StringID,Function).

    setIconByIDRender(RenderID,Function):-
        iconByIdRender_V:=redBlackTree::insert(iconByIdRender_V,RenderID,Function).

clauses
    tryGetRunner(RunnerID)=redBlackTree::tryLookUp(runner_V,RunnerID).
    tryGetChangeStateHandler(ChangeStateHandlerID)=redBlackTree::tryLookUp(changeStateHandler_V,ChangeStateHandlerID).
    tryGetTooltipRender(RenderID)=redBlackTree::tryLookUp(tooltipRender_V,RenderID).
    tryGetMenuRender(RenderID)=redBlackTree::tryLookUp(menuRender_V,RenderID).
    tryGetCustomFactory(FactoryID)=redBlackTree::tryLookUp(customFactory_V,FactoryID).
    tryGetIconByIdRender(RenderID)=redBlackTree::tryLookUp(iconByIdRender_V,RenderID).

end implement cmdPerformers
