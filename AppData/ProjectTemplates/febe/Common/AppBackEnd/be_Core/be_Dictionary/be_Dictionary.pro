%
implement be_Dictionary
    inherits be_Connector

    open core,  pfc\log
    open edf, xmlNavigate, be_Options

facts
    dictionarySource_V:entityRegistry{string DictionaryXmlFileName}:=entityRegistry{string DictionaryXmlFileName}::new().
    dictionaryXmlDoc_V:entityRegistry{xmlDocument DictionaryXmlDocument}:=entityRegistry{xmlDocument DictionaryXmlDocument}::new().
    substitution_V:entityRegistry{string SubstituteToText}:=entityRegistry{string SubstituteToText}::new().

clauses
    new(BackEnd):-
        be_Connector::new(BackEnd).

clauses
    tryAdd_DictionaryNameSpace(NameSpace,DictionaryXmlFile):- % dictionary is active
        dictionarySource_V:getNameAndEntity_nd(NS,DictionaryFile),
            string::equalIgnoreCase(NameSpace,NS),
            string::equalIgnoreCase(filename::normalize(DictionaryXmlFile),filename::normalize(DictionaryFile)),
        !.
    tryAdd_DictionaryNameSpace(NameSpace,DictionaryXmlFile):-
        file::existExactFile(DictionaryXmlFile),
        MakeObj=dictionarySupport::new(),
        LanguageList=be_Options():getSupportedLanguagesList(),
        Languages=[namedValue(LanguageID,string(LanguageTitle))||tuple(LanguageID,LanguageTitle,_LanguageFlagId) in LanguageList],
        MakeObj:languageList_P:=Languages,
        MakeObj:nameSpace_P:=NameSpace,
        MakeObj:dictionaryFileName_P:=DictionaryXmlFile,
        XmlDictionary=MakeObj:createDictionaryXmlDocument(),
        checkVersionAndStoreSubstitutions(XmlDictionary),
        !,
        dictionarySource_V:register(NameSpace,DictionaryXmlFile),
        dictionaryXmlDoc_V:register(NameSpace,XmlDictionary).

clauses
    remove_DictionaryNameSpace(NameSpace):-
        dictionarySource_V:unRegisterByName(NameSpace),
        dictionaryXmlDoc_V:unRegisterByName(NameSpace).

clauses
    create_CoreDictionary(NameSpace,DictionaryXmlFile, TupleItemList):-
        !,
        MakeObj=dictionarySupport::new(),
        LanguageList=be_Options():getSupportedLanguagesList(), %->tuple{string LanguageName,string LanguageTitle, string LanguageFlagId}*.
        Languages=[namedValue(LanguageID,string(LanguageTitle))||tuple(LanguageID,LanguageTitle,_LanguageFlagId) in LanguageList],
        if a([av(use_dictionary_C, s("yes"))])=be_Options():getFrontEndOptions(a([s(use_dictionary_C)])) then
            MakeObj:saveDictionary_P:=true
        else
            MakeObj:saveDictionary_P:=false
        end if,
        MakeObj:languageList_P:=Languages,
        MakeObj:nameSpace_P:=NameSpace,
        MakeObj:dictionaryFileName_P:=DictionaryXmlFile,
        XmlDictionary=MakeObj:doIt(TupleItemList),
        dictionaryXmlDoc_V:register(NameSpace,XmlDictionary),
        dictionarySource_V:register(NameSpace,DictionaryXmlFile).


predicates
    checkVersionAndStoreSubstitutions:(xmlDocument XmlDictionary).
clauses
    checkVersionAndStoreSubstitutions(XmlDictionary):-
        if Root = XmlDictionary:getNode_nd([root()]),! then
            checkFormatAndVersion(Root)
        else
            exception::raise_User("Unexpected alternative")
        end if,
        foreach  SubstitutionNode = XmlDictionary:getNode_nd([root(),child(substitute_C, {(_)})]) do
            if
                SubstitutionID=SubstitutionNode:attribute(id_C),
                xmlElement::text(SubstitudeBy)=SubstitutionNode:tryGetItem(xmlElement::text, 1)
            then
                substitution_V:register(SubstitutionID,SubstitudeBy),
                log::writef(log::info,"declared Substitution [%] as [%]",SubstitutionID,SubstitudeBy)
            else
                NoSubstituionIDMessage="The SubstitutionNode must have SubstitutionID and the SubstitudeBy",
                log::write(log::error,NoSubstituionIDMessage),
                exception::raise_User(NoSubstituionIDMessage)
            end if
        end foreach.

clauses
    getDictionary_nd() = av(NameSpace,DictionaryItemArray):-
        dictionaryXmlDoc_V:getNameAndEntity_nd(NameSpace,XmlDictionary),
            DictionaryItemArray=getNSDictionary(NameSpace,XmlDictionary),
            succeed().

clauses
    getDictionary(NameSpace) = DictionaryItemArray:-
        XmlDictionary=dictionaryXmlDoc_V:getEntityByName_nd(NameSpace),
        !,
        DictionaryItemArray=getNSDictionary(NameSpace,XmlDictionary),
        succeed().
    getDictionary(NameSpace) = _:-
        ErrorMsg=string::format("No dictionary for the NameSpace [%] found",NameSpace),
        log::write(log::error,ErrorMsg),
        exception::raise_User(ErrorMsg).

predicates
    getNSDictionary:(string NameSpace,xmlDocument XmlDictionary)->edf_D DictionaryItemArray.
