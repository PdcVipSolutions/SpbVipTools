%

interface fe_Command

predicates
    initRibbon:(boolean TrueIfAsScript).

predicates
    expandRibbon:(binary XmlBinContent).

predicates
    reloadRibbon:().

predicates
    languageList_Menu:()->menuCommand::menuItem*.

predicates
    designRibbonLayout : ().

predicates
    updateRibbonLabels1 : ().

predicates
    setMenu:().

end interface fe_Command