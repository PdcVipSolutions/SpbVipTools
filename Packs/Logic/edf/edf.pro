% Copyright (c) Prolog Development Center SPb

implement edf
    open core

clauses
    fromValue(core::none)=edf::n:-!.
    fromValue(boolean(Value))=bl(Value):-!.
    fromValue(unsigned(Value))=u(Value):-!.
    fromValue(unsigned64(Value))=u64(Value):-!.
    fromValue(integer(Value))=i(Value):-!.
    fromValue(integer64(Value))=i64(Value):-!.
    fromValue(real(Value))=r(Value):-!.
    fromValue(char(Value))=c(Value):-!.
    fromValue(string(Value))=s(Value):-!.
    fromValue(string8(Value))=s8(Value):-!.
    fromValue(binary(Value))=b(Value):-!.
    fromValue(binaryNonAtomic(Value))=bNA(Value):-!.
    fromValue(gmtTimeValue(Value))=tg(Value):-!.
    fromValue(localTimeValue(Value))=tl(Value):-!.
    fromValue(object(Value))=o(Value):-!.
    fromValue(AnyOther)=_:-
        exception::raise_User(string::format("Not supported conversion for [%]",AnyOther)).

clauses
    fromValueList(ValueList)=a([fromValue(Value)||Value in ValueList]).

clauses
    fromNamedValueList(NamedValueList)=a([av(Name,fromValue(Value))||namedValue(Name,Value) in NamedValueList]).

clauses
    toValue(edf::n)=core::none:-!.
    toValue(bl(Value))=boolean(Value):-!.
    toValue(u(Value))=unsigned(Value):-!.
    toValue(u64(Value))=unsigned64(Value):-!.
    toValue(i(Value))=integer(Value):-!.
    toValue(i64(Value))=integer64(Value):-!.
    toValue(r(Value))=real(Value):-!.
    toValue(c(Value))=char(Value):-!.
    toValue(s(Value))=string(Value):-!.
    toValue(s8(Value))=string8(Value):-!.
    toValue(b(Value))=binary(Value):-!.
    toValue(bNA(Value))=binaryNonAtomic(Value):-!.
    toValue(o(Value))=object(Value):-!.
    toValue(tg(Value))=gmtTimeValue(Value):-!.
    toValue(tl(Value))=localTimeValue(Value):-!.
    toValue(AnyOther)=_:-
        exception::raise_User(string::format("Not supported conversion for [%]",AnyOther)).

clauses
    toValueList(a(ExchValueList))=[toValue(ExchValue)||ExchValue in ExchValueList]:-!.
    toValueList(AnyOther)=_:-
        exception::raise_User(string::format("Not supported conversion for [%]",AnyOther)).

clauses
    toNamedValueList(a(ExchNamedValueList))=[namedValue(Name,toValue(ExchValue))||av(Name,ExchValue) in ExchNamedValueList]:-!.
    toNamedValueList(AnyOther)=_:-
        exception::raise_User(string::format("Not supported conversion for [%]",AnyOther)).

clauses
    toJson(_O,n) = json::n:-!.
    toJson(_O,bl(false)) = json::f:-!.
    toJson(_O,bl(true)) = json::t:-!.
    toJson(_O,s(Value)) = json::s(Value):-!.
    toJson(_O,r(Value)) = json::r(Value):-!.
    toJson(_O,u64(Value)) = json::a([json::s("u64_"),json::r(Value)]):-!.
    toJson(_O,i64(Value)) = json::a([json::s("i64_"),json::r(Value)]):-!.
    toJson(_O,u(Value)) = json::a([json::s("u_"),json::r(Value)]):-!.
    toJson(_O,i(Value)) = json::a([json::s("i_"),json::r(Value)]):-!.
    toJson(_O,c(Value)) = json::a([json::s("c_"),json::s(string::charToString(Value))]):-!.
    toJson(_O,s8(Value)) = json::a([json::s("s8_"),json::s(string8::fromUtf8(Value))]):-!.
    toJson(_O,b(Value)) = json::a([json::s("b_"),json::s(cryptography::base64_encode(Value))]):-!.
    toJson(_O,tg(Value)) = json::a([json::s("tg_"),json::s(toString(Value))]):-!.
    toJson(_O,tl(Value)) = json::a([json::s("tl_"),json::s(toString(Value))]):-!.
    toJson(O,rf(Value)) = json::a([json::s("rf_"),toJson(O,Value)]):-!.
    toJson(_O,err(ErrorCode,ErrorText)) = json::a([json::s("error"),json::r(ErrorCode),json::s(ErrorText)]):-!.
    toJson(O,a(Array)) = Json:-
        if J_Array=tryCorrectArray(O,Array) then
           Json=json::a(J_Array)
        elseif hasDomain(jsonObject,Jobject),Jobject=tryCorrectObject(O,Array) then
            Json=json::o(Jobject)
        else
            Json=json::o(O)
        end if,
        !.
    toJson(O,av(Name,Edf)) = json::o(O):- setValue(O,Name,Edf),!.
    toJson(_O,AnyOther)=_:-
        exception::raise_User(string::format("Not supported conversion for [%]",AnyOther)).

class predicates
    tryCorrectArray:(jsonObject,edf_D*)->json::jsonValue* determ. % list of scalars