clauses
    getNSDictionary(_NameSpace,XmlDictionary)=a(DictionaryItemList):-
        CurrentLanguage=be_Options():currentLanguage_P,
        DictionaryItemList=[DictionaryItem||
            Node = XmlDictionary:getNode_nd([root(), child("*", {(O):-O:name_P="row"})]),
            Key=Node:attribute("id"),
            if
                LngNode = Node:getNode_nd([self({(_)}), child(CurrentLanguage, {(_)})]),
                xmlElement::text(NodeText)=LngNode:tryGetItem(xmlElement::text,1),
                Text=tryResolvePrefix(NodeText)
            then
                % The text definition for the current language exists
            else
                Text="undefined" % we will see in the UI where the language localization is not defined for the given item
            end if,
            DictionaryItem=av(Key,s(Text))
        ].

clauses
    getLanguageList() =a(LanguageList):-
        SupportedLanguageList=be_Options():getSupportedLanguagesList(),
        if not(SupportedLanguageList=[]) then
            LanguageList=[a([bl(toBoolean(be_Options():currentLanguage_P = LanguageName)),av(LanguageName,av(LanguageTitle,s(LanguageFlagId)))])||
                tuple(LanguageName,LanguageTitle,LanguageFlagId) in SupportedLanguageList]
        else
            LanguageList=[a([bl(true),av(be_Options::baseLanguage_C,s(be_Options::baseLanguageTitle_C))])],
            log::write(log::info,"No Language List found. Base Language only [%] titled as [%] will be used",be_Options::baseLanguage_C,be_Options::baseLanguageTitle_C)
        end if.

predicates
    checkFormatAndVersion:(xmlElement RootNode).
clauses
    checkFormatAndVersion(Root):-
        not(Root:name_P=dictionaryRootName_C),
        Message="The xmlDictionaryScript\'s Root must have the name \"language\"",
        log::write(log::error,Message),
        exception::raise_User(Message).
    checkFormatAndVersion(Root):-
        if Root:attribute(version_C)=XmlScriptVersion
        then
            if XmlScriptVersion=xmlDictionaryScriptVersion_C
            then
            else
                Message=string::format("The xmlRibbonScript version [%] is invalid.\n Must correspond to [%]",XmlScriptVersion, xmlDictionaryScriptVersion_C),
                log::write(log::error,Message),
                exception::raise_User(Message)
            end if
        else
            Message="The xmlDictionaryScript version must be declared as the root attribute \"version\"",
            log::write(log::error,Message),
            exception::raise_User(Message)
        end if.

predicates
    tryResolvePrefix:(string SourceString)->string ResultString determ.
clauses
    tryResolvePrefix("")=_SourceString:-!,fail.
    tryResolvePrefix(SourceString)=ResultString:-
        if %check if SourceString has inclusions like  $(KeyWord)
            FragmentList=string::split_delimiter(SourceString,"$("),
            not(FragmentList=[]),
            not(FragmentList=[SourceString]) % no delimeter met
        then
            ResultFragmentList=
                [Result|| Fragment in FragmentList,
                    if
                        string::splitStringBySeparators(Fragment,")",HeadStr,_Separator,RestStr)
                    then
                        SubstituionValue=substitution_V:getEntityByName_nd(HeadStr),
                        Result=string::concat(SubstituionValue,RestStr)
                    else
                        Result=Fragment,
                        log::writef(log::error,"No closing bracket in the substitution-oriented string [%]",Fragment)
                    end if
                ],
            ResultString=string::concatlist(ResultFragmentList)
        else
            ResultString=SourceString
        end if.

facts
    dictionary_V : xmlDocument := erroneous.
    languages_V: string*:=[].
clauses
    removeExtraLanguagesFromAllDictionaries() :-
        languages_V:=[],
        SupportedLanguageList=be_Options():getSupportedLanguagesList(),
        ActualLanguageList=[Language||tuple(Language,_,_) in SupportedLanguageList],
        foreach FileName = directory::getFilesInDirectoryAndSub_nd(@".\", "*_Dictionary.xml") do
            dictionary_V := xmlDocument::new("language"),
            dictionary_V:codePage_P := utf8,
            dictionary_V:indent_P := true,
            dictionary_V:xmlStandalone_P := xmlLite::yes,
            XmlOptions = inputStream_file::openFile(FileName, stream::binary),
            spbXmlLigntSupport::read(XmlOptions, dictionary_V),
            XmlOptions:close(),
            if FrontEndNode=dictionary_V:getNode_nd([root(),child("language_list", { (_) })]),!
            then
                foreach tuple(_,LanguageId,_LanguageTitle)=FrontEndNode:getAttribute_nd() do
                    if not(tuple(LanguageId,_,_) in SupportedLanguageList) then
                        FrontEndNode:removeAttribute(LanguageId),
                        log::writef(log::info,"removed language % at language-list node (file [%])",LanguageId, FileName)
                    end if
                end foreach
            end if,
            foreach Node = dictionary_V:getNode_nd([root(), child("row", { (_) })]) do
                foreach ExtraLangNode = Node:getNode_nd([child("*", { (O):-not(O:name_P in ActualLanguageList) })]) do
                    Node:removeNode(ExtraLangNode),
                    if not(ExtraLangNode:name_P in languages_V) then
                        languages_V:=[ExtraLangNode:name_P|languages_V]
                    end if
                end foreach
            end foreach,
            OutputStream = outputStream_file::create(FileName, stream::binary),
            dictionary_V:saveXml(OutputStream),
            if languages_V=[] then
                log::writef(log::info,"no Extra Languages found in  dictionary file [%]\n", FileName)
            else
                log::writef(log::info,"phrases of languages [%] removed from dictionary file [%]",languages_V, FileName)
            end if
        end foreach.

end implement be_Dictionary
