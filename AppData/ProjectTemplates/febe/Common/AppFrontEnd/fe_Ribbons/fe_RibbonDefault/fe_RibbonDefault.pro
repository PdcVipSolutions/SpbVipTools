%

implement fe_RibbonDefault
    inherits fe_Connector

    open core, ribbonControl, vpiDomains
    open defaultDictionary

facts
    nameSpace_V:string:=frontEnd::basicNS_C.

clauses
    new(FrontEnd):-
        fe_Connector::new(FrontEnd).

clauses
    setRibbonContext(_CmdContext).

%    if no appHead_Ribbon.xml script file defined, then these commands are initiated for the ribbon
clauses
    getRibbonLayout(Fe_Form,ContextObj)=[SectionBasic,InitialSection/*,TestSection*/]:-
 % default Commands
        OptionsCmdId=string::concat(frontEnd::basicNS_C,@"\","ribbon.default.cmd.options"),
        OptionsCmd = command::new(Fe_Form,OptionsCmdId),
        OptionsCmd:ribbonLabel := fe_Dictionary():getStringByKey(OptionsCmdId,"Options"),
        OptionsCmd:tipTitle := toolTip::tip(fe_Dictionary():getStringByKey(string::concat(OptionsCmdId,".tooltip"),"Options")),
        OptionsCmd:icon :=some(icon::createFromImages([bitmap::createFromBinary(optionsIcon32_C)])),
        OptionsCmd:run := onOptions,

        HelpCmdId=string::concat(frontEnd::basicNS_C,@"\","ribbon.default.cmd.help"),
        HelpCmd = command::new(Fe_Form,HelpCmdId),
        HelpCmd:ribbonLabel := fe_Dictionary():getStringByKey(HelpCmdId,"Help"),
        HelpCmd:tipTitle := toolTip::tip(fe_Dictionary():getStringByKey(string::concat(HelpCmdId,".tooltip"),"Help")),
        HelpCmd:icon :=some(icon::createFromImages([bitmap::createFromBinary(helpIcon32_C)])),
        HelpCmd:run := onHelp,

        AboutCmdId=string::concat(frontEnd::basicNS_C,@"\","ribbon.default.cmd.about"),
        AboutCmd = command::new(Fe_Form,AboutCmdId),
        AboutCmd:ribbonLabel := fe_Dictionary():getStringByKey(AboutCmdId,"About"),
        AboutCmd:tipTitle := toolTip::tip(fe_Dictionary():getStringByKey(string::concat(AboutCmdId,".tooltip"),"About")),
        AboutCmd:icon := some(icon::createFromImages([bitmap::createFromBinary(aboutIcon32_C)])),
        AboutCmd:run := onAbout,
        AboutCmd:enabled := true,

        SectionBasicID=string::concat(frontEnd::basicNS_C,@"\",ribbon_default_section_basic_C),
        Options_Help_About = block([
            [cmd(OptionsCmd:id, imageAndText(vertical))],
            [cmd(AboutCmd:id, imageAndText(vertical))],
            [cmd(HelpCmd:id, imageAndText(vertical))]
            ]),
        SectionBasic = section(SectionBasicID, fe_Dictionary():getStringByKey(SectionBasicID,"Help"), toolTip::noTip,core::none,
            [
            Options_Help_About
            ]),

        DesignCmdId=string::concat(frontEnd::basicNS_C,@"\","ribbon.cmd.design-ribbon"),
        DesignCmd = command::new(Fe_Form,DesignCmdId),
        DesignCmd:ribbonLabel := fe_Dictionary():getStringByKey(DesignCmdId,"Design"),
        DesignCmd:tipTitle := toolTip::tip(fe_Dictionary():getStringByKey(string::concat(DesignCmdId,".tooltip"),"Design")),
        DesignCmd:icon :=some(icon::createFromImages([bitmap::createFromBinary(designIcon32_C)])),
        if DesignCmd:run := ContextObj:tryGetRunner("default") then end if,

        ExpandCmdId=string::concat(frontEnd::basicNS_C,@"\","ribbon.cmd.add-ribbon-extension"),
        ExpandCmd = command::new(Fe_Form, ExpandCmdId),
        ExpandCmd:ribbonLabel := fe_Dictionary():getStringByKey(ExpandCmdId,"Expand"),
        ExpandCmd:tipTitle := toolTip::tip(fe_Dictionary():getStringByKey(string::concat(ExpandCmdId,".tooltip"),"Expand")),
        ExpandCmd:icon :=some(icon::createFromImages([bitmap::createFromBinary(expandIcon32_C)])),
        if ExpandCmd:run := ContextObj:tryGetRunner("add-extension") then end if,

        ReloadCmdId=string::concat(frontEnd::basicNS_C,@"\","ribbon.cmd.restore-ribbon-layout"),
        ReloadCmd = command::new(Fe_Form, ReloadCmdId),
        ReloadCmd:ribbonLabel := fe_Dictionary():getStringByKey(ReloadCmdId,"Reload"),
        ReloadCmd:tipTitle := toolTip::tip(fe_Dictionary():getStringByKey(string::concat(ReloadCmdId,".tooltip"),"Reload")),
        ReloadCmd:icon :=some(icon::createFromImages([bitmap::createFromBinary(reloadIcon32_C)])),
        if ReloadCmd:run := ContextObj:tryGetRunner("default") then end if,
        Design_Expand_Reload =  block([
            [cmd(DesignCmd:id, imageAndText(vertical))],
            [cmd(ExpandCmd:id, imageAndText(vertical))],
            [cmd(ReloadCmd:id, imageAndText(vertical))]
            ]),
        SectionID=string::concat(frontEnd::basicNS_C,@"\",ribbon_default_section_C),
        InitialSection = section(SectionID, fe_Dictionary():getStringByKey(SectionID,"Ribbon"), toolTip::noTip,core::none,
            [
            Design_Expand_Reload
            ]),

%        CustomCmd1 = customCommand::new(Fe_Form, string::concat(frontEnd::basicNS_C,@"\","custom.control.1")),
%        CustomCmd1:ribbonLabel := "CustomCmd1",
%        CustomCmd1:width := 200,
%        CustomCmd1:height := 15,
%        CustomCmd1:factory :={ () = listButton::new()},
%
%        CustomCmd2 = customCommand::new(Fe_Form, string::concat(frontEnd::basicNS_C,@"\","custom.control.2")),
%        CustomCmd2:ribbonLabel := "CustomCmd2",
%        CustomCmd2:tipTitle := toolTip::tip("Demo CustomControl Tooltip"),
%        CustomCmd2:width := 200,
%        CustomCmd2:height := 15,
%        CustomCmd2:factory :={ () = editControl::new()},
%
%        CustomCmd3 = customCommand::new(Fe_Form, string::concat(frontEnd::basicNS_C,@"\","custom.control.3")),
%        CustomCmd3:ribbonLabel := "CustomCmd3",
%        CustomCmd3:width := 80,
%        CustomCmd3:height := 15,
%        CustomCmd3:factory :={ () =TextCtl:- TextCtl=textControl::new(),TextCtl:setText("Hello People!")},
%
%        CustomCmd4 = customCommand::new(Fe_Form, string::concat(frontEnd::basicNS_C,@"\","custom.control.4")),
%        CustomCmd4:ribbonLabel := "CustomCmd4",
%        CustomCmd4:width := 50,
%        CustomCmd4:height := 15,
%        CustomCmd4:factory :={ () =TextCtl:- TextCtl=checkButton::new(),TextCtl:setText("Check Button!")},
%
%        TestSectionID="TestSection",
%        TestSection = section(TestSectionID, "JustTest", toolTip::noTip,core::none,
%            [
%                block([[cmd(CustomCmd1:id, textOnly)],[cmd(CustomCmd2:id, textOnly)]]),
%                block([[cmd(CustomCmd3:id, textOnly)],[cmd(CustomCmd4:id, textOnly)]])
%            ]),
        succeed().

predicates
    onOptions:(command).
clauses
    onOptions(_):- fe_CoreTasks():editOptions().

predicates
    onAbout:(command).
clauses
    onAbout(_):- fe_Tasks():about(nameSpace_V).

predicates
    onHelp:(command).
clauses
    onHelp(_):- fe_Tasks():help(nameSpace_V).

end implement fe_RibbonDefault
