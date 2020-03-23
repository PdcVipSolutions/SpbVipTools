%

interface be_Options
    open core, edf

constants
    baseLanguage_C : string = "eng".
    baseLanguageTitle_C : string = "English".
    baseLanguageFlagId_C : string = "en".

properties
    currentLanguage_P:string.

predicates
    getFrontEndOptions : () -> edf_D.  % a([av(OptName,s(OptValue)),...])
    getFrontEndOptions : (edf_D OptionsIdList) -> edf_D. % a([av(OptName,s(OptValue)),...])
    getSupportedLanguagesList:()->tuple{string LanguageName,string LanguageTitle, string LanguageFlagId}*.
    getStartUpRibbonBinScripts:()->edf_D FileNames.
    getRibbonExtensionsList:()->string* FileNameList.

predicates
    setFrontEndOptions : (edf_D FrontEndOptions).
    updateUILanguage : (string NewUilanguageID).
    expandRibbon : (string RibbonExpansionFile).
    saveOptions : ().

end interface be_Options