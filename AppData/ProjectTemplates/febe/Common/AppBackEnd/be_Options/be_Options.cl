%

class be_Options : be_Options
    open core

constants
    emptyString_C:string="".


constants
    embeddedFileName_C:string=@"..\bin\$$(Project.Name)AppData\Ribbons\ribbon_basic.xml".
    embeddedRibbonXml_C:binary=#bininclude(@"..\bin\$$(Project.Name)AppData\Ribbons\ribbon_basic.xml").

constants
% Options Xml
    %Node titles
    ribbonNode_C="ribbon".
    groupNode_C= "group".
    be_OptionsNode_C="be_options".
    fe_OptionsNode_C="fe_options".
    fe_AppWindow_C="fe_AppWindow".

    languageNode_C="language".
    support_C="support".
    loadable_C="loadable".
    embedded_C="embedded".
    default_C="default".

    lastLayout_C= "lastlayout".
    sourceLayout_C= "sourcelayout".

    ribbonChangedTime_C="ribbon-changetime".
    ribbonStartup_C="ribbon-startup".
    ribbonUseLast_C="ribbon-uselast".
    lastUsedstartup_C="ribbon-lastusedstartup".
    ribbonState_C="ribbon-state".


    %Node attributes titles
%ribbon
    startup_C = "startup".
    changeTime_C="changetime".
    usedStartup_C= "usedstartup".
    useLast_C="uselast".
    state_C="state".
    script_C="script".
    supportedLanguage_C="supportedLanguage".

% Language
    current_C = "current".
    lastUsedLanguage_C="last".
    use_dictionary_C="use-dictionary".
    title_C="title".
    refresh_C="refresh".
constructors
    new:(backEnd).

end class be_Options