clauses
    tryCorrectArray(_O,[av(_,_)])=_:-
        !,fail.
    tryCorrectArray(_O,[av(_,_)|_])=_:-
        !,fail.
    tryCorrectArray(_O,[])=[]:-!.
    tryCorrectArray(O,ValueList)=JsonList:-
       JsonList =[Json||Value in ValueList, Json = toJson(O,Value)].

class predicates
    tryCorrectObject:(jsonObject,edf_D*)->jsonObject determ. % list of named values
clauses
    tryCorrectObject(_O,AV_List)=NewJO:-
        try
            NewJO=jsonObject::new(),
            foreach
                AV in AV_List,
                if AV=av(Name,EdfValue) then
                else
                    exception::raise_User("to be failed")
                end if
            do
                setValue(NewJO,Name,EdfValue)
            end foreach
        catch _TraceID do
            fail
        end try.

clauses
    setValue(O,Name,av(SubName,Edf)):-
        NJO=O:set_newObject(Name),
        setValue(NJO,SubName,Edf),
        !.
    setValue(O,Name,n) :-!, O:setNull(Name).
    setValue(O,Name,bl(Value)) :-!, O: set_Boolean(Name,Value).
    setValue(O,Name,s(Value)) :-!, O: set_String(Name,Value).
    setValue(O,Name,r(Value)) :-!, O: set_Real(Name,Value).
    setValue(O,Name,a(Array)) :-!,
        Result=toJson(O,a(Array)),
        if Result=json::a(JArray) then O:set_Array(Name,JArray)
        elseif Result=json::o(NJO) then O:set_Object(Name,NJO)
        else
        end if .
    setValue(O,Name,i(Value)) :-!, setValue(O,Name,a([s("i_"),r(Value)])). %O:set_Integer(Name,Value).
    setValue(O,Name,i64(Value)) :-!, setValue(O,Name,a([s("i64_"),r(Value)])).%O:set_Integer64(Name,Value).
    setValue(O,Name,u(Value)) :-!, setValue(O,Name,a([s("u_"),r(Value)])).
    setValue(O,Name,u64(Value)) :-!, setValue(O,Name,a([s("u64_"),r(Value)])).
    setValue(O,Name,c(Value)) :-!, setValue(O,Name,a([s("c_"),s(string::charToString(Value))])).
    setValue(O,Name,s8(Value)) :-!, setValue(O,Name,a([s("s8_"),s(string8::fromUtf8(Value))])).
    setValue(O,Name,b(Value)) :-!, setValue(O,Name,a([s("b_"),s(cryptography::base64_encode(Value))])).
    setValue(O,Name,tg(Value)) :-!, setValue(O,Name,a([s("tg_"),s(toString(Value))])).
    setValue(O,Name,tl(Value)) :-!, setValue(O,Name,a([s("tl_"),s(toString(Value))])).
%    setValue(O,Name,rf(Value)) :- setValue(O,Name,a([s("rf_"),setValue(O,Name,Value)])). %TODO ?check where it was used
    setValue(O,Name,err(ErrorCode,ErrorText)) :-!, setValue(O,Name,av("error",a([i(ErrorCode),s(ErrorText)]))).
    setValue(_O,_Name,AnyOther):-
        exception::raise_User(string::format("Not supported conversion for [%]",AnyOther)).

clauses
    fromJson(json::n)=edf::n:-!.
    fromJson(json::s(S))=edf::s(S):-!.
    fromJson(json::r(S))=edf::r(S):-!.
    fromJson(json::t)=edf::bl(true):-!.
    fromJson(json::f)=edf::bl(false):-!.
    fromJson(json::a([json::s("s8_"),json::s(Value)]))=s8(string8::toUtf8(Value)) :-!.
    fromJson(json::a([json::s("i_"),json::r(Integer)]))=edf::i(toTerm(integer,toString(Integer))) :-!.
    fromJson(json::a([json::s("i64_"),json::r(Integer64)]))=edf::i64(toTerm(integer64,toString(Integer64))) :-!.
    fromJson(json::a([json::s("u_"),json::r(Unsigned)]))=edf::u(toTerm(unsigned,toString(Unsigned))) :-!.
    fromJson(json::a([json::s("u64_"),json::r(Unsigned64)]))=edf::u64(toTerm(unsigned64,toString(Unsigned64))) :-!.
    fromJson(json::a([json::s("av_"),json::s(Name),Json]))=edf::av(Name,fromJson(Json)) :-!.
    fromJson(json::a([json::s("tg_"),json::s(Value)]))=tg(toTerm(Value)) :-!.
    fromJson(json::a([json::s("tl_"),json::s(Value)]))=tl(toTerm(Value)) :-!.
    fromJson(json::a([json::s("rf_"),Json]))=edf::rf(fromJson(Json)) :-!.
    fromJson(json::a([json::s("b_"),json::s(Base64)]))=b(cryptography::base64_decode(Base64)) :-!.
    fromJson(json::a([json::s("error"),json::r(ErrorCode),json::s(ErrorText)]))=edf::err(toTerm(integer,toString(ErrorCode)),ErrorText) :-!.
    fromJson(json::a(Array))=a([EdfElement||Element in Array,EdfElement=fromJson(Element)]) :-!.
    fromJson(json::o(JsonObject))=Edf:-
        !,
        Edf_list=[av(Key,Edf)||
            Key=JsonObject:map:getKey_nd(),
            JsonValue=JsonObject:map:get(Key),
            Edf=fromJson(JsonValue)
        ],
        if Edf_list=[Element] then Edf=Element
        else Edf=a(Edf_list)
        end if.

end implement edf