% Copyright (c) Prolog Development Center SPb
%

implement fe_Tasks inherits fe_Connector
    open core, vpiDomains, pfc\asynchronous, pfc\log
    open  defaultDictionary,edf, coreIdentifiers, dataExchangeIdentifiers, /*frontEnd,*/ eventManager

clauses
    new(FrontEnd) :-
        fe_Connector::new(FrontEnd).

clauses
    mapPromise(_Promise, _Any, _BeResponces).

clauses
    tryHandleRespondedData(0, _EdfData).

clauses
    onTimeOut(RequestId,TraceId):-
        ParentWindow=tryConvert(window,fe_AppWindow()),
        !,
        spbExceptionDialog::displayError(ParentWindow,TraceID,string::format("TimeOut Event. Context=[%]",RequestId)).
    onTimeOut(_RequestId,_TraceId).

/* Internal tasks invocations */
clauses
    help(NameSpace) :-
        mainExe::getFilename(Path, _),
        DefaultHelpFile = string::concat(filename::createPath(Path, @"$$(Project.Name)AppData\"),@"helpEn.html"),
        HelpFile = fe_Dictionary():getStringByKey(string::concat(NameSpace, @"\", helpFile_C), DefaultHelpFile),
        shell_api::shellOpen(HelpFile).

constants
    aboutShadow_C : binary = #bininclude(@"Doc\VicShadow.jpg").

clauses
    about(_NameSpace) :-
        Icon = icon::createFromImages([bitmap::createFromBinary(aboutShadow_C)]),
        DlgObj = aboutDialog::new(convert(window, fe_AppWindow())),
        _Font1 = vpi::fontCreate(ff_Times, [fs_Bold], 11),
        DlgObj:productFamilyFont_P := vpi::fontCreate(ff_Times, [fs_Bold], 11),
        DlgObj:productFamily_P := "SPBrSolutions",
        DlgObj:productNameFont_P := vpi::fontCreate(ff_Times, [fs_Bold], 11),
        DlgObj:productName_P := "ProjectTemplate\nVersion 1.0",
        DlgObj:copyrightFont_P := vpi::fontCreate(ff_Times, [fs_Bold], 11),
        DlgObj:copyright_P := "(c) Prolog Development Center SPb.",
        DlgObj:companyNameFont_P := vpi::fontCreate(ff_Helvetica, [], 11),
        DlgObj:companyName_P := "Developed by Victor Yukhtenko",
        DlgObj:contentFont_P := vpi::fontCreate(ff_Helvetica, [], 9),
        DlgObj:content_P :=
            "Provides the creation of the applications based on client-server architecture.\nMain features are:\n  - multilanguage mechanizm;\n  - pzl-components (dll-based) as plagins;\n  - http-communication with backend as the service (or remote server).\nVisual Prolog is a registered trademark of Prolog Development Center A/S (Denmark).",
        DlgObj:image_P := Icon:getImage(64, 65),
        DlgObj:show().

end implement fe_Tasks
