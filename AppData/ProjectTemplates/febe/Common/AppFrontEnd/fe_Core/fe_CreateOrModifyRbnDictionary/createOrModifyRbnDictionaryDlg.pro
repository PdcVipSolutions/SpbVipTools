%

implement createOrModifyRbnDictionaryDlg inherits dialog
    open core, vpiDomains, string, createRbnDictionaryDlg_Dictionary

facts - scripts
    file_F:(string Name,string FileName,string NameSpace,string DictionaryFile).

facts
    frontEnd_V:frontEnd:=erroneous.
    invoker_V:fe_CreateOrModifyRbnDictionary:=erroneous.
    frontEndFileUsed_V:boolean:=false.
    coreDictionary_P:coreDictionary:=erroneous.
    dictionary_P:dictionary:=erroneous.

clauses
    new(Parent,FrontEnd,Invoker) :-
        frontEnd_V:=FrontEnd,
        invoker_V:=Invoker,
        dialog::new(Parent),
        generatedInitialize(),
        coreDictionary_P:=createRbnDictionaryDlg_Dictionary::new().

clauses
    initData():-
        DictNameSpace=coreDictionary_P:nameSpace_P,
        scriptFilename_STT_ctl : setText(dictionary_P:getStringByKey(concat(DictNameSpace,"/",scriptFilename_STT_C),scriptFilename_STT_ctl:getText())),
        namespace_STT_ctl : setText(dictionary_P:getStringByKey(concat(DictNameSpace,"/",namespace_STT_C),namespace_STT_ctl:getText())),
        dictionaryFileName_STT_ctl : setText(dictionary_P:getStringByKey(concat(DictNameSpace,"/",dictionaryFileName_STT_C),dictionaryFileName_STT_ctl:getText())),
        browse_PB_ctl : setText(dictionary_P:getStringByKey(concat(DictNameSpace,"/",browse_PB_C),browse_PB_ctl:getText())),
        modifySourceScript_CHB_ctl : setText(dictionary_P:getStringByKey(concat(DictNameSpace,"/",modifySourceScript_CHB_C),modifySourceScript_CHB_ctl:getText())),
        ribbonScript_LB_ctl:selectAt(0),
        file_F(_Name,_FileName,NameSpace,DictionaryFile),
        !,
        nameSpace_EC_ctl:setText(NameSpace),
        dictionaryFileName_EC_ctl:setText(DictionaryFile).
    initData().

clauses
    setFileCandidates(tuple(FileName,NameSpace,DictionaryFile)):-
        fileName::getPathAndName(FileName,Path,Name),
        assert(file_F(Name,FileName,NameSpace,DictionaryFile)),
        ribbonScript_LB_ctl:add(string::format("% (%)",Name,Path)).

predicates
    onBrowse_PBClick : button::clickResponder.
clauses
    onBrowse_PBClick(_Source) = button::defaultAction:-
        RibbonScriptFile = vpiCommonDialogs::getFileName
            ("*.xml", ["Ribbon File","*.xml"], "Ribbon File", [vpiDomains::dlgfn_filemustexist], frontEnd_V:lastFolder_P),
            try
                TmpDoc=xmlDocument::new("ribbon-layout"),
                TmpDoc:codePage_P:=utf8,
                TmpDoc:indent_P:=true,
                TmpDoc:xmlStandalone_P:=xmlLite::yes,
                XmlFileAsBinary = inputStream_file::openFile(RibbonScriptFile, stream::binary),
                spbXmlLigntSupport::read(XmlFileAsBinary, TmpDoc),
                XmlFileAsBinary:close(),
                RootNode = TmpDoc:getNode_nd([xmlNavigate::root()]),
                "ribbon-layout"=RootNode:name_P,
                if DictionaryNode = RootNode:getNode_nd([xmlNavigate::child("dictionary",{(_)})]) then
                    if NameSpace=DictionaryNode:attribute("namespace") then
                    else
                        NameSpace=""
                    end if,
                    if DictionaryFile=DictionaryNode:attribute("file") then
                    else
                        DictionaryFile=""
                    end if
                else
                    NameSpace="",
                    DictionaryFile=""
                end if,
                !,
                fileName::getPathAndName(RibbonScriptFile,Path,Name),
                frontEnd_V:lastFolder_P:=Path,
                ribbonScript_LB_ctl:clearList(),
                ribbonScript_LB_ctl:addAt(0,string::format("% (%)",Name,Path)),
                ribbonScript_LB_ctl:selectAt(0),
                nameSpace_EC_ctl:setText(NameSpace),
                dictionaryFileName_EC_ctl:setText(DictionaryFile),
                retractFactDb(scripts),
                assert(file_F(Name,RibbonScriptFile,NameSpace,DictionaryFile)),
                frontEndFileUsed_V:=true
            catch _Trace do
                fail
            end try.
    onBrowse_PBClick(_Source) = button::defaultAction.
% TODO Message must be here

predicates
    onRibbonScript_LBSelectionChanged : listControl::selectionChangedListener.
clauses
    onRibbonScript_LBSelectionChanged(_Source):-
        [FileData]=ribbonScript_LB_ctl:getSelectedItems(),
        [FileName|_]=string::split(FileData,"("),
        Name=string::trim(FileName),
        file_F(Name,_FileNameSrc,NameSpace,DictionaryFile),
        !,
        nameSpace_EC_ctl:setText(NameSpace),
        dictionaryFileName_EC_ctl:setText(DictionaryFile).
    onRibbonScript_LBSelectionChanged(_Source).

