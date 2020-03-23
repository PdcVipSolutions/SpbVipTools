% SPBrSolutions

interface coreIdentifiers
    open core

constants % messageDataIds
    transactionID_C="transID".
    dataFormatID_C="dataformat".
constants
% Options attributes names (exchange process)
    id_C="id".
    lastRibbonLayout_C="ribbon-lastlayout".
    srcRibbonLayout_C="ribbon-sourcelayout".
    ribbonChangedTime_C="ribbon-changetime".
    ribbonStartup_C="ribbon-startup".
    ribbonState_C="ribbon-state".
    ribbonScript_C="ribbon-script".

    currentLanguage_C="currentlanguage".
    lastLanguage_C="lastusedlanguage".
    useDictionary_C="use-dictionary".
    refreshDictionary_C="refresh-dictionary".
    languageTitle_C="title".
    languageFlagId_C="flag".
    lastFolder_C="lastfolder".
    useMenu_C="use-menu".

% Options attributes values
    useDictionaryNo_C = "no".
    useDictionaryYes_C = "yes".
    useMenuNo_C = "no".
    useMenuYes_C = "yes".

    ribbonStartupDefault_C="default".
    ribbonStartupEmbedded_C="embedded".
    ribbonStartupLoadable_C="loadable".

constants % to BE requests (0...1000)
    fe_IsBackEndAlive_C=0.
    fe_GetDictionary_C=fe_IsBackEndAlive_C+1. % 1
    fe_GetFrontEndOptions_C=fe_GetDictionary_C+1. % 2
    fe_SetFrontEndOptions_C=fe_GetFrontEndOptions_C+1. % 3
    fe_EditOptions_C=fe_SetFrontEndOptions_C+1. % 4
    fe_UpdateUILanguage_C=fe_EditOptions_C+1. % 5
    fe_AddDictionaryNameSpace_C=fe_UpdateUILanguage_C+1. % 6
    fe_RemoveDictionaryNameSpace_C=fe_AddDictionaryNameSpace_C+1. % 7
    fe_GetStartUpRibbonScripts_C=fe_RemoveDictionaryNameSpace_C+1. % 8
    fe_GetUILanguageList_C=fe_GetStartUpRibbonScripts_C+1. % 9
    fe_GetIconByID_C=fe_GetUILanguageList_C+1. % 10
    fe_GetRibbonAttributes_C=fe_GetIconByID_C+1. % 11
    fe_SaveOptions_C=fe_GetRibbonAttributes_C+1. % 12
    fe_ExpandRibbon_C=fe_SaveOptions_C+1. % 13
    fe_getRibbonScriptFiles_C=fe_ExpandRibbon_C+1. % 14
    fe_CreateModifyDictionary_C=fe_getRibbonScriptFiles_C+1. % 15
    fe_AddCoreDictionaryNameSpace_C=fe_CreateModifyDictionary_C+1. % 16
    fe_CreateCoreDictionary_C=fe_AddCoreDictionaryNameSpace_C+1. % 17
    fe_removeExtraLanguagesFromDictionaries_C=fe_CreateCoreDictionary_C+1. % 18

constants % Core FrontEnd errors (1001...2000)
    fe_Error_C = 1001. % no deep knowledge

constants % from BE responces (2001...3000)
    be_Alive_C=2001.
    be_EndOfData_C=be_Alive_C+1. % 2002
    be_WillFollow_C=be_EndOfData_C+1. % 2003
    be_EndOfChain_C=be_WillFollow_C+1. % 2004
    be_Settings_C=be_EndOfChain_C+1. % 2005
    be_EditOptions_C=be_Settings_C+1. % 2006
    be_TakeDictionary_C=be_EditOptions_C+1. % 2007
    be_TakeFrontEndOptions_C=be_TakeDictionary_C+1. % 2008
    be_TakeUILanguageList_C=be_TakeFrontEndOptions_C+1. % 2009
    be_TakeIconByID_C=be_TakeUILanguageList_C+1. % 2010
    be_TakeRibbonAttributes_C=be_TakeIconByID_C+1. % 2011
    be_TakeStartUpRibbonScripts_C=be_TakeRibbonAttributes_C+1. % 2012
    be_TakeRibbonScriptFiles_C=be_TakeStartUpRibbonScripts_C+1. % 2013
    be_SaveFileContent_C=be_TakeRibbonScriptFiles_C+1. % 2014
    be_TakeCoreDictionaryInitResponse_C=be_SaveFileContent_C+1. % 2015
    be_CoreDictionaryCreated_C=be_TakeCoreDictionaryInitResponse_C+1. % 2016
    be_EndOfDictionaryList_C=be_CoreDictionaryCreated_C+1. % 2017

constants % Core BackEnd errors (3001...4000)
    be_Error_C=3001. % no deep knowledge
    be_Timeout_C=be_Error_C+1. % 3002
    be_RpcError_C=be_Timeout_C+1. % 3003
    be_NoEndOfChainError_C=be_RpcError_C+1. % 3004
    be_NonResponsiveServer_C=be_NoEndOfChainError_C+1. % 3005
    be_Non200Status_C=be_NonResponsiveServer_C+1. % 3006

%======= Test-related Codes in the range 4001... 8000
%======= User Codes in the range 8001...

end interface coreIdentifiers