predicates
    onOkClick : button::clickResponder.
clauses
    onOkClick(_Source) = button::noAction:-
        ""=string::trim(nameSpace_EC_ctl : getText()),
        !,
        vpiCommondialogs::error("NameSpace content Error","NameSpace can not be EmptyString"),
        nameSpace_EC_ctl:setFocus().
    onOkClick(_Source) = button::noAction:-
        ""=string::trim(dictionaryFileName_EC_ctl : getText()),
        !,
        vpiCommondialogs::error("Dictionary FileName content Error","Dictionary FileName can not be EmptyString"),
        dictionaryFileName_EC_ctl:setFocus().
    onOkClick(_Source) = button::defaultAction:-
        [FileData]=ribbonScript_LB_ctl:getSelectedItems(),
        [FileName|_]=string::split(FileData,"("),
        Name=string::trim(FileName),
        file_F(Name,FileNameSrc,_NameSpace,_DictionaryFile),
        !,
        invoker_V:performTask(frontEndFileUsed_V,FileNameSrc,nameSpace_EC_ctl : getText(),dictionaryFileName_EC_ctl : getText(),modifySourceScript_CHB_ctl:getChecked()).
    onOkClick(_Source) = button::defaultAction.


% This code is maintained automatically, do not update it manually.
%  16:19:30-29.9.2019

facts
    ok_ctl : button.
    cancel_ctl : button.
    scriptFilename_STT_ctl : textControl.
    namespace_STT_ctl : textControl.
    dictionaryFileName_STT_ctl : textControl.
    browse_PB_ctl : button.
    nameSpace_EC_ctl : editControl.
    dictionaryFileName_EC_ctl : editControl.
    ribbonScript_LB_ctl : listButton.
    modifySourceScript_CHB_ctl : checkButton.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setText("createOrModifyRbnDictionaryDlg"),
        setRect(rct(50, 40, 298, 157)),
        setModal(true),
        setDecoration(titlebar([closeButton])),
        setBorder(sizeBorder()),
        setState([wsf_NoClipSiblings]),
        browse_PB_ctl := button::new(This),
        browse_PB_ctl:setText("Browse"),
        browse_PB_ctl:setPosition(200, 8),
        browse_PB_ctl:setSize(44, 12),
        browse_PB_ctl:defaultHeight := false,
        browse_PB_ctl:setAnchors([control::top, control::right]),
        browse_PB_ctl:setClickResponder(onBrowse_PBClick),
        nameSpace_EC_ctl := editControl::new(This),
        nameSpace_EC_ctl:setText("Use or modify this NameSpace"),
        nameSpace_EC_ctl:setPosition(60, 36),
        nameSpace_EC_ctl:setWidth(136),
        nameSpace_EC_ctl:setAnchors([control::left, control::top, control::right]),
        dictionaryFileName_EC_ctl := editControl::new(This),
        dictionaryFileName_EC_ctl:setText("Use or modify this dictionary FileName"),
        dictionaryFileName_EC_ctl:setPosition(60, 60),
        dictionaryFileName_EC_ctl:setWidth(136),
        dictionaryFileName_EC_ctl:setAnchors([control::left, control::top, control::right]),
        ok_ctl := button::newOk(This),
        ok_ctl:setText("&OK"),
        ok_ctl:setPosition(60, 98),
        ok_ctl:setSize(56, 16),
        ok_ctl:defaultHeight := false,
        ok_ctl:setClickResponder(onOkClick),
        cancel_ctl := button::newCancel(This),
        cancel_ctl:setText("Cancel"),
        cancel_ctl:setPosition(124, 98),
        cancel_ctl:setSize(56, 16),
        cancel_ctl:defaultHeight := false,
        scriptFilename_STT_ctl := textControl::new(This),
        scriptFilename_STT_ctl:setText("RibbonScript FileName"),
        scriptFilename_STT_ctl:setPosition(4, 6),
        scriptFilename_STT_ctl:setSize(52, 26),
        namespace_STT_ctl := textControl::new(This),
        namespace_STT_ctl:setText("Dictionary NameSpace"),
        namespace_STT_ctl:setPosition(4, 34),
        namespace_STT_ctl:setSize(52, 24),
        dictionaryFileName_STT_ctl := textControl::new(This),
        dictionaryFileName_STT_ctl:setText("Dictionary FileName"),
        dictionaryFileName_STT_ctl:setPosition(4, 58),
        dictionaryFileName_STT_ctl:setSize(52, 26),
        ribbonScript_LB_ctl := listButton::new(This),
        ribbonScript_LB_ctl:setPosition(60, 8),
        ribbonScript_LB_ctl:setWidth(136),
        ribbonScript_LB_ctl:setMaxDropDownRows(5),
        ribbonScript_LB_ctl:setAnchors([control::left, control::top, control::right]),
        ribbonScript_LB_ctl:addSelectionChangedListener(onRibbonScript_LBSelectionChanged),
        modifySourceScript_CHB_ctl := checkButton::new(This),
        modifySourceScript_CHB_ctl:setText(" Modify Source Script"),
        modifySourceScript_CHB_ctl:setPosition(60, 82),
        modifySourceScript_CHB_ctl:setWidth(136).
% end of automatic code

end implement createOrModifyRbnDictionaryDlg
